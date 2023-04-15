//
//  BluetoothFunctions.swift
//  MAURAMA
//
//  Created by Si Young Choi on 2023/01/31.
//

/// ---------------------------------------------
/// BLUETOOTH BASICS
///
/// ①セントラルマネージャーを起動する。
/// ②ペリフェラルを検出する。
/// ③ペリフェラルと接続する。
/// ④ペリフェラルのサービスを検出する。
/// ⑤サービス特性を検出する。
/// ⑥サービス特性の値を取得する。
///
///

/// --------------------------------------------------------------------------------
/// < REFERENCE >
/// https://www.youtube.com/watch?v=n-f0BwxKSD0&t=81s

/// --------------------------------------------------------------------------------
/// < COREBLUETOOTH IS NOT SUPPORTED IN THE IOS SIMULATOR >
/// https://stackoverflow.com/questions/26176046/corebluetooth-ble-hardware-is-unsupported-on-this-platform


/// --------------------------------------------------------------------------------
/// https://qiita.com/haru15komekome/items/f5791d322995a3fd7452
/// https://tech.mokelab.com/ios/CoreBluetooth/BLE/central.html




import Foundation
import SwiftUI
import CoreBluetooth

let btDeviceName = "COARAMAUSE"

let btServiceUUID       = CBUUID(string: "4742b483-87e5-496a-85d8-a79ebd8a8231")
let btCharacteristcUUID = CBUUID(string: "237d86a5-7e97-429c-8d31-ca59cc51f504")








/// THIS CLASS CONTAINS BLUETOOTH CENTRAL MANAGER
class BluetoothController: NSObject, ObservableObject {

    /// IN BLUETOOTH IMPLEMENTATION,
    /// CENTRAL IS NOT SERVER, IS CLIENT, WHICH HAS THE INFORMATION WE WANT TO SEE
    /// SO PERIPHERAL IS SERVER
       
    
    /// CBCentralManager
    /// An object that scans for, discovers, connects to, and manages peripherals
    //private var centralManager: CBCentralManager?
    var peripherals: [CBPeripheral] = []
    
    /// When the property changes, publishing occurs in the property’s
    /// willSet block, meaning subscribers receive the new value before
    /// it’s actually set on the property.
    @Published var peripheralNames: [String] = []
    
    /// RECEIVED MESSAGE FROM MAURAMA_BLUETOOTH MODULE
    /// * THIS IS NOT NEEDED TO BE 'Published' PROPERTY WRAPPER
    var receivedString: String = ""
    

    
    
    let btServices = [btServiceUUID]
    
    
    
    var centralManager: CBCentralManager?
    var peripheral: CBPeripheral?
    var characteristic: CBCharacteristic?
    

    
    
    
    override init() {
        super.init()
        
        /// GETTING CENTRAL MANAGER
        ///
        /// delegate :: delegate
        /// The delegate that receives central events.
        ///
        /// queue :: DispatchQueue?
        ///
        self.centralManager = CBCentralManager(
            delegate: self,
            queue: .main)
        
        
        
        print("BluetoothController IS INITIALIZED")
        
    }
    
    
    
    func sendDataToPeripheral(_ data: Data) {
        
        guard let peripheral = self.peripheral,
              let characteristic = self.characteristic else {
            if peripheral == nil {
                print("ERROR ---- sendDataToPeripheral FUNCTION !!!!")
                print("           peripheral IS nil !!!!")
            }
            
            if characteristic == nil {
                print("ERROR ---- sendDataToPeripheral FUNCTION !!!!")
                print("           characteristic IS nil !!!!")
            }
            
            return
        }
        
        
        peripheral.writeValue(data, for: characteristic, type: .withResponse )
        
    }
    
}



/// DELEGATE PATTERN IS USED TO REGISTER EVENT HANDLERS
/// WE WANT TO EXECUTE WHEN PROPER EVENT WAS RECIEVED




/// CBCentralManagerDelegate
///
/// A protocol that provides updates for the discovery and management of peripheral devices.
///
/// Extensions add new functionality to an existing class, structure, enumeration, or protocol type.
///
extension BluetoothController: CBCentralManagerDelegate {

    /// Tells the delegate the central manager’s state updated.
    ///
    /// PARAMETER
    /// central
    /// The central manager whose state has changed.
    func centralManagerDidUpdateState( _ central: CBCentralManager) {
        
        /// IF CENTRAL'S STATE IS POWERED ON...
        ///
        /// enum CBManagerState : Int, @unchecked Sendable
        /// Manager States
        ///
        /// case poweredOff
        /// A state that indicates Bluetooth is currently powered off.
        ///
        /// case poweredOn
        /// A state that indicates Bluetooth is currently powered on and available to use.
        ///
        /// case resetting
        /// A state that indicates the connection with the system service was momentarily lost.
        ///
        /// case unauthorized
        /// A state that indicates the application isn’t authorized to use the Bluetooth low energy role.
        ///
        /// case unknown
        /// The manager’s state is unknown.
        ///
        /// case unsupported
        /// A state that indicates this device doesn’t support the Bluetooth low energy central or client role.
        ///
        
        
        switch central.state {
            
        case .poweredOff:
            print("Bluetooth PoweredOff")
            break
            
        case .poweredOn:
            print("Bluetooth poweredOn")
            break
            
        case .resetting:
            print("Bluetooth resetting")
            break
            
        case .unauthorized:
            print("Bluetooth unauthorized")
            break
            
        case .unknown:
            print("Bluetooth unknown")
            break
            
        case .unsupported:
            print("Bluetooth unsupported")
            break
            
        @unknown default:
            print("ERROR OCCURED")
            break
        }
        
        
    }
    
    
    
    func startBluetoothScan() {
        
        self.centralManager?.scanForPeripherals( withServices: nil )
        
    }
    
    
    func stopBluetoothScan() {
        
        self.centralManager?.stopScan()
        
    }
    
    
    

    
    /// Tells the delegate the central manager discovered a peripheral while scanning for devices.
    func centralManager( _ central: CBCentralManager,
                         didDiscover peripheral: CBPeripheral,
                         advertisementData: [String : Any],
                         rssi RSSI: NSNumber ) {
        
        
        ///print("===  didDiscover EVENT  ===")
        ///print("SCANNING PERIPHERALS...")
        ///print("DISCOVERED  -->  \(String(describing: peripheral.name))  !!")
        
        
        if !peripherals.contains(peripheral) {
            
            self.peripherals.append(peripheral)
            self.peripheralNames.append(peripheral.name ?? "Unnamed Device")
        }
    }
    
    
    
    func centralManager(_ central: CBCentralManager,
                        didConnect peripheral: CBPeripheral) {
        
        print("===  didConnect EVENT  ===")
        print("CONNECTED TO -->  \(peripheral.name!)  !!")
        
        
        peripheral.delegate = self
        
        // WE CONNECTED TO PERIPHERAL SO WE NEED TO SEARCH PROPER SERVICE
        // FROM OUR CONNECTED PERIPHERAL
        self.peripheral?.discoverServices(btServices)
        
       
    }
       
    
}




extension BluetoothController: CBPeripheralDelegate {


    
    func peripheral( _ peripheral: CBPeripheral,
                     didDiscoverServices error: Error?) {

        print("===  didDiscoverServices EVENT  ===")
        print("GETTING SERVICE FROM PERIPHERAL -->  \(peripheral.name!)  !!")
        

        self.peripheral?.discoverCharacteristics(nil, for: (peripheral.services?.first)!)
        
    }

    
    
    
    func peripheral( _ peripheral: CBPeripheral,
                     didDiscoverCharacteristicsFor service: CBService,
                     error: Error?) {
        
        print("===  didDiscoverCharacteristicsFor EVENT  ===")
        print(service)
        
        
        guard let characteristics = service.characteristics else {
            return
        }
        
        
        for characteristic in characteristics {
            
            if characteristic.uuid == btCharacteristcUUID {
                
                self.peripheral?.setNotifyValue(true, for: characteristic)
                
                self.peripheral?.readValue(for: characteristic)
               
                // SAVING characteristics CLASS-SCOPE
                self.characteristic = characteristic
                
                
            }
        }
    }
    
    
    func peripheral(_ peripheral: CBPeripheral,
                    didWriteValueFor characteristic: CBCharacteristic,
                    error: Error?) {
        
        if error == nil {
            print("Message sent=======>\(String(describing: characteristic.value))")
        }else{

            print("Message Not sent=======>\(String(describing: error))")
        }
        
    }
    
    
    
    func peripheral( _ peripheral: CBPeripheral,
                     didUpdateValueFor characteristic: CBCharacteristic,
                     error: Error? ) {
        
        
        print("===  didUpdateValueFor EVENT  ===")
        ///print(characteristic)
        
        
        guard let data = characteristic.value else {
            // no data transmitted, handle if needed
            return
        }
        
        
        if characteristic.uuid == btCharacteristcUUID {
            
            // CONVERTING RAW VALUE TO STRING !
            let stringValue = String(data: data, encoding: String.Encoding.utf8)
            
            print(stringValue! as String)
            
            receivedString = stringValue!
            
        }
    }
    
}


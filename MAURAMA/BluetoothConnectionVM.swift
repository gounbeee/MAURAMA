//
//  BluetoothConnectionVM.swift
//  MAURAMA
//
//  Created by Si Young Choi on 2023/02/09.
//

import SwiftUI





struct BluetoothScanButtonVM: View {

    @Binding var isScanning: Bool

    @State var bluetoothCtr : BluetoothController
    
    
    var body: some View {
        
        MainIntroVM().padding(EdgeInsets(top: 0, leading: 0, bottom: 30, trailing: 0))
        
        
        Button(isScanning ? "STOP SCANNING" : "スキャンを開始") {
            self.isScanning.toggle()
            self.bluetoothCtr.startBluetoothScan()
            
        }
        .foregroundColor(Color.red)
        .animation(.spring(response: 0.2, dampingFraction: 0.5, blendDuration: 0.1).delay( 50.0 ), value: 10)
        
    }
    
}




struct BluetoothConnectionVM: View {
    

    @ObservedObject var bluetoothCtr : BluetoothController
        
    /// FOR BLE CONNECTION CHECK
    @State var isScanning : Bool = false
    @State var isConnected : Bool = false
    
    
    
    init( _ bleCtr : BluetoothController) {
        
        /// PASSING TO MEMBER PROPERTY
        self.bluetoothCtr = bleCtr
        
        ///print(self.bluetoothCtr.peripheralNames)
        ///print("BluetoothConnectionVM IS INITIALIZED")

    }
    
    
    
    var body: some View {
        
        ///let _ = print(self.isScanning)
        
        
        /// FOR NEW CONNECTION TO PERIPHERAL
        if !self.isScanning && !self.isConnected {
            
            /// BUTTON FOR STARTING SCAN
            BluetoothScanButtonVM(isScanning: $isScanning, bluetoothCtr: self.bluetoothCtr)
            
        } else if self.isScanning && !self.isConnected {
            
            VStack {
             
                Text("Bluetoothを検索中")
                    .font(.headline)
                
                Text("Coaramauseを選択してください")
                    .font(.body)
                
            }.padding(EdgeInsets(top: 40, leading: 0, bottom: 0, trailing: 0))
            
            /// -----------------------------------------------
            /// LISTING BLUETOOTH PERIPHERALS
            NavigationView{
                
                List(self.bluetoothCtr.peripheralNames,
                     id: \.self) { peripheralName in

                    
                    /// WHEN PERIPHERAL'S NAME IS PRESSED
                    ///let _ = print(peripheralName)
                    Button(action: {
                        print("BUTTON CLICKED  --  \(peripheralName)")
         
                        /// print(bluetoothViewModel.peripherals)
                        
                        /// FOR EVERY PERIPHERALS,
                        self.bluetoothCtr.peripherals.forEach { periph in
                            
                            //print(periph)
                            
                            /// WE WILL CONNECT TO 'SELECTED NAME IN THE LIST'
                            if periph.name == peripheralName {
                                
                                /// REGISTER CURRENT PERIPHERAL
                                self.bluetoothCtr.peripheral = periph
                                
                                /// CONNECT TO PERIPHERAL
                                self.bluetoothCtr.centralManager?.connect(periph, options: nil)
        
                                /// STOP SCANNING
                                self.bluetoothCtr.centralManager?.stopScan()
        
                                print("CONNECTED !!")
                                
                                self.isScanning  = false
                                self.isConnected = true
                                
                            }
                        }
                                                                                
                    }) {
                        Text(peripheralName)
                    }
                }

                     
            }
            
            
            Button(action: {
                print("RESET")
                
                /// STOP CURRENT SCANNING
                self.bluetoothCtr.centralManager?.stopScan()
                
                /// FLAG INITIALIZING
                self.isScanning  = false
                self.isConnected = false
                
                
            }) {
                Text("RESET SCANNING")
            }
            
            
            
        }
        
        
        
        
        if !self.isScanning && self.isConnected {
            //Text("LIST OF MATHMATICAL BUTTONS")
            MathListVM( bluetoothCtr: self.bluetoothCtr )
        }
        
        
        ///var _ = print("BluetoothConnectionVM IS VIEWED")
        
    }
    
    
    
    
    func toggleScanning() -> Void {
        
        ///print( "isScanning  IS   \(self._isScanning) ")
        
        if self._isScanning.wrappedValue == true {
            self._isScanning.wrappedValue = false
            print( "(IN if Statement :: Block 1) isScanning  IS   \(self._isScanning.wrappedValue) ")
            
            bluetoothCtr.stopBluetoothScan()

        } else {
            self._isScanning.wrappedValue = true
            print( "(IN if Statement :: Block 2) isScanning  IS   \(self._isScanning.wrappedValue) ")
            bluetoothCtr.startBluetoothScan()
        }

        print( "isScanning  IS  AFTER PROCESS ->  \(self._isScanning.wrappedValue) ")

    }
    
    
    
}



struct BluetoothConnectionVM_Previews: PreviewProvider {

    @State static var isScanning: Bool = true

    @State static var bluetoothCtr : BluetoothController = BluetoothController()
    
    
    
    static var previews: some View {

        BluetoothConnectionVM(bluetoothCtr)
    }
}



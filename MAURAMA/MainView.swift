
import AVFoundation
import SwiftUI
import VideoPlayer
//import NetworkExtension
import Network
import CoreBluetooth






struct MainView: View {
    
    /// BLUETOOTH VIEWMODEL
    @ObservedObject private var bleControls : BluetoothController
    
    

    init() {
        
        
        let bleController = BluetoothController()
        self.bleControls = bleController
        

        print("MainView IS INITIALIZED")
    }
    
    
    var body: some View {
        

        VStack {
            
            // ----------------------------------------------------------------------
            BluetoothConnectionVM( self.bleControls )
            
            
            
            
            
        }
                
        
        
    }
}




struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

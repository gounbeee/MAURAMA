
import AVFoundation
import SwiftUI
import VideoPlayer
//import NetworkExtension
import Network
import CoreBluetooth



//struct MovieUrls {
//
//    var title : String
//    var Url : URL
//
//}


//var playingTitle: String = ""
//

//var movDict: [String: URL] = ["01 - Subject": URL(string: "http://siyoung.work/media/bunny.mp4")!,
//                              "02 - Subject": URL(string: "http://siyoung.work/media/bunny.mp4")!,
//                              "03 - Subject": URL(string: "http://siyoung.work/media/bunny.mp4")!,
//                              "04 - Subject": URL(string: "http://siyoung.work/media/bunny.mp4")!,
//                              "05 - Subject": URL(string: "http://siyoung.work/media/bunny.mp4")!
//                             ]
//
//
//let movieList = movDict
//                .keys
//                .sorted()
//                .map {
//                    MovieUrls(title: $0, Url: movDict[$0]!)
//
//                }
//
//




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
            
            BluetoothConnectionVM( self.bleControls )
        }
    }
}




struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

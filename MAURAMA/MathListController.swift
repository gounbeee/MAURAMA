//
//  MathListController.swift
//  MAURAMA
//
//  Created by Si Young Choi on 2023/02/10.
//

import Foundation



/// THIS CLASS WILL GET THE FILE LIST FROM INTERNET
/// THEN, PREPARE IMAGE FILES WE WANT TO DISPLAY


/// The NSObject class provides inheriting classes with a framework for creating, initializing,
/// deallocating, copying, comparing, archiving, and unarchiving objects, run-time environment,
/// querying objects, and message forwarding.
///
class MathListController: NSObject, ObservableObject {
    
//    @Published var currentImagesName : [String] = [""]          // INITIALIZED
                                                                // +  Published -> THIS IS Published SO THIS PROPERTY CAN BE A TRIGGER
                                                                //                 FOR RE-EASTABLISHING BELOW PROPERTIES !!
    var pgCSVName : String = ""                                 // INITIALIZED
    var fnManager : FileManager
    
    var csvPageDictionary : [Int: String] = [:]
    var csvTitleDictionary : [Int: String] = [:]
    
    
    override init() {
        
 
        /// default PROPERTY
        /// IS 'default singleton instance'
        fnManager = FileManager.default
        
        
        
        print("MathListController CLASS IS INITIALIZED")
        
    }
    
    
   
    
    func preparePageCSVFromServer (csvUrl stringData : String ) {
        
        /// < GETTING FILE FROM REMOTE SERVER >
        /// https://developer.apple.com/documentation/foundation/url_loading_system/downloading_files_from_websites
        /// https://developer.apple.com/documentation/foundation/url_loading_system/fetching_website_data_into_memory
        ///
        //let urlRequest = URLRequest(url: URL(string: csvUrl)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60.0 )
        let session = URLSession(configuration: .default)
        
        let downloadPageCSVTask : URLSessionDataTask = session.dataTask(with: URL(string: stringData)!, completionHandler: handlePageCSV( data: response: error: ) )

        downloadPageCSVTask.resume()
                
    }
    
    
    
    /// < CSV PARSING >
    /// https://www.youtube.com/watch?v=Q2hGcqpnCro
    ///
    func handlePageCSV(data: Data?, response: URLResponse?, error: Error?) {
        
        /// ERROR HANDLING WHEN DATA IS RECEIVED
        if error != nil {
            print(error!)
            return
        }

        if let safeData = data {
            
            let dataString = String(data: safeData, encoding: .utf8)
            
            let rows = dataString!.components(separatedBy: "\r\n")
            ///print(rows)

            /// < enumerated() >
            /// https://qiita.com/a-beco/items/0fcfa69cca20a0ba601c
            for (index, _) in rows.enumerated() {

                csvPageDictionary[index] = rows[index]

            }

        }
    
    }
    
    
    
    func prepareTitleCSVFromServer (csvUrl stringData : String ) {
        
        /// < GETTING FILE FROM REMOTE SERVER >
        /// https://developer.apple.com/documentation/foundation/url_loading_system/downloading_files_from_websites
        /// https://developer.apple.com/documentation/foundation/url_loading_system/fetching_website_data_into_memory
        ///
        //let urlRequest = URLRequest(url: URL(string: csvUrl)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60.0 )
        let session = URLSession(configuration: .default)
        
        let downloadTitleCSVTask : URLSessionDataTask = session.dataTask(with: URL(string: stringData)!, completionHandler: handleTitleCSV( data: response: error: ) )

        downloadTitleCSVTask.resume()
                
    }
    
    
    
    /// < CSV PARSING >
    /// https://www.youtube.com/watch?v=Q2hGcqpnCro
    ///
    func handleTitleCSV(data: Data?, response: URLResponse?, error: Error?) {
        
        /// ERROR HANDLING WHEN DATA IS RECEIVED
        if error != nil {
            print(error!)
            return
        }

        if let safeData = data {
            
            let dataString = String(data: safeData, encoding: .utf8)
            
            let rows = dataString!.components(separatedBy: "\r\n")
            ///print(rows)

            /// < enumerated() >
            /// https://qiita.com/a-beco/items/0fcfa69cca20a0ba601c
            for (index, _) in rows.enumerated() {

                csvTitleDictionary[index] = rows[index]

            }

        }
    
    }
    
    
}

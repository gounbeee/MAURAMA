//
//  MathContentController.swift
//  MAURAMA
//
//  Created by Si Young Choi on 2023/02/11.
//

import Foundation


let g_imgUrlPath : String = "https://siyoung.work/COARAMAUSE_CONTENTS/pg/"
let g_imgFnPrefix : String = "pg"
let g_imgFnDecimals : Int = 5
let g_imgFnExt : String = ".png"

/// WE WILL ADD BELOW NUMBER BECAUSE WE ARE HAVING CONTENT IS NOT-ZERO-INDEXED,
/// AND, 00001 ~ 00005 FILES ARE "INTRO IMAGES"
/// SO, ACTUAL CONTENT IS STARTING FROM 00006 ~
let g_imgIndexShift = 5


class MathContentController : NSObject, ObservableObject {
    
    ///private let currentImg = "https://siyoung.work/COARAMAUSE_CONTENTS/pg/pg00006.png"
    
    
    var csvPageDictionary : [Int: String] = [:]
    
    
    override init() {
        
        super.init()
        
        print("MathContentController CLASS IS INITIALZED")
    }
    
    
    
    func calcIndexSubjectStart(pgIndex pgInd : Int) -> Int {
        
        /// IF pgInd IS 0, SO SUBJECT NUMBER IS 0, WE CAN JUST EXPORT INPUTTED VALUE
        ///
        if pgInd == 0 {
            
            return (pgInd+1) + g_imgIndexShift
            
        } else {
            var resultIndex : Int = 0
            
            /// CALCULATE STARTING POINT OF IMAGES IN SELECTED SUBJECT
            
            //             1
            for i in 0..<pgInd {
            
                /// ACCUMULATING PAGE COUNT
                var currentPgCnt : Int = 0
                
                if self.csvPageDictionary[i] == "" {
                    currentPgCnt = 0
                } else {
                    currentPgCnt = Int(self.csvPageDictionary[i]!)!
                }
                    
                resultIndex += currentPgCnt
                
            }
            
            print("-- Calculated STRATING INDEX IS -->   \((resultIndex+1) + g_imgIndexShift)")
            
            return (resultIndex+1) + g_imgIndexShift
        }
    }
    
    
    func createImageFileUrlList(pgIndex pgInd : Int, pgCount pgCnt : Int) -> Array<String> {
        

        /// BELOW IS FINALIZED INDEX NUMBER OF SUBJECT'S FILE NUMBER
        let startingIndex : Int = calcIndexSubjectStart(pgIndex: pgInd)
        
        
        var resultArray : [String] = []
        
        /// < FORMATTER >
        /// https://stackoverflow.com/questions/30663996/format-string-with-trailing-zeros-removed-for-x-decimal-places-in-swift
        let formatter = NumberFormatter()
        formatter.minimumIntegerDigits = g_imgFnDecimals
        
        
        /// < FOR LOOP >
        /// https://www.programiz.com/swift-programming/for-in-loop
        for index in 0..<pgCnt {
            let fileNum = NSNumber(value: startingIndex + index)
            
            let finalNm = String( formatter.string(from: fileNum )! )
            
            /// COMBINE ALL STRINGS
            let finalUrl = g_imgUrlPath + g_imgFnPrefix + finalNm + g_imgFnExt
            
            resultArray.append( finalUrl )
        }
        
        return resultArray
        
    }
    

}

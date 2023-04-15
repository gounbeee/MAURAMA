//
//  MovieDataView.swift
//  MAURAMA
//
//  Created by Si Young Choi on 2023/01/23.
//

import SwiftUI

struct MovieDataView: View {
    
    var title: String = "Default Title"
    
    var btnSize = 20.0
    
    
    var body: some View {
        
        ZStack{
            
            Text(title)
                .padding(10)
                .frame(maxWidth: 200, maxHeight: 60, alignment: .leading)
                //.border(.green)
                .alignmentGuide(
                    VerticalAlignment.center,
                    computeValue: { _ in btnSize/2 })
                .font(.headline)
                //.background(Color.green)
                .offset(x: -50)

                
                        
//            TriangleRight(wdth: btnSize, hght: btnSize)
//                .fill(.red)
//                //.border(.green)
//                .frame(width: btnSize, height: btnSize)
//                //.background(Color.blue)
//                .offset(x: 140, y: btnSize/2)
          
            
            
        }
        
        
        
        
        
        
    }
}



struct MovieDataView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        
        MovieDataView(title: "Previewed Title")
        
        
    }
}

//
//  TriangleRight.swift
//  MAURAMA
//
//  Created by Si Young Choi on 2023/01/23.
//

import SwiftUI



struct TriangleRight: Shape {
             
    var wdth = 80.0
    var hght = 80.0
    
    func path(in rect: CGRect) -> Path {
        
        var path = Path()
        
        path.addLines([
            CGPoint(
                x: 0.0,
                y: 0.0),
            CGPoint(
                x: wdth,
                y: hght/2),
            CGPoint(
                x: 0.0,
                y: hght)
            
        ])
        
        let multiplier = min(rect.width, rect.height)
       
        let _ = CGAffineTransform(scaleX:multiplier , y: multiplier)
        
        return path
    }
        
    
    
}


struct TriangleRight_Previews: PreviewProvider {
    static var previews: some View {
        TriangleRight(wdth: 50.0, hght: 50.0)
            
    }
}

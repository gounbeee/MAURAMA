//
//  MainIntroVM.swift
//  MAURAMA
//
//  Created by Si Young Choi on 2023/02/11.
//

import SwiftUI


/// < ANIMATION TEXT >
/// https://qiita.com/chitomo12/items/13a463ae6dbaf9b192ea


struct BounceAnimationView: View {
    let characters: Array<String.Element>

    @State var offsetYForBounce: CGFloat = -50
    @State var opacity: CGFloat = 0
    @State var baseTime: Double

    init(text: String, startTime: Double){
        self.characters = Array(text)
        self.baseTime = startTime
    }

    var body: some View {
        HStack(spacing:0){
            
            ForEach(0..<characters.count) { num in
                
                Text(String(self.characters[num]))
                    //.font(.custom("HiraMinProN-W3", fixedSize: 24))
                    .font(.system(size: 36.0))
                    .offset(x: 0, y: offsetYForBounce)
                    .opacity(opacity)
                    .animation(.spring(response: 0.2, dampingFraction: 0.5, blendDuration: 0.1).delay( Double(num) * 0.1 ), value: offsetYForBounce)
            }
            .onTapGesture {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                    opacity = 0
                    offsetYForBounce = -50
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    opacity = 1
                    offsetYForBounce = 0
                }
            }
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + (0.8 + baseTime)) {
                    opacity = 1
                    offsetYForBounce = 0
                }
            }
        }
    }
}




struct MainIntroVM: View {
    
    
    var body: some View {
        
        
        BounceAnimationView(text: "COARAMAUSE", startTime: 0.0)
        
        
        
    }
    
    
}





struct MainIntroVM_Previews: PreviewProvider {
    static var previews: some View {
        MainIntroVM()
    }
}

//
//  MathContentVM.swift
//  MAURAMA
//
//  Created by Si Young Choi on 2023/02/10.
//

import SwiftUI


/// < FLOATING BUTTON >
/// https://dev.classmethod.jp/articles/swiftui_floatingbutton_linkage_textfield/
/// https://blog.devgenius.io/swiftui-tutorial-how-to-make-a-floating-action-button-fab-867d3183375
struct FloatingButton: View {
    
    @Binding var flag : Bool
    

    var body: some View {
        VStack {
            HStack {
                
                Button(action: {
                        ///print("Tapped!!")
                        flag.toggle()
                        
                    }, label: {
                        Image(systemName: "arrowshape.turn.up.left.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 30))
                            .padding(EdgeInsets(top: -4, leading: 0, bottom: 0, trailing: 0))
                        
                    })
                    .frame(width: 45, height: 45)
                    .background(Color.gray.opacity(0.5))
                    .cornerRadius(30.0)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 16.0, trailing: 16.0))

            }
        }
    }
}



/// < PAGE VIEW >
/// https://www.youtube.com/watch?v=zzqKhitBQfM
struct DisplayPageView: View {
    
    @Binding var subNum : Int
    // @Binding var imgUrls : [String]
    @Binding var isEntered : Bool

    
    var body: some View {
        
        ZStack (alignment: .top) {
            
            
            
            
// -----------------------------------
// この部分は、イメージファイルを複数見せるバージョン
//
//            VStack {
//
//                TabView {
//
//                    ForEach(self.imgUrls, id: \.self) { url in
//
//
//                        AsyncImage(url: URL(string: url)) { image in
//                            image.resizable()
//                                .scaledToFit()
//                                .cornerRadius(15.0)
//                                .aspectRatio(contentMode: .fit)
//                                .padding()
//
//
//
//                        } placeholder: {
//
//                            ProgressView()
//
//                        }
//                    }
//                }
//                .tabViewStyle(.page)
//                .indexViewStyle(.page(backgroundDisplayMode: .never))
//
//            }     // VStack

            
            let _ = print(self.subNum)
            
            
            // ムービ教材を再生
            MovieDataView( subNum: self.$subNum )
            
            
            // 戻るボタン
            FloatingButton(flag: self.$isEntered)
                .padding(EdgeInsets(top: 20, leading: -160, bottom: 0, trailing: 0))
            
        }  // ZStack
        .background(Color.black)
    }
}




struct MathContentVM: View {
    
    @Binding var subNum : Int
    // @Binding var imgUrls : [String]
    @Binding var isEntered : Bool

 
    var body: some View {
        
        if self.isEntered {
            
            /// TODO :: EXPAND NEW STYLE OF DISPLAYING CONTENTS !!!!
            ///  CURRENTLY WE ARE HAVING VERTICAL SLIDE AND PAGE VIEW
           
            //NOT USING -- DisplayScrollView(imgUrls: $imgUrls, isEntered: $isEntered)
            
            //DisplayPageView(subNum: $subNum, imgUrls: $imgUrls, isEntered: $isEntered)
            DisplayPageView(subNum: $subNum, isEntered: $isEntered)
            
            
            
            
            
            
            
            
        }

    } // VIEW
}





struct MathContentVM_Previews: PreviewProvider {

    @State static var subjectNumber = 2
    
    @State static var imgUrlsTest : [String] = [ "https://siyoung.work/COARAMAUSE_CONTENTS/pg/pg00006.png",
                               "https://siyoung.work/COARAMAUSE_CONTENTS/pg/pg00007.png",
                               "https://siyoung.work/COARAMAUSE_CONTENTS/pg/pg00008.png",
                               "https://siyoung.work/COARAMAUSE_CONTENTS/pg/pg00009.png" ]
    @State static var isEntered : Bool = true

    /// <  >
    /// https://stackoverflow.com/questions/61753114/instance-member-cannot-be-used-on-type-in-swiftui-preview
    ///
    static var previews: some View {

        MathContentVM(subNum: $subjectNumber,  isEntered: $isEntered)

    }
}

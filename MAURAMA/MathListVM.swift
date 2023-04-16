//
//  MathListVM.swift
//  MAURAMA
//
//  Created by Si Young Choi on 2023/02/10.
//

import SwiftUI


let g_csvPageUrl = "https://siyoung.work/COARAMAUSE_CONTENTS/pg.csv"
let g_csvTitleUrl = "https://siyoung.work/COARAMAUSE_CONTENTS/pg_title.csv"




/// ----------------------------------------------------------------------------

/// ** THIS IS NOT USING HERE BUT IT WORKS **

/// < STORING POSITION OF SCROLLVIEW >
/// https://swiftuirecipes.com/blog/swiftui-scrollview-scroll-offset
/// https://stackoverflow.com/questions/62588015/get-the-current-scroll-position-of-a-swiftui-scrollview
///
/// : THIS IS CONSTRUCTED WITH PREFERENCE FUNCTIONALITIES
///
///  1. Put a GeometryReader in the ScrollView's content's background. This will allow you to track the content's frame and its changes.
///    (The same trick with a GeometryReader in the background can also be used to measure SwiftUI views.)
///  2. The frame's minY property is the current offset. Negate it to track the offset as a positive number.
///  3. Safely propagate the new offset value via a PreferenceKey to the binding.
///  4. For the sake of completeness, we'll include a ScrollViewProxy so that you can scroll ObservableScrollView programatically.
///
///


// Simple preference that observes a CGFloat.
struct ScrollViewOffsetPreferenceKey: PreferenceKey {
  static var defaultValue = CGFloat.zero

  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
    value += nextValue()
  }
}



// A ScrollView wrapper that tracks scroll offset changes.
struct ObservableScrollView<Content>: View where Content : View {
    
  @Namespace var scrollSpace

  @Binding var scrollOffset: CGFloat
    
    
  let content: (ScrollViewProxy) -> Content

    
    
  init(scrollOffset: Binding<CGFloat>,
       @ViewBuilder content: @escaping (ScrollViewProxy) -> Content) {
      
    _scrollOffset = scrollOffset
    self.content = content
      
  }

    
  var body: some View {
      
    ScrollView {
      ScrollViewReader { proxy in
          
        content(proxy)
          .background(
            
            GeometryReader { geo in
              let offset = -geo.frame(in: .named(scrollSpace)).minY
              Color.clear
                .preference(key: ScrollViewOffsetPreferenceKey.self,
                            value: offset)
          })
          
         
      }
        
    }
    .coordinateSpace(name: scrollSpace)
    .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { value in
      scrollOffset = value
    }
  }
    
}


/// NavigationView {
///     ObservableScrollView(scrollOffset: $scrollOffset) { proxy in
///         Button("Jump") {
///             proxy.scrollTo( 15 )
///         }
///
///         LazyVStack (alignment: .center) {
///
///             ForEach(self.mathListController.csvTitleDictionary.sorted(by: <), id: \.key) { index, value in
///                 ...
///                 ...
///                 ...
///
///
///         }
///
///     }.navigationBarTitle("Scroll offset: \(scrollOffset)",
///                          displayMode: .inline)
/// }




/// ----------------------------------------------------------------------------






struct MathListVM: View {
    
    @ObservedObject var mathListController : MathListController
    @ObservedObject var mathContentController : MathContentController
    @State private var isListed : Bool = false
    @State private var isEntered : Bool = false
    @State private var fileUrlList : [String] = []
    

    @State var bluetoothCtr : BluetoothController
    

    @AppStorage("scrollPosition") private var stored: Int = 0
    @State private var current: [Int] = []
    
    
    @State var subjectNumber : Int = -1
    
    
    init(bluetoothCtr bleCtr : BluetoothController) {
        
        self.bluetoothCtr = bleCtr
        
        
        /// CREATE NEW MATHLIST + MATHCONTENT CONTROLLER
        self.mathListController = MathListController()
        self.mathContentController = MathContentController()
        
        /// GETTING CSV FILE FROM SERVER
        self.mathListController.preparePageCSVFromServer(csvUrl: g_csvPageUrl)
        self.mathListController.prepareTitleCSVFromServer(csvUrl: g_csvTitleUrl)
        
        
        
        

        print("MathListVM IS INITIALIZED")
        
    }
    
    
    
    var body: some View {

        
        if !self.isListed {
            
            Button(action: {
                
                //let _ = print(self.mathListController.csvDictionary)
                self.isListed.toggle()
                
            }) {
                Text("Coaramauseを始める")
                    .font(.title)
                    
            }
            
        } else if self.isEntered == false {
            

            
            
            /// < SCROLL JUMP >
            /// USED BELOW
            /// https://stackoverflow.com/questions/65870891/save-scrollviews-position-and-scroll-back-to-it-later-offset-to-position
            /// NOT BELOW
            /// https://capibara1969.com/3562/
            ScrollViewReader { scrollProxy in
                
                VStack {
       
                    Text("題材を選択してください")
                        .font(.body)
                        .padding(EdgeInsets(top: 40, leading: 0, bottom: 20, trailing: 0))
                    
                    HStack {
                        
                        Button("場所をセーブ") {
                            
                            stored = current.sorted()[0]
                            print("!! stored \(stored)")
                            
                        }.padding(EdgeInsets(top: 0, leading: 50, bottom: 0, trailing: 0))
                        
                        Spacer()
                        
                        Button("場所をロード") {
                            scrollProxy.scrollTo(stored, anchor: .top)
                            print("[x] restored \(stored)")
                        }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 50))
                        
                    }.onAppear {
                        
                        /// IF THERE IS ALREADY STORED SCROLL POSTION,
                        /// LOAD IT
                        if self.stored != 0 {
                            scrollProxy.scrollTo(stored, anchor: .top)
                        }
                        
                    }
                    
                    
                    Divider()
                    
                    
                    ScrollView  {
                        
                        // < FOREACH WHILE USING VIEW AND DICTIONARY !! >
                        // https://stackoverflow.com/questions/70238391/loop-through-dictionary-in-swiftui
                        // https://stackoverflow.com/questions/56675532/swiftui-iterating-through-dictionary-with-foreach
                        
                        LazyVStack (alignment: .center) {
                            
                            
                            ForEach(self.mathListController.csvTitleDictionary.sorted(by: <), id: \.key) { index, value in
                                
                                // 教材タイトルのボタンが押されたとき
                                Button(action: {
                                    
                                    // 現在の教材リストの番号を覚えさせ、次にリストを表示するとき最初から移動させる
                                    stored = current.sorted()[0]
                                    print("!! stored \(stored)")
                                                                       
                                    
                                    print( "PRESSED SUBJECTS'S INDEX IS  -->   \(index + 1)" )
                                    
                                    
                                    
                                    print( "TITLE OF INDEX \(index+1) IS -->  \(String(self.mathListController.csvTitleDictionary[index]!)) ")
                                    
                                    /// SEARCHING REAL INDEX NUMBER FROM TITLE
                                    /// https://stackoverflow.com/questions/39677330/how-does-string-substring-work-in-swift
                                    ///
                                    /// ここで、読み込んでいたCSVデータから該当する教材を呼び出す
                                    let title = String(self.mathListController.csvTitleDictionary[index]!)
                                    let convertedIndexStr = title.prefix(5)    // 1, 11,  2000 ...

                                    let searchedIndexNumber = (convertedIndexStr as NSString).integerValue
                                    
                                    
                                    print( "SEARCHED INDEX NUMBER OF SUBJECT IS  -->  \(searchedIndexNumber)")
                                    self.subjectNumber = searchedIndexNumber - 1
                                    
                                    
                                    /// APPLYING FROM LIST CONTROLLER TO CONTENT CONTROLLER
                                    self.mathContentController.csvPageDictionary = self.mathListController.csvPageDictionary

                                    ///  let _ = print(index)
                                    ///  let _ = print(String(self.mathListController.csvTitleDictionary[index]!) )
                                    ///  let _ = print(String(self.mathListController.csvPageDictionary[index]!) )
                                    ///  let _ = print(String(self.mathContentController.csvPageDictionary[index]!) )


                                    // CHECK nil VALUE
                                    if let pgCount = Int(self.mathListController.csvPageDictionary[searchedIndexNumber-1]!) {


                                            
                                        self.fileUrlList = self.mathContentController.createImageFileUrlList(pgIndex: searchedIndexNumber-1,
                                                                                                             pgCount: pgCount )

                                        /// < WRITING VALUE TO CHARACTERISTIC FOR SENDING TO PERIPHERAL >
                                        /// https://www.ditto.live/blog/jp-getting-started-with-core-bluetooth
                                        /// https://stackoverflow.com/questions/28680589/how-to-convert-an-int-into-nsdata-in-swift
                                        ///
                                        ///func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
                                        ///    let response = "Hey there".data(using: .utf8)
                                        ///    request.value = response
                                        ///    peripheral.updateValue(response!, for: characteristics![0] as! CBMutableCharacteristic, onSubscribedCentrals: [request.central])
                                        ///}
                                        ///
                                        self.bluetoothCtr.sendDataToPeripheral(convertedIndexStr.data(using: .utf8)!)


                                    } else {

                                        print("****  ERROR  ----  THERE IS NO PAGES SO WILL LOAD FIRST SUBJECT")
                                        self.fileUrlList = self.mathContentController.createImageFileUrlList(pgIndex: 0,
                                                                                                             pgCount: 2 )
                                    }

                                    self.isEntered.toggle()
                                    
                                }) {
                                    
                                    Text("\(value)")
                                        .font(.title)
                                        .frame(alignment: .leading)
                                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                                        .onAppear {
                                            print(">> added \(index)")
                                            current.append(index)
                                        }
                                    
                                        .onDisappear {
                                            current.removeAll { $0 == index }
                                            print("<< removed \(index)")
                                        }
                                        .id(index)

                                }
                            }
                        }
                    }
                }
            }
        }

        
        
        if self.isEntered {
            //MathContentVM( subNum: self.$subjectNumber,imgUrls: self.$fileUrlList, isEntered: self.$isEntered )

            MathContentVM( subNum: self.$subjectNumber, isEntered: self.$isEntered )
            
        }
        
        
    }
}






struct MathListVM_Previews: PreviewProvider {
    ///
    ///SwiftUI Preview -> You have to use static var here:
    ///
    ///    struct ErrorView_Previews: PreviewProvider {
    ///        @State static var alert = false
    ///        @State static var error = "Please fill all the contents properly"
    ///
    ///        static var previews: some View {
    ///            ErrorView(alert: $alert, error: $error)
    ///        }
    ///    }
    /// https://stackoverflow.com/questions/61753114/instance-member-cannot-be-used-on-type-in-swiftui-preview
    /// 
    @State static var bluetoothCtr : BluetoothController = BluetoothController()
    
    @State static var fileUrl : [String] = [ "https://siyoung.work/COARAMAUSE_CONTENTS/pg/pg00006.png",
                                              "https://siyoung.work/COARAMAUSE_CONTENTS/pg/pg00007.png",
                                              "https://siyoung.work/COARAMAUSE_CONTENTS/pg/pg00008.png",
                                              "https://siyoung.work/COARAMAUSE_CONTENTS/pg/pg00009.png" ]
    
    @State static var isEnt : Bool = true
    
    

    static var previews: some View {
        
        MathListVM(bluetoothCtr: bluetoothCtr)
        
        ///MathContentVM( imgUrls: $fileUrl, isEntered: self.$isEnt )
        
    }
}

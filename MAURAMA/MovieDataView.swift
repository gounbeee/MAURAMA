//
//  MovieDataView.swift
//  MAURAMA
//
//  Created by Si Young Choi on 2023/01/23.
//

import SwiftUI
import AVFoundation
import VideoPlayer


// MOVIE教材を表示させるVIEWMODEL
struct MovieDataView: View {
        
    // 教材のインデックス番号
    @Binding var subNum : Int
    
    // VideoPlayerは、内部でGSPlayerを使用している。
    // 関連して、再生の状態を管理するための情報。
    
    @State private var play: Bool = true
    @State private var time: CMTime = .zero
    @State private var autoReplay: Bool = true
    @State private var mute: Bool = false
    @State private var stateText: String = ""
    @State private var totalDuration: Double = 0
    
    
    
    var body: some View {
        
        VStack{
            let serverFilePath = "http://siyoung.work/media/"
            let subNumStr = serverFilePath + String(self.subNum+1) + ".mp4"
            
            //let _ = print(subNumStr)
            
            Spacer()
            
            // 動画教材
            VideoPlayer(url: URL(string: subNumStr)!, play: $play, time: $time)
                .autoReplay(autoReplay)
                .mute(mute)
                .onBufferChanged { progress in print("onBufferChanged \(progress)") }
                .onPlayToEndTime { print("onPlayToEndTime") }
                .onReplay { print("onReplay") }
                .onStateChanged { state in
                    switch state {
                    case .loading:
                        self.stateText = "Loading..."
                    case .playing(let totalDuration):
                        self.stateText = "Playing!"
                        self.totalDuration = totalDuration
                    case .paused(let playProgress, let bufferProgress):
                        self.stateText = "Paused: play \(Int(playProgress * 100))% buffer \(Int(bufferProgress * 100))%"
                    case .error(let error):
                        self.stateText = "Error: \(error)"
                    }
                }
                .onTapGesture { location in
                    // 動画の上をタップすると、その箇所の座標が得られる。
                    // また、その時の動画の再生時刻を得る。
                    // これを持って、とある時刻に特定の場所をクリックした時を指し示すことができる。
                    // これで、各教材から次の教材に付加的な知識を表示したり、遷移することができる。
                    
                    
                    print("TAPPED AT \(location)")
                    let crntTm : Float64 = CMTimeGetSeconds(time)
                    
                    print("AND CURRENT TIME IS \(crntTm)")
                    
                    
                    
                }
                .aspectRatio(1.78, contentMode: .fit)
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.7), radius: 6, x: 0, y: 2)
                .padding()

            
            // 現在の状態表示用テキスト
            Text(stateText)
                .padding()
            
            
            // PLAYBACK用ボタンたち
            HStack {
                Button(self.play ? "Pause" : "Play") {
                    self.play.toggle()
                }
                
                Divider().frame(height: 20)
                
                Button(self.mute ? "Sound Off" : "Sound On") {
                    self.mute.toggle()
                }
                
                Divider().frame(height: 20)
                
                Button(self.autoReplay ? "Auto Replay On" : "Auto Replay Off") {
                    self.autoReplay.toggle()
                }
            }
            
            HStack {
                Button("Backward 5s") {
                    self.time = CMTimeMakeWithSeconds(max(0, self.time.seconds - 5), preferredTimescale: self.time.timescale)
                }
                
                Divider().frame(height: 20)
                
                Text("\(getTimeString()) / \(getTotalDurationString())")
                
                Divider().frame(height: 20)
                
                Button("Forward 5s") {
                    self.time = CMTimeMakeWithSeconds(min(self.totalDuration, self.time.seconds + 5), preferredTimescale: self.time.timescale)
                }
            }
            
            
            
            Spacer()
            
            
        }
        .onDisappear { self.play = false }
        
                
    }
    
    
    func getTimeString() -> String {
        let m = Int(time.seconds / 60)
        let s = Int(time.seconds.truncatingRemainder(dividingBy: 60))
        return String(format: "%d:%02d", arguments: [m, s])
    }
    
    
    func getTotalDurationString() -> String {
        let m = Int(totalDuration / 60)
        let s = Int(totalDuration.truncatingRemainder(dividingBy: 60))
        return String(format: "%d:%02d", arguments: [m, s])
    }
    
    
}



struct MovieDataView_Previews: PreviewProvider {

    @State static var subNum : Int = 2


    static var previews: some View {


        MovieDataView( subNum: $subNum)


    }
}

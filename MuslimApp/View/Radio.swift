//
//  Radio.swift
//  MuslimApp
//
//  Created by Muhedin Alic on 03.06.24.
//

import SwiftUI
import AVKit

struct Radio: View {
    let audioFile = "imena"
        
        @State private var player: AVAudioPlayer?
        @State private var isplaying = false
        @State private var totalTime: TimeInterval = 0.0
        @State private var currentTime: TimeInterval = 0.0
        
    var body: some View {
        NavigationView {
            ZStack {
                Color.white.ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .center) {
                        Text("Muslim Radio")
                            .font(.largeTitle)
                            .bold()
                            .padding(.top)
                            .foregroundColor(Color("MuslimBlack"))
                        Text("(RefRef)")
                            .font(.callout)
                            .foregroundColor(Color.gray)
                        
                        Image("logo")
                            .resizable()
                            .opacity(0.8)
                            .frame(width: 150, height: 150)
                        
                        VStack {
                            
                            HStack {
                                Text(timeString(time: currentTime))
                                Spacer()
                                Text(timeString(time: totalTime))
                            }
                            .font(.caption)
                            .foregroundColor(.black.opacity(0.8))
                            .padding([.top, .trailing, .leading], 20)
                            
                            VStack {
                                Slider(value: Binding(get: {
                                        currentTime
                                }, set: { newValue in
                                        audioTime(to: newValue)
                                }), in: 0...totalTime)
                                        .accentColor(Color("DarkGreen")) // Promenite boju ovde
                                        .padding([.top, .trailing], 20)
                                
                                Image(systemName: isplaying ? "pause.circle.fill" : "play.circle.fill")
                                    .font(.largeTitle)
                                    .scaleEffect(2.0) // Uvećanje slike
                                    .padding(.top, 18)
                                    .shadow(color: .gray, radius: 2, x: 0, y: 2)
                                    .onTapGesture {
                                        isplaying ? stopAudio() : playAudio()
                                    }
                                }
                            }
                        .padding(.horizontal)
                    }
                }
                .onAppear(perform: {
                    setupAudio()
                })
                .onReceive(Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()) { _ in
                    updateProgress()
                }
                .navigationBarHidden(true)
            }
        }
    }
    
    private func setupAudio() {
            guard let url = Bundle.main.url(forResource: audioFile, withExtension: "mp3") else { return }
            do {
                player = try AVAudioPlayer(contentsOf: url)
                player?.prepareToPlay()
                totalTime = player?.duration ?? 0.0
            } catch {
                print("Error loading audio: \(error)")
            }
        }
    
        private func playAudio() {
            player?.play()
            isplaying = true
        }
        
        private func stopAudio() {
            player?.stop()
            isplaying = false
        }
        
        private func updateProgress() {
            guard let player = player else { return }
            currentTime = player.currentTime
        }
        
        private func audioTime(to time: TimeInterval) {
            player?.currentTime = time
        }
    
        private func timeString(time: TimeInterval) -> String {
            let minute = Int(time) / 60
            let seconds = Int(time) % 60
            return String(format: "%02d:%02d", minute, seconds)
        }
}

struct Radio_Previews: PreviewProvider {
    static var previews: some View {
        Radio()
    }
}

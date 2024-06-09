//
//  AllahovaLijepaImena.swift
//  MuslimApp
//
//  Created by Muhedin Alic on 03.06.24.
//

import SwiftUI
import AVKit

struct AllahovaLijepaImena: View {
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

                        Image("allah")
                            .resizable()
                            .opacity(0.8)
                            .frame(width: 150, height: 150)
                        Text("(Asma-ul-Husna)")
                            .font(.callout)
                            .foregroundColor(Color.gray)
                        Text("99 Allahovih lijepih imena")
                            .font(.title)
                            .bold()
                            .padding(.top)
                            .foregroundColor(Color("MuslimBlack"))
                        VStack {
                            
                            HStack {
                                Text(timeString(time: currentTime))
                                Spacer()
                                Text(timeString(time: totalTime))
                            }
                            .font(.caption)
                            .foregroundColor(.black.opacity(0.8))
                            .padding([.top, .trailing, .leading], 20)
                            
                            HStack {
                                Image(systemName: isplaying ? "pause.circle.fill" : "play.circle.fill")
                                    .font(.largeTitle)
                                    .padding(.top, 18)
                                    .onTapGesture {
                                        isplaying ? stopAudio() : playAudio()
                                    }
                                Slider(value: Binding(get: {
                                        currentTime
                                }, set: { newValue in
                                        audioTime(to: newValue)
                                }), in: 0...totalTime)
                                        .accentColor(Color("DarkGreen")) // Promenite boju ovde
                                        .padding([.top, .trailing], 20)
                                }
                            }
                        .padding(.horizontal)
                            
                        
                        
                                            
                        VStack(alignment: .leading, spacing: 0) {
                            ForEach(imena) { ime in
                                ListaAllahovihImena(
                                    redniBroj: String(ime.redniBroj),
                                    imeSureNaArapskom: ime.imeNaArapskom,
                                    prevodImenaSure: ime.prevodImena,
                                    sura: ime.ime
                                )
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 0)
                                .padding(.vertical, 2)
                                
                                Divider()
                            }
                        }
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

struct AllahovaLijepaImena_Previews: PreviewProvider {
    static var previews: some View {
        AllahovaLijepaImena()
    }
}

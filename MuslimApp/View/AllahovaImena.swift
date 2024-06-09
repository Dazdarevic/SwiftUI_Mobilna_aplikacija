import SwiftUI
import AVKit

// pomocna klasa za upravljanje audio reprodukcijom
class AudioManager: NSObject, ObservableObject, AVAudioPlayerDelegate {
    @Published var isPlaying = false
    var player: AVAudioPlayer?
    
    func setUpAudio(fileName: String, fileType: String) {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: fileType) else {
            print("Audio file \(fileName).\(fileType) not found")
            return
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.delegate = self
            player?.prepareToPlay()
        } catch {
            print("Error initializing audio player: \(error.localizedDescription)")
        }
    }
    
    func playAudio() {
        player?.play()
        isPlaying = true
    }
    
    func stopAudio() {
        player?.stop()
        isPlaying = false
    }
    
    // AVAudioPlayerDelegate metode
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let error = error {
            print("Audio player decode error: \(error.localizedDescription)")
        }
    }
}

struct AllahovaImena: View {
    let audioFileName = "imena"
    let audioFileType = "mp3"
    
    @StateObject private var audioManager = AudioManager()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.white.ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .center) {
                        Text("99 Allahovih lijepih imena")
                            .font(.largeTitle)
                            .bold()
                            .padding(.top)
                            .foregroundColor(Color("MuslimBlack"))
                        Text("(Asma-ul-Husna)")
                            .font(.callout)
                            .foregroundColor(Color.gray)
                        
                        Image("allah")
                            .resizable()
                            .opacity(0.8)
                            .frame(width: 150, height: 150)
                        
                        Image(systemName: audioManager.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                            .font(.largeTitle)
                            .onTapGesture {
                                audioManager.isPlaying ? audioManager.stopAudio() : audioManager.playAudio()
                            }
                                            
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
                .onAppear {
                    audioManager.setUpAudio(fileName: audioFileName, fileType: audioFileType)
                }
                .navigationBarHidden(true)
            }
        }
    }
}

struct AllahovaImena_Previews: PreviewProvider {
    static var previews: some View {
        AllahovaImena()
    }
}

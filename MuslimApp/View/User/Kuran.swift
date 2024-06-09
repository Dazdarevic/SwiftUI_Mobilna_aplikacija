import SwiftUI

struct Kuran: View {
    @EnvironmentObject var settings: UserSettings

    var body: some View {
        NavigationView {
            ZStack {
                Color.white.ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .center) {
                        Text("Kur'anske sure")
                            .font(.largeTitle)
                            .bold()
                            .padding(.top)
//                            .padding(.leading)
                            .foregroundColor(Color("MuslimBlack"))
//                            .alignmentGuide(.leading) { _ in
//                                0 // pozicionira tekst na lijevu stranu
//                            }
                        
                        Image("quran")
                            .resizable()
                            .opacity(0.8)
                            .frame(width: 150, height: 120)
                                            
                        VStack(alignment: .leading, spacing: 0) {
                            ForEach(sure) { sura in
                                NavigationLink(destination: PrikazSure(suraNumber: sura.redniBroj,
                                                                       imeSure: sura.prevodImenaSure,
                                                                       tipSure: sura.tipSure)) {
                                    ListaSura(
                                        redniBroj: String(sura.redniBroj),
                                        imeSureNaArapskom: sura.imeSureNaArapskom,
                                        prevodImenaSure: sura.prevodImenaSure,
                                        tipSure: sura.tipSure,
                                        sura: sura.sura,
                                        brojAjeta: sura.brojAjeta
                                    )
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal, 0)
                                    .padding(.vertical, 2)
                                }
                                Divider()
                            }
                        }
                    }
                }
                .navigationBarHidden(settings.backBtn)
                .navigationBarBackButtonHidden(settings.backBtn)
            }
        }
    }
}

struct Kuran_Previews: PreviewProvider {
    static var previews: some View {
        Kuran()
            .environmentObject(UserSettings())
    }
}

import SwiftUI
import JWTDecode

struct Hifz: View {
    @State private var isRotated = false // pracenje rotacije - semafor
    @State private var versesArabic: [Verse] = [] // prevod ajeta
    @State private var randomText: String = ""
    @State private var dzuzBroj: Int = 30 // redni broj dzuza
    let gradient = Gradient(colors: [Color("PrimaryColor"), Color("MuslimLightGreen")])
    let gradient2 = Gradient(colors: [Color("DarkGreen"), Color("DarkGreen")])

    @State private var selectedCircle: Int? = nil

    
    var body: some View {
        ScrollView {
            VStack {
                Text("Testiraj svoj hifz. Probaj da se setiš narednog ajeta.")
                    .font(.title3)
                    .foregroundColor(Color("DarkGreen"))
                    .multilineTextAlignment(.center)
                    .padding(.vertical)
                Text("Izaberite džuz")
                    .font(.callout)
                    .bold()
                    .textCase(.uppercase)
                    .foregroundColor(Color("DarkGreen"))
                    .multilineTextAlignment(.center)
                    .offset(x: 0, y: 410)
                
                Group {
                    ZStack {
                        Rectangle()
                            .fill(isRotated ? Color("DarkGreen") : Color("MuslimWhite").opacity(0.8))
                            .frame(width: .infinity)
                            .frame(height: 210)
                            .cornerRadius(20)
                            .shadow(color: .gray, radius: 10, x: 0, y: 5)
                            .rotation3DEffect(
                                Angle(degrees: isRotated ? 180 : 0),
                                axis: (x: 0, y: 1, z: 0)
                            ) // Rotacija
                            
//                            .animation(.easeInOut(duration: 1), value: isRotated)
                            .padding()
                        
                        VStack {
                            if isRotated {
                                Text(randomText)
                                    .font(.title2)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding()
                                    .foregroundColor(Color.white.opacity(0.9))
                                    .lineLimit(nil)
                                    .rotation3DEffect(
                                        Angle(degrees: isRotated ? 0 : 180),
                                        axis: (x: 0, y: 1, z: 0)
                                    ) // Rotacija
                                    .animation(.easeInOut(duration: 0.5), value: isRotated)
                            } else {
                                Image("znakpitanja")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .padding()
                                    .rotation3DEffect(
                                        Angle(degrees: isRotated ? 180 : 0),
                                        axis: (x: 0, y: 1, z: 0)
                                    ) // Rotacija
                                    .animation(.easeInOut(duration: 0.5), value: isRotated)
                                Text("Testiraj")
                                    .font(.title)
                                    .foregroundColor(Color.white)
                                    .padding()
                                    .background(Color("DarkGreen"))
                                    .cornerRadius(10)
                                    .rotation3DEffect(
                                        Angle(degrees: isRotated ? 180 : 0),
                                        axis: (x: 0, y: 1, z: 0)
                                    ) // Rotacija
                                    .animation(.easeInOut(duration: 0.5), value: isRotated)
                            }
                        }
                        .onTapGesture {
                            withAnimation {
                                isRotated.toggle()
                            }
                        }
                    }
                }
                .offset(x: 0, y: -50)
                
                Group {
                    Circle()
                        .fill(selectedCircle == 30 ? LinearGradient(gradient: gradient2, startPoint: .leading, endPoint: .bottomTrailing) : LinearGradient(gradient: gradient, startPoint: .leading, endPoint: .bottomTrailing))
                        .frame(width: 80, height: 100)
                        .shadow(color: .gray, radius: 5, x: 0, y: 2)
                        .offset(x: -6, y: 40)
                        .overlay(
                                Text("30")
                                    .font(.largeTitle)
                                    .bold()
                                    .foregroundColor(selectedCircle == 30 ? Color("PrimaryColor") : Color("DarkGreen"))
                                    .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                                    .clipShape(Circle())
                                    .offset(x: -6, y: 40)
                            )
                        .onTapGesture {
                            dzuzBroj = 30
                            if(selectedCircle == 30) {
                                selectedCircle = 0
                            } else {
                                selectedCircle = 30 // Postavljanje izabranog kruga
                            }
                            
                            Task {
                                await getSuraArapski()
                                getRandomVerse()
                            }
                        }

                    
                    Circle()
                        .fill(selectedCircle == 29 ? LinearGradient(gradient: gradient2, startPoint: .leading, endPoint: .bottomTrailing) : LinearGradient(gradient: gradient, startPoint: .leading, endPoint: .bottomTrailing))
                        .frame(width: 80, height: 100)
                        .shadow(color: .gray, radius: 5, x: 0, y: 2)
                        .offset(x: 90, y: -40)
                        .overlay(
                                Text("29")
                                    .font(.largeTitle)
                                    .bold()
                                    .foregroundColor(selectedCircle == 29 ? Color("PrimaryColor") : Color("DarkGreen"))                                    .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                                    .clipShape(Circle())
                                    .offset(x: 90, y: -40)
                        )
                        .onTapGesture {
                            dzuzBroj = 29
                            if(selectedCircle == 29) {
                                selectedCircle = 0
                            } else {
                                selectedCircle = 29 // Postavljanje izabranog kruga
                            }
                            
                            Task {
                                await getSuraArapski()
                                getRandomVerse()
                            }
                        }

                    Circle()
                        .fill(selectedCircle == 28 ? LinearGradient(gradient: gradient2, startPoint: .leading, endPoint: .bottomTrailing) : LinearGradient(gradient: gradient, startPoint: .leading, endPoint: .bottomTrailing))
                        .frame(width: 80, height: 100)
                        .shadow(color: .gray, radius: 5, x: 0, y: 2)
                        .offset(x: 130, y: -50)
                        .overlay(
                                Text("28")
                                    .font(.largeTitle)
                                    .bold()
                                    .foregroundColor(selectedCircle == 28 ? Color("PrimaryColor") : Color("DarkGreen"))                                    .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                                    .clipShape(Circle())
                                    .offset(x: 130, y: -50)
                        )
                        .onTapGesture {
                            dzuzBroj = 28
                            if(selectedCircle == 28) {
                                selectedCircle = 0
                            } else {
                                selectedCircle = 28 // Postavljanje izabranog kruga
                            }
                            
                            Task {
                                await getSuraArapski()
                                getRandomVerse()
                            }
                        }

                    Circle()
                        .fill(selectedCircle == 27 ? LinearGradient(gradient: gradient2, startPoint: .leading, endPoint: .bottomTrailing) : LinearGradient(gradient: gradient, startPoint: .leading, endPoint: .bottomTrailing))
                        .frame(width: 80, height: 100)
                        .shadow(color: .gray, radius: 5, x: 0, y: 2)
                        .offset(x: 100, y: -70)
                        .overlay(
                                Text("27")
                                    .font(.largeTitle)
                                    .bold()
                                    .foregroundColor(selectedCircle == 27 ? Color("PrimaryColor") : Color("DarkGreen"))                                    .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                                    .clipShape(Circle())
                                    .offset(x: 100, y: -70)
                        )
                        .onTapGesture {
                            dzuzBroj = 27
                            if(selectedCircle == 27) {
                                selectedCircle = 0
                            } else {
                                selectedCircle = 27 // Postavljanje izabranog kruga
                            }
                            
                            Task {
                                await getSuraArapski()
                                getRandomVerse()
                            }
                        }

                    Circle()
                        .fill(selectedCircle == 26 ? LinearGradient(gradient: gradient2, startPoint: .leading, endPoint: .bottomTrailing) : LinearGradient(gradient: gradient, startPoint: .leading, endPoint: .bottomTrailing))
                        .frame(width: 80, height: 100)
                        .shadow(color: .gray, radius: 5, x: 0, y: 2)
                        .offset(x: 10, y: -150)
                        .overlay(
                                Text("26")
                                    .font(.largeTitle)
                                    .bold()
                                    .foregroundColor(selectedCircle == 26 ? Color("PrimaryColor") : Color("DarkGreen"))                                    .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                                    .clipShape(Circle())
                                    .offset(x: 10, y: -150)
                        )
                        .onTapGesture {
                            dzuzBroj = 26
                            if(selectedCircle == 26) {
                                selectedCircle = 0
                            } else {
                                selectedCircle = 26 // Postavljanje izabranog kruga
                            }
                            
                            Task {
                                await getSuraArapski()
                                getRandomVerse()
                            }
                        }
                    Circle()
                        .fill(selectedCircle == 25 ? LinearGradient(gradient: gradient2, startPoint: .leading, endPoint: .bottomTrailing) : LinearGradient(gradient: gradient, startPoint: .leading, endPoint: .bottomTrailing))
                        .frame(width: 80, height: 100)
                        .shadow(color: .gray, radius: 5, x: 0, y: 2)
                        .offset(x: -85, y: -280)
                        .overlay(
                                Text("25")
                                    .font(.largeTitle)
                                    .bold()
                                    .foregroundColor(selectedCircle == 25 ? Color("PrimaryColor") : Color("DarkGreen"))                                    .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                                    .clipShape(Circle())
                                    .offset(x: -85, y: -280)
                        )
                        .onTapGesture {
                            dzuzBroj = 25
                            if(selectedCircle == 25) {
                                selectedCircle = 0
                            } else {
                                selectedCircle = 25 // Postavljanje izabranog kruga
                            }
                            
                            Task {
                                await getSuraArapski()
                                getRandomVerse()
                            }
                        }
                    
                    Circle()
                        .fill(selectedCircle == 24 ? LinearGradient(gradient: gradient2, startPoint: .leading, endPoint: .bottomTrailing) : LinearGradient(gradient: gradient, startPoint: .leading, endPoint: .bottomTrailing))
                        .frame(width: 80, height: 100)
                        .shadow(color: .gray, radius: 5, x: 0, y: 2)
                        .offset(x: -120, y: -470)
                        .overlay(
                                Text("24")
                                    .font(.largeTitle)
                                    .bold()
                                    .foregroundColor(selectedCircle == 24 ? Color("PrimaryColor") : Color("DarkGreen"))                                    .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                                    .clipShape(Circle())
                                    .offset(x: -120, y: -470)
                        )
                        .onTapGesture {
                            dzuzBroj = 24
                            if(selectedCircle == 24) {
                                selectedCircle = 0
                            } else {
                                selectedCircle = 24 // Postavljanje izabranog kruga
                            }
                            
                            Task {
                                await getSuraArapski()
                                getRandomVerse()
                            }
                        }
                    
                    Circle()
                        .fill(selectedCircle == 23 ? LinearGradient(gradient: gradient2, startPoint: .leading, endPoint: .bottomTrailing) : LinearGradient(gradient: gradient, startPoint: .leading, endPoint: .bottomTrailing))
                        .frame(width: 80, height: 100)
                        .shadow(color: .gray, radius: 5, x: 0, y: 2)
                        .offset(x: -90, y: -670)
                        .overlay(
                                Text("23")
                                    .font(.largeTitle)
                                    .bold()
                                    .foregroundColor(selectedCircle == 23 ? Color("PrimaryColor") : Color("DarkGreen"))                                    .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                                    .clipShape(Circle())
                                    .offset(x: -90, y: -670)
                        )
                        .onTapGesture {
                            dzuzBroj = 23
                            if(selectedCircle == 23) {
                                selectedCircle = 0
                            } else {
                                selectedCircle = 23 // Postavljanje izabranog kruga
                            }
                            
                            Task {
                                await getSuraArapski()
                                getRandomVerse()
                            }
                        }
                }
                .offset(x: 0, y: -80)

            }
        }
        .onAppear {
            // Poziva se kada se pogled pojavi na ekranu
            Task {
                await getSuraArapski()
                getRandomVerse()
            }
            
        }
        
    }
    
    func getSuraArapski() async {
        guard let url = URL(string: "https://cdn.jsdelivr.net/gh/fawazahmed0/quran-api@1/editions/ara-quranacademy/juzs/\(dzuzBroj).json") else {
            print("Podaci nisu pokupljeni")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let quranResponse = try decoder.decode(QuranResponse.self, from: data)
            versesArabic = quranResponse.juzs
        } catch {
            print("Greška prilikom dohvaćanja i dekodiranja podataka: \(error.localizedDescription)")
        }
    }

    
    func getRandomVerse() {
            guard !versesArabic.isEmpty else {
                print("No verses available")
                return
                
            }
            
            let randomIndex = Int.random(in: 0..<versesArabic.count)
            randomText = versesArabic[randomIndex].text
        
            print("Random text: \(randomText)")

        }

}

struct Hifz_Previews: PreviewProvider {
    static var previews: some View {
        Hifz()
    }
}

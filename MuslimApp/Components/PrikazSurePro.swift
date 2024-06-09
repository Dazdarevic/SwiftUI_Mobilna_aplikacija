import SwiftUI

struct PrikazSurePro: View {
    @State private var verses: [Verse] = [] // prevod ajeta
    @State private var versesArabic: [Verse] = [] // prevod ajeta na arapski

    let suraNumber: Int
    let imeSure: String
    let tipSure: String

    var body: some View {
        ScrollView {
            VStack {
                Group {
                    Text("\(imeSure)")
                        .font(.largeTitle)
                        .bold()
                        .padding(.top)
                        .foregroundColor(Color("DarkGreen"))
                    HStack {
                        if tipSure == "mekkanska" {
                            Image("mekka")
                                .resizable()
                                .opacity(0.8)
                                .frame(width: 20, height: 20)
                        } else {
                             Image("medina")
                                 .resizable()
                                 .opacity(0.8)
                                 .frame(width: 20, height: 20)
                        }
                        Spacer()
                        Text("\(verses.count) ajeta")
                            .font(.subheadline)
                            .foregroundColor(Color("MuslimBlack"))
                    }
                    .padding(.horizontal, 60)
                    .padding(.bottom, 12)
                    
                    Image("bismila")
                        .resizable()
                        .opacity(0.8)
                        .frame(width: 220, height: 70)
                }
            }
            .background(Color.white)
            
            VStack(spacing: 0) {
                ForEach(versesArabic.indices, id: \.self) { index in
                    VStack(alignment: .center) {
                        Text("\(versesArabic[index].verse)")
                            .font(.title2)
                            .bold()
                            .padding(.vertical, 3)
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(Color("MuslimBlack").opacity(0.7))
                        Text(versesArabic[index].text)
                            .font(.title3)
                            .padding(.horizontal, 12)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .foregroundColor(Color("MuslimBlack").opacity(0.9))
                            .lineLimit(nil)
                        
                        Text(verses[index].text)
                            .font(.title3)
                            .padding()
                            .padding(.vertical, 5)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(Color("MuslimBlack").opacity(0.9))
                            .lineLimit(nil) // omogucuje da se tekst prikaze u vise redova
                    }
                    .padding(10)
                    .font(.callout)
                    .frame(maxWidth: .infinity)
                    .background(Color("PrimaryColor").opacity(0.1))
                    .cornerRadius(10)
                }
                .padding(.vertical, 4)
            }
        }
        .onAppear {
            Task {
                await getSura()
                await getSuraArapski()
            }
        }
    }

    func getSura() async {
        guard let url = URL(string: "https://cdn.jsdelivr.net/gh/fawazahmed0/quran-api@1/editions/bos-muhamedmehanovi/\(suraNumber).json") else {
            print("Podaci nisu pokupljeni")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let decoder = JSONDecoder()
            let chapterResponse = try decoder.decode(ChapterResponse.self, from: data)
            
            // Postavljanje verses sa rezultatom dohvatanja
            verses = chapterResponse.chapter
        } catch {
            print("Podaci nisu validni: \(error.localizedDescription)")
        }
    }
    
    func getSuraArapski() async {
        guard let url = URL(string: "https://cdn.jsdelivr.net/gh/fawazahmed0/quran-api@1/editions/ara-quranacademy/\(suraNumber).json") else {
            print("Podaci nisu pokupljeni")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let decoder = JSONDecoder()
            let chapterResponseArabic = try decoder.decode(ChapterResponse.self, from: data)
            
            // Postavljanje versesArabic sa rezultatom dohvatanja
            versesArabic = chapterResponseArabic.chapter
        } catch {
            print("Podaci nisu validni: \(error.localizedDescription)")
        }
    }
}

struct PrikazSurePro_Previews: PreviewProvider {
    static var previews: some View {
        PrikazSurePro(suraNumber: 1, imeSure: "El-Fatiha", tipSure: "mekkanska")
    }
}

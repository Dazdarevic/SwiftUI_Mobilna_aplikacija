import SwiftUI

struct PrikazSure: View {
    @EnvironmentObject var settings: UserSettings
    @State private var verses: [Verse] = [] // ajeti
    let suraNumber: Int
    let imeSure: String
    let tipSure: String

    var body: some View {
            ScrollView {
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


                VStack(spacing: 0) {
                    ForEach(verses.indices, id: \.self) { index in
                        VStack(alignment: .center) {
                            Text("\(verses[index].verse)")
                                .font(.headline)
                                .bold()
                                .padding(.vertical, 3)
                                .foregroundColor(Color("DarkGreen"))
                            Text(verses[index].text)
                                .font(.body)
                                .lineLimit(nil) // omogucuje da se tekst prikaze u vise redova
                        }
                        .padding(10)
                        .font(.callout)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .background(Color("PrimaryColor").opacity(0.1))
                        .cornerRadius(10)

                        // Divider osim za zadnji element
                        if index != verses.count - 1 {
                            Divider()
                                .background(Color.gray)
                        }
                    }
                }
            }
        .onAppear {
            Task {
                await getSura()
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

            verses = chapterResponse.chapter
        } catch {
            print("Podaci nisu validni: \(error.localizedDescription)")
        }
    }
}

struct PrikazSure_Previews: PreviewProvider {
    static var previews: some View {
        PrikazSure(suraNumber: 1, imeSure: "El-Fatiha", tipSure: "mekkanska")
    }
}
    

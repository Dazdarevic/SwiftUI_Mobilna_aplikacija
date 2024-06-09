//
//  PorukaView.swift
//  MuslimApp
//
//  Created by Muhedin Alic on 03.06.24.
//

import SwiftUI
import SDWebImageSwiftUI


struct PorukaView: View {
    @State private var sveSlike: [Slika] = [] // lista dova
    @State private var randomImageUrl: String = "" // nasumicni URL

    var resizingMode: ContentMode = .fill

    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            Text("Poruka dana")
                .font(.largeTitle)
                .foregroundColor(Color("DarkGreen"))
                .bold()
                .padding(.horizontal, 25)
//
                    if !randomImageUrl.isEmpty {
                        Rectangle()
                                .opacity(0.001)
                                .overlay {
                                    WebImage(url: URL(string: randomImageUrl))
                                        .resizable()
                                        .aspectRatio(contentMode: resizingMode)
                                        .frame(height: 400)
                                        .clipped()
                                        .cornerRadius(30)
                                        .shadow(color: .gray, radius: 5, x: 0, y: 2)
                                        .padding(.horizontal, 0)

                                }
                                .frame(height: 500)
                                .clipped()
                                .cornerRadius(20)
                                .shadow(color: .gray, radius: 5, x: 0, y: 2)
                                .padding(.horizontal, 25)
                    } else {
                        Rectangle()
                                .opacity(0.001)
                                .overlay {
                                    WebImage(url: URL(string: randomImageUrl))
                                        .resizable()
                                        .indicator(.activity)
                                        .aspectRatio(contentMode: resizingMode)
                                        .allowsHitTesting(false)
                                    Image(randomImageUrl)

                                }
                                .frame(height: 400)
                                .clipped()
                                .cornerRadius(30)
                                .shadow(color: .gray, radius: 5, x: 0, y: 2)
                                .padding(.horizontal, 40)
                    }
            Circle()
                .fill(Color("DarkGreen"))
            .frame(width: 80, height: 80)
            .overlay {
                Image(systemName: "arrow.counterclockwise")
                                .font(.largeTitle)
                                .foregroundColor(Color.white)
                                .frame(width: 80, height: 80)
                                .padding()
                                .shadow(radius: 10)
            }
            .padding(.top)
            .shadow(color: .gray, radius: 5, x: 0, y: 2)
            .onTapGesture {
                // ucitaj novu sliku
                loadRandomImage()
            }
            
            Spacer()
            
        }
        .onAppear {
            Task {
                await getPoruke()
                loadRandomImage()
            }
        }
            
    }
    
    func getPoruke() async {
        guard let url = URL(string: UrlHelper.baseUrl + "/Korisnik/get-all-photos") else {
            print("Podaci nisu pokupljeni")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            print("Provera 4")
                    if let data = data {
                        do {
                            print("Provera 2")
                            let decodedResponse = try JSONDecoder().decode([Slika].self, from: data)
                            DispatchQueue.main.async {
                                self.sveSlike = decodedResponse
                                print(sveSlike)
                                loadRandomImage()

                            }
                        } catch {
                            print("Error decoding JSON: \(error)")
                        }
                    }
                }.resume()
    }
    
    func loadRandomImage() {
            guard !sveSlike.isEmpty else {
                print("No photos available")
                return
                
            }
            
            let randomIndex = Int.random(in: 0..<sveSlike.count)
            randomImageUrl = sveSlike[randomIndex].url
        
            print("Random image: \(randomImageUrl)")

        }
}

struct PorukaView_Previews: PreviewProvider {
    static var previews: some View {
        PorukaView()
    }
}

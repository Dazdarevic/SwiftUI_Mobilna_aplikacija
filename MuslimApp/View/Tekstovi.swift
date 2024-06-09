//
//  Tekstovi.swift
//  MuslimApp
//
//  Created by Muhedin Alic on 05.06.24.
//

import SwiftUI

struct Tekstovi: View {
    @State private var citati = [Citat]()
    var body: some View {
                VStack {
                    ScrollView {
                        Text("Najlepsa kazivanja")
                            .font(.largeTitle)
                            .bold()
                            .padding(.vertical)
                            ForEach(citati) { citat in
                                Text(citat.citatTxt)
                                    .padding()
                                    .background(Color("DarkGreen").opacity(0.3))
                                    .padding()
                            }
                        }
                        .onAppear {
                            guard let url = URL(string: UrlHelper.baseUrl + "/Korisnik/get-citat") else {
                                return
                            }

                            URLSession.shared.dataTask(with: url) { data, response, error in
                                guard let data = data else { return }

                                do {
                                    citati = try JSONDecoder().decode([Citat].self, from: data)
                                } catch {
                                    print("Error decoding JSON: \(error)")
                                }
                            }.resume()
                        }
            }
    }
}

struct Tekstovi_Previews: PreviewProvider {
    static var previews: some View {
        Tekstovi()

    }
}

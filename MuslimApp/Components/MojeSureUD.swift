//
//  MojeSureUD.swift
//  MuslimApp
//
//  Created by Muhedin Alic on 04.06.24.
//

import SwiftUI

struct MojeSureUD: View {
    let idZajednickeDove: Int
    let dova: String
    let brojLajkova: Int
    @State private var isLiked = false
    var lajkovanjeAction: ((Int, Bool) -> Void)?
    var getDoveAction: () -> Void
    @State private var showingDeleteAlert = false
    @State var showFormForEdit: Bool = false

    
    var body: some View {
        ScrollView {
            VStack {
                Group {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color("Biege").opacity(0.9))
                        .frame(height: 300)
                        .frame(width: .infinity)
                        .padding()
                        .cornerRadius(70)
                        .shadow(color: .gray, radius: 5, x: 0, y: 2)
                        .overlay {
                            VStack(alignment: .leading) {
                                Text(dova)
                                    .padding(.all)
                                    .font(.body)
                                    .padding(.all)
                                    .lineLimit(3)
                                HStack {
                                    
                                    HStack {
                                        Image(systemName: isLiked ? "heart.fill" : "heart")
                                            .font(.title)
                                            .foregroundColor(Color("DarkGreen"))
                                            .onTapGesture {
                                                isLiked.toggle()
                                                lajkovanjeAction?(idZajednickeDove, !isLiked)
                                            }

                                        Text("Prouči dovu")
                                            .font(.title3)
                                            .foregroundColor(Color("DarkGreen"))
                                    }
                                    .padding(.bottom)
                                    
                                    Spacer()
                                    
                                    HStack {
                                        Text("\(brojLajkova)")
                                            .font(.title3)
                                            .padding(.bottom)
                                        Circle()
                                            .fill(Color.gray.opacity(0.5))
                                            .frame(width: 40, height: 40)
                                            .padding(.bottom)
                                            .overlay {
                                                Image(systemName: "heart.fill")
                                                    .font(.title3)
                                                    .foregroundColor(Color("DarkGreen"))
                                                    .padding(.bottom)
                                        }
                                    
                                    }
                                    
                                }
                                .padding(.horizontal, 30)
                                
                                HStack {
                                    Spacer()
                                    Text("Izbriši")
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color.red)
                                        .cornerRadius(8)
                                        .shadow(radius: 3)
                                        .onTapGesture {
                                            showingDeleteAlert = true
                                        }
                                        .alert(isPresented: $showingDeleteAlert) {
                                            Alert(
                                                title: Text("Brisanje Dove"),
                                                message: Text("Da li ste sigurni da želite da izbrišete ovu dovu?"),
                                                primaryButton: .destructive(Text("Izbriši")) {
                                                Task {
                                                    await deleteDova()
                                                }},
                                                secondaryButton: .cancel()
                                            )
                                        }
//                                    Text("Ažuriraj")
//                                        .foregroundColor(.white)
//                                        .padding()
//                                        .background(Color.blue)
//                                        .cornerRadius(8)
//                                        .shadow(radius: 3)
//                                        .onTapGesture {
//                                            // azuriraj
//                                            showFormForEdit.toggle()
//                                        }
                                }
                                .padding(.horizontal, 30)
                            }
                        }
                }
                

            }
        }
    }
    func deleteDova() async {
        guard let url = URL(string: "\(UrlHelper.baseUrl)/Korisnik/izbrisi-dovu?id=\(idZajednickeDove)") else {
            print("URL nije validan")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    print("Dova uspešno izbrisana.")
                    getDoveAction()
                } else {
                    print("Greška prilikom brisanja dove. Kod greške: \(httpResponse.statusCode)")
                }
            } else {
                print("Nevalidan odgovor od servera.")
            }
        } catch {
            print("Greška prilikom slanja zahteva za brisanje dove: \(error)")
        }
    }
}
struct DovaEdit: View {
    let gradient = Gradient(colors: [Color("PrimaryColor"), Color("MuslimLightGreen")])
    @State private var mojaDova = ""
    @State private var response: String = ""

    @Environment(\.presentationMode) var presentationMode
    @Binding var showFormForEdit: Bool
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color("MuslimLightGray").opacity(1)
            
            VStack {
                Text("Dovu mogu videti svi")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                    .padding(.vertical, 100)
                TextField("Moja dova", text: $mojaDova)
                    .font(.title3)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(50)
                    .shadow(color: Color.black.opacity(0.08), radius: 60, x: 0.0, y: 16)
                    .padding(.vertical)

                Text("Ažuriraj")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color("MuslimWhite"))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(50)
                    .shadow(color: Color.black.opacity(0.5), radius: 70, x: 0.9, y: 16)
                    .onTapGesture {
                        Task {
//                            await postDova()
                            //azuriraj
                        }
                    }
                
            }
            .padding(.all)
            Button(action: {
                showFormForEdit.toggle()
            }, label: {
                Image(systemName: "xmark")
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .padding(20)
            })
        }
    }
    
    func postDova() async {
        guard let url = URL(string: UrlHelper.baseUrl + "/Korisnik/dodaj-dovu") else {
            response = "Nevažeći URL"
            print(response)  // Ispis u konzoli
            return
        }

        let userData = DovaZaSlanje(
            dovaTxt: mojaDova,
            id_Korisnika: 1
        )

        guard let jsonData = try? JSONEncoder().encode(userData) else {
            response = "Greška kod enkodiranja korisničkih podataka"
            print(response)  // Ispis u konzoli
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        do {
            let (data, urlResponse) = try await URLSession.shared.data(for: request)
            if let httpResponse = urlResponse as? HTTPURLResponse {
                if httpResponse.statusCode == 201 {
                    response = "Uspešno ste se registrovali."
                } else {
                    // Parsiranje greške iz odgovora
                    let errorResponse = String(data: data, encoding: .utf8) ?? "Nepoznata greška"
                    response = "Greška: \(httpResponse.statusCode) - \(errorResponse)"
                    print("HTTP greška: \(httpResponse.statusCode) - \(errorResponse)")
                    mojaDova = "" // Ispis u konzoli
                    
                }
            } else {
                response = "Nevažeći odgovor sa servera"
                print(response)  // Ispis u konzoli
            }
        } catch {
            response = "Mrežna greška: \(error.localizedDescription)"
            print("Mrežna greška: \(error)")  // Ispis u konzoli
        }
    }
}

struct MojeSureUD_Previews: PreviewProvider {
    static var previews: some View {
        MojeSureUD(idZajednickeDove: 1, dova: "Dova za Palestinu", brojLajkova: 122, getDoveAction: {})

    }
}

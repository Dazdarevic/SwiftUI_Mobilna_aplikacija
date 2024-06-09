import SwiftUI

struct DoveUser: View {
    @State private var sveDove: [Dova] = [] // lista dova
    @State var showMojeDove: Bool = false
    @EnvironmentObject var settings: UserSettings

    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(sveDove, id: \.id) { dova in
                        PrikazZajednickeDove(idZajednickeDove: dova.id, dova: dova.dovaTxt, brojLajkova: dova.broj_Lajkova, lajkovanjeAction: lajkujDovu)
                    }
                }
            }

            Image(systemName: "plus")
                .foregroundColor(.white)
                .padding()
                .background(Color("DarkGreen").opacity(0.8))
                .font(.system(size: 50))
                .cornerRadius(50)
                .padding()
                .shadow(color: .gray, radius: 5, x: 0, y: 2)
                .onTapGesture {
                    showMojeDove.toggle()
                }
            
            DodajDovu(showMojeDove: $showMojeDove)
                .padding(.top, 100)
                .offset(y: showMojeDove ? 0.0 : UIScreen.main.bounds.height)
                .animation(.spring(), value: self.showMojeDove)
        }
        .onAppear {
            Task {
                await getDove()
            }
        }
        .onChange(of: showMojeDove) { newValue in
            if !newValue {
                Task {
                    await getDove()
                }
            }
        }
    }
    
    func lajkujDovu(forDovaId id: Int, povecaj: Bool) {
        let lajkovanjeRequest = LajkovanjeRequest(id: id, povecaj: povecaj)
        
        var urlComponents = URLComponents(string: UrlHelper.baseUrl + "/Korisnik/promeni-broj-lajkova")!
        
        urlComponents.queryItems = [
            URLQueryItem(name: "id", value: "\(id)"),
            URLQueryItem(name: "povecaj", value: "\(povecaj)")
        ]
        
        guard let url = urlComponents.url else {
            print("Invalid URL components")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(lajkovanjeRequest)
        } catch {
            print("Error encoding lajkovanjeRequest: \(error)")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            guard (200...299).contains(response.statusCode) else {
                print("Server returned status code \(response.statusCode)")
                return
            }
            
            if let responseData = try? JSONSerialization.jsonObject(with: data, options: []) {
                print("Response data: \(responseData)")
                Task {
                    await getDove()
                }
            } else {
                print("Invalid response data")
                Task {
                    await getDove()
                }
            }
        }.resume()
    }
    
    func handleLikeButtonTapped(forDovaId dovaId: Int) {
        print("Dova sa ID-jem \(dovaId) je lajkovana")
    }
    
    func getDove() async {
        guard let url = URL(string: UrlHelper.baseUrl + "/Korisnik/get-dove") else {
            print("Podaci nisu pokupljeni")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decodedResponse = try JSONDecoder().decode([Dova].self, from: data)
                    DispatchQueue.main.async {
                        self.sveDove = decodedResponse
                        print(sveDove)
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }
        }.resume()
    }
}

struct DodajDovu: View {
    let gradient = Gradient(colors: [Color("PrimaryColor"), Color("MuslimLightGreen")])
    @State private var mojaDova = ""
    @State private var response: String = ""
    @EnvironmentObject var settings: UserSettings

    @Environment(\.presentationMode) var presentationMode
    @Binding var showMojeDove: Bool
    
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

                Text("Dodaj")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color("MuslimWhite"))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("DarkGreen"))
                    .cornerRadius(50)
                    .shadow(color: Color.black.opacity(0.5), radius: 70, x: 0.9, y: 16)
                    .onTapGesture {
                        Task {
                            await postDova()
                        }
                    }
                
            }
            .padding(.horizontal)
            Button(action: {
                showMojeDove.toggle()
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
            id_Korisnika: settings.userId
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

struct DoveUser_Previews: PreviewProvider {
    static var previews: some View {
        DoveUser()
            .environmentObject(UserSettings())

    }
}

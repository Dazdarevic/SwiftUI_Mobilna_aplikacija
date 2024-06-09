import SwiftUI

struct HomeProUser: View {
    let columns: [GridItem] = Array(repeating: .init(.fixed(80), spacing: 10), count: 4)
    @EnvironmentObject var settings: UserSettings
    @State private var najviseLajkova: [Dova] = [] //
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Vjera")
                        .font(.title)
                        .bold()
                        .padding(.horizontal, 25)
                    
                    LazyVGrid(columns: columns, spacing: 20) {
//                        NavigationLink(destination: DovaView()) {
//                            ImageTitleRowCell(imageSize: 80, imageName: "dova", title: "Dova")
//                        }
                        NavigationLink(destination: Tesbih()) {
                            ImageTitleRowCell(imageSize: 80, imageName: "tesbih", title: "Tesbih")
                        }
                        NavigationLink(destination: Radio()) {
                            ImageTitleRowCell(imageSize: 80, imageName: "radio", title: "Radio")
                        }
                        NavigationLink(destination: Hifz()) {
                            ImageTitleRowCell(imageSize: 80, imageName: "hifz", title: "Hifz")
                        }
                    }
                    .padding(.horizontal)
                }
                Divider()

                VStack(alignment: .leading, spacing: 10) {
                    Text("Zajednica")
                        .font(.title)
                        .bold()
                        .padding(.horizontal, 25)

                    LazyVGrid(columns: columns, spacing: 20) {
                        NavigationLink(destination: PorukaView()) {
                            ImageTitleRowCell(imageSize: 80, imageName: "lijeparijec", title: "Poruka")
                        }
                        NavigationLink(destination: Tekstovi()) {
                            ImageTitleRowCell(imageSize: 80, imageName: "kazivanja", title: "Tekstovi")
                        }
                        NavigationLink(destination: ZajednickeDove()) {
                            ImageTitleRowCell(imageSize: 80, imageName: "dove", title: "Dove")
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
                
                Divider()
                VStack(alignment: .leading, spacing: 10) {
                    Text("Korisno")
                        .font(.title)
                        .bold()
                        .padding(.horizontal, 25)

                    LazyVGrid(columns: columns, spacing: 20) {
                        NavigationLink(destination: AllahovaLijepaImena()) {
                            ImageTitleRowCell(imageSize: 80, imageName: "99imena", title: "99 imena")
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
                
                Divider()

                VStack(alignment: .leading, spacing: 10) {
                    Text("Dove iz cijelog svijeta")
                        .font(.title)
                        .bold()
                        .padding(.horizontal, 25)
                    ForEach(najviseLajkova, id: \.id) { dova in
                        PrikazZajednickeDove(idZajednickeDove: dova.id, dova: dova.dovaTxt, brojLajkova: dova.broj_Lajkova, lajkovanjeAction: lajkujDovu)
                        
                        
                    }
                }
            }
            .onAppear {
                Task {
                    await getDoveSaNajviseLajkova()
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
                        await getDoveSaNajviseLajkova()
                    }
                } else {
                    print("Invalid response data")
                    Task {
                        await getDoveSaNajviseLajkova()
                    }
                }
        }.resume()
    }

    func getDoveSaNajviseLajkova() async {
        guard let url = URL(string: UrlHelper.baseUrl + "/Korisnik/najvise-lajkova") else {
            print("Podaci nisu pokupljeni")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
                    if let data = data {
                        do {
                            let decodedResponse = try JSONDecoder().decode([Dova].self, from: data)
                            DispatchQueue.main.async {
                                self.najviseLajkova = decodedResponse
                                print(najviseLajkova)
                            }
                        } catch {
                            print("Error decoding JSON: \(error)")
                        }
                    }
                }.resume()
    }
}

struct HomeProUser_Previews: PreviewProvider {
    static var previews: some View {
        HomeProUser()
            .environmentObject(UserSettings())
    }
}

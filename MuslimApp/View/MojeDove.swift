//
//  MojeDove.swift
//  MuslimApp
//
//  Created by Muhedin Alic on 04.06.24.
//

import SwiftUI

struct MojeDove: View {
    @State private var sveDove: [Dova] = [] // lista dova
    @State var showMojeDove: Bool = false

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(sveDove, id: \.id) { dova in
                        PrikazZajednickeDove(idZajednickeDove: dova.id, dova: dova.dovaTxt, brojLajkova: dova.broj_Lajkova, lajkovanjeAction: lajkujDovu)
                    }
                }
            }
        }
        .onAppear {
            Task {
                await getDove()
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


struct MojeDove_Previews: PreviewProvider {
    static var previews: some View {
        MojeDove()
    }
}

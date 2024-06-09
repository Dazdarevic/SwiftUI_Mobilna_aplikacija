//
//  VaktijaComponent.swift
//  MuslimApp
//
//  Created by Muhedin Alic on 02.06.24.
//

import SwiftUI

struct VaktijaComponent: View {
    @State private var data: VaktijaData?
    @State private var currentDate = Date()
    @State private var currentHour = Calendar.current.component(.hour, from: Date())


    var body: some View {
        ZStack {
            if currentHour >= 20 || currentHour < 5 {
                            Image("noc")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } else {
                            Image("sunce")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        }
            VStack(alignment: .leading, spacing: 50) {
                Spacer()
                Group {
                    Text("Namazi")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .bold()
                }
                .padding(.horizontal, 20)

                if let data = data {
                    VStack(alignment: .center, spacing: 50) {
                        
                        HStack(spacing: 60) {
                            Button(action: {
                                loadPreviousDay()
                            }) {
                                Image(systemName: "chevron.left")
                                    .font(.largeTitle)
                                    .foregroundColor(Color("MuslimBlack"))
                                    .padding(10)
                                    .background(Color.white.opacity(0.8))
                                    .clipShape(Circle())
                                }
                            
                                VStack(alignment: .center) {
                                Text("\(data.lokacija)")
                                    .font(.title)
                                    .bold()
                                    .foregroundColor(.white)
                                Text("\(formattedDate(from: currentDate))")
                                    .foregroundColor(.white)
                        }
                            Button(action: {
                                loadNextDay()
                            }) {
                                Image(systemName: "chevron.right")
                                    .font(.largeTitle)
                                    .foregroundColor(Color("MuslimBlack"))
                                    .padding(10)
                                    .background(Color.white.opacity(0.8))
                                    .clipShape(Circle())
                                }
                        }
                        
                        HStack(alignment: .top, spacing: 120) {
                            VStack(alignment: .leading, spacing: 25) {
                                Text("Zora")
                                    .font(.title2)
                                    .textCase(.uppercase)
                                    .foregroundColor(.white)
                                Text("Izlazak sunca")
                                    .font(.title2)
                                    .textCase(.uppercase)
                                    .foregroundColor(.white)
                                Text("Podne")
                                    .font(.title2)
                                    .textCase(.uppercase)
                                    .foregroundColor(.white)
                                Text("Ikindija")
                                    .font(.title2)
                                    .textCase(.uppercase)
                                    .foregroundColor(.white)
                                Text("Akšam")
                                    .font(.title2)
                                    .textCase(.uppercase)
                                    .foregroundColor(.white)
                                Text("Jacija")
                                    .font(.title2)
                                    .textCase(.uppercase)
                                    .foregroundColor(.white)
                            }
                            
                            VStack(alignment: .trailing, spacing: 25) {
                                Text("\(data.vakat[0])")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                Text("\(data.vakat[1])")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                Text("\(data.vakat[2])")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                Text("\(data.vakat[3])")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                Text("\(data.vakat[4])")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                Text("\(data.vakat[5])")
                                    .font(.title2)
                                    .foregroundColor(.white)
                            }
                        }
                        .padding()
                        .background(.black.opacity(0.0))
                        
                        Spacer()
                    }
                }
            }
        }
        .onAppear {
            fetchData()
        }
    }
        private func loadPreviousDay() {
            currentDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
            fetchData()
        }
        
        private func loadNextDay() {
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
            fetchData()
        }
        
        private func formattedDate(from date: Date) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            return dateFormatter.string(from: date)
        }
    private func fetchData() {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd"
            let dateString = dateFormatter.string(from: currentDate)
            
            guard let url = URL(string: "https://api.vaktija.ba/vaktija/v1/110/\(dateString)") else {
                print("Invalid URL")
                return
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("Error fetching data: \(error)")
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    print("Unexpected response status code")
                    return
                }
                
                if let data = data {
                    do {
                        let decodedData = try JSONDecoder().decode(VaktijaData.self, from: data)
                        DispatchQueue.main.async {
                            self.data = decodedData
                            print(decodedData)
                        }
                    } catch {
                        print("Error decoding data: \(error)")
                    }
                }
            }.resume()
        }
}

struct VaktijaComponent_Previews: PreviewProvider {
    static var previews: some View {
        VaktijaComponent()
    }
}

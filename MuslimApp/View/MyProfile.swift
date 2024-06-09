import SwiftUI

struct MyProfile: View {
    @EnvironmentObject var settings: UserSettings
    @State private var podaci: Korisnik?
    @State var showMojeDove: Bool = false

    var body: some View {
        VStack {
            VStack {
                VStack(spacing: 10) {
                    Text("Moj profil")
                        .font(.largeTitle)
                        .textCase(.uppercase)
                        .foregroundColor(Color("DarkGreen").opacity(0.9))

                    if let podaci = podaci {
                        HStack {
                            Image(systemName: "envelope.fill")
                                .foregroundColor(Color("DarkGreen").opacity(0.9))
                            Text(podaci.email)
                                .font(.callout)
                                .textCase(.lowercase)
                                .padding()
                                .foregroundColor(.secondary)
                        }
                        
                        HStack {
                            Text("\(podaci.ime) \(podaci.prezime)")
                                .font(.title2)
                                .padding()
                                .foregroundColor(.primary)
                        }

                        HStack {
                            Text(podaci.korisnickoIme)
                                .font(.title2)
                                .padding()
                                .foregroundColor(.primary)
                        }
                    } else {
                        Text("Učitavanje...")
                            .font(.callout)
                            .foregroundColor(.secondary)
                    }

                    Divider()
                    Text("Ažuriraj")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                        .shadow(radius: 3)
                        .onTapGesture {
                            showMojeDove.toggle()
                        }
                    Text("Odjavi se")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.primary)
                        .cornerRadius(8)
                        .shadow(radius: 3)
                        .onTapGesture {
                            settings.isLoggedIn = false
                            settings.userId = 0
                            settings.uloga = ""
                            settings.prikaziPocetnaUser = false
                            settings.prikaziPocetnaProUser = false
                        }
                    
                    EditEmail(showMojeDove: $showMojeDove)
                        .offset(y: showMojeDove ? 0.0 : UIScreen.main.bounds.height)
                        .animation(.spring(), value: self.showMojeDove)
                        .padding(.vertical, 0)
                }
            }
            .padding(.top, 40)
        }
        .onAppear {
            Task {
                await getMojiPodaci()
            }
        }
        .onChange(of: showMojeDove) { newValue in
            if !newValue {
                Task {
                    await getMojiPodaci()
                }
            }
        }
    }

    func getMojiPodaci() async {
        let id = 4
        guard let url = URL(string: UrlHelper.baseUrl + "/Korisnik/\(id)") else {
            print("Podaci nisu pokupljeni")
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedResponse = try JSONDecoder().decode(Korisnik.self, from: data)
            DispatchQueue.main.async {
                self.podaci = decodedResponse
            }
        } catch {
            print("Error fetching data: \(error)")
        }
    }
}

struct EditEmail: View {
    let gradient = Gradient(colors: [Color("PrimaryColor"), Color("MuslimLightGreen")])
    @State private var noviEmail = ""
    @State private var response: String = ""
    @EnvironmentObject var settings: UserSettings // prebitno

    @Environment(\.presentationMode) var presentationMode
    @Binding var showMojeDove: Bool
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color("MuslimLightGray").opacity(1)
            
            VStack {
                TextField("Novi Email", text: $noviEmail)
                    .font(.title3)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(50)
                    .shadow(color: Color.black.opacity(0.08), radius: 60, x: 0.0, y: 16)
                    .padding(.vertical)
                    .autocapitalization(.none)

                Text("Ažuriraj")
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
                            await azurirajEmail()
                        }
                    }
            }
            .padding(.horizontal)
            .padding(.top, 80)
            Button(action: {
                showMojeDove.toggle()
                noviEmail = ""
            }, label: {
                Image(systemName: "xmark")
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .padding(20)
            })
        }
    }
    func azurirajEmail() async {
        print("Preparing to update email")
        guard let url = URL(string: UrlHelper.baseUrl + "/Korisnik/azuriraj-email") else {
            print("Invalid URL")
            return
        }
        print("Provera")
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        print("DO ovde radi")
        let body = AzurirajEmailRequest(
            id: 4,
            noviEmail: noviEmail,
            uloga: "ProPosetilac")
        do {
            request.httpBody = try JSONEncoder().encode(body)
            print("Request body encoded successfully")
        } catch {
            print("Failed to encode request body: \(error)")
            return
        }

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Response Status Code: \(httpResponse.statusCode)")
                noviEmail = ""
                showMojeDove = false
                if httpResponse.statusCode == 200 {
                    print("Email updated successfully")
                    noviEmail = ""
                    showMojeDove = false
                } else {
                    print("Failed to update email, status code: \(httpResponse.statusCode)")
                    noviEmail = ""
                    showMojeDove = false
                }
                noviEmail = ""
                showMojeDove = false
            }
            print("Received data: \(String(data: data, encoding: .utf8) ?? "No data")")
        } catch {
            print("Error sending request: \(error)")
        }
    }
}

struct MyProfile_Previews: PreviewProvider {
    static var previews: some View {
        MyProfile()
            .environmentObject(UserSettings())
    }
}

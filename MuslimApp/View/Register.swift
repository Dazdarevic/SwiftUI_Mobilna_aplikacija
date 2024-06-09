import SwiftUI

struct Register: View {
    @State private var imeTxt: String = ""
    @State private var prezimeTxt: String = ""
    @State private var emailTxt: String = ""
    @State private var passwordTxt: String = ""
    @State private var passwordRepTxt: String = ""
    @State private var messages: [String] = []
    @State private var prikaziLogin = false
    @State private var showingAlert = false
    @State private var isLoading: Bool = false
    @State private var selectedDate: Date = Date()
    @State private var isProVersion: Bool = false
    @State private var response: String = ""
    @State private var isRegistered: Bool = false


    let startingDate: Date = Calendar.current.date(from: DateComponents(year: 1914, month: 1)) ?? Date()
    let endingDate: Date = Calendar.current.date(from: DateComponents(year: 2014, month: 5)) ?? Date()
    let gradient = Gradient(colors: [Color("PrimaryColor"), Color("MuslimLightGreen")])

    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }

    var body: some View {
        ZStack {
            Color("MuslimWhite").ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 8) {
                    Group {
                        Spacer()
                        Text("Registrujte se")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color("MuslimBlack"))
                            .padding(.bottom)
                        TextField("Ime", text: $imeTxt)
                            .font(.title3)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color("SecondaryColor"))
                            .cornerRadius(50)
                            .shadow(color: Color.black.opacity(0.08), radius: 60, x: 0.0, y: 16)
                            .padding(.top)
                        TextField("Prezime", text: $prezimeTxt)
                            .font(.title3)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color("SecondaryColor"))
                            .cornerRadius(50)
                            .shadow(color: Color.black.opacity(0.08), radius: 60, x: 0.0, y: 16)
                            .padding(.top)
                        TextField("Email adresa", text: $emailTxt)
                            .font(.title3)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color("SecondaryColor"))
                            .cornerRadius(50)
                            .shadow(color: Color.black.opacity(0.08), radius: 60, x: 0.0, y: 16)
                            .padding(.top)
                            .autocapitalization(.none)
                        DatePicker("Datum rođenja", selection: $selectedDate, in: startingDate...endingDate, displayedComponents: [.date])
                            .accentColor(Color("PrimaryColor"))
                            .datePickerStyle(.automatic)
                            .padding()
                            .background(Color("SecondaryColor"))
                            .font(.title3)
                            .foregroundColor(Color("MuslimLightGray"))
                            .cornerRadius(50)
                            .padding(.top)
                        SecureField("Lozinka", text: $passwordTxt)
                            .font(.title3)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color("SecondaryColor"))
                            .cornerRadius(50)
                            .shadow(color: Color.black.opacity(0.08), radius: 60, x: 0.0, y: 16)
                            .padding(.top)
                            .autocapitalization(.none)
                        SecureField("Ponovi Lozinku", text: $passwordRepTxt)
                            .font(.title3)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color("SecondaryColor"))
                            .cornerRadius(50)
                            .shadow(color: Color.black.opacity(0.08), radius: 60, x: 0.0, y: 16)
                            .padding(.top)
                            .autocapitalization(.none)
                        Toggle(isOn: $isProVersion) {
                            Text("Pro verzija?")
                                .font(.title3)
                                .foregroundColor(Color("MuslimLightGray"))
                        }
                        .padding()
                        .background(Color("SecondaryColor"))
                        .cornerRadius(50)
                        .shadow(color: Color.black.opacity(0.08), radius: 60, x: 0.0, y: 16)
                        .padding(.top)
                    }

                    Group {
                        ForEach(messages, id: \.self) { message in
                            Text(message)
                                .foregroundColor(Color.red)
                                .padding(.all, 5)
                                .background(Color.white)
                        }
                    }
                    HStack {
                        Text("Imate nalog? ")
                        Button(action: {
                            
                        }, label: {
                            NavigationLink(destination: Login().navigationBarBackButtonHidden(true)) {
                                Text("Uloguj se")
                                    .foregroundColor(Color("PrimaryColor"))
                                    .bold()
                            }
                        })
                    }
                    .padding()
                    
                    Group {
                        if isLoading {
                            ProgressView()
                        }
                        
                        Button {
                            if validate() {
                                Task {
                                    isLoading = true
                                    await postRegister()
                                    isLoading = false
                                }
                            }
                        } label: {
                            Text("Registruj se")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(Color("MuslimWhite"))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(LinearGradient(gradient: gradient, startPoint: .leading, endPoint: .bottomTrailing))
                                .cornerRadius(50)
                                .shadow(color: Color.black.opacity(0.5), radius: 70, x: 0.9, y: 16)
                        }
                        .cornerRadius(20)
                        .padding(.vertical, 20)
                        .alert(response, isPresented: $showingAlert) {
                            Button("OK", role: .cancel) {
                                isRegistered = true
                                resetForm()
                            }
                        }
                    }
                    
                }
                .padding()
            }
        }
    }
    
    func resetForm() {
        imeTxt = ""
        prezimeTxt = ""
        emailTxt = ""
        passwordTxt = ""
        passwordRepTxt = ""
        selectedDate = Date()
        isProVersion = false
        messages = []
    }
    
    func validate() -> Bool {
        messages = []
        if emailTxt.isEmpty {
            messages.append("Unesite email")
        }
        if passwordTxt.isEmpty {
            messages.append("Unesite lozinku")
        }
        if passwordRepTxt.isEmpty {
            messages.append("Ponovite lozinku")
        }
        if imeTxt.isEmpty {
            messages.append("Unesite ime")
        }
        if prezimeTxt.isEmpty {
            messages.append("Unesite prezime")
        }
        if selectedDate == startingDate {
            messages.append("Odaberite datum rođenja")
        }
        if passwordTxt != passwordRepTxt {
            messages.append("Lozinke moraju da se poklapaju")
        }
        return messages.isEmpty
    }

    func postRegister() async {
        guard let url = URL(string: UrlHelper.baseUrl + "/Korisnik/dodaj-korisnika") else {
            response = "Nevažeći URL"
            showingAlert = true
            print(response)  // Ispis u konzoli
            return
        }

        let userData = Korisnik(
            ime: imeTxt,
            prezime: prezimeTxt,
            email: emailTxt,
            datumRodj: dateFormatter.string(from: selectedDate),
            lozinka: passwordTxt,
            proVerzija: isProVersion,
            korisnickoIme: "primer",
            uloga: isProVersion ? "ProPosetilac" : "Posetilac"
        )

        guard let jsonData = try? JSONEncoder().encode(userData) else {
            response = "Greška kod enkodiranja korisničkih podataka"
            showingAlert = true
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
                    response = "Uspješno ste se registrovali."
                } else {
                    // Parsiranje greške iz odgovora
                    let errorResponse = String(data: data, encoding: .utf8) ?? "Nepoznata greška"
                    response = "Greška: \(httpResponse.statusCode) - \(errorResponse)"
                    print("HTTP greška: \(httpResponse.statusCode) - \(errorResponse)")  // Ispis u konzoli
                }
            } else {
                response = "Nevažeći odgovor sa servera"
                print(response)  // Ispis u konzoli
            }
        } catch {
            response = "Mrežna greška: \(error.localizedDescription)"
            print("Mrežna greška: \(error)")  // Ispis u konzoli
        }

        showingAlert = true
    }
}


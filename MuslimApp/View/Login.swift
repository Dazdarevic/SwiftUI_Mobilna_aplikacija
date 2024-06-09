import SwiftUI
import JWTDecode

struct Login: View {
    
    let gradient = Gradient(colors: [Color("PrimaryColor"), Color("MuslimLightGreen")])
    @State private var usernameTxt = ""
    @State private var passwordTxt = ""
    @State private var response: String = "aaa"
    
    @State private var myToken: String = ""
    @State private var currentUserId: String = "aaa"

    @State private var showingAlert = false
    @State private var token : String = "token"
    @State public var role : String = ""
    
    @State private var messages : [String] = []
    @State var globalUserId : Int = 0
    @State var isLoading : Bool = false

    @EnvironmentObject var settings: UserSettings

    @State private var navigateToProPosetilac = false
    @State private var navigateToPosetilac = false

    var body: some View {
        NavigationView {
            ZStack {
                Color("MuslimWhite").ignoresSafeArea()
                
                VStack(spacing: 8) {
                    Spacer()
                    Group {
                        Image("logo")
                            .resizable()
                            .frame(width: 200, height: 170)
                            .cornerRadius(40)
                            
                        Spacer()
                        Text("Ulogujte se")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color("MuslimBlack"))
                            .padding(.bottom)
                    }
                    
                    Group {
                        TextField("Korisnicko ime", text: $usernameTxt)
                            .font(.title3)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color("SecondaryColor"))
                            .cornerRadius(50)
                            .shadow(color: Color.black.opacity(0.08), radius: 60, x: 0.0, y: 16)
                            .padding(.top)
                            .autocapitalization(.none)
                        
                        SecureField("Lozinka", text: $passwordTxt)
                            .font(.title3)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color("SecondaryColor"))
                            .cornerRadius(50)
                            .shadow(color: Color.black.opacity(0.08), radius: 60, x: 0.0, y: 16)
                            .padding(.vertical)
                            .autocapitalization(.none)
                    }
                    
                    //ISPIS VALIDACIONE PORUKE
                    ForEach(messages, id: \.self) { message in
                        Text(message)
                            .foregroundColor(Color.red)
                            .padding(.all, 4)
                            .background(Color.white)
                    }
                    
                    Group {
                        if isLoading {
                            ProgressView()
                        }
                            
                            Button {
                                if validate() {
                                    Task {
                                        isLoading = true
                                        await postLogin(usernameTxt: usernameTxt, passwordTxt: passwordTxt)
                                        isLoading = false
                                        navigateBasedOnRole()
                                    }
                                }
                            } label: {
                                Text("Prijavi se")
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
                        
                        HStack {
                            Text("Vrati se na pocetnu? ")
                            Button(action: {
                                
                            }, label: {
                                NavigationLink(destination: Welcome().navigationBarBackButtonHidden(true)) {
                                    Text("Pocetna")
                                        .foregroundColor(Color("PrimaryColor"))
                                        .bold()
                                }
                            })
                        }
                        
                    }
                    
                    Spacer()
                    
                    
                    
                    NavigationLink(destination: DefaultScreenUser().navigationBarBackButtonHidden(true), isActive: $settings.prikaziPocetnaUser, label: {
                        EmptyView()
                    })
                    
                    NavigationLink(destination: DefaultScreenProUser().navigationBarBackButtonHidden(true), isActive: $settings.prikaziPocetnaProUser, label: {
                        EmptyView()
                    })


                }
                .padding()
            }
        }
    }
    
    func navigateBasedOnRole() {
        if settings.uloga == "ProPosetilac" {
            navigateToProPosetilac = true
        } else if settings.uloga == "Posetilac" {
            navigateToPosetilac = true
        }
    }
    
    func postLogin(usernameTxt: String, passwordTxt: String) async {
        guard let url = URL(string: UrlHelper.baseUrl + "/Login/PostLoginDetails") else {
            return
        }
        
        let userData = LoginInfo(username: usernameTxt, password: passwordTxt)
        let jsonEncoder = JSONEncoder()
        guard let jsonData = try? jsonEncoder.encode(userData) else {
            print("Failed to encode user data")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                if let responseString = String(data: data, encoding: .utf8) {
                    DispatchQueue.main.async {
                        self.response = responseString
                    }
                    let token = getUserToken(jsonString: responseString)
                    DispatchQueue.main.async {
                        self.token = token
                    }
                    let userId = getUserId(jsonString: responseString)
                    DispatchQueue.main.async {
                        settings.isLoggedIn = true
                        settings.userId = userId
                    }
                    
                    do {
                        let jwt = try decode(jwt: token)
                        let role = jwt.claim(name: "UserRole").string ?? ""
                        DispatchQueue.main.async {
                            settings.uloga = role
                            if settings.uloga == "ProPosetilac" {
                                settings.prikaziPocetnaProUser = true
                            } else if settings.uloga == "Posetilac" {
                                settings.prikaziPocetnaUser = true
                            }
                            isLoading = false
                        }
                    } catch {
                        print("Failed to decode JWT token: \(error.localizedDescription)")
                    }
                }
            } else {
                print("Login failed with status code: \((response as? HTTPURLResponse)?.statusCode ?? 0)")
            }
        } catch {
            print("Network error: \(error)")
        }
    }

    func getUserId(jsonString: String) -> Int {
        var userId : Int = 0
        if let jsonData = jsonString.data(using: .utf8) {
            do {
                if let dict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                    if let idValue = dict["id"] as? Int {
                        print(idValue)
                        userId = idValue
                    }
                }
            } catch {
                print("Error deserializing JSON: \(error)")
            }
        }
        return userId
    }
    
    func getUserToken(jsonString: String) -> String {
        var token : String = ""
        if let jsonData = jsonString.data(using: .utf8) {
            do {
                if let dict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                    if let tokenValue = dict["accessToken"] as? String {
                        print(tokenValue)
                        token = tokenValue
                    }
                }
            } catch {
                print("Error deserializing JSON: \(error)")
            }
        }
        return token
    }
    
    func validate() -> Bool {
        messages = []
        if usernameTxt.isEmpty {
            messages.append("Unesite korisnicko ime")
        }
        if passwordTxt.isEmpty {
            messages.append("Unesite lozinku")
        }
        return messages.count == 0
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
            .environmentObject(UserSettings())
    }
}

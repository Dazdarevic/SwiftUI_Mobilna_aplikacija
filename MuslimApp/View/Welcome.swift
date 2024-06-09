import SwiftUI

struct Welcome: View {
    let gradient = Gradient(colors: [Color("PrimaryColor"), Color("MuslimLightGreen")])
    let gradient2 = Gradient(colors: [Color("SecondaryColor"), Color("Biege")])

    var body: some View {
        NavigationView {
            ZStack {
                Color("MuslimWhite").ignoresSafeArea()
                
                VStack(spacing: 15) {
                    Spacer()
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(50)
                    Spacer()
                    
                    NavigationLink(destination: Login().navigationBarBackButtonHidden(true)) {
                        PrimaryButton(title: "Uloguj se", color: "MuslimWhite")
                            .background(LinearGradient(gradient: gradient, startPoint: .leading, endPoint: .bottomTrailing))
                            .cornerRadius(20)
                            .padding(.vertical)
                    }
                    
                    NavigationLink(destination: Register().navigationBarBackButtonHidden(true)) {
                        PrimaryButton(title: "Registruj se", color: "PrimaryColor")
                            .background(LinearGradient(gradient: gradient2, startPoint: .leading, endPoint: .bottomTrailing))
                            .cornerRadius(20)
                    }
                    
                    HStack {
                        Text("Nemate nalog? ")
                        Button(action: {
                            
                        }, label: {
                            NavigationLink(destination: Register().navigationBarBackButtonHidden(true)) {
                                Text("Registruj se")
                                    .foregroundColor(Color("PrimaryColor"))
                                    .bold()
                            }
                        })
                    }
                    .padding()
                }
                .padding()
            }
        }
        
    }
}

struct Welcome_Previews: PreviewProvider {
    static var previews: some View {
        Welcome()
    }
}

struct PrimaryButton: View {
    
    var title: String = ""
    var color: String = ""
    var backgroundColor: String = ""

    var body: some View {
        Text(title)
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(Color(color))
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(backgroundColor))
            .cornerRadius(50)
            .shadow(color: Color.black.opacity(0.5), radius: 70, x: 0.9, y: 16)
    }
}

struct SecondaryButton: View {
    
    var title: String = ""
    var color: String = ""
    var backgroundColor: String = ""

    var body: some View {
        Button(action: {
            
        }, label: {
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color(color))
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(backgroundColor))
                .cornerRadius(50)
                .shadow(color: Color.black.opacity(0.5), radius: 70, x: 0.9, y: 16)
        })
    }
}

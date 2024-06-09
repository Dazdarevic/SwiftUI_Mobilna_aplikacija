import SwiftUI

struct Vaktija: View {
    var body: some View {
        ZStack {
            Image("sunce")
                .resizable()
                .aspectRatio(contentMode: .fill)

                        
            VStack(alignment: .leading, spacing: 50) {
                Spacer()
                Group {
                    Text("Namazi")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .bold()
                }
                .padding(.horizontal)

                                
                VStack(alignment: .center, spacing: 50) {
                    
                    HStack(spacing: 80) {
                        Image(systemName: "arrow.backward")
                            .font(.title)
                            .foregroundColor(.white)
                        VStack(alignment: .center) {
                            Text("Datum 1")
                                .font(.title)
                                .bold()
                                .foregroundColor(.white)
                            Text("Datum 2")
                                .foregroundColor(.white)
                        }
                        Image(systemName: "arrow.forward")
                            .font(.title)
                            .foregroundColor(.white)
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
                            Text("Zora")
                                .font(.title2)
                                .foregroundColor(.white)
                            Text("Datum 2")
                                .font(.title2)
                                .foregroundColor(.white)
                            Text("Zora")
                                .font(.title2)
                                .foregroundColor(.white)
                            Text("Datum 2")
                                .font(.title2)
                                .foregroundColor(.white)
                            Text("Zora")
                                .font(.title2)
                                .foregroundColor(.white)
                            Text("Datum 2")
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
}

struct Vaktija_Previews: PreviewProvider {
    static var previews: some View {
        Vaktija()
    }
}

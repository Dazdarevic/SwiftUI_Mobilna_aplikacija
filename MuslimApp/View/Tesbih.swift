import SwiftUI

struct Tesbih: View {
    @State private var offset: Double = 0
    @State private var brojZikrova: Int = UserDefaults.standard.integer(forKey: "brojZikrova")

    var body: some View {

        ZStack {
            VStack {
                HStack {
                    Text("Tesbih")
                        .font(.largeTitle)
                        .bold()
                        .padding(.all)
                        .foregroundColor(Color("MuslimBlack"))
                    
                    Spacer()
                    Image(systemName: "arrow.counterclockwise")
                                    .font(.title)
//                                    .background(Color.white)
                                    .foregroundColor(.gray)
                                    .clipShape(Circle())
                                    .padding()
                                    .shadow(radius: 10)
                                    .onTapGesture {
                                        brojZikrova = 0
                                        Task {
                                            saveClickCount()
                                        }
                                    }
                }
                
                Text("يَا أَيُّهَا الَّذِينَ آمَنُوا اذْكُرُوا اللَّهَ ذِكْرًا كَثِيرًا")
                    .font(.title2)
                    .padding(.vertical)
                    .foregroundColor(Color("MuslimBlack"))
                Text("Sura El -Ahzab - Saveznici, 41. ajet")
                    .font(.callout)
                    .padding(.bottom)
                Text("O vjernici, često Allaha spominjite i hvalite.")
                    .font(.title3)
                    .bold()
                    .padding(.horizontal)
                    .foregroundColor(Color("MuslimBlack"))
                
            }
            .offset(y: -220)
                

            ZStack {
                Path { path in
                    path.move(to: CGPoint(x: -400, y: 400))
                    path.addCurve(to: CGPoint(x: 400, y: 100), control1: CGPoint(x: 650, y: 350), control2: CGPoint(x: 400, y: 500))
                }
                .stroke(LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.6, green: 0.4, blue: 0.2),
                        Color(red: 0.8, green: 0.6, blue: 0.4),
                        Color(red: 0.9, green: 0.7, blue: 0.5)
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                ), lineWidth: 8)
                .shadow(color: .gray, radius: 5, x: 0, y: 2)
                .offset(y: 0)

                HStack(spacing: -90) {
                    ForEach(0..<19) { index in
                        Circle()
                            .fill(LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 0.2, green: 0.8, blue: 0.2),
                                    Color(red: 0.6, green: 1.0, blue: 0.6),
                                    Color(red: 0.2, green: 0.8, blue: 0.2)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing))
                            .frame(width: 80, height: 80)
                            .shadow(color: .gray, radius: 5, x: 0, y: 2)
                            .offset(x: Double(index) * 100 - offset, y: 40)
                    }
                }
            }
            
            
            Text("\(brojZikrova)") // Prikaz broja klikova
                .font(.largeTitle)
                .bold()
                .padding(.bottom)
                .foregroundColor(Color("DarkGreen"))
                .offset(y: 200)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            print("Tapnuli ste na Tesbih")
            withAnimation {
                offset += 100
                offset = offset.truncatingRemainder(dividingBy: 1200) //ostatak deljenja vrednosti offset floating-point vrednosti
                brojZikrova += 1
                saveClickCount()
            }
        }
        .onAppear {
            loadClickCount()
        }
        
    }
    
    private func saveClickCount() {
            UserDefaults.standard.set(brojZikrova, forKey: "brojZikrova")
        }
        
        private func loadClickCount() {
            brojZikrova = UserDefaults.standard.integer(forKey: "brojZikrova")
        }
}

struct Tesbih_Previews: PreviewProvider {
    static var previews: some View {
        Tesbih()
    }
}

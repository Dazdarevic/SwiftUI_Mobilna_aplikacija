import SwiftUI

struct DovaView: View {
    var body: some View {
        Text("Ovo je Dova View")
            .navigationBarBackButtonHidden(true) 
    }
}

struct DovaView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DovaView()
        }
    }
}

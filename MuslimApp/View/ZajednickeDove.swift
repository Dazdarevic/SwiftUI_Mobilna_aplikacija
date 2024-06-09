//
//  ZajednickeDove.swift
//  MuslimApp
//
//  Created by Muhedin Alic on 03.06.24.
//

import SwiftUI

struct ZajednickeDove: View {
    @State private var currentTab: Int = 0
    
    var body: some View {
        VStack {
            Picker(selection: $currentTab, label: Text("Tabs")) {
                Text("Sve Dove").tag(0)
                Text("Moje Dove").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            .background(Color("DarkGreen").opacity(0.2))
            .cornerRadius(10)
            .padding(.horizontal)
            
            TabView(selection: $currentTab) {
                DoveUser().tag(0)
                PrikaziMojeDove().tag(1)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
    }
}

struct ZajednickeDove_Previews: PreviewProvider {
    static var previews: some View {
        ZajednickeDove()
    }
}

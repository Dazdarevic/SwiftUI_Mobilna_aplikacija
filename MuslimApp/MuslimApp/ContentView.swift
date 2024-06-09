//
//  ContentView.swift
//  MuslimApp
//
//  Created by Muhedin Alic on 08.05.24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var settings: UserSettings

    var body: some View {
        NavigationView {
            VStack {
                  Welcome()
            }
            .navigationTitle("Dobrodosli")
            .navigationBarHidden(true)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

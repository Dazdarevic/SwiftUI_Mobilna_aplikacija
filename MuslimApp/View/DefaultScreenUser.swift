//
//  DefaultScreenUser.swift
//  MuslimApp
//
//  Created by Muhedin Alic on 31.05.24.
//

import SwiftUI

struct DefaultScreenUser: View {
    @EnvironmentObject var settings: UserSettings

    var body: some View {
        if settings.isLoggedIn {
                    TabView {
                        HomeUser()
                            .tabItem {
                                Image(systemName: "bag.fill")
                                Text("Danas")
                            }
                        
                        VaktijaComponent()
                            .tabItem {
                                Image(systemName: "clock˜SZe.badge.checkmark")
                                Text("Namazi")
                            }
                        Kuran()
                            .tabItem {
                                Image(systemName: "book")
                                Text("Kur'an")
                            }
                        MyProfile()
                            .tabItem {
                                Image(systemName: "person")
                                Text("Profil")
                            }
                    }
                    .accentColor(Color("DarkGreen").opacity(0.7))
                    .navigationBarHidden(true)
                }
                else {
                    Login()
                }
        
    }
    
}

struct DefaultScreenUser_Previews: PreviewProvider {
    static var previews: some View {
        DefaultScreenUser()
            .environmentObject(UserSettings())

    }
}

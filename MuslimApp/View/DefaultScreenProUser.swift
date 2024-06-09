//
//  DefaultScreenProUser.swift
//  MuslimApp
//
//  Created by Muhedin Alic on 31.05.24.
//

import SwiftUI

struct DefaultScreenProUser: View {
    @EnvironmentObject var settings: UserSettings

    var body: some View {
        
//        if settings.isLoggedIn {
                    TabView {
                        HomeProUser()
                            .tabItem {
                                Image(systemName: "bag.fill")
                                Text("Danas")
                            }
                        VaktijaComponent()
                            .tabItem {
                                Image(systemName: "clock.badge.checkmark")
                                Text("Namazi")
                            }
                        KuranPro()
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
//                }
//                else {
//                    Login()
//                }
        
    }
}

struct DefaultScreenProUser_Previews: PreviewProvider {
    static var previews: some View {
        DefaultScreenProUser()
            .environmentObject(UserSettings())

    }
}

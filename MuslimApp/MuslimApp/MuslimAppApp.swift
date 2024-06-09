//
//  MuslimAppApp.swift
//  MuslimApp
//
//  Created by Muhedin Alic on 08.05.24.
//

import SwiftUI

@main
struct MuslimAppApp: App {
    @StateObject private var userSettings = UserSettings()

        var body: some Scene {
            WindowGroup {
                Welcome()
                    .environmentObject(userSettings)
            }
        }
}

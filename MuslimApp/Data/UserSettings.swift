//
//  UserSettings.swift
//  MuslimApp
//
//  Created by Muhedin Alic on 31.05.24.
//

import Foundation

//handling login/logout
class UserSettings : ObservableObject {
    @Published var isLoggedIn : Bool {
        didSet {
            UserDefaults.standard.set(isLoggedIn, forKey: "login")
        }
    }
    
    @Published var backBtn : Bool {
        didSet {
            UserDefaults.standard.set(backBtn, forKey: "backBtn")
        }
    }
    
    @Published var userId : Int {
        didSet {
            UserDefaults.standard.set(userId, forKey: "userId")
        }
    }

    @Published var uloga : String {
        didSet {
            UserDefaults.standard.set(uloga, forKey: "uloga")
        }
    }
    
    @Published var prikaziPocetnaProUser : Bool {
        didSet {
            UserDefaults.standard.set(prikaziPocetnaProUser, forKey: "prikaziPocetnaProUser")
        }
    }
    
    @Published var prikaziPocetnaUser : Bool {
        didSet {
            UserDefaults.standard.set(prikaziPocetnaUser, forKey: "prikaziPocetnaUser")
            //UserDefaults ovde cuva stanje i nakon iskljucivanja aplikacije
        }
    }
    @Published var goToKuran: Bool = false

    init() {
        self.isLoggedIn = false
        self.userId = 0
        self.uloga = ""
        self.backBtn = false
        self.prikaziPocetnaProUser = false
        self.prikaziPocetnaUser = false
    }
}

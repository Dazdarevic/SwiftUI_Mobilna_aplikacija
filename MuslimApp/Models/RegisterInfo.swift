//
//  RegisterInfo.swift
//  MuslimApp
//
//  Created by Muhedin Alic on 29.05.24.
//

import Foundation

struct Korisnik : Codable {
    var ime: String
    var prezime: String
    var email: String
    var datumRodj: String
    var lozinka: String
    var proVerzija: Bool 
}

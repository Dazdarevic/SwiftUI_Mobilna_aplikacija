//
//  Korisnik.swift
//  MuslimApp
//
//  Created by Muhedin Alic on 31.05.24.
//

import Foundation

struct Korisnik : Codable {
    var ime: String
    var prezime: String
    var email: String
    var datumRodj: String
    var lozinka: String
    var proVerzija: Bool
    var korisnickoIme: String
    var uloga: String
}


struct AzurirajEmailRequest: Codable {
    var id: Int
    var noviEmail: String
    var uloga: String
}

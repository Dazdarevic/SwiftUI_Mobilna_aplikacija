//
//  Dova.swift
//  MuslimApp
//
//  Created by Muhedin Alic on 04.06.24.
//

import Foundation

struct Dova: Codable {
    let id: Int
    let dovaTxt: String
    let id_Korisnika: Int
    let broj_Lajkova: Int
}


struct DoveResponse: Decodable {
    let dove: [Dova]
}

struct LajkovanjeRequest: Codable {
    let id: Int
    let povecaj: Bool
}

struct DovaZaSlanje: Codable {
    let dovaTxt: String
    let id_Korisnika: Int
}

//struct MojiPodaci: Codable {
//    let id: Int
//    let prezime: String
//    let email: string
//}

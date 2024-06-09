//
//  Slika.swift
//  MuslimApp
//
//  Created by Muhedin Alic on 04.06.24.
//

import Foundation

struct Slika: Codable {
    let id: Int
    let url: String
}


struct SlikaResponse: Decodable {
    let slike: [Slika]
}

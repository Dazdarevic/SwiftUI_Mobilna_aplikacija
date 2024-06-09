//
//  VaktijaData.swift
//  MuslimApp
//
//  Created by Muhedin Alic on 02.06.24.
//

import Foundation

struct VaktijaData: Codable {
    let id: Int
    let lokacija: String
    let datum: [String]
    let vakat: [String]
}

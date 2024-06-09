//
//  Chapter.swift
//  MuslimApp
//
//  Created by Muhedin Alic on 02.06.24.
//

import Foundation

struct Chapter: Decodable {
    let chapter: Int
    let verses: [Verse]
}

//
//  ChapterVerse.swift
//  MuslimApp
//
//  Created by Muhedin Alic on 02.06.24.
//

import Foundation

struct Verse: Decodable {
    let chapter: Int
    let verse: Int
    let text: String
}

struct ChapterResponse: Decodable {
    let chapter: [Verse]
}

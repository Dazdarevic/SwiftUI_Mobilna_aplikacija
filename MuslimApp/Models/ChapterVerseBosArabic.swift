//
//  ChapterVerseBosArabic.swift
//  MuslimApp
//
//  Created by Muhedin Alic on 02.06.24.
//

import Foundation

struct Verse: Decodable, Hashable {
    let chapter: Int
    let verse: Int
    let text: String
}

struct ChapterResponse: Decodable {
    let chapter: [Verse]
}

struct QuranResponse: Decodable {
    let juzs: [Verse]
}


struct Citat: Identifiable, Codable {
    let id: Int
    let citatTxt: String
}

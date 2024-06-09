//
//  Message.swift
//  MuslimApp
//
//  Created by Muhedin Alic on 30.05.24.
//

import Foundation

struct Message: Encodable {

    let userID: Int
    let toUserID: Int
    let message: String

}

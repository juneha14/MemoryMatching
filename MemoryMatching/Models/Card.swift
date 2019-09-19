//
//  Card.swift
//  MemoryMatching
//
//  Created by June Ha on 2019-09-18.
//  Copyright © 2019 June Ha. All rights reserved.
//

import Foundation


struct Card: Codable {
    let id: Int64
    let image: Image
}

extension Card {
    struct Container: Codable {
        let products: [Card]
    }
}

struct Image: Codable {
    let src: String
}

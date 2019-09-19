//
//  Card.swift
//  MemoryMatching
//
//  Created by June Ha on 2019-09-18.
//  Copyright © 2019 June Ha. All rights reserved.
//

import Foundation


class Card: Codable, NSCopying {
    let id: Int64
    let image: Image

    struct Container: Codable {
        let products: [Card]
    }


    init(id: Int64, image: Image) {
        self.id = id
        self.image = image
    }

    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Card(id: id, image: image)
        return copy
    }
}

class Image: Codable {
    let src: String
}

//
//  Card.swift
//  MemoryMatching
//
//  Created by June Ha on 2019-09-18.
//  Copyright © 2019 June Ha. All rights reserved.
//

import Foundation
import UIKit


class CardViewModel: NSCopying {
    private(set) var card: Card
    private(set) var state: State = .notGuessed

    var alpha: CGFloat {
        return (state == .notGuessed) ? 0.5 : 1
    }

    enum State {
        case notGuessed
        case guessed
        case flipped
    }


    // MARK: Init

    init(card: Card) {
        self.card = card
    }

    func copy(with zone: NSZone? = nil) -> Any {
        let copy = CardViewModel(card: card)
        return copy
    }


    // MARK: API

    func set(_ state: State) {
        if state != self.state {
            self.state = state
        }
    }
}

struct Card: Codable {
    let id: Int64
    let image: Image

    struct Container: Codable {
        let products: [Card]
    }
}

struct Image: Codable {
    let src: String
}

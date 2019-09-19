//
//  EntityManager.swift
//  MemoryMatching
//
//  Created by June Ha on 2019-09-18.
//  Copyright © 2019 June Ha. All rights reserved.
//

import Foundation


final class EntityManager {
    static let instance = EntityManager()

    private(set) var entities = [Card]()
    private var currentGameCards = [Card]()


    // Use singleton
    private init() { }


    // MARK: API

    /// Makes a network request to grab all products from Shopify store
    func initialize(completion: @escaping () -> Void) {
        APIService.instance.get { [weak self] (result: Result<Card.Container, APIService.APIError>) in
            switch result {
            case let .success(cardContainer):
                self?.entities = cardContainer.products
                completion()
            case .failure(_):
                completion()
            }
        }
    }

    /// Creates new game by randomly choosing 10 cards and duplicating them
    func createNewGame() -> [Card] {
        let shuffled = entities.shuffled()[0..<10]
        var newGameCards = [Card]()

        // TODO: change iteration to n depending on how many consecutive cards need to be matched
        for _ in 1...2 {
            for card in shuffled {
                newGameCards.append(card.copy() as! Card)
            }
        }

        currentGameCards = newGameCards.shuffled()
        print(currentGameCards.count)
        return currentGameCards
    }
}

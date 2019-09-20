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

    typealias showCards = (([CardViewModel]) -> Void)?
    typealias hideCards = (([CardViewModel]) -> Void)?

    private var entities = [CardViewModel]()
    private var currentGameCards = [CardViewModel]()
    private var selectedCards = [CardViewModel]()


    // Use singleton
    private init() { }


    // MARK: API

    /// Makes a network request to grab all products from Shopify store
    func initialize(completion: @escaping () -> Void) {
        APIService.instance.get { [weak self] (result: Result<Card.Container, APIService.APIError>) in
            switch result {
            case let .success(cardContainer):
                self?.entities = cardContainer.products.map({ CardViewModel(card: $0) })
                completion()
            case .failure(_):
                completion()
            }
        }
    }

    /// Creates new game by randomly choosing 10 cards and duplicating them
    func createNewGame() -> [CardViewModel] {
        let shuffled = entities.shuffled()[0..<10]
        var newGameCards = [CardViewModel]()

        // TODO: change iteration to n depending on how many consecutive cards need to be matched
        for _ in 1...2 {
            for card in shuffled {
                newGameCards.append(card.copy() as! CardViewModel)
            }
        }

        currentGameCards = newGameCards.shuffled()
        return currentGameCards
    }

    func didSelectCard(_ card: CardViewModel?, showCards: showCards, hideCards: hideCards) {
        guard let card = card, card.state == .notGuessed else {
            return
        }

        card.set(.flipped)
        selectedCards.append(card)
        showCards?(selectedCards)

        if cardsDoMatch(selectedCards) {
            if selectedCards.count == 2 {
                for card in selectedCards {
                    card.set(.guessed)
                }

                selectedCards.removeAll()
            }
        } else if selectedCards.count > 1 {
            // Hide the cards
            for card in selectedCards {
                card.set(.notGuessed)
            }

            let cardsToHide = selectedCards
            DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(1)) {
                hideCards?(cardsToHide)
            }

            selectedCards.removeAll()
        }
    }

    func index(of cardViewModel: CardViewModel) -> Int {
        for (i, viewModel) in currentGameCards.enumerated() {
            if viewModel === cardViewModel {
                return i
            }
        }

        return 0
    }


    // MARK: Helpers

    private func cardsDoMatch(_ cards: [CardViewModel]) -> Bool {
        guard cards.count > 1 else {
            return false
        }

        for i in 1..<cards.count {
            if cards[i].card.id != cards[i - 1].card.id {
                return false
            }
        }

        return true
    }
}

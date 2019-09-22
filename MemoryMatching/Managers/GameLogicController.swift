//
//  EntityManager.swift
//  MemoryMatching
//
//  Created by June Ha on 2019-09-18.
//  Copyright © 2019 June Ha. All rights reserved.
//

import Foundation


enum GameState {
    case loading
    case failed(Error)
    case presenting([CardViewModel])
    case finished
}

final class GameLogicController {
    typealias Handler = (GameState) -> Void

    /// Original card entities fetched from Shopify store
    private var entities = [CardViewModel]()

    /// The current subset of cards belonging to a particular game
    private(set) var currentGameCards = [CardViewModel]()

    /// Cards that are flipped for guessing
    private var selectedCards = [CardViewModel]()

    /// All cards that have been correctly guessed and therefore flipped
    private var flippedCards = [CardViewModel]()


    // MARK: API

    /// Makes a network request to grab all products from Shopify store
    func fetchCards(completion: @escaping Handler) {
        APIService.instance.get { [weak self] (result: Result<Card.Container, APIService.APIError>) in
            switch result {
            case let .success(cards):
                self?.entities = cards.products.map({ CardViewModel(card: $0) })
                self?.createNewGame(completion: completion)
            case let .failure(error):
                completion(.failed(error))
            }
        }
    }

    /// Creates new game by randomly choosing 10 cards and duplicating them
    @discardableResult func createNewGame(completion: Handler?) -> [CardViewModel] {
        guard !entities.isEmpty else {
            return []
        }

        resetGame()

        let shuffled = entities.shuffled()[0..<10]
        var newGameCards = [CardViewModel]()

        // TODO: change iteration to n depending on how many consecutive cards need to be matched
        for _ in 1...2 {
            for card in shuffled {
                newGameCards.append(card.copy() as! CardViewModel)
            }
        }

        currentGameCards = newGameCards.shuffled()
        completion?(.presenting(currentGameCards))
        return currentGameCards
    }

    func didSelectCard(_ card: CardViewModel?, didFinishGame: @escaping () -> Void, hideCards: @escaping ([CardViewModel]) -> Void) {
        guard let card = card, card.state == .notGuessed else {
            return
        }

        card.set(.flipped)
        selectedCards.append(card)

        if cardsDoMatch(selectedCards) {
            flippedCards += selectedCards

            if flippedCards.count == currentGameCards.count {
                didFinishGame()
            }

            if selectedCards.count == 2 {
                for card in selectedCards {
                    card.set(.guessed)
                }

                selectedCards = []
            }
        } else if selectedCards.count > 1 {
            // Hide the cards
            for card in selectedCards {
                card.set(.notGuessed)
            }

            let cardsToHide = selectedCards
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                hideCards(cardsToHide)
            }

            selectedCards = []
        }
    }

    func index(of cardViewModel: CardViewModel) -> Int? {
        for (i, viewModel) in currentGameCards.enumerated() {
            if viewModel === cardViewModel {
                return i
            }
        }

        return nil
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

    private func resetGame() {
        currentGameCards = []
        selectedCards = []
        flippedCards = []
    }
}

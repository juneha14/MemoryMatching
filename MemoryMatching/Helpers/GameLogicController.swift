//
//  EntityManager.swift
//  MemoryMatching
//
//  Created by June Ha on 2019-09-18.
//  Copyright © 2019 June Ha. All rights reserved.
//

import Foundation


enum GameContentState {
    case loading
    case failed(Error)
    case showMenu
    case presenting([CardViewModel])
    case finished
}

protocol GameLogicControllerDelegate: AnyObject {
    func gameLogicControllerDidFinishGame(_ controller: GameLogicController)
    func gameLogicController(_ controller: GameLogicController, hideCards cards: [CardViewModel])
    func gameLogicControllerDidMatchCards(_ controller: GameLogicController)
}

final class GameLogicController {
    typealias Handler = (GameContentState) -> Void

    weak var delegate: GameLogicControllerDelegate?

    /// Original card entities fetched from Shopify store
    private var entities = [CardViewModel]()

    /// The current subset of cards belonging to a particular game
    private(set) var currentGameCards = [CardViewModel]()

    /// All cards that have been correctly guessed and therefore flipped
    private(set) var flippedCards = [CardViewModel]()

    /// Cards that are flipped for guessing
    private var selectedCards = [CardViewModel]()


    // MARK: API

    /// Makes a network request to grab all products from Shopify store
    func fetchCards(completion: @escaping Handler) {
        APIService.instance.get { [weak self] (result: Result<Card.Container, APIService.APIError>) in
            switch result {
            case let .success(cards):
                self?.entities = cards.products.map({ CardViewModel(card: $0) })
                self?.createInitialGame(completion: completion)
            case let .failure(error):
                completion(.failed(error))
            }
        }
    }

    /// Creates new game by randomly choosing 10 cards and duplicating them
    func createNewGame() -> [CardViewModel] {
        guard !entities.isEmpty else {
            return []
        }

        resetGame()
        return chooseNewDeck()
    }

    func didSelectCard(_ card: CardViewModel?) {
        guard let card = card, card.state == .notGuessed else {
            return
        }

        card.set(.flipped)
        selectedCards.append(card)

        if cardsDoMatch(selectedCards) {
            flippedCards += selectedCards

            if selectedCards.count == 2 {
                delegate?.gameLogicControllerDidMatchCards(self)

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
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.delegate?.gameLogicController(self, hideCards: cardsToHide)
            }

            selectedCards = []
        }

        if flippedCards.count == currentGameCards.count {
            delegate?.gameLogicControllerDidFinishGame(self)
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

    private func createInitialGame(completion: @escaping Handler) {
        completion(.presenting(createNewGame()))
    }
    
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

    private func chooseNewDeck() -> [CardViewModel] {
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
}

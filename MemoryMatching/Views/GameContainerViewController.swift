//
//  GameContainerViewController.swift
//  MemoryMatching
//
//  Created by June Ha on 2019-09-20.
//  Copyright © 2019 June Ha. All rights reserved.
//

import UIKit


class GameContainerViewController: UIViewController {
    private(set) var state: GameState?
    private(set) var shownViewController: UIViewController?
    private var logicController: GameLogicController


    // MARK: Init

    init(logicController: GameLogicController = GameLogicController()) {
        self.logicController = logicController
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        if state == nil {
            transition(to: .loading)
        }

        logicController.fetchCards { [weak self] state in
            self?.transition(to: state)
        }
    }


    // MARK: API

    func transition(to newState: GameState) {
        shownViewController?.remove()
        let vc = viewController(for: newState)
        add(vc)
        shownViewController = vc
        state = newState
    }


    // MARK: Helpers

    private func viewController(for state: GameState) -> UIViewController {
        switch state {
        case .loading:
            return LoadingViewController()
        case .failed(_):
            return UIViewController()
        case .presenting(let cards):
            let vc = CardsCollectionViewController(cards: cards)
            vc.didSelectCard = didSelectCard
            return vc
        case .finished:
            let vc = GameFinishedViewController()
            vc.playAgainSelected = didSelectPlayAgain
            return vc
        }
    }

    private func showFinishedAlertController() {
        let alertController = UIAlertController(title: "Hoooray!", message: "You're a memory genius!", preferredStyle: .alert)
        let playAgainAction = UIAlertAction(title: "Play Again?", style: .default) { [weak self] _ in
            self?.handleTap()
        }

        alertController.addAction(playAgainAction)
        shownViewController?.present(alertController, animated: true, completion: nil)
    }

    private func handleTap() {
        let newCards = logicController.createNewGame(completion: nil)

        if let cardsCVC = shownViewController as? CardsCollectionViewController {
            cardsCVC.startNewGame(with: newCards)
        } else {
            transition(to: .loading)
        }
    }

    private func hide(_ cards: [CardViewModel]) {
        guard let cardsCVC = shownViewController as? CardsCollectionViewController else {
            return
        }

        cardsCVC.hideCards(cards)
    }


    // MARK: Handlers

    private func didSelectCard(_ card: CardViewModel) {
        logicController.didSelectCard(card, didFinishGame: { [weak self] in
//            self?.transition(to: .finished)
            self?.showFinishedAlertController()
        }) { [weak self] cards in
            self?.hide(cards)
        }
    }

    private func didSelectPlayAgain() {
        logicController.createNewGame { [weak self] state in
            self?.transition(to: state)
        }
    }
}

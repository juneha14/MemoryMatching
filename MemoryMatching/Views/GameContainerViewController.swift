//
//  GameContainerViewController.swift
//  MemoryMatching
//
//  Created by June Ha on 2019-09-20.
//  Copyright © 2019 June Ha. All rights reserved.
//

import UIKit


class GameContainerViewController: UIViewController, CardsCollectionViewControllerDelegate, EntityManagerDelegate {
    private let entityManager = EntityManager()
    private var state: GameState?
    private var shownViewController: UIViewController?


    override func viewDidLoad() {
        super.viewDidLoad()

        entityManager.delegate = self

        if state == nil {
            transition(to: .loading)
        }

        entityManager.fetchCards { [weak self] state in
            self?.transition(to: state)
        }
    }


    // MARK: CardsCollectionViewControllerDelegate

    func cardsCollectionViewController(_ cardsCollectionViewController: CardsCollectionViewController, didSelect card: CardViewModel) {
        entityManager.didSelectCard(card)
    }


    // MARK: EntityManagerDelegate

    func entityManager(_ entityManager: EntityManager, hideCards cards: [CardViewModel]) {
        guard let cardsVC = shownViewController as? CardsCollectionViewController else {
            return
        }

        cardsVC.hideCards(cards)
    }

    func entityManagerGameDidFinish(_ entityManager: EntityManager) {
        transition(to: .finished)

//        showFinishedAlertController()
    }


    // MARK: Helpers

    private func transition(to newState: GameState) {
        shownViewController?.remove()

        let vc = viewController(for: newState)
        add(vc)
        shownViewController = vc
        state = newState
    }

    private func viewController(for state: GameState) -> UIViewController {
        switch state {
        case .loading:
            return LoadingViewController()
        case .failed(_):
            return UIViewController()
        case .presenting(let cards):
            let vc = CardsCollectionViewController(cards: cards)
            vc.delegate = self
            return vc
        case .finished:
            let vc = GameFinishedViewController()
            vc.playAgainSelected = { [weak self] in
                self?.handlePlayAgainTap()
            }
            return vc
        }
    }

    private func handlePlayAgainTap() {
        entityManager.createNewGame { [weak self] state in
            self?.transition(to: state)
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
        guard let vc = shownViewController as? CardsCollectionViewController else {
            return
        }

        let newCards = entityManager.createNewGame()
        vc.startNewGame(with: newCards)
    }
}

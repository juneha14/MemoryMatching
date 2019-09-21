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
            return UIViewController()
        }
    }
}

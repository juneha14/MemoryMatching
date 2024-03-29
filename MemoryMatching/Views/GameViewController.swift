//
//  CardsCollectionViewController.swift
//  MemoryMatching
//
//  Created by June Ha on 2019-09-18.
//  Copyright © 2019 June Ha. All rights reserved.
//

import UIKit
import SnapKit


class GameViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, GameLogicControllerDelegate {

    private unowned var gameView: GameView {
        return self.view as! GameView
    }

    private unowned var scoreView: ScoreView {
        return gameView.scoreView
    }

    private unowned var collectionView: UICollectionView {
        return gameView.collectionView
    }

    private let logicController: GameLogicController
    private var shownViewController: UIViewController?

    private struct Constants {
        static let insets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        static let minimumLineSpacing: CGFloat = 3.0
        static let minimumInteritemSpacing: CGFloat = 1.0
    }


    // MARK: Init

    init(logicController: GameLogicController) {
        self.logicController = logicController
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: Lifecycle

    override func loadView() {
        self.view = GameView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        registerViews()

        render(.loading)
        logicController.fetchCards { [weak self] state in
            self?.render(state)
        }
    }


    // MARK: Setup

    private func registerViews() {
        logicController.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CardCollectionViewCell.self, forCellWithReuseIdentifier: CardCollectionViewCell.identifier)
    }


    // MARK: Helpers

    private func render(_ state: GameContentState) {
        shownViewController?.remove()

        switch state {
        case .loading:
            let loadingViewController = LoadingViewController()
            add(loadingViewController)
            shownViewController = loadingViewController
        case .failed(_):
            break
        case .showMenu:
            break
        case .presenting(_):
            scoreView.resetScore()
            collectionView.reloadData()
        case .finished:
            let finishedViewController = GameFinishedViewController()
            finishedViewController.playAgainSelected = { [weak self] in
                if let cards = self?.logicController.createNewGame() {
                    self?.render(.presenting(cards))
                }
            }
            add(finishedViewController)
            finishedViewController.view.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(20)
                make.trailing.equalToSuperview().inset(20)
                make.height.equalTo(200)
                make.centerY.equalToSuperview()
            }

            shownViewController = finishedViewController
        }
    }


    // MARK: UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // itemWidth = (collectionView width) / (number of columns) - (left inset + right inset) - (number of columns * minimumInteritemSpacing)
        let itemWidth = collectionView.frame.width / 4.0 - (Constants.insets.left + Constants.insets.right) - (4 * Constants.minimumInteritemSpacing)
        return CGSize(width: itemWidth, height: itemWidth)
    }


    // MARK: UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return logicController.currentGameCards.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCollectionViewCell.identifier, for: indexPath) as? CardCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.viewModel = logicController.currentGameCards[indexPath.row]
    
        return cell
    }


    // MARK: UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell else {
            return
        }

        cell.showCard(true)
        logicController.didSelectCard(cell.viewModel)
    }


    // MARK: GameLogicControllerDelegate

    func gameLogicControllerDidFinishGame(_ controller: GameLogicController) {
        render(.finished)
    }

    func gameLogicController(_ controller: GameLogicController, hideCards cards: [CardViewModel]) {
        for card in cards {
            guard let index = logicController.index(of: card),
                let cell = collectionView.cellForItem(at: IndexPath(row: index, section: 0)) as? CardCollectionViewCell else {
                return
            }

            cell.showCard(false)
        }
    }

    func gameLogicControllerDidMatchCards(_ controller: GameLogicController) {
        scoreView.score += 1
    }
}

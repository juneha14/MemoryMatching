//
//  CardsCollectionViewController.swift
//  MemoryMatching
//
//  Created by June Ha on 2019-09-18.
//  Copyright © 2019 June Ha. All rights reserved.
//

import UIKit
import SnapKit


class CardsCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    private var cards = [Card]()
    private var collectionView: UICollectionView!

    private struct Constants {
        static let insets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        static let minimumLineSpacing: CGFloat = 3.0
        static let minimumInteritemSpacing: CGFloat = 1.0
    }


    // MARK: Init

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = Constants.minimumLineSpacing
        layout.minimumInteritemSpacing = Constants.minimumInteritemSpacing
        layout.sectionInset = Constants.insets
        layout.scrollDirection = .vertical

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CardCollectionViewCell.self, forCellWithReuseIdentifier: CardCollectionViewCell.identifier)
        view.addSubview(collectionView)

        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        EntityManager.instance.initialize { [weak self] in
            self?.cards = EntityManager.instance.createNewGame()
            self?.collectionView.reloadData()
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
        return cards.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCollectionViewCell.identifier, for: indexPath) as? CardCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.backgroundColor = .red //DEBUG
        cell.card = cards[indexPath.row]
    
        return cell
    }


    // MARK: UICollectionViewDelegate

    

}

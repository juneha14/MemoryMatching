//
//  GameView.swift
//  MemoryMatching
//
//  Created by June Ha on 2019-09-22.
//  Copyright © 2019 June Ha. All rights reserved.
//

import UIKit
import SnapKit


class GameView: UIView {
    lazy var scoreView = ScoreView()

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = Constants.minimumLineSpacing
        layout.minimumInteritemSpacing = Constants.minimumInteritemSpacing
        layout.sectionInset = Constants.insets
        layout.scrollDirection = .vertical

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor(red: 0.62, green: 0.4, blue: 0.4, alpha: 0.8)
        return collectionView
    }()


    private struct Constants {
        static let insets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        static let minimumLineSpacing: CGFloat = 15.0
        static let minimumInteritemSpacing: CGFloat = 1.0
    }


    // MARK: Init

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(scoreView)
        addSubview(collectionView)

        scoreView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(150)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(scoreView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(10)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

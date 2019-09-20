//
//  CardCollectionViewCell.swift
//  MemoryMatching
//
//  Created by June Ha on 2019-09-18.
//  Copyright © 2019 June Ha. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage

class CardCollectionViewCell: UICollectionViewCell {
    static let identifier = "CardCollectionViewCell"

    lazy var cardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = .black
        imageView.layer.borderColor = UIColor.blue.cgColor
        imageView.layer.borderWidth = 1.5
        return imageView
    }()

    var viewModel: CardViewModel! {
        didSet {
            render(viewModel)
        }
    }


    // MARK: Init

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(cardImageView)

        cardImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.width.equalToSuperview()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()

        cardImageView.layer.cornerRadius = cardImageView.frame.height / 6.0
    }


    // MARK: API

    func render(_ viewModel: CardViewModel) {
        let imageURL = URL(string: viewModel.card.image.src)
        cardImageView.sd_setImage(with: imageURL, completed: nil)
        cardImageView.alpha = viewModel.alpha
    }
}

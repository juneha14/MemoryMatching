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

    lazy var backCardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor(red: 0.68, green: 0.45, blue: 0.45, alpha: 0.5)
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 1.5
        return imageView
    }()

    /// Shows the actual image
    lazy var frontCardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor(red: 0.68, green: 0.45, blue: 0.45, alpha: 1.0)
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 1.5
        return imageView
    }()


    var viewModel: CardViewModel! {
        didSet {
            let imageURL = URL(string: viewModel.card.image.src)
            frontCardImageView.sd_setImage(with: imageURL, completed: nil)

            // Reset the views
            frontCardImageView.isHidden = true
            backCardImageView.isHidden = false
        }
    }


    // MARK: Init

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(frontCardImageView)
        addSubview(backCardImageView)

        frontCardImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.width.equalToSuperview()
        }

        backCardImageView.snp.makeConstraints { make in
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

        frontCardImageView.layer.cornerRadius = frontCardImageView.frame.height / 6.0
        backCardImageView.layer.cornerRadius = backCardImageView.frame.height / 6.0
    }


    // MARK: API

    func showCard(_ show: Bool) {
        guard viewModel.state == .notGuessed else {
            return
        }

        if show {
            UIView.transition(from: backCardImageView, to: frontCardImageView,
                              duration: 0.5,
                              options: [.transitionFlipFromRight, .showHideTransitionViews],
                              completion: nil)
        } else {
            UIView.transition(from: frontCardImageView, to: backCardImageView,
                              duration: 0.5,
                              options: [.transitionFlipFromLeft, .showHideTransitionViews],
                              completion: nil)
        }
    }
}

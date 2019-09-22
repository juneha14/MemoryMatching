//
//  ScoreView.swift
//  MemoryMatching
//
//  Created by June Ha on 2019-09-22.
//  Copyright © 2019 June Ha. All rights reserved.
//

import UIKit
import SnapKit


class ScoreView: UIView {
    lazy var scoreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 1
        label.text = "2 pairs out of 10 found"
        label.font = UIFont(name: "AvenirNext-Bold", size: 25.0)
        label.textColor = .white
        return label
    }()


    // MARK: Init

    override init(frame: CGRect) {
        super.init(frame: frame)

        layer.cornerRadius = 5.0
        backgroundColor = UIColor(red:0.97, green:0.47, blue:0.47, alpha:1.0)

        addSubview(scoreLabel)

        scoreLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.leading.equalToSuperview().offset(40)
            make.trailing.equalToSuperview().inset(40)
            make.bottom.equalToSuperview()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

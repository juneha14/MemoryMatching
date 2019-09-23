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
        label.numberOfLines = 2
        label.text = "0 pairs out of 10 found"
        label.font = UIFont(name: "AvenirNext-Bold", size: 25.0)
        label.textColor = .white
        return label
    }()

    var score: Int = 0 {
        didSet {
            let pairText = score == 1 ? " pair " : " pairs "
            scoreLabel.text = "\(score)" + pairText + "out of 10 found"
        }
    }


    // MARK: Init

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor(red: 0.62, green: 0.45, blue: 0.4, alpha: 0.8)

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


    // MARK: API

    func resetScore() {
        score = 0
    }
}

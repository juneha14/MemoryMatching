//
//  GameFinishedViewController.swift
//  MemoryMatching
//
//  Created by June Ha on 2019-09-21.
//  Copyright © 2019 June Ha. All rights reserved.
//

import UIKit
import SnapKit


class GameFinishedViewController: UIViewController {
    var playAgainSelected: (() -> Void)?

    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Hoooray!\nYou're a memory genius!"
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = UIFont(name: "AvenirNext-Regular", size: 17.0)
        label.textColor = .white
        return label
    }()

    private lazy var playAgainButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 17.0)
        button.setTitle("Play Again", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.clear
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 5.0
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(playAgainButtonPressed), for: .touchUpInside)
        return button
    }()

    private lazy var returnToMenuButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 17.0)
        button.setTitle("Return to Menu", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.clear
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 5.0
        button.clipsToBounds = true
        return button
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.label, self.playAgainButton, self.returnToMenuButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 10
        return stackView
    }()


    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(red:0.55, green:0.38, blue:0.38, alpha:1.0)
        view.layer.cornerRadius = 5.0
        view.addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.equalToSuperview().offset(40.0)
            make.trailing.equalToSuperview().inset(40.0)
        }
    }
    

    @objc private func playAgainButtonPressed() {
        playAgainSelected?()
    }
}

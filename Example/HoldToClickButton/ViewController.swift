//
//  ViewController.swift
//  HoldToClickButton
//
//  Created by Inder Dhir on 12/05/2018.
//  Copyright (c) 2018 Inder Dhir. All rights reserved.
//

import UIKit
import HoldToClickButton

class ViewController: UIViewController {

    private let holdToClickButton: HoldToClickButton = {
        let button = HoldToClickButton(fillColor: .orange)
        button.backgroundColor = .clear
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitle("Hold to Click", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.masksToBounds = true
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(holdToClickButton)

        holdToClickButton.translatesAutoresizingMaskIntoConstraints = false
        holdToClickButton.widthAnchor.constraint(equalToConstant: 250).isActive = true
        holdToClickButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        holdToClickButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        holdToClickButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        holdToClickButton.layer.cornerRadius = holdToClickButton.frame.height / 2
    }
}

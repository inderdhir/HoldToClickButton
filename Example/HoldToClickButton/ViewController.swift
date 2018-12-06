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

    private let holdToClickStatefulButton: HoldToClickStatefulButton = {
        let button = HoldToClickStatefulButton()
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitle("Hold to Click With States", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.masksToBounds = true
        return button
    }()

    private let holdToClickButton: HoldToClickButton = {
        let button = HoldToClickButton()
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

        view.addSubview(holdToClickStatefulButton)
        view.addSubview(holdToClickButton)

        holdToClickStatefulButton.translatesAutoresizingMaskIntoConstraints = false
        holdToClickStatefulButton.widthAnchor.constraint(equalToConstant: 250).isActive = true
        holdToClickStatefulButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        holdToClickStatefulButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        holdToClickStatefulButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -180).isActive = true

        holdToClickButton.translatesAutoresizingMaskIntoConstraints = false
        holdToClickButton.widthAnchor.constraint(equalToConstant: 250).isActive = true
        holdToClickButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        holdToClickButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        holdToClickButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        holdToClickStatefulButton.layer.cornerRadius = holdToClickStatefulButton.frame.height / 2
        holdToClickButton.layer.cornerRadius = holdToClickButton.frame.height / 2
    }
}

//
//  ViewController.swift
//  HoldToClickButton
//
//  Created by Inder Dhir on 12/05/2018.
//  Copyright (c) 2018 Inder Dhir. All rights reserved.
//

import UIKit
import HoldToClickButton

private class HoldToClickFillView: UIView {

    private var fillView: UIView = {
        let view = UIView()
        view.backgroundColor = .orange
        return view
    }()

    private var path: UIBezierPath?

    private var startFrame: CGRect!
    private var trailing: NSLayoutConstraint!

    private var isAnimating = false {
        didSet {
            if isAnimating {
                trailing.isActive = true
                UIView.animate(withDuration: 1.5, delay: 0, options: .curveEaseInOut, animations: {
                    self.layoutIfNeeded()
                }, completion: nil)
            } else {
                trailing.isActive = false
                fillView.layer.removeAllAnimations()
                setNeedsLayout()
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear

        startFrame = frame

        addSubview(fillView)

        fillView.translatesAutoresizingMaskIntoConstraints = false
        fillView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true

        trailing = fillView.trailingAnchor.constraint(equalTo: trailingAnchor)
        trailing.isActive = false

        fillView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        fillView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isAnimating { isAnimating = true }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isAnimating = false
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
}

private class HoldToClickButtonExtension: UIButton {
    private let fillView = HoldToClickFillView()

    public init() {
        super.init(frame: .zero)

        addSubview(fillView)
        sendSubview(toBack: fillView)

        fillView.translatesAutoresizingMaskIntoConstraints = false
        fillView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        fillView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        fillView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        fillView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

class ViewController: UIViewController {

    private let holdToClickButton: HoldToClickButtonExtension = {
        let button = HoldToClickButtonExtension()
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitle("Hide A Memory", for: .normal)
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
        holdToClickButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        holdToClickButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        holdToClickButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        holdToClickButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        holdToClickButton.layer.cornerRadius = holdToClickButton.frame.height / 2
    }
}

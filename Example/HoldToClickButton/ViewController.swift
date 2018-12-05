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

    private var isHolding = false {
        didSet {
            print("\(isHolding)")
        }
    }

    private var startTime: Date? {
        didSet { setNeedsDisplay() }
    }
    private let time: TimeInterval = 3

    private var fillColor = UIColor.orange {
        didSet { setNeedsDisplay() }
    }

    private var fillTimer: Timer?

    private var path: UIBezierPath?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        startTime = Date()
        fillTimer = Timer.scheduledTimer(
            timeInterval: 0.016,
            target: self,
            selector: #selector(fillView),
            userInfo: nil,
            repeats: true
        )
        fillTimer?.fire()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("TOUCHES ENDED")
        startTime = nil

        fillTimer?.invalidate()
        fillTimer = nil

        setNeedsDisplay()
    }

    override func draw(_ rect: CGRect) {
        print("DRAW")
//        super.draw(rect)

        if let startTime = startTime {
            let elapsed = Date().timeIntervalSince(startTime)
            if elapsed < time {
                let percent = CGFloat(elapsed / time)
                fillColor.setFill()

                let fillRect = CGRect(x: rect.minX, y: rect.minY, width: rect.width * percent, height: rect.height)
                path = UIBezierPath(rect: fillRect)
                path?.fill()
            } else {
                fillTimer?.invalidate()
                fillTimer = nil
            }
        } else {
            path = nil
        }
    }

    @objc func fillView() {
        setNeedsDisplay()
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
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


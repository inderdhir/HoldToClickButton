//
//  HoldToClickButton.swift
//  HoldToClickButton
//
//  Created by Inder Dhir on 12/6/18.
//

import UIKit

public class HoldToClickButton: UIButton {

    private var trailing: NSLayoutConstraint!

    private var isAnimating = false {
        didSet {
            if isAnimating {
                trailing.isActive = true
                UIView.animate(withDuration: 1.5, delay: 0, options: .curveEaseInOut, animations: {
                    self.layoutIfNeeded()
                }, completion: { [weak self] completed in
                    if completed {
                        print("Completed")
                    } else {
                        self?.playCancelAnimation()
                        print("Completed")
                    }
                })
            } else {
                trailing.isActive = false
                fillView.layer.removeAllAnimations()
                setNeedsLayout()
            }
        }
    }

    private var fillView: UIView = {
        let view = UIView()
        view.backgroundColor = .orange
        return view
    }()

    public init() {
        super.init(frame: .zero)

        addSubview(fillView)
        sendSubview(toBack: fillView)

        backgroundColor = .clear

        fillView.translatesAutoresizingMaskIntoConstraints = false
        fillView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        fillView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        fillView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        trailing = fillView.trailingAnchor.constraint(equalTo: trailingAnchor)
        trailing.isActive = false
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    private func playCancelAnimation() {
        let midX = center.x
        let midY = center.y

        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.15
        animation.repeatCount = 1
        animation.autoreverses = true
        animation.fromValue = CGPoint(x: midX - 20, y: midY)
        animation.toValue = CGPoint(x: midX + 20, y: midY)
        layer.add(animation, forKey: "position")
    }

    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isAnimating { isAnimating = true }
    }

    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isAnimating = false
    }
}

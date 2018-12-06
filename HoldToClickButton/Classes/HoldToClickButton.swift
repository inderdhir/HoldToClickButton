//
//  HoldToClickButton.swift
//  HoldToClickButton
//
//  Created by Inder Dhir on 12/6/18.
//

import UIKit

public protocol HoldToClickButtonDelegate: class {
    func didStartHoldingToClick()
    func didStopHoldingToClick()
    func didCompleteHoldToClick()
    func didCancelHoldToClick()
}

public class HoldToClickButton: UIButton {

    // MARK: Public

    public weak var delegate: HoldToClickButtonDelegate?

    // MARK: Private

    private var trailing: NSLayoutConstraint!

    private var isHolding = false {
        didSet {
            if isHolding {
                trailing.isActive = true
                UIView.animate(withDuration: 1.5, delay: 0, options: .curveEaseInOut, animations: {
                    self.layoutIfNeeded()
                }, completion: { [weak self] completed in
                    if completed {
                        self?.delegate?.didCompleteHoldToClick()
                    } else {
                        self?.playCancelAnimation()
                        self?.delegate?.didCancelHoldToClick()
                    }
                })
            } else {
                trailing.isActive = false
                fillView.layer.removeAllAnimations()
                setNeedsLayout()
            }
        }
    }

    private var fillView = UIView()

    public init(fillColor: UIColor) {
        super.init(frame: .zero)

        fillView.backgroundColor = fillColor

        addSubview(fillView)
        sendSubview(toBack: fillView)

        fillView.translatesAutoresizingMaskIntoConstraints = false
        fillView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        fillView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        fillView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        trailing = fillView.trailingAnchor.constraint(equalTo: trailingAnchor)
        trailing.isActive = false
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func playCancelAnimation() {
        let midX = center.x
        let midY = center.y
        let cancelAnimation = CABasicAnimation(keyPath: "position")
        cancelAnimation.duration = 0.15
        cancelAnimation.repeatCount = 1
        cancelAnimation.autoreverses = true
        cancelAnimation.fromValue = CGPoint(x: midX - 20, y: midY)
        cancelAnimation.toValue = CGPoint(x: midX + 20, y: midY)
        layer.add(cancelAnimation, forKey: "cancelAnimation")
    }

    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isHolding {
            isHolding = true
            delegate?.didStartHoldingToClick()
        }
    }

    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isHolding = false
        delegate?.didStopHoldingToClick()
    }
}

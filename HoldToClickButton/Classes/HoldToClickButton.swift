//
//  HoldToClickButton.swift
//  HoldToClickButton
//
//  Created by Inder Dhir on 12/6/18.
//

import UIKit

/// Callbacks for HoldToClickButton
public protocol HoldToClickButtonDelegate: class {
    
    /// User began holding the button to click
    func didStartHoldingToClick()

    /// User stopped holding the button to click
    func didStopHoldingToClick()

    /// User completed the hold to click
    func didCompleteHoldToClick()

    /// User cancelled the hold to click
    func didCancelHoldToClick()
}

public class HoldToClickButton: UIButton {

    // MARK: Public

    /// Delegate for callbacks
    public weak var delegate: HoldToClickButtonDelegate?

    /// Duration of the progress animation. Default: 1.5
    public var animationDuration: TimeInterval = 1.5

    /// Options for progress animation. Default: curveEaseInOut
    public var animationOptions: UIViewAnimationOptions = .curveEaseInOut

    /// Toggle cancel 'shake' animation. Default: true
    public var isCancelAnimationEnabled = true

    // MARK: Private

    /// The trailing constraint of the progressView, used to animate progress
    private var trailingConstraint: NSLayoutConstraint!

    /// Keeps track of whether the button is being held or not. Used to trigger progress and animations
    private var isHolding = false {
        didSet {
            if isHolding {
                delegate?.didStartHoldingToClick()

                layoutIfNeeded()

                trailingConstraint.isActive = true
                UIView.animate(
                    withDuration: animationDuration,
                    delay: 0,
                    options: animationOptions,
                    animations: { self.layoutIfNeeded() },
                    completion: { [weak self] completed in
                        if completed {
                            self?.delegate?.didCompleteHoldToClick()
                        } else {
                            self?.delegate?.didCancelHoldToClick()
                            if self?.isCancelAnimationEnabled == true { self?.playCancelAnimation() }
                        }
                    })
            } else {
                delegate?.didStopHoldingToClick()

                trailingConstraint.isActive = false
                progressView.layer.removeAllAnimations()
                setNeedsLayout()
            }
        }
    }

    /// View used as a background to show progress while holding the button
    private var progressView = UIView()

    public init(fillColor: UIColor) {
        super.init(frame: .zero)

        progressView.backgroundColor = fillColor

        addSubview(progressView)
        sendSubview(toBack: progressView)

        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        progressView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        progressView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        trailingConstraint = progressView.trailingAnchor.constraint(equalTo: trailingAnchor)
        trailingConstraint.isActive = false
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    /// Play the cancel animation when the user stops holding the button
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
        if !isHolding { isHolding = true }
    }

    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isHolding = false
    }
}

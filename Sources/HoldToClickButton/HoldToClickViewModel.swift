//
//  HoldToClickViewModel.swift
//  
//
//  Created by Inder Dhir on 8/3/23.
//

import Foundation
import SwiftUI

@MainActor
final class HoldToClickViewModel: ObservableObject {
    @Published var holdState = HoldState.none
    @Published var cancelXOffset: CGFloat = 0
    
    private var holdDuration: TimeInterval = 1.0
    private var cancelDuration: TimeInterval = 1.0
    private var onHoldBegin: (() -> Void)?
    private var onHoldEnd: (() -> Void)?
    private var onHoldCancel: (() -> Void)?
    
    private var holdEndSerialQueue = DispatchQueue(label: "com.inderdhir.holdtoclick.hold_end")
    private var hasTriggeredHoldEnd = false
    private var holdTask: Task<Void, Never>?
    private var cancelTask: Task<Void, Never>?
    
    enum HoldState {
        case none, holding, canceling
    }
    
    func setup(
        holdDuration: TimeInterval,
        cancelDuration: TimeInterval,
        onHoldBegin: (() -> Void)?,
        onHoldEnd: (() -> Void)?,
        onHoldCancel: (() -> Void)?
    ) {
        self.holdDuration = holdDuration
        self.cancelDuration = cancelDuration
        self.onHoldBegin = onHoldBegin
        self.onHoldEnd = onHoldEnd
        self.onHoldCancel = onHoldCancel
    }
    
    func onDragGestureChange(value: DragGesture.Value, maxWidth: CGFloat) {
        guard holdState == .none else { return }
        
        holdState = .holding
        onHoldBegin?()
        
        holdTask?.cancel()
        holdTask = Task {
            await scheduleHoldEnd()
        }
    }
    
    func onDragEnd() {
        holdEndSerialQueue.sync {
            if hasTriggeredHoldEnd {
                reset()
            } else {
                holdTask?.cancel()
                
                cancelTask?.cancel()
                cancelTask = Task {
                    await playCancelAnimation()
                    reset()
                }
            }
        }
    }
    
    private func scheduleHoldEnd() async {
        let holdDurationNS = UInt64(holdDuration * 1_000_000_000)
        try? await Task.sleep(nanoseconds: holdDurationNS)
        
        holdEndSerialQueue.sync {
            hasTriggeredHoldEnd = true
        }
        onHoldEnd?()
    }
    
    private func playCancelAnimation() async {
        holdState = .canceling
        
        let cancelDurationNS = UInt64(cancelDuration * 1_000_000_000)
        cancelXOffset = -10
        try? await Task.sleep(nanoseconds: cancelDurationNS)
        cancelXOffset = 0
        
        holdState = .none
    }
    
    private func reset() {
        holdState = .none
        
        holdTask?.cancel()
        hasTriggeredHoldEnd = false
        
        cancelTask?.cancel()
    }
}

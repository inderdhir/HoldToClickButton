//
//  HoldToClickButton.swift
//  
//
//  Created by Inder Dhir on 11/20/22.
//

import SwiftUI

struct HoldToClickButton<Label>: View where Label: View {
    
    private let fillColor: Color
    private let holdDuration: TimeInterval
    private let label: () -> Label
    private let onHoldBegin: (() -> Void)?
    private let onHoldEnd: (() -> Void)?
    private let onHoldCancel: (() -> Void)?
    
    @State var onHolding = false
    @State var currentHoldTime: TimeInterval = 0
    @State var progressWidth: CGFloat = 0
    
    let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    @State var isCanceling = false
    @State var cancelHoldTime: TimeInterval = 0
    @State var cancelTime = 0.5
    @State var xOffset: CGFloat = 0
    
    
    public init(
        fillColor: Color,
        holdDuration: TimeInterval = 1.5,
        label: @escaping () -> Label,
        onHoldBegin: (() -> Void)? = nil,
        onHoldEnd: (() -> Void)? = nil,
        onHoldCancel: (() -> Void)? = nil
    ) {
        self.fillColor = fillColor
        self.holdDuration = holdDuration
        self.label = label
        self.onHoldBegin = onHoldBegin
        self.onHoldEnd = onHoldEnd
        self.onHoldCancel = onHoldCancel
    }
    
    var body: some View {
        GeometryReader { geometryReader in
            ZStack {
                HStack {
                    fillColor
                        .frame(width: progressWidth)
                    
                    Spacer()
                }
                
                label()
            }
            // Ensures that the following gesture works on the outer ZStack
            .contentShape(Rectangle())
            .animation(isCanceling ? Animation.easeInOut(duration: 0.15).repeatForever(autoreverses: true) : nil)
            .onReceive(timer) { _ in
                if isCanceling {
                    updateCancelState()
                    cancelHoldAnimation()
                } else if onHolding {
                    updateHoldState()
                }
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        guard !onHolding && !isCanceling else { return }
                        
                        withAnimation(.easeInOut(duration: holdDuration)) {
                            progressWidth = geometryReader.size.width
                        }
                        
                        onHolding = true
                        onHoldBegin?()
                    }
                    .onEnded { value in
                        onHolding = false
                        cancelHoldAnimation()

                        if hasMetHoldThreshold {
//                            onHoldEnd?()
                        } else {
                            playCancelAnimation()
                        }
                    },
                including: .all
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .offset(x: xOffset)
        }
    }
    
    var hasMetCancelThreshold: Bool {
        cancelHoldTime >= cancelTime
    }
    
    var hasMetHoldThreshold: Bool {
        currentHoldTime >= holdDuration
    }
    
    private func updateCancelState() {
        if hasMetCancelThreshold {
            cancelCancelAnimation()
        } else {
            cancelHoldTime += 0.05
        }
    }
    
    private func updateHoldState() {
        if hasMetHoldThreshold {
            cancelHoldAnimation()
            onHoldEnd?()
            
            currentHoldTime = 0
        } else {
            currentHoldTime += 0.05
        }
    }
    
    func cancelHoldAnimation() {
        var transaction = Transaction()
        transaction.disablesAnimations = true
        withTransaction(transaction) {
            progressWidth = 0
        }
    }
    
    func playCancelAnimation() {
        isCanceling = true
        
        withAnimation {
            xOffset = -15
        }
    }
    
    func cancelCancelAnimation() {
        isCanceling = false
        cancelHoldTime = 0

        var transaction = Transaction()
        transaction.disablesAnimations = true
        withTransaction(transaction) {
            xOffset = 0
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            HoldToClickButton(
                fillColor: .blue,
                label: {
                    Text("Hold To Click")
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                }, onHoldBegin: {
                }, onHoldEnd: {
                }
            )
            .cornerRadius(25)
            .overlay(content: {
                Capsule(style: .continuous)
                    .stroke(Color.black, lineWidth: 2)
            })
            .frame(width: 320, height: 50)
        }
    }
}

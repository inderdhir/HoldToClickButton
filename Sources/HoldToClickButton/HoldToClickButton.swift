//
//  HoldToClickButton.swift
//
//
//  Created by Inder Dhir on 11/20/22.
//

import SwiftUI

public struct HoldToClickButton<Label>: View where Label: View {
    
    private let fillColor: Color
    private let borderColor: Color
    private let borderWidth: CGFloat
    private let holdDuration: TimeInterval
    private let cancelDuration: TimeInterval
    private let label: () -> Label
    private let onHoldBegin: (() -> Void)?
    private let onHoldEnd: (() -> Void)?
    private let onHoldCancel: (() -> Void)?
    @StateObject private var viewModel = HoldToClickViewModel()
    
    public init(
        fillColor: Color = Color.orange,
        borderColor: Color = Color.black,
        borderWidth: CGFloat = 2.0,
        holdDuration: TimeInterval = 1.5,
        cancelDuration: TimeInterval = 0.3,
        label: @escaping () -> Label,
        onHoldBegin: (() -> Void)? = nil,
        onHoldEnd: (() -> Void)? = nil,
        onHoldCancel: (() -> Void)? = nil
    ) {
        self.fillColor = fillColor
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.holdDuration = holdDuration
        self.cancelDuration = cancelDuration
        self.label = label
        self.onHoldBegin = onHoldBegin
        self.onHoldEnd = onHoldEnd
        self.onHoldCancel = onHoldCancel
    }
    
    public var body: some View {
        GeometryReader { geometryReader in
            let roundedRect = RoundedRectangle(cornerRadius: geometryReader.size.height * 0.5)
            
            Group {
                label()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(
                        fillColor
                            .animation(
                                viewModel.holdState == .holding ? .easeInOut(duration: holdDuration) : .default,
                                value: viewModel.holdState
                            )
                            .offset(x: fillXOffset(maxWidth: geometryReader.size.width))
                            .frame(maxWidth: viewModel.holdState == .holding ? .infinity : 0, alignment: .leading)
                    )
                    // Ensures that the following gesture works on the outer ZStack
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                viewModel.onDragGestureChange(
                                    value: value,
                                    maxWidth: geometryReader.size.width
                                )
                            }
                            .onEnded { _ in
                                viewModel.onDragEnd()
                            }
                    )
            }
            .clipShape(roundedRect)
            .overlay(roundedRect.strokeBorder(borderColor, lineWidth: borderWidth))
            .offset(x: viewModel.cancelXOffset, y: 0)
            .animation(
                viewModel.holdState == .canceling ?
                    .easeOut(duration: cancelDuration / 2)
                    .repeatForever(autoreverses: true).speed(4) : .default,
                value: viewModel.holdState
            )
        }
        .onAppear {
            viewModel.setup(
                holdDuration: holdDuration,
                cancelDuration: cancelDuration,
                onHoldBegin: onHoldBegin,
                onHoldEnd: onHoldEnd,
                onHoldCancel: onHoldCancel
            )
        }
    }
    
    private func fillXOffset(maxWidth: CGFloat) -> CGFloat {
        if viewModel.holdState == .holding {
            0
        } else if viewModel.holdState == .canceling {
            -(maxWidth * 0.5) - 100
        } else {
            -(maxWidth * 0.5)
        }
    }
}

#Preview {
    HoldToClickButton(
        label: {
            Text("Hold To Click")
                .fontWeight(.bold)
                .foregroundColor(.black)
        }
    )
    .frame(width: 320, height: 50)
    .padding()
}

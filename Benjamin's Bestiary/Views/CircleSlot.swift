//
//  CircleSlot.swift
//  Benjamin's Bestiary
//

import SwiftUI

struct CircleSlot: View {
    @Binding var isComplete: Bool

    let slotSize: CGFloat
    let fontSize: CGFloat

    var body: some View {
        ZStack {
            if isComplete {
                Text("O")
                    .font(.custom("InknutAntiqua-Regular", size: fontSize))
            } else {
                ZStack {
                    Circle()
                        .strokeBorder(
                            style: StrokeStyle(lineWidth: 2, dash: [4, 4])
                        )
                        .foregroundColor(.gray.opacity(0.6))

                    DrawingViewControllerWrapper(
                        onCircleValidated: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                isComplete = true
                            }
                        },
                        minPoints: 15,
                        maxClosingDistance: 100,
                        circularityTolerance: 0.40,
                        brushWidth: 8.0,
                        backgroundColor: .clear
                    )
                }
                .frame(width: slotSize, height: slotSize)
                .clipShape(Circle())
            }
        }
        .frame(width: slotSize, height: slotSize)
    }
}

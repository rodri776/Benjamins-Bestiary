//
//  DrawingViewControllerWrapper.swift
//  Benjamin's Bestiary
//

import SwiftUI

struct DrawingViewControllerWrapper: UIViewControllerRepresentable {
    var onCircleValidated: () -> Void
    var minPoints: Int = 20
    var maxClosingDistance: CGFloat = 100
    var circularityTolerance: CGFloat = 0.35
    var brushWidth: CGFloat = 10.0
    var strokeColor: UIColor = .black
    var backgroundColor: UIColor = .white

    func makeUIViewController(context: Context) -> DrawingViewController {
        let vc = DrawingViewController()
        vc.onCircleValidated = onCircleValidated
        vc.minPoints = minPoints
        vc.maxClosingDistance = maxClosingDistance
        vc.circularityTolerance = circularityTolerance
        vc.brushWidth = brushWidth
        vc.strokeColor = strokeColor
        vc.viewBackgroundColor = backgroundColor
        return vc
    }

    func updateUIViewController(_ uiViewController: DrawingViewController, context: Context) {
        uiViewController.onCircleValidated = onCircleValidated
    }
}

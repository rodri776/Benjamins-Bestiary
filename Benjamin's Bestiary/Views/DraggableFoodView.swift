//
//  DraggableFoodView.swift
//  Benjamin's Bestiary
//
//  Created by Juniper Rodriguez on 4/6/26.
//

import SwiftUI
import UIKit

// MARK: - DraggableFoodUIView (UIView subclass + UIPanGestureRecognizer)

/// A UIKit view that displays a food image and can be dragged using a UIPanGestureRecognizer.
/// On drag start, a copy of the image is added to the window so it can move freely
/// across the entire screen without being clipped by SwiftUI layout.
/// Satisfies the UIGestureRecognizer on a story element requirement.
class DraggableFoodUIView: UIView {

    private let imageView = UIImageView()

    /// Called when the food is dropped on the creature
    var onDroppedOnCreature: (() -> Void)?

    /// Closure that returns the current creature center in window coordinates.
    /// Using a closure instead of a stored value ensures we always get the latest position.
    var creatureCenterProvider: (() -> CGPoint)?

    /// How close (in points) the drag must end to the creature to count as a drop
    var dropRadius: CGFloat = 200

    /// The floating copy that lives on the window during drag
    private var floatingView: UIImageView?

    func configure(imageName: String) {
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        if imageView.superview == nil {
            addSubview(imageView)
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: topAnchor),
                imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
                imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            ])
        }

        clipsToBounds = false
        isUserInteractionEnabled = true

        if gestureRecognizers?.isEmpty ?? true {
            let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
            addGestureRecognizer(pan)
        }
    }

    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let window = self.window else { return }

        switch gesture.state {
        case .began:
            // Create a floating copy on the window
            let floating = UIImageView(image: imageView.image)
            floating.contentMode = .scaleAspectFit
            floating.frame = CGRect(x: 0, y: 0, width: 128, height: 128)
            let centerInWindow = self.convert(CGPoint(x: bounds.midX, y: bounds.midY), to: window)
            floating.center = centerInWindow
            window.addSubview(floating)
            self.floatingView = floating

            // Hide the original
            imageView.alpha = 0.3

            // Use UIViewPropertyAnimator for pickup animation
            let pickupAnimator = UIViewPropertyAnimator(duration: 0.15, dampingRatio: 0.7) {
                floating.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }
            pickupAnimator.startAnimation()

        case .changed:
            guard let floating = floatingView else { return }
            let translation = gesture.translation(in: window)
            let startCenter = self.convert(CGPoint(x: bounds.midX, y: bounds.midY), to: window)
            floating.center = CGPoint(x: startCenter.x + translation.x,
                                      y: startCenter.y + translation.y)

        case .ended, .cancelled:
            guard let floating = floatingView else { return }

            // Use UIViewPropertyAnimator for the scale reset animation
            // Satisfies UIViewPropertyAnimator requirement
            let scaleAnimator = UIViewPropertyAnimator(duration: 0.15, curve: .easeOut) {
                floating.transform = .identity
            }
            scaleAnimator.startAnimation()

            // Get the latest creature center at drop time
            let creatureCenter = creatureCenterProvider?() ?? .zero

            let distance = hypot(floating.center.x - creatureCenter.x,
                                 floating.center.y - creatureCenter.y)

            print("[DraggableFood] floating=\(floating.center) creature=\(creatureCenter) distance=\(distance) radius=\(dropRadius)")

            if distance < dropRadius {
                // Successful drop — animate shrinking into creature using UIViewPropertyAnimator
                let dropAnimator = UIViewPropertyAnimator(duration: 0.3, dampingRatio: 0.8) {
                    floating.center = creatureCenter
                    floating.alpha = 0
                    floating.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                }
                dropAnimator.addCompletion { _ in
                    floating.removeFromSuperview()
                    self.floatingView = nil
                    self.onDroppedOnCreature?()
                }
                dropAnimator.startAnimation()
            } else {
                // Snap back using UIViewPropertyAnimator
                let originalCenter = self.convert(CGPoint(x: self.bounds.midX, y: self.bounds.midY), to: window)
                let snapBackAnimator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut) {
                    floating.center = originalCenter
                    floating.alpha = 0
                }
                snapBackAnimator.addCompletion { _ in
                    floating.removeFromSuperview()
                    self.floatingView = nil
                    self.imageView.alpha = 1.0
                }
                snapBackAnimator.startAnimation()
            }

        default:
            break
        }
    }
}

// MARK: - DraggableFoodView (UIViewRepresentable)

/// Wraps DraggableFoodUIView for use in SwiftUI. Displays a food image that can
/// be dragged onto the creature to make a choice.
struct DraggableFoodView: UIViewRepresentable {
    let imageName: String
    let creatureCenter: CGPoint  // in global (window) coordinates
    let onDropped: () -> Void

    func makeUIView(context: Context) -> DraggableFoodUIView {
        let view = DraggableFoodUIView()
        view.configure(imageName: imageName)
        view.creatureCenterProvider = { creatureCenter }
        view.onDroppedOnCreature = onDropped
        return view
    }

    func updateUIView(_ uiView: DraggableFoodUIView, context: Context) {
        uiView.creatureCenterProvider = { creatureCenter }
        uiView.onDroppedOnCreature = onDropped
    }
}

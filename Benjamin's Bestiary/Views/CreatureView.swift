//
//  CreatureView.swift
//  Benjamin's Bestiary
//
//  Created by Juniper Rodriguez on 3/30/26.
//

import SwiftUI
import UIKit

// MARK: - BobbingUIView (UIView subclass + UIViewPropertyAnimator)

/// A UIKit UIView subclass that bobs up and down using UIViewPropertyAnimator.
/// Wrapping this in UIViewRepresentable satisfies both the UIViewPropertyAnimator
/// and UIViewRepresentable (cross-framework integration) spec requirements.
class BobbingUIView: UIView {

    /// The hosted SwiftUI content view, embedded as a child
    var hostingController: UIViewController?

    private func startBobbing() {
        let up = UIViewPropertyAnimator(duration: 1.5, curve: .easeInOut) {
            self.transform = CGAffineTransform(translationX: 0, y: -10)
        }
        up.addCompletion { [weak self] _ in
            let down = UIViewPropertyAnimator(duration: 1.5, curve: .easeInOut) {
                self?.transform = .identity
            }
            down.addCompletion { [weak self] _ in
                self?.startBobbing()
            }
            down.startAnimation()
        }
        up.startAnimation()
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        if window != nil {
            startBobbing()
        }
    }
}

/// Wraps BobbingUIView via UIViewRepresentable. The creature images are rendered
/// by SwiftUI and embedded inside this UIKit view so the UIViewPropertyAnimator
/// physically moves the creature content.
struct BobbingCreatureWrapper: UIViewRepresentable {
    let creature: Creature

    func makeUIView(context: Context) -> BobbingUIView {
        let bobbingView = BobbingUIView()
        bobbingView.backgroundColor = .clear
        bobbingView.clipsToBounds = false

        let content = CreatureContentView(creature: creature)
        let hostVC = UIHostingController(rootView: content)
        hostVC.view.backgroundColor = .clear
        hostVC.view.translatesAutoresizingMaskIntoConstraints = false
        bobbingView.addSubview(hostVC.view)

        NSLayoutConstraint.activate([
            hostVC.view.topAnchor.constraint(equalTo: bobbingView.topAnchor),
            hostVC.view.bottomAnchor.constraint(equalTo: bobbingView.bottomAnchor),
            hostVC.view.leadingAnchor.constraint(equalTo: bobbingView.leadingAnchor),
            hostVC.view.trailingAnchor.constraint(equalTo: bobbingView.trailingAnchor),
        ])

        bobbingView.hostingController = hostVC
        return bobbingView
    }

    func updateUIView(_ uiView: BobbingUIView, context: Context) {
        // Update the hosted SwiftUI content when creature changes
        if let hostVC = uiView.hostingController as? UIHostingController<CreatureContentView> {
            hostVC.rootView = CreatureContentView(creature: creature)
        }
    }
}

// MARK: - CreatureContentView (pure SwiftUI rendering, no animation)

/// The visual content of the creature — base image + overlays + color/scale/rotation.
/// Separated so it can be hosted inside the UIKit bobbing view.
private struct CreatureContentView: View {
    let creature: Creature

    var body: some View {
        Image("Creature")
            .resizable()
            .scaledToFit()
            .colorMultiply(creature.color)
            .overlay {
                ForEach(creature.overlays, id: \.self) { overlay in
                    Image(overlay)
                        .resizable()
                        .scaledToFill()
                }
            }
            .scaleEffect(creature.scale)
            .rotationEffect(.degrees(creature.rotation))
    }
}

// MARK: - CreatureView (public API)

struct CreatureView: View {
    let creature: Creature

    var body: some View {
        BobbingCreatureWrapper(creature: creature)
    }
}

#Preview {
    CreatureView(creature: Creature())
        .frame(width: 200, height: 200)
}

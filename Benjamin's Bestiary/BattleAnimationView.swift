//
//  BattleAnimationView.swift
//  Benjamin's Bestiary
//
//  Created by Juniper Rodriguez on 4/7/26.
//

import SwiftUI
import UIKit

/// A UIKit view that handles battle physics animation
/// Satisfies physics animation requirement with UIDynamicAnimator and UICollisionBehavior
class BattlePhysicsView: UIView {
    
    private var animator: UIDynamicAnimator!
    private var creatureView: UIImageView!
    private var bossView: UIImageView!
    private var collision: UICollisionBehavior!
    var onComplete: (() -> Void)?
    var shouldWin: Bool = true
    
    private var battleActive = false
    private var lastCollisionTime: TimeInterval = 0
    private let collisionSoundCooldown: TimeInterval = 0.3  // Minimum time between collision sounds
    
    init(creatureImage: UIImage?, bossImage: UIImage?) {
        super.init(frame: .zero)
        self.backgroundColor = .clear
        
        setupViews(creatureImage: creatureImage, bossImage: bossImage)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews(creatureImage: UIImage?, bossImage: UIImage?) {
        // Create creature view (left side, frozen initially)
        creatureView = UIImageView(image: creatureImage)
        creatureView.contentMode = .scaleAspectFit
        creatureView.frame = CGRect(x: 50, y: 0, width: 200, height: 200)
        addSubview(creatureView)
        
        // Create boss view (right side, frozen initially)
        bossView = UIImageView(image: bossImage)
        bossView.contentMode = .scaleAspectFit
        bossView.frame = CGRect(x: 600, y: 0, width: 350, height: 350)
        addSubview(bossView)
    }
    
    func startBattle() {
        guard !battleActive else { return }
        battleActive = true
        
        print("⚔️ Battle starting!")
        
        // Initialize animator with reference view (like the example)
        animator = UIDynamicAnimator(referenceView: self)
        
        // Setup collision behavior (like the example)
        collision = UICollisionBehavior(items: [creatureView, bossView])
        collision.collisionMode = .everything
        collision.translatesReferenceBoundsIntoBoundary = true // Bounce off edges
        
        // Continuously check for collisions and play sound with proper timing
        collision.action = { [weak self] in
            guard let self = self else { return }
            
            // Check if frames are intersecting
            if self.creatureView.frame.intersects(self.bossView.frame) {
                let currentTime = CACurrentMediaTime()
                
                // Only play sound if enough time has passed since last collision
                if currentTime - self.lastCollisionTime > self.collisionSoundCooldown {
                    print("💥 Collision detected!")
                    SoundManager.shared.playSoundEffect(named: "CreatureFight", withExtension: "mp3")
                    self.lastCollisionTime = currentTime
                }
            }
        }
        
        // Add collision behavior to animator (like the example)
        animator?.addBehavior(collision)
        
        // Add gravity to make movement more dynamic (inspired by example)
        let gravity = UIGravityBehavior(items: [creatureView, bossView])
        gravity.gravityDirection = CGVector(dx: 0, dy: 0.3) // Slight downward pull
        animator?.addBehavior(gravity)
        
        // MUCH FASTER push towards each other with instantaneous mode
        let creaturePush = UIPushBehavior(items: [creatureView], mode: .instantaneous)
        creaturePush.magnitude = 20.0 // Even faster!
        creaturePush.angle = 0 // Push right
        animator?.addBehavior(creaturePush)
        
        let bossPush = UIPushBehavior(items: [bossView], mode: .instantaneous)
        bossPush.magnitude = 20.0 // Even faster!
        bossPush.angle = .pi // Push left
        animator?.addBehavior(bossPush)
        
        // Setup item behavior for physics properties (like the example)
        let itemBehavior = UIDynamicItemBehavior(items: [creatureView, bossView])
        itemBehavior.elasticity = 0.95 // Super bouncy
        itemBehavior.resistance = 0.02 // Very low resistance for maximum speed
        itemBehavior.friction = 0.1 // Low friction for sliding movement
        itemBehavior.allowsRotation = false // Keep upright
        animator?.addBehavior(itemBehavior)
        
        // End after 6 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) { [weak self] in
            self?.endBattle()
        }
    }
    
    private func endBattle() {
        print("⚔️ Battle ending!")
        animator?.removeAllBehaviors()
        
        // Call completion immediately for smooth page transition
        onComplete?()
    }
}

/// SwiftUI wrapper
struct BattlePhysicsViewWrapper: UIViewRepresentable {
    let creatureImage: UIImage?
    let bossImage: UIImage?
    let shouldWin: Bool
    let startBattle: Bool
    let onComplete: () -> Void
    
    func makeUIView(context: Context) -> BattlePhysicsView {
        let view = BattlePhysicsView(creatureImage: creatureImage, bossImage: bossImage)
        view.shouldWin = shouldWin
        view.onComplete = onComplete
        return view
    }
    
    func updateUIView(_ uiView: BattlePhysicsView, context: Context) {
        if startBattle {
            uiView.startBattle()
        }
    }
}

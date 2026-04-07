//
//  SparkleScene.swift
//  Benjamin's Bestiary
//
//  Created by Juniper Rodriguez on 4/7/26.
//

import SpriteKit

/// SpriteKit scene that displays falling sparkles behind the bestiary
/// Satisfies assignment requirement for SpriteKit integration
class SparkleScene: SKScene {
    
    override func didMove(to view: SKView) {
        // Transparent background so it appears behind SwiftUI content
        backgroundColor = .clear
        
        // Start generating sparkles
        let generateSparkle = SKAction.run { [weak self] in
            self?.addSparkle()
        }
        let wait = SKAction.wait(forDuration: 0.3)
        let sequence = SKAction.sequence([generateSparkle, wait])
        run(SKAction.repeatForever(sequence))
    }
    
    /// Creates and animates a falling sparkle using emoji
    private func addSparkle() {
        // Create sparkle using emoji text
        let sparkleLabel = SKLabelNode(text: "✨")
        sparkleLabel.fontSize = CGFloat.random(in: 30...60)
        
        // Random starting position at top
        sparkleLabel.position = CGPoint(
            x: CGFloat.random(in: 50...size.width - 50),
            y: size.height + 20
        )
        
        // Random alpha for depth effect
        sparkleLabel.alpha = CGFloat.random(in: 0.5...1.0)
        
        // Add to scene
        addChild(sparkleLabel)
        
        // Animate falling
        let fallDuration = Double.random(in: 4.0...7.0)
        let moveDown = SKAction.moveBy(x: 0, y: -size.height - 100, duration: fallDuration)
        
        // Gentle rotation as it falls
        let rotate = SKAction.rotate(byAngle: .pi * 2, duration: fallDuration / 2)
        let repeatRotate = SKAction.repeatForever(rotate)
        
        // Fade out near bottom
        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
        let remove = SKAction.removeFromParent()
        
        let moveSequence = SKAction.sequence([moveDown, fadeOut, remove])
        let group = SKAction.group([moveSequence, repeatRotate])
        
        sparkleLabel.run(group)
    }
}

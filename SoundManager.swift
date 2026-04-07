//
//  SoundManager.swift
//  Benjamin's Bestiary
//
//  Created by Juniper Rodriguez on 4/5/26.
//

import AVFoundation
import UIKit

// MARK: - SoundManager Singleton

/// Manages all text-to-speech and sound effects for the app.
/// Uses AVSpeechSynthesizer for read-aloud and AVAudioPlayer for sound effects.
@MainActor
class SoundManager: NSObject, AVSpeechSynthesizerDelegate, AVAudioPlayerDelegate {

    static let shared = SoundManager()

    private let synthesizer = AVSpeechSynthesizer()
    private var audioPlayers: [AVAudioPlayer] = []  // Support multiple concurrent sounds
    private var lastSoundEffectTime: [String: TimeInterval] = [:]  // Track last play time per sound
    private let soundEffectCooldown: TimeInterval = 0.2  // Minimum time between same sound

    /// Callback fired as each word range is spoken — used for word highlighting
    var onWordSpoken: ((NSRange) -> Void)?

    /// The full text currently being spoken
    private(set) var currentText: String = ""

    /// Whether speech is currently in progress
    private(set) var isSpeaking: Bool = false

    private override init() {
        super.init()
        synthesizer.delegate = self
        configureAudioSession()
    }
    
    /// Configure the audio session for speech synthesis
    private func configureAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            // Configure for playback with speech, allow mixing for sound effects
            try audioSession.setCategory(.playback, mode: .spokenAudio, options: [.mixWithOthers])
            try audioSession.setActive(true, options: [.notifyOthersOnDeactivation])
            print("✅ Audio session configured for speech synthesis")
        } catch {
            print("❌ Failed to configure audio session: \(error)")
        }
    }

    // MARK: - Text-to-Speech

    /// Speak the given text aloud, calling `onWordSpoken` for each word range.
    func speak(_ text: String) {
        print("🎤 SoundManager.speak() called with text length: \(text.count)")
        
        // Save the current callback if it exists (it was just set by the caller)
        let callback = onWordSpoken
        
        // Stop any previous speech immediately
        if synthesizer.isSpeaking {
            print("   ⏹️ Stopping previous speech...")
            synthesizer.stopSpeaking(at: .immediate)
        }
        
        // Reset state
        currentText = text
        isSpeaking = true
        
        // Restore the callback after stopping
        onWordSpoken = callback
        
        // Small delay to ensure clean audio buffer reset
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            guard let self = self else { return }
            
            // Double-check we still want to speak (not cancelled in the meantime)
            guard self.isSpeaking else {
                print("   ❌ Speech was cancelled, aborting")
                return
            }
            
            // Ensure audio session is still active (but don't reconfigure)
            do {
                try AVAudioSession.sharedInstance().setActive(true, options: [])
            } catch {
                print("❌ Failed to reactivate audio session: \(error)")
                return
            }
            
            let voice = AVSpeechSynthesisVoice(language: "en-US")
            let utterance = AVSpeechUtterance(string: text)
            utterance.voice = voice
            utterance.pitchMultiplier = 1.0
            utterance.rate = 0.5
            utterance.preUtteranceDelay = 0.1
            utterance.postUtteranceDelay = 0.1
            
            print("   ▶️ Starting speech synthesis...")
            print("   📌 Callback registered: \(self.onWordSpoken != nil)")
            self.synthesizer.speak(utterance)
        }
    }

    /// Stop any ongoing speech.
    func stop() {
        print("⏹️ SoundManager.stop() called (isSpeaking: \(synthesizer.isSpeaking))")
        
        // Clear callback FIRST to prevent any further updates
        onWordSpoken = nil
        
        // Only try to stop if actually speaking
        if synthesizer.isSpeaking {
            print("   Stopping synthesizer...")
            // Use immediate stop to prevent buffer issues during rapid transitions
            synthesizer.stopSpeaking(at: .immediate)
        }
        
        isSpeaking = false
        currentText = ""
    }

    // MARK: - AVSpeechSynthesizerDelegate
    
    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer,
                           didStart utterance: AVSpeechUtterance) {
        Task { @MainActor in
            isSpeaking = true
        }
    }
    
    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer,
                           willSpeakRangeOfSpeechString characterRange: NSRange,
                           utterance: AVSpeechUtterance) {
        Task { @MainActor in
            guard onWordSpoken != nil else { return }
            onWordSpoken?(characterRange)
        }
    }

    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer,
                           didFinish utterance: AVSpeechUtterance) {
        Task { @MainActor in
            isSpeaking = false
            onWordSpoken?(NSRange(location: 0, length: 0))
        }
    }
    
    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer,
                           didCancel utterance: AVSpeechUtterance) {
        Task { @MainActor in
            isSpeaking = false
        }
    }

    // MARK: - Sound Effects (AVAudioPlayer)

    /// Play a sound effect from a bundled audio file.
    /// Supports concurrent sound effects and prevents spamming the same sound too frequently.
    func playSoundEffect(named filename: String, withExtension ext: String = "mp3") {
        let soundKey = "\(filename).\(ext)"
        
        // Check if this sound was played too recently
        let currentTime = CACurrentMediaTime()
        if let lastTime = lastSoundEffectTime[soundKey],
           currentTime - lastTime < soundEffectCooldown {
            print("⏸️ SoundManager: Skipping '\(soundKey)' - too soon (cooldown: \(soundEffectCooldown)s)")
            return
        }
        
        guard let url = Bundle.main.url(forResource: filename, withExtension: ext) else {
            print("❌ SoundManager: audio file '\(soundKey)' not found")
            return
        }
        
        do {
            // Create a new audio player for this sound effect
            let player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()  // Preload audio buffer
            
            // Set delegate to clean up when done
            player.delegate = self
            
            // Check if audio is ready before playing
            if player.play() {
                audioPlayers.append(player)  // Keep reference to prevent deallocation
                lastSoundEffectTime[soundKey] = currentTime
                print("🔊 Playing sound effect: \(soundKey) (concurrent: \(audioPlayers.count))")
            } else {
                print("⚠️ SoundManager: could not start playing \(soundKey)")
            }
        } catch {
            print("❌ SoundManager: failed to play \(soundKey) — \(error)")
        }
    }
    
    // MARK: - AVAudioPlayerDelegate
    
    /// Called when an audio player finishes playing
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        // Remove finished player from array to free memory
        audioPlayers.removeAll { $0 === player }
        print("🎵 Sound effect finished. Remaining: \(audioPlayers.count)")
    }
    
    /// Called if audio player encounters an error
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        audioPlayers.removeAll { $0 === player }
        if let error = error {
            print("❌ Audio player decode error: \(error.localizedDescription)")
        }
    }
}

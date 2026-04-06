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
class SoundManager: NSObject, AVSpeechSynthesizerDelegate, @unchecked Sendable {

    static let shared = SoundManager()

    private let synthesizer = AVSpeechSynthesizer()
    private var audioPlayer: AVAudioPlayer?

    /// Callback fired as each word range is spoken — used for word highlighting
    var onWordSpoken: ((NSRange) -> Void)?

    /// The full text currently being spoken
    private(set) var currentText: String = ""

    /// Whether speech is currently in progress
    private(set) var isSpeaking: Bool = false

    private override init() {
        super.init()
        synthesizer.delegate = self
    }

    // MARK: - Text-to-Speech

    /// Speak the given text aloud, calling `onWordSpoken` for each word range.
    func speak(_ text: String) {
        stop()
        currentText = text
        isSpeaking = true

        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate * 0.85
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(utterance)
    }

    /// Stop any ongoing speech.
    func stop() {
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
        isSpeaking = false
        onWordSpoken = nil
    }

    // MARK: - AVSpeechSynthesizerDelegate

    /// Called as each word is about to be spoken — provides the character range for highlighting.
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer,
                           willSpeakRangeOfSpeechString characterRange: NSRange,
                           utterance: AVSpeechUtterance) {
        onWordSpoken?(characterRange)
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer,
                           didFinish utterance: AVSpeechUtterance) {
        isSpeaking = false
        // Clear highlight when done
        onWordSpoken?(NSRange(location: 0, length: 0))
    }

    // MARK: - Sound Effects (AVAudioPlayer)

    /// Play a sound effect from a bundled audio file.
    func playSoundEffect(named filename: String, withExtension ext: String = "mp3") {
        guard let url = Bundle.main.url(forResource: filename, withExtension: ext) else {
            print("SoundManager: audio file '\(filename).\(ext)' not found")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("SoundManager: failed to play \(filename).\(ext) — \(error)")
        }
    }
}

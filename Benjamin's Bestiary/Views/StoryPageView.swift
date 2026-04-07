//
//  StoryPageView.swift
//  Benjamin's Bestiary
//
//  Created by Juniper Rodriguez on 3/30/26.
//

import SwiftUI

// MARK: - Story Page View
/// Displays a single page of the interactive story
/// Requirements satisfied:
/// - UIPageViewController integration via PageViewControllerWrapper
/// - Read to Me with word highlighting (TTS)
/// - UIGestureRecognizer for drag-and-drop food
/// - Sound effects via SoundManager singleton
struct StoryPageView: View {
    let page: StoryPage
    @Binding var creature: Creature
    var onChoose: ((Choice, Bool) -> Void)? = nil
    var onHome: (() -> Void)? = nil
    var onNameCreature: ((String) -> Void)? = nil
    var selectedChoiceDestination: String? = nil
    
    @State private var creatureName: String = ""
    @State private var highlightedRange: NSRange = NSRange(location: 0, length: 0)
    @State private var creatureFrame: CGRect = .zero
    @State private var showBattleAnimation: Bool = false
    @State private var pendingBattleChoice: Choice?
    @AppStorage("kAutoplayPreference") private var autoPlay = false
    @AppStorage("kTapToPlayPreference") private var tapToPlay = false

    private var hasFoodPictures: Bool {
        page.choices.contains { $0.picture != nil && !$0.picture!.isEmpty }
    }
    
    var body: some View {
        ZStack {
            page.background
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                // MARK: - Home + Read Aloud + Progress bar
                HStack {
                    Button(action: { onHome?() }) {
                        Image(systemName: "house.fill")
                    }
                    .font(.system(size: 32))
                    .accessibilityLabel("Home")
                    .padding()

                    if tapToPlay {
                        Button(action: { speakPageText() }) {
                            Image(systemName: "speaker.wave.2.fill")
                        }
                        .font(.system(size: 28))
                        .accessibilityLabel("Read Aloud")
                    }

                   Spacer()

                   ProgressView(value: Double(page.pageNum),
                                total: 6)
                }.padding()
                Spacer()

                // MARK: - Characters
                
                HStack(spacing: 24) {
                    // Requirement: UIDynamics - Battle physics animation
                    if page.id.contains("encounter"), let characterImage = page.characterImage {
                        BattlePhysicsViewWrapper(
                            creatureImage: UIImage(named: "Creature"),
                            bossImage: UIImage(named: characterImage),
                            shouldWin: pendingBattleChoice?.destinationID != "death",
                            startBattle: showBattleAnimation,
                            onComplete: {
                                if let choice = pendingBattleChoice {
                                    showBattleAnimation = false
                                    onChoose?(choice, false)
                                    pendingBattleChoice = nil
                                }
                            }
                        )
                        .frame(height: 350)
                    } else {
                        if let characterImage = page.characterImage {
                            Image(characterImage)
                                .resizable()
                                .scaledToFit()
                                .frame(height: page.creatureVisible ? 200 : 350)
                        }

                        if page.creatureVisible {
                            Color.clear
                                .frame(width: 200, height: 200)
                                .overlay {
                                    CreatureView(creature: creature)
                                }
                                .overlay {
                                    GeometryReader { geo in
                                        Color.clear
                                            .onAppear {
                                                creatureFrame = geo.frame(in: .global)
                                            }
                                            .onChange(of: geo.frame(in: .global)) {
                                                creatureFrame = geo.frame(in: .global)
                                            }
                                    }
                                }
                        }
                    }
                }

                // MARK: - Story Text and Choices
                
                Spacer()
                VStack {
                    // Requirement: Word highlighting synchronized with TTS
                    highlightedText
                        .font(.custom("InknutAntiqua-medium", size: 24))
                        .multilineTextAlignment(.center)

                    // Requirement: UIGestureRecognizer - Draggable food items
                    if hasFoodPictures && onChoose != nil {
                        HStack(spacing: 20) {
                            ForEach(Array(page.choices.enumerated()), id: \.offset) { _, choice in
                                if let picture = choice.picture, !picture.isEmpty {
                                    VStack(spacing: 2) {
                                        DraggableFoodView(
                                            imageName: picture,
                                            creatureCenter: CGPoint(
                                                x: creatureFrame.midX,
                                                y: creatureFrame.midY
                                            ),
                                            onDropped: {
                                                if let mutation = choice.creatureMutation {
                                                    var updated = creature
                                                    updated.apply(mutation)
                                                    creature = updated
                                                }
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                                    onChoose?(choice, true)
                                                }
                                            }
                                        )
                                        .frame(width: 128, height: 128)

                                        Text(choice.label)
                                            .font(.custom("InknutAntiqua-medium", size: 11))
                                    }
                                }
                            }
                        }
                        .padding(.top, 4)
                    }
                    
                    if !page.choices.isEmpty && !hasFoodPictures {
                        HStack(spacing: 16) {
                            ForEach(Array(page.choices.enumerated()), id: \.offset) { _, choice in
                                Button(choice.label) {
                                    if page.id.contains("encounter") {
                                        pendingBattleChoice = choice
                                        showBattleAnimation = true
                                    } else {
                                        onChoose?(choice, false)
                                    }
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(selectedChoiceDestination == choice.destinationID ? .green : Color("ButtonColor").opacity(0.75))
                                .opacity(selectedChoiceDestination != nil && selectedChoiceDestination != choice.destinationID ? 0.5 : 1.0)
                                .allowsHitTesting(onChoose != nil)
                            }
                        }
                    }
                    
                    if page.showNameField {
                        HStack(spacing: 12) {
                            TextField("Enter a name...", text: $creatureName)
                                .font(.custom("InknutAntiqua-medium", size: 20))
                                .textFieldStyle(.roundedBorder)
                            
                            Button("Done") {
                                let name = creatureName.trimmingCharacters(in: .whitespaces)
                                if !name.isEmpty {
                                    onNameCreature?(name)
                                }
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(Color("ButtonColor").opacity(0.75))
                            .font(.custom("InknutAntiqua-semibold", size: 20))
                            .disabled(creatureName.trimmingCharacters(in: .whitespaces).isEmpty)
                        }
                        .padding(.top, 8)
                    }
                }
                .padding(24)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.ultraThinMaterial)
                )
                .shadow(color: .black.opacity(0.25), radius: 12, x: 0, y: 4)
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
            .padding()
        }
        .foregroundStyle(Color("TextColor").opacity(0.75))
        .onAppear {
            // Requirement: Sound effects via singleton
            if page.id == "death" {
                SoundManager.shared.playSoundEffect(named: "Whale Death", withExtension: "mp3")
            }
            
            // Requirement: Auto-play honors user preference
            if autoPlay {
                speakPageText()
            }
        }
        .onDisappear {
            highlightedRange = NSRange(location: 0, length: 0)
            SoundManager.shared.stop()
        }
    }

    // MARK: - Text-to-Speech
    
    /// Requirement: Read to Me - TTS with word highlighting
    private func speakPageText() {
        SoundManager.shared.onWordSpoken = { [self] range in
            self.highlightedRange = range
        }
        SoundManager.shared.speak(page.text)
    }

    /// Requirement: Word highlighting synchronized via AVSpeechSynthesizerDelegate
    private var highlightedText: Text {
        let fullText = page.text
        
        guard highlightedRange.length > 0,
              let swiftRange = Range(highlightedRange, in: fullText) else {
            return Text(fullText)
        }

        var attributed = AttributedString(fullText)
        if let attrRange = Range(highlightedRange, in: attributed) {
            attributed[attrRange].foregroundColor = .yellow
            attributed[attrRange].font = .custom("InknutAntiqua-bold", size: 28)
        }
        return Text(attributed)
    }
}

#Preview {
    @Previewable @State var creature = Creature()
    StoryPageView(
        page: StoryPage(
            id: "preview",
            pageNum: 1,
            text: "Benjamin has encountered a strange creature in the forest.",
            choices: [],
            background: Image("Background")
        ),
        creature: $creature
    )
}

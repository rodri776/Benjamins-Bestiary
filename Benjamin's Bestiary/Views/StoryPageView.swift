//
//  StoryPageView.swift
//  Benjamin's Bestiary
//
//  Created by Juniper Rodriguez on 3/30/26.
//
import SwiftUI

struct StoryPageView: View {
    let page: StoryPage
    @Binding var creature: Creature
    var onChoose: ((Choice) -> Void)? = nil
    var onHome: (() -> Void)? = nil
    var onNameCreature: ((String) -> Void)? = nil
    var selectedChoiceDestination: String? = nil
    
    @State private var creatureName: String = ""
    @State private var highlightedRange: NSRange = NSRange(location: 0, length: 0)
    @AppStorage("kAutoplayPreference") private var autoPlay = false
    @AppStorage("kTapToPlayPreference") private var tapToPlay = false
    
    var body: some View {
        ZStack {
            page.background
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                // MARK: Home + Read Aloud + Progress bar
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

                // MARK: The Creature
                if page.creatureVisible {
                  CreatureView(creature: creature)
                      .frame(width: 200, height: 200)
                }
                
                // MARK: Story w/ Choices
                Spacer()
                VStack{
                    // MARK: Highlighted story text
                    highlightedText
                        .font(.custom("InknutAntiqua-medium", size: 24))
                        .multilineTextAlignment(.center)
                    
                    // displays choices for each page
                    if !page.choices.isEmpty {
                        HStack(spacing: 16) {
                            ForEach(Array(page.choices.enumerated()), id: \.offset) { _, choice in
                                
                                // button rendering accounts for choice history
                                Button(choice.label) {
                                    onChoose?(choice)
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(selectedChoiceDestination == choice.destinationID ? .green : nil)
                                .opacity(selectedChoiceDestination != nil && selectedChoiceDestination != choice.destinationID ? 0.5 : 1.0)
                                .allowsHitTesting(onChoose != nil) // disable touch on pre-selected options
                                
                                if let picture = choice.picture, !picture.isEmpty {
                                    Image(picture)
                                    }
                            }
                        }
                    }
                    
                    // MARK: Naming text field
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
                            .font(.custom("InknutAntiqua-semibold", size: 20))
                            .disabled(creatureName.trimmingCharacters(in: .whitespaces).isEmpty)
                        }
                        .padding(.top, 8)
                    }
                }.padding(24)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: .black.opacity(0.25), radius: 12, x: 0, y: 4)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)
            }.padding()
        }
        .foregroundStyle(Color("TextColor").opacity(0.75))
        .onAppear {
            if autoPlay {
                speakPageText()
            }
        }
        .onDisappear {
            SoundManager.shared.stop()
        }
    }

    // MARK: - Read Aloud

    private func speakPageText() {
        SoundManager.shared.onWordSpoken = { range in
            highlightedRange = range
        }
        SoundManager.shared.speak(page.text)
    }

    // MARK: - Word Highlighting via NSAttributedString

    /// Builds an AttributedString with the currently-spoken word highlighted.
    private var highlightedText: Text {
        let fullText = page.text
        guard highlightedRange.length > 0,
              Range(highlightedRange, in: fullText) != nil else {
            return Text(fullText)
        }

        var attributed = AttributedString(fullText)
        if let attrRange = Range(highlightedRange, in: attributed) {
            attributed[attrRange].foregroundColor = .yellow
            attributed[attrRange].font = .custom("InknutAntiqua-bold", size: 24)
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

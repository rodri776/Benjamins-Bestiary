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
    
    var body: some View {
        ZStack {
            Image("Background")
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                // MARK: Home + Progress bar
                HStack {
                    Button(action: { onHome?() }) {
                        Image(systemName: "house.fill")
                    }
                    .font(.system(size: 32))
                    .accessibilityLabel("Home")
                    .padding()

                   Spacer()

                   ProgressView(value: Double(page.pageNum),
                                total: 7)
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
                    Text(page.text)
                        .font(.custom("InknutAntiqua-medium", size: 24))
                        .multilineTextAlignment(.center)
                    
                    // displays choices for each page
                    if !page.choices.isEmpty {
                        HStack(spacing: 16) {
                            ForEach(Array(page.choices.enumerated()), id: \.offset) { _, choice in
                                Button(choice.label) {
                                    onChoose?(choice)
                                }
                                .buttonStyle(.borderedProminent)
                                
                                if let picture = choice.picture, !picture.isEmpty {
                                    Image(picture)
                                    }
                            }
                        }
                    }
                }.padding(24)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: .black.opacity(0.25), radius: 12, x: 0, y: 4)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)
            }.padding()
        }
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

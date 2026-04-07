//
//  BeastView.swift
//  Benjamin's Bestiary
//
//  Created by Juniper Rodriguez on 3/31/26.
//
import SwiftUI
import SpriteKit

struct BeastView: View {
    @State private var savedCreatures: [SavedCreature] = []
    @State private var isLoading = false
    
    var body: some View {
        ZStack {
            // Background image
            Image("Background")
                .resizable()
                .ignoresSafeArea()
            
            // SpriteKit sparkles with transparent background
            GeometryReader { geometry in
                SpriteView(scene: createSparkleScene(size: geometry.size), options: [.allowsTransparency])
                    .ignoresSafeArea()
                    .allowsHitTesting(false) // Allow taps to pass through
                    .background(Color.clear) // Ensure transparent
            }
            
            VStack {
                if isLoading {
                    Spacer()
                    ProgressView("Loading from iCloud...")
                        .font(.custom("InknutAntiqua-medium", size: 20))
                        .tint(.white)
                    Spacer()
                } else if savedCreatures.isEmpty {
                    Spacer()
                    VStack(spacing: 20) {
                        Image(systemName: "cloud")
                            .font(.system(size: 64))
                            .opacity(0.5)
                        
                        Text("Your creatures will be shown here.")
                            .multilineTextAlignment(.center)
                            .font(.custom("InknutAntiqua-medium", size: 32))
                            .opacity(0.5)
                        
                        Text("They sync across all your devices via iCloud!")
                            .multilineTextAlignment(.center)
                            .font(.custom("InknutAntiqua-regular", size: 18))
                            .opacity(0.5)
                        
                        Button("Refresh") {
                            loadCreatures()
                        }
                        .buttonStyle(.borderedProminent)
                        .font(.custom("InknutAntiqua-semibold", size: 20))
                    }
                    .padding()
                    Spacer()
                } else {
                    ScrollView {
                        LazyVGrid(columns: [
                            GridItem(.adaptive(minimum: 200), spacing: 20)
                        ], spacing: 20) {
                            ForEach(savedCreatures) { savedCreature in
                                CreatureCard(savedCreature: savedCreature) {
                                    deleteCreature(savedCreature)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
        }
        .foregroundStyle(Color("TextColor").opacity(0.75))
        .onAppear {
            print("🐾 BeastView appeared - loading creatures...")
            loadCreatures()
        }
        .refreshable {
            loadCreatures()
        }
    }
    
    /// Creates the SpriteKit scene for falling sparkles
    private func createSparkleScene(size: CGSize) -> SKScene {
        let scene = SparkleScene()
        scene.size = size
        scene.scaleMode = .resizeFill
        return scene
    }
    
    private func loadCreatures() {
        isLoading = true
        
        // Load from CloudKit with fallback to local
        BestiaryManager.shared.loadAllCreatures { creatures in
            self.savedCreatures = creatures
            self.isLoading = false
            
            print("📚 Loaded \(creatures.count) creatures from bestiary (CloudKit + local)")
            for creature in creatures {
                print("   - \(creature.name): overlays=\(creature.overlays)")
            }
        }
    }
    
    private func deleteCreature(_ creature: SavedCreature) {
        print("🗑️ Deleting creature '\(creature.name)'...")
        
        // Optimistically remove from UI
        savedCreatures.removeAll { $0.id == creature.id }
        
        // Delete from storage
        BestiaryManager.shared.deleteCreature(creature) { success in
            if success {
                print("✅ Creature deleted successfully")
            } else {
                print("⚠️ Creature deleted locally but CloudKit sync may have failed")
            }
        }
    }
}

struct CreatureCard: View {
    let savedCreature: SavedCreature
    var onDelete: (() -> Void)? = nil
    
    @State private var showingDeleteAlert = false
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            VStack(spacing: 12) {
                // Creature preview
                CreatureView(creature: savedCreature.toCreature())
                    .frame(width: 150, height: 150)
                
                // Creature name
                Text(savedCreature.name)
                    .font(.custom("InknutAntiqua-bold", size: 20))
                
                // Date saved
                Text(savedCreature.dateSaved, style: .date)
                    .font(.custom("InknutAntiqua-medium", size: 12))
                    .opacity(0.7)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
            )
            .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
            
            // X button in bottom-left corner
            if onDelete != nil {
                Button(role: .destructive) {
                    showingDeleteAlert = true
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(.white, .gray)
                }
                .padding(8)
            }
        }
        .alert("Delete \(savedCreature.name)?", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                onDelete?()
            }
        } message: {
            Text("This creature will be removed from all your devices.")
        }
    }
}

#Preview {
    BeastView()
}

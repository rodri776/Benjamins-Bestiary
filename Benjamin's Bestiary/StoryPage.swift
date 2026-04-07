//
//  StoryPage.swift
//  Benjamin's Bestiary
//
//  Created by Juniper Rodriguez on 3/30/26.
//
import SwiftUI
import CloudKit

struct StoryPage {
    let id: String
    let pageNum: Int
    let text: String
    let choices: [Choice]
    let background: Image
    var creatureVisible: Bool = true
    var showNameField: Bool = false
    var characterImage: String? = nil  // e.g. "Benjamin", "SeaMobyDick"
}

struct Choice {
    let label: String
    let picture: String?
    let destinationID: String
    let creatureMutation: CreatureMutation?
    var action: () -> Void = {}
}

struct CreatureMutation {
    var color: Color? = nil
    var scale: Double? = nil
    var overlays: [String]? = nil   // image asset names to layer on top (e.g. "Beak", "Glow")
}

struct Creature {
    var name: String = ""
    var color: Color = .white
    var scale: Double = 1.0
    var rotation: Double = 0.0
    var overlays: [String] = []     // e.g. ["Beak", "Wings"]

    mutating func apply(_ mutation: CreatureMutation) {
        print("🔧 Applying mutation - color: \(mutation.color?.description ?? "none"), scale: \(mutation.scale?.description ?? "none"), overlays: \(mutation.overlays?.description ?? "none")")
        if let color = mutation.color { self.color = color }
        if let scale = mutation.scale { self.scale = scale }
        if let newOverlays = mutation.overlays { 
            print("   Adding overlays: \(newOverlays) to existing: \(self.overlays)")
            // Only add overlays that don't already exist (prevent duplicates)
            for overlay in newOverlays {
                if !self.overlays.contains(overlay) {
                    self.overlays.append(overlay)
                } else {
                    print("   ⚠️ Skipping duplicate overlay: \(overlay)")
                }
            }
            print("   Result: \(self.overlays)")
        }
    }
}


// MARK: - Bestiary Storage with CloudKit

import CloudKit

/// Manages saving and loading creatures to/from the bestiary using CloudKit
/// "One More Thing" requirement: Uses CloudKit framework for iCloud syncing
class BestiaryManager {
    static let shared = BestiaryManager()
    
    private let container: CKContainer
    private let database: CKDatabase
    private let kLocalBestiaryKey = "kSavedCreatures"  // Fallback local storage
    
    private init() {
        // Initialize CloudKit container
        container = CKContainer.default()
        database = container.publicCloudDatabase  // Using public database for simplicity
        
        print("☁️ BestiaryManager initialized with CloudKit")
        print("   Container: \(container.containerIdentifier ?? "unknown")")
    }
    
    // MARK: - Save Creature to CloudKit
    
    /// Save a creature to both CloudKit and local storage
    func saveCreature(_ creature: Creature) {
        print("💾 BestiaryManager.saveCreature() called")
        print("   Name: '\(creature.name)'")
        print("   Color: \(creature.color)")
        print("   Scale: \(creature.scale)")
        print("   Overlays: \(creature.overlays)")
        
        // Create a saved version
        let savedCreature = SavedCreature(
            name: creature.name,
            colorRGBA: creature.color.toRGBA(),
            scale: creature.scale,
            rotation: creature.rotation,
            overlays: creature.overlays,
            dateSaved: Date()
        )
        
        // Save locally first (immediate feedback)
        saveCreatureLocally(savedCreature)
        
        // Then sync to CloudKit (background)
        saveCreatureToCloudKit(savedCreature)
    }
    
    /// Save creature to CloudKit
    private func saveCreatureToCloudKit(_ creature: SavedCreature) {
        // Create a CloudKit record
        let record = CKRecord(recordType: "Creature")
        
        // Set fields
        record["name"] = creature.name as CKRecordValue
        record["red"] = creature.colorRGBA.red as CKRecordValue
        record["green"] = creature.colorRGBA.green as CKRecordValue
        record["blue"] = creature.colorRGBA.blue as CKRecordValue
        record["alpha"] = creature.colorRGBA.alpha as CKRecordValue
        record["scale"] = creature.scale as CKRecordValue
        record["rotation"] = creature.rotation as CKRecordValue
        record["overlays"] = creature.overlays as CKRecordValue
        record["dateSaved"] = creature.dateSaved as CKRecordValue
        record["creatureID"] = creature.id.uuidString as CKRecordValue
        
        // Save to CloudKit
        database.save(record) { savedRecord, error in
            if let error = error {
                print("❌ CloudKit save error: \(error.localizedDescription)")
            } else {
                print("☁️ Creature '\(creature.name)' saved to CloudKit!")
            }
        }
    }
    
    // MARK: - Load Creatures
    
    /// Load all creatures from both CloudKit and local storage
    /// Completion handler returns combined results
    func loadAllCreatures(completion: @escaping ([SavedCreature]) -> Void) {
        print("📚 BestiaryManager.loadAllCreatures() called")
        
        // Start with local creatures
        let localCreatures = loadCreaturesLocally()
        print("   Found \(localCreatures.count) local creatures")
        
        // Query CloudKit for creatures
        let query = CKQuery(recordType: "Creature", predicate: NSPredicate(value: true))
        query.sortDescriptors = [NSSortDescriptor(key: "dateSaved", ascending: false)]
        
        // Use the new fetch API instead of deprecated perform
        database.fetch(withQuery: query, inZoneWith: nil, desiredKeys: nil, resultsLimit: CKQueryOperation.maximumResults) { result in
            switch result {
            case .success(let queryResult):
                print("☁️ Found \(queryResult.matchResults.count) CloudKit creatures")
                
                // Convert CloudKit records to SavedCreatures
                var cloudCreatures: [SavedCreature] = []
                for (_, recordResult) in queryResult.matchResults {
                    switch recordResult {
                    case .success(let record):
                        if let creature = self.creatureFromRecord(record) {
                            cloudCreatures.append(creature)
                        }
                    case .failure(let error):
                        print("⚠️ Error fetching individual record: \(error.localizedDescription)")
                    }
                }
                
                // Merge local and cloud (remove duplicates by ID)
                var mergedCreatures = localCreatures
                for cloudCreature in cloudCreatures {
                    if !mergedCreatures.contains(where: { $0.id == cloudCreature.id }) {
                        mergedCreatures.append(cloudCreature)
                    }
                }
                
                // Sort by date
                mergedCreatures.sort { $0.dateSaved > $1.dateSaved }
                
                print("   Total merged: \(mergedCreatures.count) creatures")
                
                DispatchQueue.main.async {
                    completion(mergedCreatures)
                }
                
            case .failure(let error):
                print("❌ CloudKit query error: \(error.localizedDescription)")
                // Fall back to local only
                DispatchQueue.main.async {
                    completion(localCreatures)
                }
            }
        }
    }
    
    /// Synchronous version that only returns local creatures (for quick display)
    func loadAllCreatures() -> [SavedCreature] {
        return loadCreaturesLocally()
    }
    
    // MARK: - Local Storage (Fallback)
    
    private func saveCreatureLocally(_ creature: SavedCreature) {
        var creatures = loadCreaturesLocally()
        creatures.append(creature)
        
        if let encoded = try? JSONEncoder().encode(creatures) {
            UserDefaults.standard.set(encoded, forKey: kLocalBestiaryKey)
            print("   ✅ Creature '\(creature.name)' saved locally! Total: \(creatures.count)")
        } else {
            print("   ❌ Failed to encode creatures!")
        }
    }
    
    private func loadCreaturesLocally() -> [SavedCreature] {
        guard let data = UserDefaults.standard.data(forKey: kLocalBestiaryKey),
              let creatures = try? JSONDecoder().decode([SavedCreature].self, from: data) else {
            return []
        }
        return creatures
    }
    
    // MARK: - Helper Methods
    
    /// Convert CloudKit record to SavedCreature
    private func creatureFromRecord(_ record: CKRecord) -> SavedCreature? {
        guard let name = record["name"] as? String,
              let red = record["red"] as? Double,
              let green = record["green"] as? Double,
              let blue = record["blue"] as? Double,
              let alpha = record["alpha"] as? Double,
              let scale = record["scale"] as? Double,
              let rotation = record["rotation"] as? Double,
              let overlays = record["overlays"] as? [String],
              let dateSaved = record["dateSaved"] as? Date,
              let creatureIDString = record["creatureID"] as? String,
              let creatureID = UUID(uuidString: creatureIDString) else {
            print("⚠️ Failed to parse CloudKit record")
            return nil
        }
        
        let colorRGBA = RGBAColor(red: red, green: green, blue: blue, alpha: alpha)
        
        return SavedCreature(
            id: creatureID,
            name: name,
            colorRGBA: colorRGBA,
            scale: scale,
            rotation: rotation,
            overlays: overlays,
            dateSaved: dateSaved
        )
    }
    
    /// Clear all creatures from local storage (for testing)
    func clearBestiary() {
        UserDefaults.standard.removeObject(forKey: kLocalBestiaryKey)
        print("🗑️ Local bestiary cleared")
    }
    
    /// Delete a specific creature from both CloudKit and local storage
    func deleteCreature(_ creature: SavedCreature, completion: @escaping (Bool) -> Void) {
        print("🗑️ BestiaryManager.deleteCreature() called for '\(creature.name)'")
        
        // Delete from local storage first
        deleteCreatureLocally(creature)
        
        // Then delete from CloudKit
        deleteCreatureFromCloudKit(creature) { success in
            completion(success)
        }
    }
    
    /// Delete creature from CloudKit using new fetch API
    private func deleteCreatureFromCloudKit(_ creature: SavedCreature, completion: @escaping (Bool) -> Void) {
        // First, find the record in CloudKit by creatureID
        let predicate = NSPredicate(format: "creatureID == %@", creature.id.uuidString)
        let query = CKQuery(recordType: "Creature", predicate: predicate)
        
        // Use new fetch API
        database.fetch(withQuery: query, inZoneWith: nil, desiredKeys: nil, resultsLimit: 1) { result in
            switch result {
            case .success(let queryResult):
                // Get the first (and should be only) record
                guard let (_, recordResult) = queryResult.matchResults.first else {
                    print("⚠️ No CloudKit record found to delete")
                    DispatchQueue.main.async {
                        completion(false)
                    }
                    return
                }
                
                switch recordResult {
                case .success(let record):
                    // Delete the record
                    self.database.delete(withRecordID: record.recordID) { recordID, error in
                        if let error = error {
                            print("❌ CloudKit delete error: \(error.localizedDescription)")
                            DispatchQueue.main.async {
                                completion(false)
                            }
                        } else {
                            print("☁️ Creature '\(creature.name)' deleted from CloudKit!")
                            DispatchQueue.main.async {
                                completion(true)
                            }
                        }
                    }
                    
                case .failure(let error):
                    print("❌ Error fetching record to delete: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        completion(false)
                    }
                }
                
            case .failure(let error):
                print("❌ CloudKit query error while deleting: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
    }
    
    /// Delete creature from local storage
    private func deleteCreatureLocally(_ creature: SavedCreature) {
        var creatures = loadCreaturesLocally()
        creatures.removeAll { $0.id == creature.id }
        
        if let encoded = try? JSONEncoder().encode(creatures) {
            UserDefaults.standard.set(encoded, forKey: kLocalBestiaryKey)
            print("   ✅ Creature '\(creature.name)' deleted locally! Remaining: \(creatures.count)")
        } else {
            print("   ❌ Failed to encode creatures after deletion!")
        }
    }
    
    /// Sync all local creatures to CloudKit (useful for migration)
    func syncLocalToCloud() {
        let localCreatures = loadCreaturesLocally()
        print("🔄 Syncing \(localCreatures.count) local creatures to CloudKit...")
        
        for creature in localCreatures {
            saveCreatureToCloudKit(creature)
        }
    }
}

/// A saved creature that can be encoded/decoded and synced with CloudKit
struct SavedCreature: Codable, Identifiable {
    let id: UUID
    let name: String
    let colorRGBA: RGBAColor
    let scale: Double
    let rotation: Double
    let overlays: [String]
    let dateSaved: Date
    
    /// Initialize with auto-generated ID (for local saves)
    init(name: String, colorRGBA: RGBAColor, scale: Double, rotation: Double, overlays: [String], dateSaved: Date) {
        self.id = UUID()
        self.name = name
        self.colorRGBA = colorRGBA
        self.scale = scale
        self.rotation = rotation
        self.overlays = overlays
        self.dateSaved = dateSaved
    }
    
    /// Initialize with explicit ID (for CloudKit records)
    init(id: UUID, name: String, colorRGBA: RGBAColor, scale: Double, rotation: Double, overlays: [String], dateSaved: Date) {
        self.id = id
        self.name = name
        self.colorRGBA = colorRGBA
        self.scale = scale
        self.rotation = rotation
        self.overlays = overlays
        self.dateSaved = dateSaved
    }
    
    /// Convert back to a Creature for display
    func toCreature() -> Creature {
        var creature = Creature()
        creature.name = name
        creature.color = colorRGBA.toColor()
        creature.scale = scale
        creature.rotation = rotation
        creature.overlays = overlays
        return creature
    }
}

// MARK: - Color Encoding Helpers

/// Helper for encoding/decoding Color
struct RGBAColor: Codable {
    var red: Double
    var green: Double
    var blue: Double
    var alpha: Double
    
    func toColor() -> Color {
        Color(red: red, green: green, blue: blue, opacity: alpha)
    }
}

extension Color {
    func toRGBA() -> RGBAColor {
        #if canImport(UIKit)
        let uiColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return RGBAColor(red: Double(red), green: Double(green), blue: Double(blue), alpha: Double(alpha))
        #else
        let nsColor = NSColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        nsColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return RGBAColor(red: Double(red), green: Double(green), blue: Double(blue), alpha: Double(alpha))
        #endif
    }
}



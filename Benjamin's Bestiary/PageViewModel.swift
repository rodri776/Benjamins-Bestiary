//
//  PageViewModel.swift
//  Benjamin's Bestiary
//
//  Created by Juniper Rodriguez on 3/30/26.
//
import SwiftUI


@Observable
class PageViewModel {
    var currentPageID: String = "opening"
    var history: [String] = ["opening"]
    var creature: Creature = Creature()
    var pages: [String: StoryPage] = [:]
    var shouldDismiss: Bool = false
    
    func reset() {
        currentPageID = "opening"
        history = ["opening"]
        creature = Creature()
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "kBookmarkPageID")
        defaults.removeObject(forKey: "kBookmarkHistory")
        defaults.removeObject(forKey: "kBookmarkCreatureColor")
        defaults.removeObject(forKey: "kBookmarkCreatureScale")
        defaults.removeObject(forKey: "kBookmarkCreatureRotation")
        defaults.removeObject(forKey: "kBookmarkCreatureOverlays")
    }
    
    func choose(_ choice: Choice) {
        if choice.destinationID == "finish" {
            reset()
            shouldDismiss = true
            return
        }
        if choice.destinationID == "opening" {
            reset()
            return
        }
        if let mutation = choice.creatureMutation {
            creature.apply(mutation)
        }
        history.append(choice.destinationID)
        currentPageID = choice.destinationID
    }
    
    func nameCreature(_ name: String) {
        creature.name = name
        
        // Save creature to bestiary
        BestiaryManager.shared.saveCreature(creature)
        
        // Play sparkle sound effect when creature added to bestiary
        SoundManager.shared.playSoundEffect(named: "Sparkle", withExtension: "mp3")
        
        history.append("bestiary")
        currentPageID = "bestiary"
    }
    
    func saveBookmark() {
        // Don't save bookmarks for naming page or beyond
        guard currentPageID != "naming" && currentPageID != "bestiary" else {
            return
        }
        
        let defaults = UserDefaults.standard
        defaults.set(currentPageID, forKey: "kBookmarkPageID")
        defaults.set(history, forKey: "kBookmarkHistory")
        
        // Save creature state
        if let colorData = try? JSONEncoder().encode(creature.color.toRGBA()) {
            defaults.set(colorData, forKey: "kBookmarkCreatureColor")
        }
        defaults.set(creature.scale, forKey: "kBookmarkCreatureScale")
        defaults.set(creature.rotation, forKey: "kBookmarkCreatureRotation")
        defaults.set(creature.overlays, forKey: "kBookmarkCreatureOverlays")
    }

    func restoreBookmark() {
        let defaults = UserDefaults.standard
        if let savedPageID = defaults.string(forKey: "kBookmarkPageID"),
           let savedHistory = defaults.stringArray(forKey: "kBookmarkHistory") {
            currentPageID = savedPageID
            history = savedHistory
            
            // Restore creature state
            if let colorData = defaults.data(forKey: "kBookmarkCreatureColor"),
               let rgba = try? JSONDecoder().decode(RGBAColor.self, from: colorData) {
                creature.color = rgba.toColor()
            }
            creature.scale = defaults.double(forKey: "kBookmarkCreatureScale")
            if creature.scale == 0 { creature.scale = 1.0 } // default if not saved
            creature.rotation = defaults.double(forKey: "kBookmarkCreatureRotation")
            if let overlays = defaults.stringArray(forKey: "kBookmarkCreatureOverlays") {
                creature.overlays = overlays
            }
        }
    }
}


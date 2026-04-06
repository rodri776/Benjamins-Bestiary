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
        history.append("bestiary")
        currentPageID = "bestiary"
    }
    
    func saveBookmark() {
        let defaults = UserDefaults.standard
        defaults.set(currentPageID, forKey: "kBookmarkPageID")
        defaults.set(history, forKey: "kBookmarkHistory")
    }

    func restoreBookmark() {
        let defaults = UserDefaults.standard
        if let savedPageID = defaults.string(forKey: "kBookmarkPageID"),
           let savedHistory = defaults.stringArray(forKey: "kBookmarkHistory") {
            currentPageID = savedPageID
            history = savedHistory
        }
    }
}

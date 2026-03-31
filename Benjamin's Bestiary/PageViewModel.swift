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
    
    func choose(_ choice: Choice) {
        if let mutation = choice.creatureMutation {
            creature.apply(mutation)
        }
        history.append(choice.destinationID)
        currentPageID = choice.destinationID
    }
}

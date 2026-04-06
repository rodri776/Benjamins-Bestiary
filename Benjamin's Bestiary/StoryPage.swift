//
//  StoryPage.swift
//  Benjamin's Bestiary
//
//  Created by Juniper Rodriguez on 3/30/26.
//
import SwiftUI

struct StoryPage {
    let id: String
    let pageNum: Int
    let text: String
    let choices: [Choice]
    let background: Image
    var creatureVisible: Bool = true
    var showNameField: Bool = false
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
        if let color = mutation.color { self.color = color }
        if let scale = mutation.scale { self.scale = scale }
        if let overlays = mutation.overlays { self.overlays.append(contentsOf: overlays) }
    }
}


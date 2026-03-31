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
}

struct Choice {
    let label: String
    let picture: String?
    let destinationID: String
    let creatureMutation: CreatureMutation?
    var action: () -> Void = {}
}

struct CreatureMutation {
    /*
    // Page 2 (biome choice): establishes base palette
    var biomeBase: BiomeBase? = nil

    // Page 3/4 (food choice): potential mutations based on diet
    var colorModifier: ColorModifier? = nil
    var mouthShape: MouthShape? = nil
    var bodyShape: BodyShape? = nil
    
    // Page 5 (encounter outcome): additive, never replaced
    var extraTrait: ExtraTrait? = nil
    */
}

struct Creature {
    var name: String = ""
    var color: Color = .white
    var scale: Double = 1.0
    var rotation: Double = 0.0

    mutating func apply(_ mutation: CreatureMutation) {
        /*
        if let biomeBase = mutation.biomeBase { self.biomeBase = biomeBase }
        if let colorModifier = mutation.colorModifier { self.colorModifier = colorModifier }
        if let mouthShape = mutation.mouthShape { self.mouthShape = mouthShape }
        if let bodyShape = mutation.BodyShape { self.bodyShape = bodyShape }
        self.extraTrait = mutation.extraTrait
        */
    }
}


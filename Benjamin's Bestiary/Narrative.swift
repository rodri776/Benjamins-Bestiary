//
//  Narrative.swift
//  Benjamin's Bestiary
//
//  Created by Juniper Rodriguez on 3/31/26.
//

import SwiftUI

let storyPages: [String: StoryPage] = [

    // MARK: - Page 1 — Opening
    "opening": StoryPage(
        id: "opening",
        pageNum: 1,
        text: "Benjamin is the Beastkeeper of Andolonia, a world much like ours thousands of light years away.",
        choices: [Choice(label: "Greet Benjamin", picture: nil, destinationID: "biome_choice", creatureMutation: nil)],
        background: Image("Background1"),
        creatureVisible: false,
        characterImage: "Benjamin"
    ),

    // MARK: - Page 2 — Biome Choice
    "biome_choice": StoryPage(
        id: "biome_choice",
        pageNum: 2,
        text: "One day, while on one of his many explorations, he comes across a mysterious, adorable creature. He decides to take it with him on his journey. Which biome should they explore next?",
        choices: [
            Choice(label: "The Sea",           picture: nil, destinationID: "sea_food",     creatureMutation: nil),
            Choice(label: "The Flower Forest",  picture: nil, destinationID: "forest_food",  creatureMutation: nil),
            Choice(label: "The Unknown",        picture: nil, destinationID: "unknown_food", creatureMutation: nil)
        ],
        background: Image("Background2")
    ),

    // MARK: - Page 3A — Sea Food Choice
    "sea_food": StoryPage(
        id: "sea_food",
        pageNum: 3,
        text: "While exploring the Sea, Benjamin has gathered foods of 3 different kinds. Which of these should he feed to his companion?",
        choices: [
            Choice(label: "Seaweed",        picture: "FoodSeaSeaweed",    destinationID: "sea_encounter",  creatureMutation: CreatureMutation(color: .green)),
            Choice(label: "Invertebrates",  picture: "FoodSeaShellfish",  destinationID: "sea_encounter",  creatureMutation: CreatureMutation(color: .pink, overlays: ["SmallBeak"])),
            Choice(label: "Fish",           picture: "FoodSeaFish",       destinationID: "sea_encounter",  creatureMutation: CreatureMutation(overlays: ["Creature-Fish"]))
        ],
        background: Image("BackgroundSea")
    ),

    // MARK: - Page 3B — Flower Forest Food Choice
    "forest_food": StoryPage(
        id: "forest_food",
        pageNum: 3,
        text: "While exploring the Flower Forest, Benjamin has gathered foods of 3 different kinds. Which of these should he feed to his companion?",
        choices: [
            Choice(label: "Petals",      picture: "FoodFlowerPetals",  destinationID: "forest_encounter",  creatureMutation: CreatureMutation(color: .pink)),  // Only color, no overlay yet
            Choice(label: "Berries",     picture: "FoodFlowerBerries", destinationID: "forest_encounter",  creatureMutation: CreatureMutation(color: Color(red: 0.5, green: 0.0, blue: 0.8), scale: 3.0)),
            Choice(label: "Birds",       picture: "FoodFlowerBirds",   destinationID: "forest_encounter",  creatureMutation: CreatureMutation(overlays: ["VultureBeak"]))
        ],
        background: Image("BackgroundFlower")
    ),

    // MARK: - Page 3C — Unknown Food Choice
    "unknown_food": StoryPage(
        id: "unknown_food",
        pageNum: 3,
        text: "While exploring the Unknown, Benjamin has gathered foods of 3 different kinds. Which of these should he feed to his companion?",
        choices: [
            Choice(label: "Leaves", picture: "FoodUnknownLeaves", destinationID: "unknown_encounter",  creatureMutation: CreatureMutation(color: .gray)),
            Choice(label: "Fruit",  picture: "FoodUnknownFruit",  destinationID: "unknown_encounter",  creatureMutation: CreatureMutation(overlays: ["LargeBeak"])),
            Choice(label: "Void",   picture: "FoodUnknownVoid",   destinationID: "naming",  creatureMutation: CreatureMutation(overlays: ["FoodUnknownVoid"]))
        ],
        background: Image("BackgroundUnknown")
    ),

    // MARK: - Page 4 — Encounter (per biome)

    "sea_encounter": StoryPage(
        id: "sea_encounter",
        pageNum: 4,
        text: "While on the journey back home, Benjamin and his creature run into Moby Dick. Would you like to battle or hide?",
        choices: [
            Choice(label: "Battle", picture: nil, destinationID: "death",  creatureMutation: nil),
            Choice(label: "Hide",   picture: nil, destinationID: "naming", creatureMutation: nil)
        ],
        background: Image("BackgroundSea"),
        characterImage: "SeaMobyDick"
    ),

    "forest_encounter": StoryPage(
        id: "forest_encounter",
        pageNum: 4,
        text: "While on the journey back home, Benjamin and his creature run into an Exterminator. Would you like to battle or hide?",
        choices: [
            Choice(label: "Battle", picture: nil, destinationID: "naming", creatureMutation: CreatureMutation(overlays: ["SpikeOverlay"])),
            Choice(label: "Hide",   picture: nil, destinationID: "naming", creatureMutation: CreatureMutation(overlays: ["FlowerOverlay"]))  // FlowerOverlay when hiding!
        ],
        background: Image("BackgroundFlower"),
        characterImage: "FlowerExterminator"
    ),

    "unknown_encounter": StoryPage(
        id: "unknown_encounter",
        pageNum: 4,
        text: "While on the journey back home, Benjamin and his creature run into The Grand Soothsayer. Would you like to battle or hide?",
        choices: [
            Choice(label: "Battle", picture: nil, destinationID: "naming", creatureMutation: nil),
            Choice(label: "Hide",   picture: nil, destinationID: "naming", creatureMutation: CreatureMutation(overlays: ["PurpleGlow"]))  // Purple glow when hiding!
        ],
        background: Image("BackgroundUnknown"),
        characterImage: "UnknownSoothsayer"
    ),

    // MARK: - Death Outcome
    "death": StoryPage(
        id: "death",
        pageNum: 4,
        text: "Oh no! Benjamin and his creature didn't make it this time...",
        choices: [
            Choice(label: "Try Again", picture: nil, destinationID: "opening", creatureMutation: nil)
        ],
        background: Image("Background"),
        creatureVisible: false,
        characterImage: "Skull+Crossbones"
    ),

    // MARK: - Page 5 — Naming
    "naming": StoryPage(
        id: "naming",
        pageNum: 5,
        text: "Benjamin and his creature made it home safely! Now he finally has time to name it. What should its name be?",
        choices: [],
        background: Image("Background"),
        showNameField: true
    ),

    // MARK: - Page 6 — Bestiary Entry
    "bestiary": StoryPage(
        id: "bestiary",
        pageNum: 6,
        text: "Benjamin added his new companion to the bestiary!",
        choices: [
            Choice(label: "Finish", picture: nil, destinationID: "finish", creatureMutation: nil)
        ],
        background: Image("Background")
    )
]

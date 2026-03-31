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
        background: Image("Background"),
        creatureVisible: false
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
        background: Image("Background")
    ),

    // MARK: - Page 3A — Sea Food Choice
    // (Modifies Color, Mouth shape, and size/body-shape)
    "sea_food": StoryPage(
        id: "sea_food",
        pageNum: 3,
        text: "While exploring the Sea, Benjamin has gathered foods of 3 different kinds. Which of these should he feed to his companion?",
        choices: [
            Choice(label: "Seaweed",        picture: nil, destinationID: "sea_I",   creatureMutation: nil), // TODO: modifies color
            Choice(label: "Invertebrates",  picture: nil, destinationID: "sea_II",  creatureMutation: nil), // TODO: modifies mouth shape
            Choice(label: "Fish",           picture: nil, destinationID: "sea_III", creatureMutation: nil)  // TODO: modifies size/body-shape
        ],
        background: Image("Background")
    ),

    // MARK: - Page 3B — Flower Forest Food Choice
    "forest_food": StoryPage(
        id: "forest_food",
        pageNum: 3,
        text: "While exploring the Flower Forest, Benjamin has gathered foods of 3 different kinds. Which of these should he feed to his companion?",
        choices: [
            Choice(label: "Petals",      picture: nil, destinationID: "forest_I",   creatureMutation: nil), // TODO: modifies color
            Choice(label: "Random Bits",  picture: nil, destinationID: "forest_II",  creatureMutation: nil), // TODO: modifies mouth shape
            Choice(label: "Birds",        picture: nil, destinationID: "forest_III", creatureMutation: nil)  // TODO: modifies size/body-shape
        ],
        background: Image("Background")
    ),

    // MARK: - Page 3C — Unknown Food Choice
    "unknown_food": StoryPage(
        id: "unknown_food",
        pageNum: 3,
        text: "While exploring the Unknown, Benjamin has gathered foods of 3 different kinds. Which of these should he feed to his companion?",
        choices: [
            Choice(label: "Leaves", picture: nil, destinationID: "unknown_I",   creatureMutation: nil), // TODO: modifies color
            Choice(label: "Fruit",  picture: nil, destinationID: "unknown_II",  creatureMutation: nil), // TODO: modifies mouth shape
            Choice(label: "Meat",   picture: nil, destinationID: "unknown_III", creatureMutation: nil)  // TODO: modifies size/body-shape
        ],
        background: Image("Background")
    ),

    // MARK: - Page 4-I — Height choices (from food-type I: Seaweed / Petals / Leaves)
    // {modifies body shape (and color for Forest path)}

    "sea_I": StoryPage(
        id: "sea_I",
        pageNum: 4,
        text: "Which height should the creature eat from?",
        choices: [
            Choice(label: "The Ground", picture: nil, destinationID: "sea_encounter", creatureMutation: nil), // TODO: modifies body shape
            Choice(label: "The Bush",   picture: nil, destinationID: "sea_encounter", creatureMutation: nil), // TODO: modifies body shape
            Choice(label: "The Tree",   picture: nil, destinationID: "sea_encounter", creatureMutation: nil)  // TODO: modifies body shape
        ],
        background: Image("Background")
    ),

    "forest_I": StoryPage(
        id: "forest_I",
        pageNum: 4,
        text: "Which height should the creature eat from?",
        choices: [
            Choice(label: "The Ground", picture: nil, destinationID: "forest_encounter", creatureMutation: nil), // TODO: modifies body shape + color
            Choice(label: "The Bush",   picture: nil, destinationID: "forest_encounter", creatureMutation: nil), // TODO: modifies body shape + color
            Choice(label: "The Tree",   picture: nil, destinationID: "forest_encounter", creatureMutation: nil)  // TODO: modifies body shape + color
        ],
        background: Image("Background")
    ),

    "unknown_I": StoryPage(
        id: "unknown_I",
        pageNum: 4,
        text: "Which height should the creature eat from?",
        choices: [
            Choice(label: "The Ground", picture: nil, destinationID: "unknown_encounter", creatureMutation: nil), // TODO: modifies body shape
            Choice(label: "The Bush",   picture: nil, destinationID: "unknown_encounter", creatureMutation: nil), // TODO: modifies body shape
            Choice(label: "The Tree",   picture: nil, destinationID: "unknown_encounter", creatureMutation: nil)  // TODO: modifies body shape
        ],
        background: Image("Background")
    ),

    // MARK: - Page 4-II — Group choices (from food-type II: Invertebrates / Random Bits / Fruit)
    // {modifies mouth shape and body color}

    "sea_II": StoryPage(
        id: "sea_II",
        pageNum: 4,
        text: "Which group should the creature eat from?",
        choices: [
            Choice(label: "Crustaceans",  picture: nil, destinationID: "sea_encounter", creatureMutation: nil), // TODO: modifies mouth shape + body color
            Choice(label: "Mollusks",     picture: nil, destinationID: "sea_encounter", creatureMutation: nil), // TODO: modifies mouth shape + body color
            Choice(label: "Cephalopods",  picture: nil, destinationID: "sea_encounter", creatureMutation: nil)  // TODO: modifies mouth shape + body color
        ],
        background: Image("Background")
    ),

    "forest_II": StoryPage(
        id: "forest_II",
        pageNum: 4,
        text: "Which group should the creature eat from?",
        choices: [
            Choice(label: "Hard Seeds & Nuts", picture: nil, destinationID: "forest_encounter", creatureMutation: nil), // TODO: modifies mouth shape + body color
            Choice(label: "Insects",           picture: nil, destinationID: "forest_encounter", creatureMutation: nil), // TODO: modifies mouth shape + body color
            Choice(label: "Berries",           picture: nil, destinationID: "forest_encounter", creatureMutation: nil)  // TODO: modifies mouth shape + body color
        ],
        background: Image("Background")
    ),

    "unknown_II": StoryPage(
        id: "unknown_II",
        pageNum: 4,
        text: "Which group should the creature eat from?",
        choices: [
            Choice(label: "Pome",      picture: nil, destinationID: "unknown_encounter", creatureMutation: nil), // TODO: modifies mouth shape + body color
            Choice(label: "Pepo",      picture: nil, destinationID: "unknown_encounter", creatureMutation: nil), // TODO: modifies mouth shape + body color
            Choice(label: "Tropicale", picture: nil, destinationID: "unknown_encounter", creatureMutation: nil)  // TODO: modifies mouth shape + body color
        ],
        background: Image("Background")
    ),

    // MARK: - Page 4-III — Hunt choices (from food-type III: Fish / Birds / Meat)
    // {modifies mouth shape, body shape, and body color}

    "sea_III": StoryPage(
        id: "sea_III",
        pageNum: 4,
        text: "Which animal should the creature hunt?",
        choices: [
            Choice(label: "Guppies",   picture: nil, destinationID: "sea_encounter", creatureMutation: nil), // TODO: modifies mouth + body shape + color
            Choice(label: "Moby Dick", picture: nil, destinationID: "death",         creatureMutation: nil)  // DEATH OUTCOME
        ],
        background: Image("Background")
    ),

    "forest_III": StoryPage(
        id: "forest_III",
        pageNum: 4,
        text: "Which animal should the creature hunt?",
        choices: [
            Choice(label: "Flightless Bird",  picture: nil, destinationID: "forest_encounter", creatureMutation: nil), // TODO: modifies mouth + body shape + color
            Choice(label: "Bird of Prey",      picture: nil, destinationID: "forest_encounter", creatureMutation: nil), // TODO: modifies mouth + body shape + color
            Choice(label: "Bird of Paradise",  picture: nil, destinationID: "forest_encounter", creatureMutation: nil)  // TODO: modifies mouth + body shape + color
        ],
        background: Image("Background")
    ),

    "unknown_III": StoryPage(
        id: "unknown_III",
        pageNum: 4,
        text: "Which animal should the creature hunt?",
        choices: [
            Choice(label: "Chimera",        picture: nil, destinationID: "unknown_encounter", creatureMutation: nil), // TODO: modifies mouth + body shape + color
            Choice(label: "Breadlings",     picture: nil, destinationID: "unknown_encounter", creatureMutation: nil), // TODO: modifies mouth + body shape + color
            Choice(label: "The Soothsayer", picture: nil, destinationID: "unknown_encounter", creatureMutation: nil)  // TODO: modifies mouth + body shape + color
        ],
        background: Image("Background")
    ),

    // MARK: - Page 5 — Encounter (per biome)

    "sea_encounter": StoryPage(
        id: "sea_encounter",
        pageNum: 5,
        text: "While on the journey back home, Benjamin and his creature run into Moby Dick. Would you like to battle or hide?",
        choices: [
            Choice(label: "Battle", picture: nil, destinationID: "death",  creatureMutation: nil), // DEATH OUTCOME
            Choice(label: "Hide",   picture: nil, destinationID: "naming", creatureMutation: nil)  // TODO: creature gains ripple pattern
        ],
        background: Image("Background")
    ),

    "forest_encounter": StoryPage(
        id: "forest_encounter",
        pageNum: 5,
        text: "While on the journey back home, Benjamin and his creature run into an Exterminator. Would you like to battle or hide?",
        choices: [
            Choice(label: "Battle", picture: nil, destinationID: "naming", creatureMutation: nil), // TODO: creature grows spikes and a gas mask
            Choice(label: "Hide",   picture: nil, destinationID: "naming", creatureMutation: nil)  // TODO: creature gains colorful flower pattern
        ],
        background: Image("Background")
    ),

    "unknown_encounter": StoryPage(
        id: "unknown_encounter",
        pageNum: 5,
        text: "While on the journey back home, Benjamin and his creature run into The Grand Soothsayer. Would you like to battle or hide?",
        choices: [
            Choice(label: "Battle", picture: nil, destinationID: "naming", creatureMutation: nil), // TODO: creature gains a third eye and a purple glow
            Choice(label: "Hide",   picture: nil, destinationID: "naming", creatureMutation: nil)  // TODO: creature becomes 50% transparent
        ],
        background: Image("Background")
    ),

    // MARK: - Death Outcome
    "death": StoryPage(
        id: "death",
        pageNum: 5,
        text: "Oh no! Benjamin and his creature didn't make it this time...",
        choices: [
            Choice(label: "Try Again", picture: nil, destinationID: "opening", creatureMutation: nil)
        ],
        background: Image("Background"),
        creatureVisible: false
    ),

    // MARK: - Page 6 — Naming
    "naming": StoryPage(
        id: "naming",
        pageNum: 6,
        text: "Benjamin and his creature made it home safely! Now he finally has time to name it. What should its name be?",
        choices: [], // TODO: text field w/ dice button for name randomization (destinationID: "bestiary")
        background: Image("Background")
    ),

    // MARK: - Page 7 — Bestiary Entry
    "bestiary": StoryPage(
        id: "bestiary",
        pageNum: 7,
        text: "Benjamin added his new companion to the bestiary!",
        choices: [], // TODO: button to check his bestiary
        background: Image("Background")
    )
]

// Claude Code Prompt: On 'narrative' file, use my storyboard comment to build the storyPages dictionary. consult me for any design choices and edits for files outside of this along the way. For now, use "Background" asset as default for all pages.
    

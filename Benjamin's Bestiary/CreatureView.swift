//
//  CreatureView.swift
//  Benjamin's Bestiary
//
//  Created by Juniper Rodriguez on 3/30/26.
//

import SwiftUI

struct CreatureView: View {
    let creature: Creature

    var body: some View {
        Image("Creature")
            .resizable()
            .scaledToFit()
            .colorMultiply(creature.color)
            .scaleEffect(creature.scale)
            .rotationEffect(.degrees(creature.rotation))
    }
}

#Preview {
    CreatureView(creature: Creature())
}

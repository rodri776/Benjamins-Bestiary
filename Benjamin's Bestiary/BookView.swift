//
//  BookView.swift
//  Benjamin's Bestiary
//
//  Created by Juniper Rodriguez on 3/26/26.
//

import SwiftUI

struct BookView: View {
    let storyPages: [StoryPage]
    @State private var creature = Creature()

    var body: some View {
        PageViewControllerWrapper(
            pages: storyPages.map { page in
                UIHostingController(rootView: StoryPageView(page: page, creature: $creature))
            }
        )
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    BookView(storyPages: [])
}

//
//  HomeView.swift
//  Benjamin's Bestiary
//
//  Created by Juniper Rodriguez on 3/26/26.
//

import SwiftUI
struct HomeView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("Benjamin's Bestiary").font(.largeTitle)
            Text("Juniper Rodriguez").italic()
            Spacer()
            
            NavigationLink(destination: BookView()) {
                Label("Begin Reading", systemImage: "book.pages.fill")
            }.buttonStyle(.bordered).padding()
            Button("See Bestiary", systemImage: "pawprint.fill") {}.buttonStyle(.bordered).padding()
            Spacer()
            HStack {
                Spacer()
                Button("Settings", systemImage: "gearshape.fill") {}
                Spacer()
                Button("About", systemImage: "person.fill") {}
                Spacer()
            }.padding()
        }
    }
}

#Preview {
    HomeView()
}

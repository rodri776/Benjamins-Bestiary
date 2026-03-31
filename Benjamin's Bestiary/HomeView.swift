//
//  HomeView.swift
//  Benjamin's Bestiary
//
//  Created by Juniper Rodriguez on 3/26/26.
//

import SwiftUI
struct HomeView: View {
    var body: some View {
        ZStack {
            Image("Background")
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                Text("Benjamin's Bestiary")
                    .font(.custom("InknutAntiqua-bold", size: 64))
                Text("By Juniper Rodriguez").italic()
                    .font(.custom("InknutAntiqua-light", size: 24))
                Spacer()
                
                NavigationLink(destination: BookView()) {
                    Label("Begin Reading", systemImage: "book.pages.fill").padding()
                }.buttonStyle(.bordered).padding()
                .font(.custom("InknutAntiqua-semibold", size: 42))
                NavigationLink(destination: BeastView()) {
                    Label("See Bestiary", systemImage: "pawprint.fill").padding()
                }.buttonStyle(.bordered).padding()
                    .font(.custom("InknutAntiqua-semibold", size: 28))
                Spacer()
                HStack {
                    Spacer()
                    Button("Settings", systemImage: "gearshape.fill") {}
                        .font(.custom("InknutAntiqua-regular", size: 24))
                    Spacer()
                    Button("About", systemImage: "person.fill") {}
                        .font(.custom("InknutAntiqua-regular", size: 24))

                    Spacer()
                }.padding()
            }
        }
    }
}

#Preview {
    HomeView()
}

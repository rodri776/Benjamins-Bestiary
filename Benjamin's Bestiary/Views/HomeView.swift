//
//  HomeView.swift
//  Benjamin's Bestiary
//
//  Created by Juniper Rodriguez on 3/26/26.
//

import SwiftUI
struct HomeView: View {
    @State private var showParentalGate = false
    @State private var isUnlocked = false

    var body: some View {
        ZStack {
            Image("Background1")
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
                }.buttonStyle(.borderedProminent)
                .tint(Color("ButtonColor").opacity(0.75))
                .padding()
                .font(.custom("InknutAntiqua-semibold", size: 42))
                NavigationLink(destination: BeastView()) {
                    Label("See Bestiary", systemImage: "pawprint.fill").padding()
                }.buttonStyle(.borderedProminent)
                .tint(Color("ButtonColor").opacity(0.75))
                .padding()
                    .font(.custom("InknutAntiqua-semibold", size: 28))
                Spacer()
                HStack {
                    Spacer()
                    NavigationLink(destination: SettingsView()) {
                        Label("Settings", systemImage: "gearshape.fill")
                    }
                        .font(.custom("InknutAntiqua-regular", size: 24))
                    Spacer()
                    Button("About", systemImage: "person.fill") {
                        showParentalGate = true
                    }
                        .font(.custom("InknutAntiqua-regular", size: 24))

                    Spacer()
                }.padding()
            }
        }
        .foregroundStyle(Color("TextColor").opacity(0.75))
        .sheet(isPresented: $showParentalGate) {
            ParentalGateView(isUnlocked: $isUnlocked)
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
                .presentationCompactAdaptation(.fullScreenCover)  // Full width on iPad
        }
        .navigationDestination(isPresented: $isUnlocked) {
            AboutView()
        }
    }
}

#Preview {
    HomeView()
}

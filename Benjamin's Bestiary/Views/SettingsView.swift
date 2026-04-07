//
//  SettingsView.swift
//  Benjamin's Bestiary
//
//  Created by Juniper Rodriguez on 4/1/26.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("kAutoplayPreference") private var autoPlay = false
    @AppStorage("kTapToPlayPreference") private var tapToPlay = true  // Default to true so button is visible

    var body: some View {
        ZStack {
            Image("Background")
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                List {
                    Toggle("Auto-play on page load", isOn: $autoPlay)
                        .font(.custom("InknutAntiqua-regular", size: 30))
                        .listRowBackground(Color(.black).opacity(0.2))
                        .padding()
                    Toggle("Tap-to-play button", isOn: $tapToPlay)
                        .font(.custom("InknutAntiqua-regular", size: 30))                   .listRowBackground(Color(.black).opacity(0.2))
                        .padding()
                }
                .scrollContentBackground(.hidden)
                .navigationTitle(Text("Settings"))
            }
        }
        .foregroundStyle(Color("TextColor").opacity(0.75))
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}

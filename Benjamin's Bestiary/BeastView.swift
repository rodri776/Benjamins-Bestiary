//
//  BeastView.swift
//  Benjamin's Bestiary
//
//  Created by Juniper Rodriguez on 3/31/26.
//
import SwiftUI

struct BeastView: View {
    var onHome: (() -> Void)? = nil

    var body: some View {
        ZStack {
            Image("Background")
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Button(action: { onHome?() }) {
                        Image(systemName: "house.fill")
                    }
                    .font(.system(size: 32))
                    .accessibilityLabel("Home")
                    .padding()
                   Spacer()
                }.padding()
                Spacer()
                Text("Your creatures will be shown here.")
                    .multilineTextAlignment(.center)
                    .font(.custom("InknutAntiqua-medium", size: 32))
                    .opacity(0.5)
                Spacer()
            }
        }
    }
}

#Preview {
    BeastView()
}

//
//  BeastView.swift
//  Benjamin's Bestiary
//
//  Created by Juniper Rodriguez on 3/31/26.
//
import SwiftUI

struct BeastView: View {
    var body: some View {
        ZStack {
            Image("Background")
                .resizable()
                .ignoresSafeArea()
            
            VStack {
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

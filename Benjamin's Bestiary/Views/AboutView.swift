//
//  AboutView.swift
//  Benjamin's Bestiary
//
//  Created by Juniper Rodriguez on 4/5/26.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        ZStack{
            Image("Background")
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                Image("Author")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 250, height: 250)
                    .clipShape(Circle())
                    .padding()
                Text("Juniper Rodriguez")
                    .font(.custom("InknutAntiqua-semibold", size: 48))
                Label("Author", systemImage: "person.fill")
                    .font(.custom("InknutAntiqua-SemiBold", size: 24))
                    .opacity(0.7)
                Spacer()
                Text("Juniper is a computer science graduate student at the University of Chicago with a penchant for building quirky and imaginative iOS apps.")
                    .font(.custom("InknutAntiqua-medium", size: 24))
                    .multilineTextAlignment(.center)
                    .padding(75)
                Spacer()
            }
        }
        .foregroundStyle(Color("TextColor").opacity(0.75))
    }
}

#Preview {
    AboutView()
}

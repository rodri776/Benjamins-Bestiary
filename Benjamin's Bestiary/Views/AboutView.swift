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
                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras mollis blandit pharetra. Integer dictum, mauris in luctus imperdiet, tellus orci venenatis augue, id iaculis odio lorem a massa. Sed efficitur quam ut facilisis convallis. Maecenas vitae mollis orci. Ut ligula est, iaculis nec tortor non, venenatis lobortis ante.")
                    .font(.custom("InknutAntiqua-medium", size: 24))
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

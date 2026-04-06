//
//  ParentalGateView.swift
//  Benjamin's Bestiary
//
//  Created by Juniper Rodriguez on 4/5/26.
//
import SwiftUI

struct ParentalGateView: View {
    @Binding var isUnlocked: Bool
    @Environment(\.dismiss) private var dismiss

    @State private var firstOComplete = false
    @State private var secondOComplete = false

    private let quoteFont: Font = .custom("InknutAntiqua-Regular", size: 52)
    private let slotSize: CGFloat = 150
    private let quoteFontSize: CGFloat = 52

    var body: some View {
        ZStack {
            Image("Background")
                .resizable()
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Text("Parental Gate")
                    .font(.custom("InknutAntiqua-Bold", size: 48))

                Text("Fill in the missing letters to continue")
                    .font(.custom("InknutAntiqua-Regular", size: 24))

                VStack(spacing: 4) {
                    Text("In 1859, Charles Darwin Published")
                        .font(quoteFont)

                    HStack(alignment: .center, spacing: 0) {
                        Text("\"")
                            .font(quoteFont)

                        CircleSlot(
                            isComplete: $firstOComplete,
                            slotSize: slotSize,
                            fontSize: quoteFontSize
                        )

                        Text("n the")
                            .font(quoteFont)
                    }

                    HStack(alignment: .center, spacing: 0) {
                        CircleSlot(
                            isComplete: $secondOComplete,
                            slotSize: slotSize,
                            fontSize: quoteFontSize
                        )

                        Text("rigin of Species\"")
                            .font(quoteFont)
                    }
                }
                .padding(.horizontal, 40)
                .padding(.vertical, 20)
            }
            .padding()
        }
        .foregroundStyle(Color("TextColor").opacity(0.75))
        .onChange(of: firstOComplete) { checkUnlock() }
        .onChange(of: secondOComplete) { checkUnlock() }
    }

    private func checkUnlock() {
        if firstOComplete && secondOComplete {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isUnlocked = true
                dismiss()
            }
        }
    }
}

#Preview {
    ParentalGateView(isUnlocked: .constant(false))
}

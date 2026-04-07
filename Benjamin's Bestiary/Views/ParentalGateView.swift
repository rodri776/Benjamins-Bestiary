//
//  ParentalGateView.swift
//  Benjamin's Bestiary
//
//  Created by Juniper Rodriguez on 4/5/26.
//
import SwiftUI

// Note: ParentalGateError enum is defined in DrawingViewController.swift
// to satisfy the assignment's custom error handling requirement

// MARK: - Parental Gate View

struct ParentalGateView: View {
    @Binding var isUnlocked: Bool
    @Environment(\.dismiss) private var dismiss

    @State private var firstOComplete = false
    @State private var secondOComplete = false
    @State private var errorMessage: String? = nil
    @State private var showError = false

    private let quoteFont: Font = .custom("InknutAntiqua-Regular", size: 32)
    private let slotSize: CGFloat = 120
    private let quoteFontSize: CGFloat = 32

    var body: some View {
        ZStack {
            Image("Background")
                .resizable()
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Text("Parental Gate")
                    .font(.custom("InknutAntiqua-Bold", size: 40))

                Text("Fill in the missing letters to continue")
                    .font(.custom("InknutAntiqua-Regular", size: 20))
                    .multilineTextAlignment(.center)
                
                // Error message display
                if showError, let error = errorMessage {
                    Text(error)
                        .font(.custom("InknutAntiqua-Regular", size: 18))
                        .foregroundColor(.red)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(.black.opacity(0.3))
                        )
                        .transition(.scale.combined(with: .opacity))
                }

                Spacer()

                VStack(spacing: 12) {
                    Text("In 1859, Charles Darwin Published")
                        .font(.custom("InknutAntiqua-Regular", size: 26))
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)  // Allow unlimited lines
                        .fixedSize(horizontal: false, vertical: true)  // Allow vertical expansion

                    // First line: "On the"
                    HStack(alignment: .center, spacing: 4) {
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
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    
                    // Second line: "Origin of Species"
                    HStack(alignment: .center, spacing: 4) {
                        CircleSlot(
                            isComplete: $secondOComplete,
                            slotSize: slotSize,
                            fontSize: quoteFontSize
                        )

                        Text("rigin of Species\"")
                            .font(quoteFont)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 40)
                
                Spacer()
            }
            .padding(40)  // Increased outer padding
        }
        .foregroundStyle(Color("TextColor").opacity(0.75))
        .onChange(of: firstOComplete) { checkUnlock() }
        .onChange(of: secondOComplete) { checkUnlock() }
    }

    private func checkUnlock() {
        // Check if both circles are completed
        if firstOComplete && secondOComplete {
            // Both slots filled - unlock!
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isUnlocked = true
                dismiss()
            }
        }
        // Note: Individual circle validation with ParentalGateError is handled
        // by DrawingViewController's do-try-throw pattern
    }
}

#Preview {
    ParentalGateView(isUnlocked: .constant(false))
}

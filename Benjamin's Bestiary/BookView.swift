//
//  BookView.swift
//  Benjamin's Bestiary
//
//  Created by Juniper Rodriguez on 3/26/26.
//

import SwiftUI

struct BookView: View {
    // replaced [UIViewController] pages with PageViewModel to account for non-linear page navigation
    @State private var viewModel = PageViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        PageViewControllerWrapper(viewModel: viewModel)
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            viewModel.pages = storyPages
        }
        .onChange(of: viewModel.shouldDismiss) {
            if viewModel.shouldDismiss { dismiss() }
        }
    }
}

#Preview {
    BookView()
}

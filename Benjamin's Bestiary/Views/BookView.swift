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
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        PageViewControllerWrapper(viewModel: viewModel)
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            viewModel.pages = storyPages
            viewModel.shouldDismiss = false
            viewModel.restoreBookmark()
        }
        .onChange(of: viewModel.shouldDismiss) {
            viewModel.saveBookmark() // saves bookmark after page flipped
            if viewModel.shouldDismiss { dismiss() }
        }
        .onChange(of: viewModel.currentPageID) {
            viewModel.saveBookmark() // saves bookmark on every page change
        }
        .onChange(of: scenePhase) {
            if scenePhase == .background {
                viewModel.saveBookmark() // saves bookmark when app enters background
            }
        }
    }
}

#Preview {
    BookView()
}

//
//  PageViewControllerWrapper.swift
//  Benjamin's Bestiary
//
//  Created by Juniper Rodriguez on 3/26/26.
//
import SwiftUI

struct PageViewControllerWrapper: UIViewControllerRepresentable {

    // MARK: - Properties
    var viewModel: PageViewModel // replaced linear array with 'ViewModel' to account for branching ("Choose Your Own Adventure" logic)

    // MARK: - UIViewControllerRepresentable
    func makeUIViewController(context: Context) -> UIPageViewController {
        let pageVC = UIPageViewController(
            transitionStyle: .pageCurl,
            navigationOrientation: .horizontal
        )
        pageVC.dataSource = context.coordinator
        return pageVC
    }

    // helper to build view controller from Page ID
    func makeHostingController(for pageID: String) -> UIViewController? {
        guard let page = viewModel.pages[pageID] else { return nil }
        let host = UIHostingController(rootView: StoryPageView(
            page: page,
            creature: Binding(
                get: { self.viewModel.creature },
                set: { self.viewModel.creature = $0 }
            )
        ))
        host.view.accessibilityIdentifier = pageID
        return host
    }
    
    // animation triggered when currentPageID changes
    func updateUIViewController(_ uiViewController: UIPageViewController, context: Context) {
        let currentlyShown = uiViewController.viewControllers?.first?.view.accessibilityIdentifier
        if currentlyShown != viewModel.currentPageID {
            if let newVC = makeHostingController(for: viewModel.currentPageID) {
                uiViewController.setViewControllers([newVC], direction: .forward, animated: true)
            }
        }
    }

    func makeCoordinator() -> Coordinator { Coordinator(wrapper: self) }

    // MARK: - Coordinator

    class Coordinator: NSObject, UIPageViewControllerDataSource {
        
        // uses history for back-swipe, blocks forward-swipe
        let wrapper: PageViewControllerWrapper
        init(wrapper: PageViewControllerWrapper) { self.wrapper = wrapper }

        func pageViewController(_ pvc: UIPageViewController,
            viewControllerBefore vc: UIViewController) -> UIViewController? {
            
            // walks backgwards through history
            guard let pageID = vc.view.accessibilityIdentifier,
                  let index = wrapper.viewModel.history.lastIndex(of: pageID),
                  index > 0 else { return nil }
            return wrapper.makeHostingController(for: wrapper.viewModel.history[index - 1])
            
        }

        func pageViewController(_ pvc: UIPageViewController,
            viewControllerAfter vc: UIViewController) -> UIViewController? {
            
            return nil // reader must make a choice before seeing next page

        }
    }
}

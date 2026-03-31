//
//  PageViewControllerWrapper.swift
//  Benjamin's Bestiary
//
//  Created by Juniper Rodriguez on 3/26/26.
//
import SwiftUI

struct PageViewControllerWrapper: UIViewControllerRepresentable {

    // MARK: - Properties
    var pages: [UIViewController]

    // MARK: - UIViewControllerRepresentable

    func makeUIViewController(context: Context) -> UIPageViewController {
        let pageVC = UIPageViewController(
            transitionStyle: .pageCurl,
            navigationOrientation: .horizontal
        )
        pageVC.dataSource = context.coordinator
        return pageVC
    }

    func updateUIViewController(_ uiViewController: UIPageViewController, context: Context) {
        if let first = pages.first {
            uiViewController.setViewControllers(
                [first], direction: .forward, animated: false
            )
        }
    }

    func makeCoordinator() -> Coordinator { Coordinator(pages: pages) }

    // MARK: - Coordinator

    class Coordinator: NSObject, UIPageViewControllerDataSource {
        var pages: [UIViewController]
        init(pages: [UIViewController]) { self.pages = pages }

        func pageViewController(_ pvc: UIPageViewController,
            viewControllerBefore vc: UIViewController) -> UIViewController? {
            guard let i = pages.firstIndex(of: vc), i > 0 else { return nil }
            return pages[i - 1]
        }

        func pageViewController(_ pvc: UIPageViewController,
            viewControllerAfter vc: UIViewController) -> UIViewController? {
            guard let i = pages.firstIndex(of: vc), i < pages.count - 1 else { return nil }
            return pages[i + 1]
        }
    }
}

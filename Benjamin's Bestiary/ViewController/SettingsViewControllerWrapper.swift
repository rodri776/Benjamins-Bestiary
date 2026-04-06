//
//  SettingsViewControllerWrapper.swift
//  Benjamin's Bestiary
//
//  Created by Juniper Rodriguez on 4/1/26.
//
import Foundation
import SwiftUI

struct SettingsViewControllerWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> SettingsViewController {
        return SettingsViewController()
    }
    func updateUIViewController(_ uiViewController: SettingsViewController, context: Context) {}
}

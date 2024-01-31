//
//  RepositionableViewsApp.swift
//  RepositionableViews
//
//  Created by Rick Mann on 2024-01-30.
//

import SwiftUI

@main
struct RepositionableViewsApp: App {
    var body: some Scene {
        Window("Window", id: "widow")
        {
            ContentView()
        }
        .windowResizability(.contentSize)
    }
}

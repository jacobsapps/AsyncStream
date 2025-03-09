//
//  AsyncStreamApp.swift
//  AsyncStream
//
//  Created by Jacob Bartlett on 09/03/2025.
//

import SwiftUI

@main
struct AsyncStreamApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                DownloadView()
                    .tabItem {
                        Label("Download", systemImage: "arrow.down.circle")
                    }
                
                CompassView()
                    .tabItem {
                        Label("Compass", systemImage: "safari")
                    }
                
                FPSView()
                    .tabItem {
                        Label("FPS", systemImage: "gauge")
                    }
            }
        }
    }
}

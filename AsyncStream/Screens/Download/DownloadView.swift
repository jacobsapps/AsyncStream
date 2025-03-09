//
//  DownloadView.swift
//  AsyncStream
//
//  Created by Jacob Bartlett on 09/03/2025.
//

import SwiftUI

struct DownloadView: View {
    
    @State private var progress: Double = 0
    @State private var showError: Bool = false
    
    var body: some View {
        NavigationStack {
            ProgressBar(progress: progress)
                .frame(maxHeight: .infinity, alignment: .center)
                .padding()
                .navigationTitle("Downloading...")
                .task {
                    
                    do {
                        for try await percentage in DownloadAPI.downloadStream() {
                            progress = percentage
                        }
                    } catch {
                        self.showError = true
                    }
                }
                .alert("Download Error", isPresented: $showError) {
                    Button("OK", role: .cancel) { }
                }
        }
    }
}

struct ProgressBar: View {
    let progress: Double
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Download \(String(format: "%.2f", progress))% complete")
            GeometryReader { geo in
                let proportionalWidth = geo.size.width * (progress / 100)
                RoundedRectangle(cornerRadius: 2)
                    .foregroundStyle(.green)
                    .frame(width: proportionalWidth, height: 4, alignment: .leading)
            }
        }
    }
}

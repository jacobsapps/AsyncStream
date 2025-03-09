//
//  DownloadAPI.swift
//  AsyncStream
//
//  Created by Jacob Bartlett on 09/03/2025.
//

import Foundation

final class DownloadAPI {
    
    enum DownloadError: Error {
        case failedToDownload
    }
    
    static func downloadStream() -> AsyncThrowingStream<Double, Error> {
        AsyncThrowingStream { continuation in
            Task {
                var percentage = 0.0
                while percentage < 70 {
                    try await Task.sleep(for: .milliseconds(10))
                    let bits = Double.random(in: 0...0.3)
                    percentage += bits
                    continuation.yield(with: .success(percentage))
                }
                continuation.yield(with: .failure(DownloadError.failedToDownload))
                continuation.finish()
            }
        }
    }
}

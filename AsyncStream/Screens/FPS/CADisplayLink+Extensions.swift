//
//  CADisplayLink+Extensions.swift
//  AsyncStream
//
//  Created by Jacob Bartlett on 09/03/2025.
//

import QuartzCore

@MainActor
extension CADisplayLink {
    static func events(mode: RunLoop.Mode = .default) -> AsyncStream<CADisplayLink> {
        AsyncStream { continuation in
            let displayLink = DisplayLink(mode: mode) { displayLink in
                continuation.yield(displayLink)
            }

            continuation.onTermination = { _ in
                Task { await displayLink.stop() }
            }
        }
    }
}

@MainActor
private final class DisplayLink {
    private var displayLink: CADisplayLink?
    private var handler: (CADisplayLink) -> Void

    init(mode: RunLoop.Mode, handler: @escaping (CADisplayLink) -> Void) {
        self.handler = handler
        self.displayLink = CADisplayLink(target: self, selector: #selector(update))
        self.displayLink?.add(to: .main, forMode: mode)
    }

    @objc private func update(displayLink: CADisplayLink) {
        handler(displayLink)
    }

    func stop() {
        displayLink?.invalidate()
        displayLink = nil
    }
}

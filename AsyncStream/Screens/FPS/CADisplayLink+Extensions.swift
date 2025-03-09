//
//  CADisplayLink+Extensions.swift
//  AsyncStream
//
//  Created by Jacob Bartlett on 09/03/2025.
//

import QuartzCore

extension CADisplayLink {
    static func events(mode: RunLoop.Mode = .default) -> AsyncStream<CADisplayLink> {
        AsyncStream { continuation in
            let displayLink = CADisplayLink(
                target: DisplayLinkWrapper(continuation),
                selector: #selector(DisplayLinkWrapper.tick)
            )
            displayLink.add(to: .main, forMode: mode)
            continuation.onTermination = { @Sendable _ in
                displayLink.invalidate()
            }
        }
    }
}

private final class DisplayLinkWrapper {
    let continuation: AsyncStream<CADisplayLink>.Continuation

    init(_ continuation: AsyncStream<CADisplayLink>.Continuation) {
        self.continuation = continuation
    }

    @objc func tick(_ displayLink: CADisplayLink) {
        continuation.yield(displayLink)
    }
}

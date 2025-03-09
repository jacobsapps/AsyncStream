//
//  FPSView.swift
//  AsyncStream
//
//  Created by Jacob Bartlett on 09/03/2025.
//

import SwiftUI

struct FPSView: View {
    @State private var fps: Double = 0
    @State private var lastTimestamp: TimeInterval = 0
    @State private var arcCount: Int = 0
    @State private var isAnimating: Bool = false
    private let smoothingFactor: Double = 0.1
    
    var body: some View {
        ZStack {
            PerformanceLoadView(arcCount: arcCount)
            
            Text(String(format: "FPS: %.0f", fps))
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.black.opacity(0.7)))
                .task {
                    for await link in CADisplayLink.events() {
                        updateFPS(link)
                    }
                }
                .onAppear {
                    isAnimating = true
                    startAddingComplexity()
                }
                .onDisappear {
                    isAnimating = false
                    arcCount = 0
                }
        }
    }
    
    private func updateFPS(_ link: CADisplayLink) {
        let currentTime = link.timestamp
        let elapsedTime = currentTime - lastTimestamp
        lastTimestamp = currentTime

        if elapsedTime > 0 {
            let newFPS = 1.0 / elapsedTime
            fps = (fps * (1 - smoothingFactor)) + (newFPS * smoothingFactor)
        }
    }

    private func startAddingComplexity() {
        Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { timer in
            if isAnimating {
                arcCount += 15
            } else {
                timer.invalidate()
            }
        }
    }
}

struct PerformanceLoadView: View {
    let arcCount: Int

    var body: some View {
        ZStack {
            ForEach(0..<arcCount, id: \.self) { _ in
                ArcView()
                    .rotationEffect(.degrees(Double.random(in: 0...360)))
                    .offset(
                        x: CGFloat.random(in: -400...400),
                        y: CGFloat.random(in: -200...200)
                    )
            }
        }
        .animation(.easeInOut(duration: 1), value: arcCount)
    }
}

struct ArcView: View {
    @State private var rotation: Double = 0
    private let color: Color = Color(
         red: Double.random(in: 0...1),
         green: Double.random(in: 0...1),
         blue: Double.random(in: 0...1)
     )
    
    var body: some View {
        Circle()
            .trim(from: Double.random(in: 0.1...0.3), to: Double.random(in: 0.5...1.0))
            .stroke(color, lineWidth: 2)
            .frame(width: 90, height: 90)
            .rotationEffect(.degrees(rotation))
            .onAppear {
                withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                    rotation = 360
                }
            }
    }
}

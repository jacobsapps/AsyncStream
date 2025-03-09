//
//  CompassView.swift
//  AsyncStream
//
//  Created by Jacob Bartlett on 09/03/2025.
//

import SwiftUI

struct CompassView: View {
    @State private var rotationAngle: Angle = .degrees(0)
    
    var body: some View {
        ZStack {
            ForEach(0..<36) {
                let angle = Angle.degrees(Double($0 * 10)) + rotationAngle
                Rectangle()
                    .frame(width: $0 == 0 ? 16 : 8, height: $0 == 0 ? 3 : 2)
                    .foregroundColor($0 == 0 ? .red : .blue)
                    .rotationEffect(angle)
                    .offset(x: 120 * cos(CGFloat(angle.radians)), y: 120 * sin(CGFloat(angle.radians)))
                    .animation(.bouncy, value: rotationAngle)
            }
        }
        .task {
            for await angle in LocationManager.shared.rotationAngleStream {
                rotationAngle = Angle.degrees(angle)
            }
        }
        .onAppear {
            LocationManager.shared.start()
        }
        .onDisappear {
            LocationManager.shared.stop()
        }
    }
}

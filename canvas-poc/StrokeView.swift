//
//  StrokeView.swift
//  canvas-poc
//
//  Created by Henry Brinkman on 10/07/2024.
//

import SwiftUI
import PencilKit

struct StrokeView: View {
    let stroke: PKStroke
    let svgPath: UIBezierPath
    let polkadotPattern: Bool

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Path { path in
                    for ink in stroke.ink {
                        path.move(to: ink.location)
                        path.addLine(to: ink.location)
                    }
                }
                .stroke(style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                .foregroundColor(.blue)
                .clipShape(svgPath) // Clip the stroke to the SVG path
                .overlay(
                    polkadotPattern ? AnyView(PolkadotPattern()) : AnyView(EmptyView())
                )
            }
        }
    }

    struct PolkadotPattern: View {
        let dotSize: CGFloat = 2

        var body: some View {
            GeometryReader { geometry in
                ZStack {
                    ForEach(0..<100) { index in
                        Circle()
                            .fill(Color.white)
                            .frame(width: dotSize, height: dotSize)
                            .offset(x: .random(in: 0...geometry.size.width), y: .random(in: 0...geometry.size.height))
                    }
                }
            }
        }
    }
}

#Preview {
    StrokeView()
}

//
//  DrawingView.swift
//  canvas-poc
//
//  Created by Henry Brinkman on 10/07/2024.
//

import SwiftUI
import PencilKit

struct DrawingView: View {
    @State private var strokes: [PKStroke] = []
    @State private var drawingBounds: CGRect = .zero
    let svgPath: String = "cat_head"

    var body: some View {
        ZStack {
            SVGPath(from: svgPath)?
                .stroke(style: StrokeStyle(lineWidth: 1, lineCap: .round, lineJoin: .round))
                .foregroundColor(.gray)
            PencilKitView(strokes: $strokes, drawingBounds: $drawingBounds, svgPath: svgPath)
            ForEach(strokes.indices, id: \.self) { index in
                StrokeView(stroke: strokes[index], svgPath: (SVGPath(from: svgPath)?.path)!, polkadotPattern: true)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            // Set the drawing bounds to the size of the screen
            self.drawingBounds = UIScreen.main.bounds
        }
    }
}
#Preview {
    DrawingView()
}

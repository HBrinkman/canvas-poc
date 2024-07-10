//
//  PencilkitView.swift
//  canvas-poc
//
//  Created by Henry Brinkman on 10/07/2024.
//

import PencilKit
import SwiftUI

struct PencilKitView: UIViewRepresentable {
    @Binding var strokes: [PKStroke]
    @Binding var drawingBounds: CGRect
    let svgPath: String

    init(strokes: Binding<[PKStroke]>, drawingBounds: Binding<CGRect>, svgPath: String) {
        self._strokes = strokes
        self._drawingBounds = drawingBounds
        self.svgPath = svgPath
    }

    func makeUIView(context: Context) -> PKCanvasView {
        let canvasView = PKCanvasView()
        canvasView.delegate = context.coordinator
        canvasView.drawingPolicy = .anyInput
        return canvasView
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {
//        uiView.strokes = strokes
//        uiView.drawingBounds = drawingBounds
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PKCanvasViewDelegate {
        let parent: PencilKitView

        init(_ parent: PencilKitView) {
            self.parent = parent
        }

        func canvasViewDidBegin(_ canvasView: PKCanvasView) {
            // Clear the strokes array when the user starts drawing
            parent.strokes = []
        }

        func canvasView(_ canvasView: PKCanvasView, didCommit stroke: PKStroke) {
            // Add the new stroke to the strokes array
            parent.strokes.append(stroke)
        }
    }
}

//
//  SvgDrawingView.swift
//  canvas-poc
//
//  Created by Henry Brinkman on 09/07/2024.
//

import SwiftUI

struct SvgDrawingView: View {
    @ObservedObject var viewModel: DrawingViewModel
        @State private var currentPath = Path()
        @State private var activeSVGPath: SVGPath?
        
        var body: some View {
            ZStack {
                // Render all SVG paths as outlines
                ForEach(viewModel.svgPaths) { svgPath in
                    Path(svgPath.path)
                        .stroke(Color.gray, lineWidth: 1)
                }
                
                // Render the drawn paths
                ForEach(viewModel.drawnPaths) { drawingPath in
                    drawingPath.path
                        .stroke(Color.black, lineWidth: 2)
                        .mask(Path(viewModel.svgPaths.first { $0.id == drawingPath.id }?.path ?? CGPath(rect: .zero, transform: nil)))
                }
                
                // Render the current path being drawn
                currentPath
                    .stroke(Color.black, lineWidth: 2)
                    .mask(
                        Path(activeSVGPath?.path ?? CGPath(rect: .zero, transform: nil))
                    )
            }
            .background(Color.white)
            .gesture(DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            let point = value.location
                            if let svgPath = viewModel.path(at: point) {
                                if activeSVGPath == nil {
                                    // Move to the starting point
                                    currentPath.move(to: point)
                                    activeSVGPath = svgPath
                                } else {
                                    currentPath.addLine(to: point)
                                }
                            }
                        }
                        .onEnded { value in
                            if activeSVGPath != nil {
                                viewModel.addCurrentPath(currentPath)
                            }
                            activeSVGPath = nil
                            currentPath = Path()
                        })
        }
}

#Preview {
    SvgDrawingView(viewModel: DrawingViewModel(svgPaths: []))
}

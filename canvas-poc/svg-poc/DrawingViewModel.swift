//
//  DrawingViewModel.swift
//  canvas-poc
//
//  Created by Henry Brinkman on 09/07/2024.
//

import Combine
import SwiftUI

class DrawingViewModel: ObservableObject {
    @Published var drawnPaths: [DrawingPath] = []
    var svgPaths: [SVGPath]
    
    init(svgPaths: [SVGPath]) {
        self.svgPaths = svgPaths
    }
    
    func path(at point: CGPoint) -> SVGPath? {
        return svgPaths.first { $0.path.contains(point) }
    }
    
    func addCurrentPath(_ path: Path) {
        drawnPaths.append(DrawingPath(path: path))
    }
}

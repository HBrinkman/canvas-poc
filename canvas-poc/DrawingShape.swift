//
//  DrawingShape.swift
//  canvas-poc
//
//  Created by Henry Brinkman on 07/07/2024.
//

import SwiftUI

struct DrawingShape: Shape {
    let points: [CGPoint]
    let engine = DrawingEngine()
    func path(in rect: CGRect) -> Path {
        engine.createPath(for: points)
    }
}

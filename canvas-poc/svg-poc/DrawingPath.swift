//
//  DrawingPath.swift
//  canvas-poc
//
//  Created by Henry Brinkman on 09/07/2024.
//

import SwiftUI

struct DrawingPath: Identifiable, Hashable {
    let id = UUID()
    var path: Path

    // Conformance to Hashable
    static func == (lhs: DrawingPath, rhs: DrawingPath) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

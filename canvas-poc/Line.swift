//
//  Line.swift
//  canvas-poc
//
//  Created by Henry Brinkman on 07/07/2024.
//

import Foundation
import SwiftUI

struct Line: Identifiable {
    
    var points: [CGPoint]
    var color: Color
    var lineWidth: CGFloat

    let id = UUID()
}

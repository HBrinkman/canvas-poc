//
//  Item.swift
//  canvas-poc
//
//  Created by Henry Brinkman on 05/07/2024.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}

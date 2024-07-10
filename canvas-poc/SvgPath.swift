//
//  SvgPath.swift
//  canvas-poc
//
//  Created by Henry Brinkman on 10/07/2024.
//

import Foundation
import UIKit

//struct SVGPath {
//    let path: UIBezierPath
//
//    init?(from svgPath: String) {
//        guard let url = Bundle.main.url(forResource: svgPath, withExtension: "svg") else { return nil }
//        guard let svgData = try? Data(contentsOf: url) else { return nil }
//        guard let svgParser = SVGParser(data: svgData) else { return nil }
//        guard let svgElement = svgParser.parse() else { return nil }
//        guard let pathElement = svgElement.children.first(where: { $0 is SVGPathElement }) as? SVGPathElement else { return nil }
//        self.path = pathElement.uiBezierPath
//    }
//}

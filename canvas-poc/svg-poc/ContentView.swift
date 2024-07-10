//
//  ContentView.swift
//  canvas-poc
//
//  Created by Henry Brinkman on 09/07/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = DrawingViewModel(svgPaths: [
            SVGPath(path: CGPath(rect: CGRect(x: 50, y: 50, width: 100, height: 100), transform: nil)),
            SVGPath(path: CGPath(rect: CGRect(x: 50, y: 160, width: 100, height: 150), transform: nil))
        ])
    
    var body: some View {
        SvgDrawingView(viewModel: viewModel)
                    .frame(width: 300, height: 400)
                    .border(Color.black, width: 1)
    }
}

#Preview {
    ContentView()
}

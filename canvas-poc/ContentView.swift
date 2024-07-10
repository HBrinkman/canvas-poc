//
//  ContentView.swift
//  canvas-poc
//
//  Created by Henry Brinkman on 10/07/2024.
//

import SwiftUI
import PencilKit

struct ContentView: View {
    var body: some View {
        Home()
    }
}

#Preview {
    ContentView()
}

struct Home: View {
    
    @State var canvas = PKCanvasView()
    @State var canvas2 = PKCanvasView()
    @State var canvas3 = PKCanvasView()

    var body: some View {
        
        ZStack {
            DrawingView(canvas: $canvas)
            DrawingView(canvas: $canvas2)
                .frame(width: 300, height: 300)
                .clipShape(
                    RoundedRectangle(cornerRadius: 6)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(.red, lineWidth: 2)
                )
            
            DrawingView(canvas: $canvas3)
                .frame(width: 300, height: 300)
                .border(.green)
                .offset(x: 150, y: 150)
                .clipShape(
                    RoundedRectangle(cornerRadius: 6)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(.red, lineWidth: 2)
                )
        }
    }
}

struct DrawingView: UIViewRepresentable {
    
    @Binding var canvas: PKCanvasView
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvas.drawingPolicy = .anyInput
        // Fill tool strokes verwijderen en background color setten op een bepaalde shape
        // Met een eraser meteen background weer op wit zetten
        canvas.backgroundColor = .blue
        return canvas
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        
    }
}

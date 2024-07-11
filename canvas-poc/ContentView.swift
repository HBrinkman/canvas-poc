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
    @State var isErasing = false
    @State var selectedColor: Color = .black
    @State var selectedTool: PKInkingTool.InkType = .pencil
    
    var body: some View {
        
        ZStack(alignment: .bottomTrailing) {
            DrawingView(canvas: $canvas, isErasing: $isErasing, selectedTool: $selectedTool, selectedColor: $selectedColor)
                .ignoresSafeArea()
            ZStack {
                Rectangle()
                    .foregroundColor(.brown)
                    .cornerRadius(8)
                VStack {
                    Spacer()
                    HStack {
                        Button {
                            print("Done")
                        } label: {
                            Image(systemName: "checkmark.square.fill")
                        }
                        Button {
                            print("Take screenshot")
                        } label: {
                            Image(systemName: "camera.fill")
                        }
                    }
                    Spacer()
                    Button {
                        // TODO show overlay
                        print("Select brush")
                        isErasing = false
                        selectedTool = .watercolor
                    } label: {
                        Image(systemName: "pencil")
                    }
                    Spacer()
                    Button {
                        print("Select color")
                    } label: {
                        Image(systemName: "eyedropper.full")
                    }
                    Spacer()
                    Button {
                        isErasing = true
                    } label: {
                        Image(systemName: "eraser.fill")
                    }
                    Spacer()
                    HStack {
                        Button {
                            print("Undo")
                        } label: {
                            Image(systemName: "arrow.uturn.backward.circle.fill")
                        }
                        Button {
                            print("Redo")
                        } label: {
                            Image(systemName: "arrow.uturn.forward.circle.fill")
                        }
                    }
                    Spacer()
                }
            }
            .frame(
                maxWidth: 200,
                maxHeight: .infinity
            )
            .padding(.vertical, 20)

            
        }
    }
}

struct DrawingView: UIViewRepresentable {
    
    @Binding var canvas: PKCanvasView
    @Binding var isErasing: Bool
    @Binding var selectedTool: PKInkingTool.InkType
    @Binding var selectedColor: Color
    
    var ink: PKInkingTool {
        PKInkingTool(selectedTool, color: UIColor(selectedColor), width: 20)
    }
    let eraser = PKEraserTool(.bitmap, width: 20)
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvas.drawingPolicy = .anyInput
        canvas.tool = isErasing ? eraser : ink
        return canvas
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        uiView.tool = isErasing ? eraser : ink
    }
}

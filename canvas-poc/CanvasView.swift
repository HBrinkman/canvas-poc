//
//  CanvasView.swift
//  canvas-poc
//
//  Created by Henry Brinkman on 15/07/2024.
//

import SwiftUI

struct CanvasView: View {
    @State private var selectedColor: Color = .orange
    
    var body: some View {
        VStack {
            HStack {
                ForEach([Color.green, .orange, .blue, .red, .pink, .black, .purple], id: \.self) { color in
                    colorButton(color: color)
                }
            }
            HStack {
                CanvasDrawingView(selectedColor: $selectedColor)
                
                // POC performance is prima en clipshapes werken
                //                    .frame(maxWidth: .infinity / 10, maxHeight: .infinity)
//                    .border(.black)
//                    .clipShape(Circle())
//                CanvasDrawingView(selectedColor: $selectedColor)
//                    .frame(maxWidth: .infinity / 10, maxHeight: .infinity)
//                    .border(.black)
//                CanvasDrawingView(selectedColor: $selectedColor)
//                    .frame(maxWidth: .infinity / 10, maxHeight: .infinity)
//                    .border(.black)
//                CanvasDrawingView(selectedColor: $selectedColor)
//                    .frame(maxWidth: .infinity / 10, maxHeight: .infinity)
//                    .border(.black)
//                CanvasDrawingView(selectedColor: $selectedColor)
//                    .frame(maxWidth: .infinity / 10, maxHeight: .infinity)
//                    .border(.black)
//                CanvasDrawingView(selectedColor: $selectedColor)
//                    .frame(maxWidth: .infinity / 10, maxHeight: .infinity)
//                    .border(.black)
//                CanvasDrawingView(selectedColor: $selectedColor)
//                    .frame(maxWidth: .infinity / 10, maxHeight: .infinity)
//                    .border(.black)
//                CanvasDrawingView(selectedColor: $selectedColor)
//                    .frame(maxWidth: .infinity / 10, maxHeight: .infinity)
//                    .border(.black)
//                CanvasDrawingView(selectedColor: $selectedColor)
//                    .frame(maxWidth: .infinity / 10, maxHeight: .infinity)
//                    .border(.black)
            }
        }
        .ignoresSafeArea()
    }
    
    @ViewBuilder
    func colorButton(color: Color) -> some View {
        Button {
            selectedColor = color
        } label: {
          Image(systemName: "circle.fill")
                .font(.largeTitle)
                .foregroundColor(color)
                .mask {
                    Image(systemName: "pencil.tip")
                        .font(.largeTitle)
                }
        }
    }
    
//    @ViewBuilder
//    func clearButton() -> some View {
//        Button {
//            lines = []
//        } label: {
//            Image(systemName: "pencil.tip.crop.circle.badge.minus")
//                .font(.largeTitle)
//                .foregroundColor(.gray)
//        }
//    }
}

#Preview {
    CanvasView()
}

//
//  CanvasDrawingView.swift
//  canvas-poc
//
//  Created by Henry Brinkman on 15/07/2024.
//

import SwiftUI

struct Line {
    var points: [CGPoint]
    var color: Color
}

struct HeartShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.width
        let height = rect.height
        let topCurveHeight = height * 0.3
        
        path.move(to: CGPoint(x: width / 2, y: height))
        
        // Top left curve
        path.addCurve(to: CGPoint(x: 0, y: height - topCurveHeight),
                      control1: CGPoint(x: width / 4, y: height),
                      control2: CGPoint(x: 0, y: height - topCurveHeight / 2))
        
        // Top left circle
        path.addArc(center: CGPoint(x: width / 4, y: height - topCurveHeight),
                    radius: width / 4,
                    startAngle: Angle(radians: .pi),
                    endAngle: Angle(radians: 0),
                    clockwise: true)
        
        // Top right circle
        path.addArc(center: CGPoint(x: width * 3 / 4, y: height - topCurveHeight),
                    radius: width / 4,
                    startAngle: Angle(radians: .pi),
                    endAngle: Angle(radians: 0),
                    clockwise: true)
        
        // Top right curve
        path.addCurve(to: CGPoint(x: width / 2, y: height),
                      control1: CGPoint(x: width, y: height - topCurveHeight / 2),
                      control2: CGPoint(x: width * 3 / 4, y: height))
        
        return path
    }
}

struct CanvasDrawingView: View {
    @Binding var selectedColor: Color
    @State private var lines: [Line] = []
    @State private var imagePositions: [CGPoint] = []
    let image: Image = Image(systemName: "star.fill") // Example image
    
    
    var body: some View {
        VStack {
            Canvas { context, size in
//                for position in imagePositions {
//                    // Als ik patroon wil gaan tekenen heb ik het volgende nodig. Tijdens het tekenen van een image, een specifiek gedeelte van de image pakken waar de gebruiker op dat moment aan het tekenen is.
//                    let uiImage = UIImage(systemName: "star.fill")! // Example to get a UIImage
//                    let backgroundImageTest = Image("pawpatrol-background")
////                        .resizable()
////                        .aspectRatio(contentMode: .fit)
////                        .frame(width: 50, height: 50)
////                        .clipShape(Circle())
////                        .compositingGroup()
////                    context.draw(Image("pattern2"), at: position)
//                    context.draw(backgroundImageTest, at: position)
//                }
                for line in lines {
                    var path = Path()
                    path.addLines(line.points)
                    
//                    context.stroke(path, with: .color(line.color), style: StrokeStyle(
//                        lineWidth: 5,
//                        lineCap: .round,
//                        lineJoin: .round
//                    ))
                    
//                    context.stroke(path, with: GraphicsContext.Shading.linearGradient(Gradient(colors: [.green, .blue]), startPoint: line.points.first!, endPoint: line.points.last!))
                    
                    context.stroke(path, with: GraphicsContext.Shading.tiledImage(Image("pattern")), style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
//
//                    // Weird spraycan effect
//                    //                    drawSprayCanEffect(for: line, on: context)
//                    
                }
            }
            .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                .onChanged({ value in
                    let position = value.location
                    imagePositions.append(position)
                    
                    if value.translation == .zero {
                        lines.append(Line(points: [position], color: selectedColor))
                    } else {
                        guard let lastIndex = lines.indices.last else {
                            return
                        }
                        
                        lines[lastIndex].points.append(position)
                    }
                }))
        }
    }
    
    func drawSprayCanEffect(for line: Line, on context: GraphicsContext) {
           let sprayRadius: CGFloat = 20 // Increased for visibility
           let dotsPerPoint: Int = 10 // Increased for density

           for point in line.points {
               for _ in 0..<dotsPerPoint {
                   let randomPoint = CGPoint(
                       x: point.x + CGFloat.random(in: -sprayRadius...sprayRadius),
                       y: point.y + CGFloat.random(in: -sprayRadius...sprayRadius)
                   )
                   let dotPath = Path(ellipseIn: CGRect(origin: randomPoint, size: CGSize(width: 20, height: 20))) // Increased dot size
                   context.fill(dotPath, with: .color(line.color.opacity(0.7))) // Increased opacity for visibility
               }
           }
           print("Drew spray effect for \(line.points.count) points") // Debugging print statement
       }
    
//    func calculatePointsForHearts(from startPoint: CGPoint, to endPoint: CGPoint, spacing: CGFloat) -> [CGPoint] {
//        let totalDistance = sqrt(pow(endPoint.x - startPoint.x, 2) + pow(endPoint.y - startPoint.y, 2))
//        let numberOfHearts = Int(floor(totalDistance / spacing))
//        var points: [CGPoint] = []
//
//        for i in 0..<numberOfHearts {
//            let t = CGFloat(i) / CGFloat(numberOfHearts)
//            let x = startPoint.x + t * (endPoint.x - startPoint.x)
//            let y = startPoint.y + t * (endPoint.y - startPoint.y)
//            points.append(CGPoint(x: x, y: y))
//        }
//
//        return points
//    }
}

#Preview {
    CanvasDrawingView(selectedColor: .constant(.orange))
}

extension Image {
    var cgImage: CGImage? {
        let uiImage = UIImage(systemName: "star.fill")!
        return uiImage.cgImage
    }
}

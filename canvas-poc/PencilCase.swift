//
//  PencilCase.swift
//  canvas-poc
//
//  Created by Henry Brinkman on 15/07/2024.
//


import SwiftUI

struct PencilTip: Shape {
    let nLines: Int
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let lineSpace = rect.width / CGFloat(nLines)
        for i in 0..<nLines {
            var x = (CGFloat(i) * lineSpace) + (CGFloat.random(in: 0...1) * lineSpace)
            path.move(to: CGPoint(x: x, y: rect.minY))
            x = (CGFloat(i) * lineSpace) + (CGFloat.random(in: 0...1) * lineSpace)
            path.addLine(to: CGPoint(x: x, y: rect.maxY))
            var y = (CGFloat(i) * lineSpace) + (CGFloat.random(in: 0...1) * lineSpace)
            path.move(to: CGPoint(x: rect.minX, y: y))
            y = (CGFloat(i) * lineSpace) + (CGFloat.random(in: 0...1) * lineSpace)
            path.addLine(to: CGPoint(x: rect.maxX, y: y))
        }
        return path
    }
}

class PencilCase {

    let nTipsPerSize = 7
    let scalingFactor = CGFloat(20)
    let scaledLineWidth = CGFloat(10)
    let scaledBlurRadius = CGFloat(8)

    typealias Images = [Image]
    typealias PencilTips = [CGFloat: Images]
    private var colorMap = [Color: PencilTips]()

    private func point2TipIndex(_ point: CGPoint) -> Int {
        Int(100 * abs(point.x + point.y)) % nTipsPerSize
    }

    private func scaledRectangle(lineWidth: CGFloat) -> CGRect {
        CGRect(x: 0, y: 0, width: lineWidth * scalingFactor, height: lineWidth * scalingFactor)
    }

    private func createPencilTip(color: Color, lineWidth: CGFloat) -> Image {
        Image(size: CGSize(width: lineWidth, height: lineWidth)) { context in
            context.scaleBy(x: 1.0 / self.scalingFactor, y: 1.0 / self.scalingFactor)
            context.addFilter(.shadow(color: color, radius: self.scaledBlurRadius))
            context.clip(to: Path(ellipseIn: self.scaledRectangle(lineWidth: lineWidth)))
            context.stroke(
                PencilTip(nLines: max(1, Int(lineWidth.squareRoot())))
                    .path(in: self.scaledRectangle(lineWidth: lineWidth)),
                with: .color(color.opacity(0.8)),
                lineWidth: self.scaledLineWidth
            )
        }
    }

    private func createPencilTips(color: Color, lineWidth: CGFloat) -> Images {
        var result = Images()
        result.reserveCapacity(nTipsPerSize)
        for _ in 0..<nTipsPerSize {
            result.append(createPencilTip(color: color, lineWidth: lineWidth))
        }
        return result
    }

    func pencilTip(color: Color, lineWidth: CGFloat, point: CGPoint) -> Image {
        let result: Image
        if let pencilTips = colorMap[color] {
            if let existingTips = pencilTips[lineWidth] {
                result = existingTips[point2TipIndex(point)]
            } else {
                let tips = createPencilTips(color: color, lineWidth: lineWidth)
                colorMap[color]?[lineWidth] = tips
                result = tips[point2TipIndex(point)]
            }
        } else {
            let tips = createPencilTips(color: color, lineWidth: lineWidth)
            colorMap[color] = [lineWidth: tips]
            result = tips[point2TipIndex(point)]
        }
        return result
    }
}

enum DrawingTool {
    case pen
    case pencil
    case marker
}

struct LinePencilCase {
    let tool: DrawingTool
    var points: [CGPoint]
    let color: Color
    let lineWidth: CGFloat
}

struct PencilCaseContentView: View {

    @State private var lines: [LinePencilCase] = []
    // selecting color and line width
    @State private var selectedColor = Color.orange
    @State private var selectedLineWidth: CGFloat = 7
    @State private var drawingTool = DrawingTool.pen

    private let pencilCase = PencilCase()

    private func pencilLine(
        ctx: GraphicsContext,
        pointA: CGPoint,
        pointB: CGPoint,
        color: Color,
        lineWidth: CGFloat
    ) {
        // Determine the length of the line
        var x = pointA.x
        var y = pointA.y
        let dx = pointB.x - x
        let dy = pointB.y - y
        let len = ((dx * dx) + (dy * dy)).squareRoot()

        // Determine the number of steps and the step sizes,
        // aiming for approx. 1 step per pixel of length
        let nSteps = max(1, Int(len + 0.5))
        let stepX = dx / CGFloat(nSteps)
        let stepY = dy / CGFloat(nSteps)

        // Draw the points of the line
        for _ in 0..<nSteps {
            let point = CGPoint(x: x, y: y)
            let pencilTip = pencilCase.pencilTip(
                color: color,
                lineWidth: lineWidth,
                point: point
            )
            ctx.draw(pencilTip, at: point)
            x += stepX
            y += stepY
        }
    }

    private func connectPointsWithPencil(ctx: GraphicsContext, line: LinePencilCase) {
        var lastPoint: CGPoint?
        for point in line.points {
            if let lastPoint {
                pencilLine(
                    ctx: ctx,
                    pointA: lastPoint,
                    pointB: point,
                    color: line.color,
                    lineWidth: line.lineWidth
                )
            }
            lastPoint = point
        }
    }

    var body: some View {
        VStack {

            Spacer()

            //Canvas for drawing
            Canvas { ctx, size in
                for line in lines {
                    if line.tool == .pencil {
                        connectPointsWithPencil(ctx: ctx, line: line)
                    } else {
                        var path = Path()
                        path.addLines(line.points)
                        ctx.stroke(
                            path,
                            with: .color(line.color),
                            style: StrokeStyle(
                                lineWidth: line.lineWidth,
                                lineCap: lineCapIs(tool: line.tool),
                                lineJoin: .round
                            )
                        )
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 390)
            .border(.gray)
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onChanged { value in
                        let position = value.location
                        if value.translation == .zero {
                            lines.append(
                                LinePencilCase(
                                    tool: drawingTool,
                                    points: [position],
                                    color: selectedColor,
                                    lineWidth: selectedLineWidth
                                )
                            )
                        } else {
                            guard let lastIdx = lines.indices.last else {
                                return
                            }
                            lines[lastIdx].points.append(position)
                        }
                    }
            )
            .padding(.horizontal)
            .padding(.bottom, 100)

            // bottom tool display
            VStack {
                HStack{
                    Spacer()
                    toolSymbol(tool: .pen, imageName: "paintbrush.pointed.fill")
                    toolSymbol(tool: .pencil, imageName: "pencil")
                    toolSymbol(tool: .marker, imageName: "paintbrush.fill")

                    ColorPicker("Color", selection: $selectedColor)
                        .padding()
                        .font(.largeTitle)
                        .labelsHidden()
                    Spacer()
                    clearButton()
                    Spacer()

                }
                Slider(value: $selectedLineWidth, in: 1...20)
                    .frame(width:200)
                    .accentColor(selectedColor)
            }
            .background(.gray.opacity(0.3))
        }
    }

    func clearButton() -> some View {
        Button {
            lines = []
        } label: {
            Image(systemName: "pencil.tip.crop.circle.badge.minus")
                .font(.largeTitle)
                .foregroundColor(.gray)
        }
    }

    private func toolSymbol(tool: DrawingTool, imageName: String) -> some View {
        Button { drawingTool = tool } label: {
            Image(systemName: imageName)
                .font(.title)
                .foregroundColor(drawingTool == tool ? selectedColor : .gray)
            }
    }

    func lineCapIs(tool: DrawingTool) -> CGLineCap {
        tool == .marker ? .square : .round
    }
}

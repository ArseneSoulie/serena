//
//  Untitled.swift
//  serena
//
//  Created by A S on 28/07/2025.
//

// https://kanjivg.tagaini.net/svg-format.html

import Foundation

struct KanjiVGParser {
    
}

struct KanjiStrokes {
    let strokes: [Stroke]
    
    init(from: URL) throws {
        throw KanjiVGError.malformedSVG
    }
}

struct Stroke: Identifiable {
    let id: String
    let pathPoints: [CGPoint]
    let index: Int
    let groups: [StrokeGroup]
}

struct StrokeGroup: Identifiable {
    let id: String
    let element: String
    let number: Int?
    let original: String?
    let part: Int?
    let partial: Bool?
    let phon: String?
    let position: StrokePosition?
    let radical: StrokeRadical?
    let radicalForm: Bool?
    let tradForm: Bool?
}

enum StrokeRadical {
    case general
    case jis
    case nelson
    case tradit
}

enum StrokePosition {
    case bottom
    case kamae
    case left
    case nyo
    case nyoc
    case right
    case tare
    case tarec
    case top
    
}

enum KanjiVGError: Error {
    case malformedSVG
}


import SwiftUI

struct a :View {
    @State private var drawAmount: CGFloat = 1.0
    
    var body: some View {
        VStack {
            KanjiPath()
                .trim(from: 0, to: drawAmount)
                .stroke(Color.blue, style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                .frame(width: 100, height: 100)
            Button("reset and draw") {
                drawAmount = 0.0
                withAnimation(.linear(duration: 2)) {
                    drawAmount = 1.0
                }
            }
        }
    }
}

let pathStrings = [
    "M27.62,14.5C31.86,18.35,36.4,25.08,37,27",
    "M49.5,11.5c1.78,2.24,6.04,8.11,6.75,11.75",
    "M78.25,11.38c0.31,1.17,0.04,2.02-0.72,3.29c-1.6,2.64-5.07,6.81-8.27,9.84",
    "M27.84,34.42c0.74,0.74,1.62,1.83,1.81,2.99c1.11,7.07,2.33,14.25,3.58,22.59c0.27,1.79,0.54,3.63,0.81,5.53",
    "M30,35.64c12.75-1.67,34.38-3.91,44.27-4.89c4.19-0.41,7.11,1.25,6.41,5.01c-1.16,6.21-2.86,13.91-4.67,20.03c-0.48,1.63-0.97,3.14-1.46,4.48",
    "M32.57,48.36c8.93-1.23,39.31-4.11,45.02-4.19",
    "M34.66,61.04C46.38,60,61,58.62,74.38,57.71",
    "M12.25,76.95c2.54,0.54,7.24,0.78,9.76,0.54c19.5-1.87,43.7-3.62,66.71-4.48c4.23-0.16,6.79,0.26,8.91,0.53",
    "M52.99,35.86c0.89,0.89,1.59,2.19,1.6,3.48c0.04,5.51-0.01,38.66-0.03,53.79c0,2.88,0,5.11,0,6.39"
]

struct KanjiPath: Shape {
    func path(in rect: CGRect) -> Path {
        let cgPath = CGMutablePath()
        for pathString in pathStrings {
            cgPath.addPath(try! CGPath.from(svgPath: pathString, invertYAxis: true))
        }
        let absolutePath = Path(cgPath)
        let boundingRect = absolutePath.boundingRect
        let scale = min(rect.width/boundingRect.width, rect.height/boundingRect.height)
        let scaled = absolutePath.applying(.init(scaleX: scale, y: scale))
        let scaledBoundingRect = scaled.boundingRect
        let offsetX = scaledBoundingRect.midX - rect.midX
        let offsetY = scaledBoundingRect.midY - rect.midY
        return scaled.offsetBy(dx: -offsetX, dy: -offsetY)
    }
}

#Preview {
    a()
}

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

#if canImport(CoreGraphics)
import CoreGraphics
extension Stroke {
    var cgPath: CGPath {
        let path = CGMutablePath()
        guard let first = pathPoints.first else { return path }

        path.move(to: first)
        for point in pathPoints.dropFirst() {
            path.addLine(to: point)
        }

        return path.copy()!
    }
}
#endif

#if canImport(SwiftUI)
import SwiftUI

extension Stroke {
    @available(iOS 13.0, *)
    var swiftUIPath: Path {
        Path(cgPath)
    }
}
#endif

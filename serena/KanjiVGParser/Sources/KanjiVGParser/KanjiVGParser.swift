//
//  KanjiVGParser.swift
//  serena
//
//  Created by A S on 28/07/2025.
//

// https://kanjivg.tagaini.net/svg-format.html

import Foundation

struct Stroke: Identifiable {
    let id: String
    let path: Path
    let index: Int
    let groups: [StrokeGroup]
}

struct KVGStroke: Identifiable {
    let id: String
    let pathString: String
}

extension KVGStroke {
    init?(attributeDict: [String: String]) {
        guard
            let id = attributeDict["id"],
            let pathString = attributeDict["d"] else {
            return nil
        }

        self.id = id
        self.pathString = pathString
    }
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

extension StrokeGroup {
    init?(attributeDict: [String: String]) {
        guard
            let id = attributeDict["id"],
            let element = attributeDict["kvg:element"] else {
            return nil
        }

        self.id = id
        self.element = element
        number = attributeDict["kvg:number"].flatMap(Int.init)
        original = attributeDict["kvg:original"]
        part = attributeDict["kvg:part"].flatMap(Int.init)
        partial = attributeDict["kvg:partial"].flatMap(Self.boolValue)
        phon = attributeDict["kvg:phon"]
        position = attributeDict["kvg:position"].flatMap(StrokePosition.init)
        radical = attributeDict["kvg:radical"].flatMap(StrokeRadical.init)
        radicalForm = attributeDict["kvg:radicalForm"].flatMap(Self.boolValue)
        tradForm = attributeDict["kvg:tradForm"].flatMap(Self.boolValue)
    }

    private static func boolValue(_ str: String) -> Bool? {
        switch str.lowercased() {
        case "true", "1", "yes": true
        case "false", "0", "no": false
        default: nil
        }
    }
}

enum StrokeRadical: String {
    case general
    case jis
    case nelson
    case tradit
}

enum StrokePosition: String {
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

import SwiftUI

final class KanjiVGParser: NSObject, XMLParserDelegate {
    private var strokeGroupStack: [StrokeGroup] = []
    private var strokes: [Stroke] = []
    private var currentElement = ""

    func parse(data: Data) -> [Stroke] {
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
        return strokes
    }

    // MARK: - XMLParserDelegate

    func parser(
        _: XMLParser,
        didStartElement elementName: String,
        namespaceURI _: String?,
        qualifiedName _: String?,
        attributes attributeDict: [String: String] = [:],
    ) {
        if elementName == "g", let strokeGroup = StrokeGroup(attributeDict: attributeDict) {
            strokeGroupStack.append(strokeGroup)
        } else if
            elementName == "path", let kvgStroke = KVGStroke(attributeDict: attributeDict),
            let path = path(pathString: kvgStroke.pathString) {
            strokes.append(Stroke(
                id: kvgStroke.id,
                path: path,
                index: strokes.count,
                groups: strokeGroupStack,
            ))
        }
    }

    func parser(
        _: XMLParser,
        didEndElement elementName: String,
        namespaceURI _: String?,
        qualifiedName _: String?,
    ) {
        if elementName == "g" {
            _ = strokeGroupStack.popLast()
        }
    }

    func path(pathString: String) -> Path? {
        guard let cgPath = try? CGPath.from(svgPath: pathString, invertYAxis: true) else { return nil }
        return Path(cgPath)
    }
}

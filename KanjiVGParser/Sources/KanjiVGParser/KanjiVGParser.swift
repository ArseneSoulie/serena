//
//  Untitled.swift
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
        guard let id = attributeDict["id"],
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
        guard let id = attributeDict["id"],
              let element = attributeDict["kvg:element"] else {
            return nil
        }
        
        self.id = id
        self.element = element
        self.number = attributeDict["kvg:number"].flatMap(Int.init)
        self.original = attributeDict["kvg:original"]
        self.part = attributeDict["kvg:part"].flatMap(Int.init)
        self.partial = attributeDict["kvg:partial"].flatMap(Self.boolValue)
        self.phon = attributeDict["kvg:phon"]
        self.position = attributeDict["kvg:position"].flatMap(StrokePosition.init)
        self.radical = attributeDict["kvg:radical"].flatMap(StrokeRadical.init)
        self.radicalForm = attributeDict["kvg:radicalForm"].flatMap(Self.boolValue)
        self.tradForm = attributeDict["kvg:tradForm"].flatMap(Self.boolValue)
    }
    
    private static func boolValue(_ str: String) -> Bool? {
        switch str.lowercased() {
        case "true", "1", "yes": return true
        case "false", "0", "no": return false
        default: return nil
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

import Foundation
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
        _ parser: XMLParser,
        didStartElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?,
        attributes attributeDict: [String : String] = [:]
    ) {
        if elementName == "g", let strokeGroup = StrokeGroup.init(attributeDict: attributeDict) {
            strokeGroupStack.append(strokeGroup)
        } else if elementName == "path", let kvgStroke = KVGStroke.init(attributeDict: attributeDict), let path = path(pathString: kvgStroke.pathString) {
            strokes.append(Stroke(
                id: kvgStroke.id,
                path: path,
                index: strokes.count,
                groups: strokeGroupStack
            ))
        }
    }
    
    func parser(
        _ parser: XMLParser,
        didEndElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?
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


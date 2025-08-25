//
//  UserKanaMnemonics.swift
//  UserKanaMnemonics
//
//  Created by A S on 25/08/2025.
//

struct UserKanaMnemonics: Codable {
    var mnemonics: [String: UserKanaMnemonic]
}

struct UserKanaMnemonic: Codable {
    let writtenMnemonic: String?
    let drawingMnemonic: String?
}

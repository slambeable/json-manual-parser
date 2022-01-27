//
//  JSONData.swift
//  JSONManualParser
//
//  Created by Андрей Евдокимов on 27.01.2022.
//

import Foundation

struct Deck {
    let success: Bool
    let deckId: String
    let shuffled: Bool?
    let cards: [[String: Any]]?
    let remaining: Int
}

struct Card {
    let image: String
    let value: String
    let suit: String
    let code: String
}

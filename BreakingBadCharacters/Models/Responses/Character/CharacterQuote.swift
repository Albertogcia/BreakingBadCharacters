//
//  CharacterQuote.swift
//  BreakingBadCharacters
//
//  Created by Alberto García Antuña on 27/3/22.
//

import Foundation

struct CharacterQuote: Codable {
    
    let id: Int?
    let quote: String?
    
    private enum CodingKeys: String, CodingKey {
        case id = "quote_id"
        case quote
    }
}

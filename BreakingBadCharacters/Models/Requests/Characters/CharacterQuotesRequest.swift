//
//  CharacterQuotesRequest.swift
//  BreakingBadCharacters
//
//  Created by Alberto García Antuña on 27/3/22.
//

import Foundation

struct CharacterQuotesRequest: APIRequest {
    
    let characterName: String
    
    typealias Response = [CharacterQuote]
    
    init(characterName: String){
        self.characterName = characterName
    }
    
    var method: Method {
        .GET
    }
    
    var path: String {
        return "/quote"
    }
    
    var parameters: [String: String] {
        return ["author": characterName]
    }
    
    var body: [String: Any] {
        return [:]
    }
    
    var headers: [String: String] {
        return [:]
    }
}


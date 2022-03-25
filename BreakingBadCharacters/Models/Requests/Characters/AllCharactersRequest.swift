//
//  AllCharactersRequest.swift
//  BreakingBadCharacters
//
//  Created by Alberto García Antuña on 24/3/22.
//

import Foundation

struct AllCharactersRequest: APIRequest {
    
    typealias Response = [Character]
    
    var method: Method {
        .GET
    }
    
    var path: String {
        return "/characters"
    }
    
    var parameters: [String: String] {
        return [:]
    }
    
    var body: [String: Any] {
        return [:]
    }
    
    var headers: [String: String] {
        return [:]
    }
}

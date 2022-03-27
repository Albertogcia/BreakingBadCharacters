//
//  RemoteDataManager.swift
//  BreakingBadCharacters
//
//  Created by Alberto García Antuña on 24/3/22.
//

import Foundation

protocol RemoteDataManager {
    func fetchAllCharacters(completion: @escaping (Result<[Character]?, Error>) -> ())
    
    func fetchCharacterQuotes(characterName: String, completion: @escaping (Result<[CharacterQuote]?, Error>) -> ())
}

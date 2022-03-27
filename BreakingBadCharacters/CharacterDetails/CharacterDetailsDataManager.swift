//
//  CharacterDetailsDataManager.swift
//  BreakingBadCharacters
//
//  Created by Alberto García Antuña on 27/3/22.
//

import Foundation

protocol CharacterDetailsDataManager {
    func fetchCharacterQuotes(characterName: String, completion: @escaping (Result<[CharacterQuote]?, Error>) -> ())
}

extension DataManager: CharacterDetailsDataManager {
    func fetchCharacterQuotes(characterName: String, completion: @escaping (Result<[CharacterQuote]?, Error>) -> ()) {
        remoteDataManager.fetchCharacterQuotes(characterName: characterName, completion: completion)
    }
}

//
//  CharactersDataManager.swift
//  BreakingBadCharacters
//
//  Created by Alberto García Antuña on 24/3/22.
//

import Foundation

protocol CharactersDataManager {
    func fetchAllCharacters(completion: @escaping (Result<[Character]?, Error>) -> ())
}

extension DataManager: CharactersDataManager {
    func fetchAllCharacters(completion: @escaping (Result<[Character]?, Error>) -> ()) {
        remoteDataManager.fetchAllCharacters(completion: completion)
    }
}

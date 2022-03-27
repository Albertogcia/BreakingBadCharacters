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
        remoteDataManager.fetchAllCharacters { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(characters):
                self.addCharactersToCache(characters: characters)
                completion(.success(characters))
            case .failure:
                self.localDataManager.fetchAllCharacters { result in
                    switch result {
                    case let .success(characters):
                        completion(.success(characters))
                    case let .failure(error):
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    private func addCharactersToCache(characters: [Character]?){
        guard let characters = characters else { return }
        localDataManager.deleteAllCharacters { error in
            guard error == nil else { return }
            self.localDataManager.insertCharacters(characters) { _ in }
        }

    }
}

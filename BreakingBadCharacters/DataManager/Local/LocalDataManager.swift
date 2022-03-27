//
//  LocalDataManager.swift
//  BreakingBadCharacters
//
//  Created by Alberto García Antuña on 24/3/22.
//

import Foundation

protocol LocalDataManager {
    
    func fetchAllCharacters(completion: @escaping (Result<[Character]?, Error>) -> Void)
    
    func insertCharacters(_ characters: [Character], completion: @escaping (Error?) -> Void)
    
    func deleteAllCharacters(completion: @escaping (Error?) -> Void)
}

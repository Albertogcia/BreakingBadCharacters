//
//  URLSessionRemoteDataManagerImp.swift
//  BreakingBadCharacters
//
//  Created by Alberto García Antuña on 24/3/22.
//

import Foundation
 
class URLSessionImp: RemoteDataManager{
    
    let session: SessionAPI
    
    init(session: SessionAPI){
        self.session = session
    }
    
    func fetchAllCharacters(completion: @escaping (Result<[Character]?, Error>) -> ()) {
        let request = AllCharactersRequest()
        session.send(request: request, completion: completion)
    }
    
    func fetchCharacterQuotes(characterName: String, completion: @escaping (Result<[CharacterQuote]?, Error>) -> ()) {
        let request = CharacterQuotesRequest(characterName: characterName)
        session.send(request: request, completion: completion)
    }
    
}

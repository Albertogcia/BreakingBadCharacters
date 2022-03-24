//
//  CharactersViewModel.swift
//  BreakingBadCharacters
//
//  Created by Alberto García Antuña on 24/3/22.
//

import Foundation

protocol CharactersCoordinatorDelegate: AnyObject{
    
}

protocol CharactersViewDelegate: AnyObject {
    
}

class CharactersViewModel{
    weak var coordinatorDelegate: CharactersCoordinatorDelegate?
    weak var viewDelgate: CharactersViewDelegate?
    let charactersDataManager: CharactersDataManager
    
    init(charactersDataManager: CharactersDataManager){
        self.charactersDataManager = charactersDataManager
    }
}

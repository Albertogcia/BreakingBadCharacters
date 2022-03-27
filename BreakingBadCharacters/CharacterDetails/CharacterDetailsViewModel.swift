//
//  CharacterDetailsViewModel.swift
//  BreakingBadCharacters
//
//  Created by Alberto García Antuña on 27/3/22.
//

import Foundation

protocol CharacterDetailsViewDelegate: AnyObject {}

class CharacterDetailsViewModel {
    weak var viewDelgate: CharacterDetailsViewDelegate?
    let characterDetailsDataManager: CharacterDetailsDataManager
    let character: Character

    init(characterDetailsDataManager: CharacterDetailsDataManager, character: Character) {
        self.characterDetailsDataManager = characterDetailsDataManager
        self.character = character
    }
}

//
//  CharactersCoordinator.swift
//  BreakingBadCharacters
//
//  Created by Alberto García Antuña on 24/3/22.
//

import Foundation
import UIKit

class CharactersCoordinator: Coordinator {
    let presenter: UINavigationController
    let charactersDataManager: CharactersDataManager
    let characterDetailsDataManager: CharacterDetailsDataManager

    init(presenter: UINavigationController, charactersDataManager: CharactersDataManager, characterDetailsDataManager: CharacterDetailsDataManager) {
        self.presenter = presenter
        self.charactersDataManager = charactersDataManager
        self.characterDetailsDataManager = characterDetailsDataManager
    }

    override func start() {
        let charactersViewModel = CharactersViewModel(charactersDataManager: charactersDataManager)
        let charactersViewController = CharactersViewController(viewModel: charactersViewModel)
        charactersViewModel.viewDelgate = charactersViewController
        charactersViewModel.coordinatorDelegate = self
        presenter.pushViewController(charactersViewController, animated: true)
    }

    override func finish() {}
}

extension CharactersCoordinator: CharactersCoordinatorDelegate {
    func didSelect(character: Character) {
        let characterDetailsViewModel = CharacterDetailsViewModel(characterDetailsDataManager: characterDetailsDataManager, character: character)
        let characterDetailsViewController = CharacterDetailsViewController(viewModel: characterDetailsViewModel)
        characterDetailsViewModel.viewDelegate = characterDetailsViewController
        presenter.pushViewController(characterDetailsViewController, animated: true)
    }
}

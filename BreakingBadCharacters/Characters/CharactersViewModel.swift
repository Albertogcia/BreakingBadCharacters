//
//  CharactersViewModel.swift
//  BreakingBadCharacters
//
//  Created by Alberto García Antuña on 24/3/22.
//

import Foundation

protocol CharactersCoordinatorDelegate: AnyObject {
    func didSelect(character: Character)
}

protocol CharactersViewDelegate: AnyObject {
    func charactersFetched()
    func errorFetchingCharacters(error: Error)
}

class CharactersViewModel {
    weak var coordinatorDelegate: CharactersCoordinatorDelegate?
    weak var viewDelgate: CharactersViewDelegate?
    let charactersDataManager: CharactersDataManager

    var breakingBadCharacters: [Character] = []
    var betterCallSaulCharacters: [Character] = []

    var hasData: Bool {
        return !breakingBadCharacters.isEmpty || !betterCallSaulCharacters.isEmpty
    }

    init(charactersDataManager: CharactersDataManager) {
        self.charactersDataManager = charactersDataManager
    }

    func fetchAllCharacters() {
        breakingBadCharacters = []
        betterCallSaulCharacters = []
        charactersDataManager.fetchAllCharacters { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(characters):
                self.groupCharacters(characters: characters)
            case let .failure(error):
                self.viewDelgate?.errorFetchingCharacters(error: error)
            }
        }
    }

    private func groupCharacters(characters: [Character]?) {
        for character in characters ?? [] {
            if !(character.breakingBadSeasonsAppearance ?? []).isEmpty {
                breakingBadCharacters.append(character)
            }
            if !(character.betterCallSaulSeasonsAppearance ?? []).isEmpty {
                betterCallSaulCharacters.append(character)
            }
        }
        viewDelgate?.charactersFetched()
    }

    // MARK: - TableView helper methods

    func numberOfSections() -> Int {
        return 2
    }

    func numberOfRows(in section: Int) -> Int {
        switch section {
        case 0:
            return breakingBadCharacters.count
        case 1:
            return betterCallSaulCharacters.count
        default:
            return 0
        }
    }

    func character(at indexPath: IndexPath) -> Character? {
        if indexPath.section == 0 {
            return breakingBadCharacters[indexPath.row]
        }
        else if indexPath.section == 1 {
            return betterCallSaulCharacters[indexPath.row]
        }
        return nil
    }

    func didSelectRow(at indexPath: IndexPath) {
        if indexPath.section == 0 {
            coordinatorDelegate?.didSelect(character: breakingBadCharacters[indexPath.row])
        }
        else if indexPath.section == 1 {
            coordinatorDelegate?.didSelect(character: betterCallSaulCharacters[indexPath.row])
        }
    }
}

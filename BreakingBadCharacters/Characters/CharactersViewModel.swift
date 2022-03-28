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
    private let charactersDataManager: CharactersDataManager

    private var allCharacters: [Character] = []
    private var filteredCharacters: [Character] = []

    internal var breakingBadCharacters: [Character] = []
    internal var betterCallSaulCharacters: [Character] = []

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
                self.allCharacters = characters ?? []
                self.filteredCharacters = self.allCharacters
                self.groupCharacters()
            case let .failure(error):
                self.viewDelgate?.errorFetchingCharacters(error: error)
            }
        }
    }

    private func groupCharacters() {
        breakingBadCharacters = filteredCharacters.filter { !($0.breakingBadSeasonsAppearance ?? []).isEmpty }
        betterCallSaulCharacters = filteredCharacters.filter { !($0.betterCallSaulSeasonsAppearance ?? []).isEmpty }
        //
        viewDelgate?.charactersFetched()
    }

    func filterCharactersBy(_ text: String?) {
        guard let text = text, !text.trimmingCharacters(in: .whitespaces).isEmpty else {
            filteredCharacters = allCharacters
            groupCharacters()
            return
        }
        filteredCharacters = allCharacters.filter { character in
            guard let name = character.characterName, let actorName = character.actorName else { return false }
            return name.lowercased().contains(text.lowercased()) || actorName.lowercased().contains(text.lowercased())
        }
        groupCharacters()
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

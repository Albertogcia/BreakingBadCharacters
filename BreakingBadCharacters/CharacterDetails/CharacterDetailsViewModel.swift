//
//  CharacterDetailsViewModel.swift
//  BreakingBadCharacters
//
//  Created by Alberto García Antuña on 27/3/22.
//

import Foundation

protocol CharacterDetailsViewDelegate: AnyObject {
    func quotesFetched()
}

class CharacterDetailsViewModel {
    weak var viewDelegate: CharacterDetailsViewDelegate?
    private let characterDetailsDataManager: CharacterDetailsDataManager
    let character: Character
    //
    let nameValue: String?
    let actorNameValue: String?
    let ageValue: String?
    let breakingBadSeasonsAppearanceValue: String?
    let betterCallSaulSeasonsAppearanceValue: String?
    //
    var quotes: [CharacterQuote] = []

    init(characterDetailsDataManager: CharacterDetailsDataManager, character: Character) {
        self.characterDetailsDataManager = characterDetailsDataManager
        self.character = character
        //
        self.nameValue = character.characterName
        self.actorNameValue = character.actorName
        if let age = character.age { self.ageValue = String(age) } else { self.ageValue = NSLocalizedString("global_unknown", comment: "") }
        self.breakingBadSeasonsAppearanceValue = !(character.breakingBadSeasonsAppearance ?? []).isEmpty ? character.breakingBadSeasonsAppearance?.map { String($0) }.joined(separator: " ") : NSLocalizedString("details_no_season_appearance", comment: "")
        self.betterCallSaulSeasonsAppearanceValue = !(character.betterCallSaulSeasonsAppearance ?? []).isEmpty ? character.betterCallSaulSeasonsAppearance?.map { String($0) }.joined(separator: " ") : NSLocalizedString("details_no_season_appearance", comment: "")
    }

    func getCharacterQuotes() {
        characterDetailsDataManager.fetchCharacterQuotes(characterName: character.characterName ?? "") { [weak self] response in
            guard let self = self else { return }
            if case let .success(quotes) = response, let quotes = quotes {
                self.quotes = quotes
            }
            self.viewDelegate?.quotesFetched()
        }
    }

    func isQuotesEmpty() -> Bool {
        return quotes.isEmpty
    }

    func numberOfQuotes() -> Int {
        return quotes.count
    }

    func getQuoteFor(index: Int) -> CharacterQuote {
        return quotes[index]
    }
}

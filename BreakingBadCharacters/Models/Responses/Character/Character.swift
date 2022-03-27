//
//  Character.swift
//  BreakingBadCharacters
//
//  Created by Alberto García Antuña on 24/3/22.
//

import Foundation

struct Character: Codable {
    let id: Int?
    let imageUrl: URL?
    let characterName: String?
    let actorName: String?
    let birthdayString: String?
    var age: Int? {
        return getAge()
    }

    let breakingBadSeasonsAppearance: [Int]?
    let betterCallSaulSeasonsAppearance: [Int]?

    init(id: Int?, imageUrl: URL?, characterName: String?, actorName: String?, birthdayString: String?, bbAppearence: String?, bcsAppearence: String?) {
        self.id = id
        self.imageUrl = imageUrl
        self.characterName = characterName
        self.actorName = actorName
        self.birthdayString = birthdayString
        self.breakingBadSeasonsAppearance = bbAppearence?.split(separator: ",").compactMap { Int($0) }
        self.betterCallSaulSeasonsAppearance = bcsAppearence?.split(separator: ",").compactMap { Int($0) }
    }
    
    init(id: Int?, imageUrl: URL?, characterName: String?, actorName: String?, birthdayString: String?, bbAppearence: [Int]?, bcsAppearence: [Int]?) {
        self.id = id
        self.imageUrl = imageUrl
        self.characterName = characterName
        self.actorName = actorName
        self.birthdayString = birthdayString
        self.breakingBadSeasonsAppearance = bbAppearence
        self.betterCallSaulSeasonsAppearance = bcsAppearence
    }

    private func getAge() -> Int? {
        guard let birthdayString = birthdayString else { return nil }
        //
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .autoupdatingCurrent
        dateFormatter.dateFormat = "dd-MM-yyyy"
        //
        guard let date = dateFormatter.date(from: birthdayString) else { return nil }
        //
        return Calendar.current.dateComponents([.year], from: date, to: Date()).year
    }

    private enum CodingKeys: String, CodingKey {
        case id = "char_id"
        case imageUrl = "img"
        case characterName = "name"
        case actorName = "portrayed"
        case birthdayString = "birthday"
        case breakingBadSeasonsAppearance = "appearance"
        case betterCallSaulSeasonsAppearance = "better_call_saul_appearance"
    }
}

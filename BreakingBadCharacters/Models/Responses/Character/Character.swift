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
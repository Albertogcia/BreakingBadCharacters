//
//  ManagedCharacter.swift
//  BreakingBadCharacters
//
//  Created by Alberto García Antuña on 26/3/22.
//

import CoreData

@objc(ManagedCharacter)
public class ManagedCharacter: NSManagedObject {
    @NSManaged var id: String?
    @NSManaged var imageUrl: URL?
    @NSManaged var characterName: String?
    @NSManaged var actorName: String?
    @NSManaged var birthdayString: String?
    @NSManaged var breakingBadSeasonsAppearance: String?
    @NSManaged var betterCallSaulSeasonsAppearance: String?
}

extension ManagedCharacter {
    static func getAllCharacters(in context: NSManagedObjectContext) throws -> [ManagedCharacter]? {
        let request = NSFetchRequest<ManagedCharacter>(entityName: "ManagedCharacter")
        request.returnsObjectsAsFaults = false
        return try context.fetch(request)
    }
}

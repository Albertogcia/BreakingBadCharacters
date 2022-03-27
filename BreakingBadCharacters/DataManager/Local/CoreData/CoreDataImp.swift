//
//  CoreDataImp.swift
//  BreakingBadCharacters
//
//  Created by Alberto García Antuña on 24/3/22.
//

import CoreData
import Foundation

class CoreDataImp: LocalDataManager {
    public static let modelName = "Database"
    public static let model = NSManagedObjectModel(name: modelName, in: Bundle(for: CoreDataImp.self))

    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext

    public struct ModelNotFound: Error {
        public let modelName: String
    }

    init() {
        self.container = NSPersistentContainer(name: CoreDataImp.modelName)
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        self.context = container.newBackgroundContext()
    }

    init(storeURL: URL) throws {
        guard let model = CoreDataImp.model else {
            throw ModelNotFound(modelName: CoreDataImp.modelName)
        }

        self.container = try NSPersistentContainer.load(
            name: CoreDataImp.modelName,
            model: model,
            url: storeURL
        )
        self.context = container.newBackgroundContext()
    }

    deinit {
        cleanUpReferencesToPersistentStores()
    }

    private func cleanUpReferencesToPersistentStores() {
        context.performAndWait {
            let coordinator = self.container.persistentStoreCoordinator
            try? coordinator.persistentStores.forEach(coordinator.remove)
        }
    }

    public func fetchAllCharacters(completion: @escaping (Result<[Character]?, Error>) -> Void) {
        performWithCurrentContext { context in
            do {
                if let coreDataCharacters = try ManagedCharacter.getAllCharacters(in: context) {
                    completion(.success(coreDataCharacters.toModel()))
                } else {
                    completion(.success(nil))
                }
            } catch {
                completion(.failure(error))
            }
        }
    }

    public func insertCharacters(_ characters: [Character], completion: @escaping (Error?) -> Void) {
        performWithCurrentContext { context in
            do {
                for character in characters {
                    let managed = ManagedCharacter(context: context)
                    managed.id = String(character.id ?? 0)
                    managed.imageUrl = character.imageUrl
                    managed.characterName = character.characterName
                    managed.actorName = character.actorName
                    managed.birthdayString = character.birthdayString
                    managed.breakingBadSeasonsAppearance = character.breakingBadSeasonsAppearance?.map { String($0) }.joined(separator: ",")
                    managed.betterCallSaulSeasonsAppearance = character.betterCallSaulSeasonsAppearance?.map { String($0) }.joined(separator: ",")
                }
                try context.save()
                completion(nil)
            } catch {
                context.rollback()
                completion(error)
            }
        }
    }

    public func deleteAllCharacters(completion: @escaping (Error?) -> Void) {
        performWithCurrentContext { context in
            do {
                try ManagedCharacter.getAllCharacters(in: context)?.forEach { context.delete($0) }
                try context.save()
                completion(nil)
            } catch {
                context.rollback()
                completion(error)
            }
        }
    }

    private func performWithCurrentContext(_ action: @escaping (NSManagedObjectContext) -> Void) {
        context.perform { [context] in
            action(context)
        }
    }
}

// MARK: - Helpers
private extension Array where Element == ManagedCharacter {
    func toModel() -> [Character] {
        return map { Character(id: Int($0.id ?? "0"), imageUrl: $0.imageUrl, characterName: $0.characterName, actorName: $0.actorName, birthdayString: $0.birthdayString, bbAppearence: $0.breakingBadSeasonsAppearance, bcsAppearence: $0.betterCallSaulSeasonsAppearance) }
    }
}

private extension NSPersistentContainer {
    static func load(name: String, model: NSManagedObjectModel, url: URL) throws -> NSPersistentContainer {
        let description = NSPersistentStoreDescription(url: url)
        let container = NSPersistentContainer(name: name, managedObjectModel: model)
        container.persistentStoreDescriptions = [description]

        var loadError: Swift.Error?
        container.loadPersistentStores { loadError = $1 }
        try loadError.map { throw $0 }

        return container
    }
}

private extension NSManagedObjectModel {
    convenience init?(name: String, in bundle: Bundle) {
        guard let momd = bundle.url(forResource: name, withExtension: "momd") else {
            return nil
        }
        self.init(contentsOf: momd)
    }
}

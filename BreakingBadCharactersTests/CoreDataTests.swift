//
//  CoreDataTests.swift
//  BreakingBadCharactersTests
//
//  Created by Alberto García Antuña on 26/3/22.
//

import BreakingBadCharacters
import CoreData
import Foundation
import XCTest

class CoreDataTests: XCTestCase {
    
    func test_insert_returnNoErrorOnSuccess() throws {
        let sut = try makeSUT()
        
        let insertionError = insert(uniqueCharacters(), to: sut)
        
        XCTAssertNil(insertionError, "Expected to insert cache successfully")
    }
    
    func test_insert_returnErrorOnInsertionError() throws {
        let stub = NSManagedObjectContext.alwaysFailingSaveStub()
        stub.startIntercepting()
        
        let sut = try makeSUT()
        let insertionError = insert(uniqueCharacters(), to: sut)
        
        XCTAssertNotNil(insertionError)
    }
    
    func test_fetch_returnsEmptyOnEmptyCache() throws {
        let sut = try makeSUT()
        
        sut.fetchAllCharacters { result in
            if case let .success(data) = result, let characters = data {
                XCTAssertTrue(characters.isEmpty, "Expected an empty array")
            }
            else {
                XCTFail("Expect empty array of characters but instead got \(result)")
            }
        }
    }
    
    func test_fetch_returnsDataOnNonEmptyCache() throws {
        let sut = try makeSUT()
        let id = 1
        insert([uniqueCharacter(id: id)], to: sut)
        
        sut.fetchAllCharacters { result in
            if case let .success(data) = result, let characters = data {
                XCTAssertEqual(characters.first?.id, id)
            }
            else {
                XCTFail("Expect a characters array but instead got \(result)")
            }
        }
    }
    
    func test_fetch_returnsErrorOnFetchError() throws {
        let stub = NSManagedObjectContext.alwaysFailingFetchStub()
        stub.startIntercepting()
        let sut = try makeSUT()
        
        sut.fetchAllCharacters { result in
            if case let .failure(error) = result {
                XCTAssertNotNil(error)
            }
            else{
                XCTFail("Expect failure but instead got \(result)")
            }
        }
    }
    
    func test_delete_deleteOnEmptyCache() throws {
        let sut = try makeSUT()
        
        let deletionError = delete(to: sut)
        
        XCTAssertNil(deletionError)
    }
    
    func test_delete_deleteWithNonEmptyCache() throws {
        let sut = try makeSUT()
        insert(uniqueCharacters(), to: sut)
        
        let deletionError = delete(to: sut)
        
        XCTAssertNil(deletionError)
    }
    
    func test_delete_returnsErrorOnDeletionError() throws {
        let stub = NSManagedObjectContext.alwaysFailingSaveStub()
        stub.startIntercepting()
        let sut = try makeSUT()
        
        let deletionError = delete(to: sut)
        
        XCTAssertNotNil(deletionError)
    }

    // - MARK: Helpers

    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) throws -> CoreDataImp {
        let sut = try CoreDataImp(storeURL: inMemoryStoreURL())
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }

    private func inMemoryStoreURL() -> URL {
        URL(fileURLWithPath: "/dev/null")
            .appendingPathComponent("\(type(of: self)).store")
    }
    
    func uniqueCharacters() -> [Character] {
        var characters: [Character] = []
        characters.append(uniqueCharacter(id: 1))
        characters.append(uniqueCharacter(id: 2))
        return characters
    }
    
    func uniqueCharacter(id: Int) -> Character {
        return Character(id: id, imageUrl: anyURL(), characterName: "MockName", actorName: "ActorMockName", birthdayString: "02-08-1997", bbAppearence: [1], bcsAppearence: [1])
    }
    
    @discardableResult
    func insert(_ characters: [Character], to sut: CoreDataImp) -> Error? {
        let exp = expectation(description: "Wait for cache insertion")
        var insertionError: Error?
        sut.insertCharacters(characters) { cacheInsertionError in
            insertionError = cacheInsertionError
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        return insertionError
    }
    
    @discardableResult
    func delete(to sut: CoreDataImp) -> Error? {
        let exp = expectation(description: "Wait for cache deletion")
        var deletionError: Error?
        sut.deleteAllCharacters { cacheDeletionError in
            deletionError = cacheDeletionError
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        return deletionError
    }
}

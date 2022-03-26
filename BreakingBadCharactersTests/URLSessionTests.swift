//
//  URLSessionTests.swift
//  BreakingBadCharactersTests
//
//  Created by Alberto García Antuña on 26/3/22.
//

import BreakingBadCharacters
import Foundation
import XCTest

class URLSessionTests: XCTestCase {
    override func setUp() {
        super.setUp()
        URLProtocolStub.startInterceptingRequests()
    }

    override func tearDown() {
        super.tearDown()
        URLProtocolStub.stopInterceptingRequests()
    }

    func test_fetchCharacters_returnCharacterWithSuccessfulResponse() {
        let id = 1
        let imageUrl = "https://any-url.com"
        let characterName = "MockName"
        let actorName = "MockActorName"
        let birthdayString = "09-07-1958"
        let appearence = 1
        let bcsAppearence = 1
        let successfulData = successfulCharacterResponseData(id: id, imageUrl: imageUrl, characterName: characterName, actorName: actorName, birthdayString: birthdayString, appearence: appearence, bcsAppearence: bcsAppearence)
        let sut = makeSUT()

        let exp = expectation(description: "Wait for request")
        sut.fetchAllCharacters { result in
            switch result {
            case let .success(characters):
                if let characters = characters, !characters.isEmpty {
                    let responseCharacter = characters[0]
                    XCTAssertEqual(responseCharacter.id, 1)
                    XCTAssertEqual(responseCharacter.imageUrl, URL(string: imageUrl))
                    XCTAssertEqual(responseCharacter.characterName, characterName)
                    XCTAssertEqual(responseCharacter.birthdayString, birthdayString)
                    XCTAssertEqual(responseCharacter.breakingBadSeasonsAppearance?.first, appearence)
                    XCTAssertEqual(responseCharacter.betterCallSaulSeasonsAppearance?.first, bcsAppearence)
                }
                else {
                    XCTFail("Expected characters but instead got empty")
                }

            case .failure:
                XCTFail("Expected success but instead got \(result)")
            }
            exp.fulfill()
        }
        URLProtocolStub.stub(data: successfulData, response: successfulHTTPURLResponse(), error: nil)

        wait(for: [exp], timeout: 1.0)
    }

    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> URLSessionImp {
        let session = SessionAPI(session: .shared)
        let sut = URLSessionImp(session: session)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }

    private func successfulCharacterResponseData(id: Int, imageUrl: String, characterName: String, actorName: String, birthdayString: String, appearence: Int, bcsAppearence: Int) -> Data {
        let json = """
        [{
        "char_id": \(id),
        "img": "\(imageUrl)",
        "name": "\(characterName)",
        "portrayed": "\(actorName)",
        "birthday": "\(birthdayString)",
        "appearance": [\(appearence)],
        "better_call_saul_appearance": [\(bcsAppearence)]
        }]
        """
        return Data(json.utf8)
    }
}

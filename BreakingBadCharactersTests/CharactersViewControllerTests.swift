//
//  CharactersViewControllerTests.swift
//  BreakingBadCharactersTests
//
//  Created by Alberto García Antuña on 27/3/22.
//

import BreakingBadCharacters
import Foundation
import XCTest

class CharactersViewControllerTests: XCTestCase {
    
    func test_viewController_onViewControllerViewLoaded() {
        let (sut, _, dataManager) = makeSUT()
        XCTAssertEqual(dataManager.requestsCount, 0, "Expected no loading requests before view is loaded")
        
        sut.loadViewIfNeeded()
        XCTAssertEqual(dataManager.requestsCount, 1, "Expected a loading request when view is loaded")
    }
    
    func test_viewController_showIndicatorWhileIsLoading() {
        let (sut, _, _) = makeSUT()
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.activityIndicator.isHidden, false)
        XCTAssertEqual(sut.noDataLabel.isHidden, true)
    }
    
    func test_viewController_hideIndicatorWhenFinishLoading() {
        let (sut, _, dataManager) = makeSUT()
        sut.loadViewIfNeeded()
        
        dataManager.completeWithEmptyData()
        
        XCTAssertEqual(sut.activityIndicator.isHidden, true)
    }
    
    func test_viewModel_groupDataBySerie(){
        let (sut, viewModel, dataManager) = makeSUT()
        sut.loadViewIfNeeded()
        
        dataManager.completeWithData()
        
        XCTAssertEqual(viewModel.breakingBadCharacters.count, 2)
        XCTAssertEqual(viewModel.betterCallSaulCharacters.count, 1)
    }
    
    func test_loadWithEmptyData_showNoDataLabel() {
        let (sut, _, dataManager) = makeSUT()
        sut.loadViewIfNeeded()
        
        dataManager.completeWithEmptyData()
        
        XCTAssertEqual(sut.noDataLabel.isHidden, false)
    }
    
    func test_loadWithError_hideActivityIndicator() {
        let (sut, _, dataManager) = makeSUT()
        sut.loadViewIfNeeded()
        
        dataManager.completeWithError()
        
        XCTAssertEqual(sut.activityIndicator.isHidden, true)
    }
    
    func test_loadWithData_showList() {
        let (sut, _, dataManager) = makeSUT()
        sut.loadViewIfNeeded()
        
        dataManager.completeWithData()
        
        XCTAssertEqual(sut.numberOfBreakingBadRows(), 2)
        XCTAssertEqual(sut.numberOfBetterCallSaulRows(), 1)
    }
    
    
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: CharactersViewController, viewModel: CharactersViewModel, dataManager: CharactersDataManagerSpy) {
        let charactersDataManager = CharactersDataManagerSpy()
        let viewModel = CharactersViewModel(charactersDataManager: charactersDataManager)
        let sut = CharactersViewController(viewModel: viewModel)
        viewModel.viewDelgate = sut
        trackForMemoryLeaks(viewModel, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, viewModel, charactersDataManager)
    }
    
    class CharactersDataManagerSpy: CharactersDataManager {
        
        private var requests = [(Result<[Character]?, Error>) -> Void]()
        
        var requestsCount: Int {
            return requests.count
        }
                
        func completeWithEmptyData(at index: Int = 0) {
            requests[index](.success([]))
        }
        
        func completeWithData(at index: Int = 0) {
            requests[index](.success(uniqueCharacters()))
        }
                        
        func completeWithError(at index: Int = 0) {
            requests[index](.failure(NSError(domain: "Mock", code: 1, userInfo: [NSLocalizedDescriptionKey: "MockError"])))
        }
        
        func fetchAllCharacters(completion: @escaping (Result<[Character]?, Error>) -> Void) {
            requests.append(completion)
        }
        
        func uniqueCharacters() -> [Character] {
            var characters: [Character] = []
            characters.append(uniqueCharacter(id: 1, bbAppearence: [1], bcsAppearence: []))
            characters.append(uniqueCharacter(id: 2, bbAppearence: [2], bcsAppearence: [1]))
            return characters
        }
        
        func uniqueCharacter(id: Int, bbAppearence: [Int], bcsAppearence: [Int]) -> Character {
            return Character(id: id, imageUrl: anyURL(), characterName: "MockName", actorName: "ActorMockName", birthdayString: "02-08-1997", bbAppearence: bbAppearence, bcsAppearence: bcsAppearence)
        }
    }
}

private extension CharactersViewController{
    func numberOfBreakingBadRows() -> Int {
        return tableView.numberOfRows(inSection: 0)
    }
    
    func numberOfBetterCallSaulRows() -> Int {
        return tableView.numberOfRows(inSection: 1)
    }
}

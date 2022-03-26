//
//  XCTestCase+Extentions.swift
//  BreakingBadCharactersTests
//
//  Created by Alberto García Antuña on 26/3/22.
//

import XCTest

extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        // Despues de cada test
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated.", file: file, line: line)
        }
    }
}

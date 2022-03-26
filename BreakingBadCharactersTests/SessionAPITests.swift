//
//  URLSessionTest.swift
//  BreakingBadCharactersTests
//
//  Created by Alberto García Antuña on 25/3/22.
//

import BreakingBadCharacters
import Foundation
import XCTest

class SessionAPITests: XCTestCase {

    override func setUp() {
        super.setUp()
        URLProtocolStub.startInterceptingRequests()
    }

    override func tearDown() {
        super.tearDown()
        URLProtocolStub.stopInterceptingRequests()
    }

    func test_request_isWellBuilt() {
        let mockRequest = MockRequest()
        let exp = expectation(description: "Wait for request")

        URLProtocolStub.observeRequest { request in
            XCTAssertEqual(request.url, mockRequest.requestWithBaseUrl().url)
            XCTAssertEqual(request.httpMethod, mockRequest.method.rawValue)
            XCTAssertEqual(request.httpBodyStream?.readData(), try? JSONSerialization.data(withJSONObject: mockRequest.body))
            exp.fulfill()
        }

        makeSUT().send(request: mockRequest, completion: { _ in })

        wait(for: [exp], timeout: 1.0)
    }

    func test_request_returnErrorOnRequestErrorWithNonSuccessfulHttpResponse() {
        let requestError = anyNSError()

        let receivedError = resultErrorFor(data: nil, response: nonSuccessfulHTPPURLResponse(), error: requestError)

        XCTAssertEqual((receivedError as NSError?)?.domain, requestError.domain)
    }

    func test_request_returnErrorOnRequestErrorWithSuccessfulHttpResponse() {
        let requestError = anyNSError()

        let receivedError = resultErrorFor(data: nil, response: successfulHTTPURLResponse(), error: requestError)

        XCTAssertEqual((receivedError as NSError?)?.domain, requestError.domain)
    }

    func test_request_returnErrorOnNonSuccessfulHttpResponse() {
        let responseError = NSError(domain: "request", code: 400, userInfo: nil)

        let receivedError = resultErrorFor(data: nil, response: nonSuccessfulHTPPURLResponse(), error: nil)

        XCTAssertEqual((receivedError as NSError?)?.domain, responseError.domain)
    }

    func test_request_returnNilOnResponseWithEmptyData() {
        let successResult = resultSuccess(data: nil, response: successfulHTTPURLResponse(), error: nil)

        XCTAssertNil(successResult)
    }

    func test_request_returnErrorOnDecodingInvalidData() {
        let receivedError = resultErrorFor(data: anyData(), response: successfulHTTPURLResponse(), error: nil)

        XCTAssertNotNil(receivedError)
    }

    func test_getFromURL_returnSuccessfulWithValidData() {
        let id = UUID().uuidString

        let data = resultSuccess(data: correctData(id: id), response: successfulHTTPURLResponse(), error: nil)

        XCTAssertEqual(data?.id, id)
    }

    // MARK: - Helpers

    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> SessionAPI {
        let sut = SessionAPI(session: .shared)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }

    private func correctData(id: String) -> Data {
        let successfullDict = ["id": id]
        return try! JSONEncoder().encode(successfullDict)
    }

    private class MockRequest: APIRequest {
        typealias Response = MockModel

        var method: Method {
            .GET
        }

        var path: String {
            return "/mock"
        }

        var parameters: [String: String] {
            return ["Mock": "Mock"]
        }

        var body: [String: Any] {
            return ["Mock": "Mock"]
        }

        var headers: [String: String] {
            return ["Mock": "Mock"]
        }
    }

    struct MockModel: Codable {
        var id: String
    }

    private func resultSuccess(data: Data?, response: URLResponse?, error: Error?, file: StaticString = #file, line: UInt = #line) -> MockRequest.Response? {
        let result = resultFor(data: data, response: response, error: error, file: file, line: line)

        switch result {
        case let .success(mockSuccessResponse):
            return mockSuccessResponse
        default:
            XCTFail("Expected success, got \(result) instead", file: file, line: line)
            return nil
        }
    }

    private func resultErrorFor(data: Data?, response: URLResponse?, error: Error?, file: StaticString = #file, line: UInt = #line) -> Error? {
        let result = resultFor(data: data, response: response, error: error, file: file, line: line)

        switch result {
        case let .failure(error):
            return error
        default:
            XCTFail("Expected failure, got \(result) instead", file: file, line: line)
            return nil
        }
    }

    private func resultFor(data: Data?, response: URLResponse?, error: Error?, file: StaticString = #file, line: UInt = #line) -> Result<MockRequest.Response?, Error> {
        URLProtocolStub.stub(data: data, response: response, error: error)
        let sut = makeSUT(file: file, line: line)
        let exp = expectation(description: "Wait for completion")

        var receivedResult: Result<MockRequest.Response?, Error>!
        let fetchRequest = MockRequest()
        sut.send(request: fetchRequest, completion: { result in
            receivedResult = result
            exp.fulfill()
        })
        wait(for: [exp], timeout: 1.0)
        return receivedResult
    }
}

private extension InputStream {
    func readData() -> Data {
        var result = Data()
        var buffer = [UInt8](repeating: 0, count: 4096)

        open()

        var amount = 0
        repeat {
            amount = read(&buffer, maxLength: buffer.count)
            if amount > 0 {
                result.append(buffer, count: amount)
            }
        } while amount > 0

        close()

        return result
    }
}

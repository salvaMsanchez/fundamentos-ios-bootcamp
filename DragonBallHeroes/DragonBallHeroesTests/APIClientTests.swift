//
//  APIClientTests.swift
//  DragonBallHeroesTests
//
//  Created by Salva Moreno on 28/9/23.
//

import XCTest
@testable import DragonBallHeroes

final class APIClientTests: XCTestCase {

    private var sut: APIClient!
    
    override func setUp() {
        super.setUp()
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: configuration)
        sut = APIClient(session: session)
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    func testLogin() {
        let expectedToken = "SomeToken"
        let someUser = "SomeUser"
        let somePassword = "SomePassword"
        
        MockURLProtocol.requestHandler = { request in
            let loginString = String(format: "%@:%@", someUser, somePassword)
            let loginData = loginString.data(using: .utf8)!
            let base64LogingString = loginData.base64EncodedString()
            
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertEqual(
                request.value(forHTTPHeaderField: "Authorization"),
                "Basic \(base64LogingString)"
            )
            
            let data = try XCTUnwrap(expectedToken.data(using: .utf8))
            let response = try XCTUnwrap(
                HTTPURLResponse(
                    url: URL(string: "https://dragonball.keepcoding.education")!,
                    statusCode: 200,
                    httpVersion: nil,
                    headerFields: ["Content-Type": "application/json"]
                )
            )
            return (response, data)
        }
        
        let expectation = expectation(description: "Login success")
        
        sut.login(
            user: someUser,
            password: somePassword
        ) { result in
            guard case let .success(token) = result else {
                XCTFail("Expected success but received \(result)")
                return
            }
            
            XCTAssertEqual(token, expectedToken)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testGetHeroes() {
        let token = "SomeToken"
        let expectedData = """
        [
            {
                "description": "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum eget lorem dolor. Etiam nulla velit, sollicitudin eget mi ac, vestibulum molestie eros",
                "name": "Julio César",
                "id": "1234",
                "favorite": false,
                "photo": "photo.png"
            },
            {
                "description": "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum eget lorem dolor. Etiam nulla velit, sollicitudin eget mi ac, vestibulum molestie eros",
                "name": "Odoacro",
                "id": "5678",
                "favorite": true,
                "photo": "photo1.png"
            }
        ]
        """
        let hero1 = Hero(
            id: "1234",
            name: "Julio César",
            description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum eget lorem dolor. Etiam nulla velit, sollicitudin eget mi ac, vestibulum molestie eros",
            photo: URL(string: "photo.png")!,
            favorite: false)
        let hero2 = Hero(
            id: "5678",
            name: "Odoacro",
            description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum eget lorem dolor. Etiam nulla velit, sollicitudin eget mi ac, vestibulum molestie eros",
            photo: URL(string: "photo1.png")!,
            favorite: true)
        
        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertEqual(
                request.value(forHTTPHeaderField: "Authorization"),
                "Bearer \(token)"
            )
            
            let data = try XCTUnwrap(expectedData.data(using: .utf8))
            let response = try XCTUnwrap(
                HTTPURLResponse(
                    url: URL(string: "https://dragonball.keepcoding.education")!,
                    statusCode: 200,
                    httpVersion: nil,
                    headerFields: ["Content-Type": "application/json"]
                )
            )
            return (response, data)
        }
        
        let expectation = expectation(description: "Heroes successfully achieved")
        
        sut.getHeroes { result in
            guard case let .success(resource) = result else {
                XCTFail("Expected success but received \(result)")
                return
            }
            
            XCTAssertEqual(resource, [hero1, hero2])
            print(resource)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testGetTransformations() {
        let hero = Hero(
            id: "1234",
            name: "Julio César",
            description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum eget lorem dolor. Etiam nulla velit, sollicitudin eget mi ac, vestibulum molestie eros",
            photo: URL(string: "photo.png")!,
            favorite: false)
        let token = "SomeToken"
        let expectedData = """
        [
            {
                "hero": {
                    "id": "\(hero.id)"
                },
                "name": "1. Vercingétorix",
                "photo": "photo.png",
                "id": "1111",
                "description": "Etiam nulla velit, sollicitudin eget mi ac, vestibulum molestie eros."
            },
            {
                "hero": {
                    "id": "\(hero.id)"
                },
                "name": "2. Bruto",
                "photo": "photo1.png",
                "id": "2222",
                "description": "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum eget lorem dolor."
            }
        ]
        """
        let transformation1: Transformation = Transformation(
            id: "1111",
            name: "1. Vercingétorix",
            description: "Etiam nulla velit, sollicitudin eget mi ac, vestibulum molestie eros.",
            photo: URL(string: "photo.png")!)
        let transformation2: Transformation = Transformation(
            id: "2222",
            name: "2. Bruto",
            description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum eget lorem dolor.",
            photo: URL(string: "photo1.png")!)
        
        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertEqual(
                request.value(forHTTPHeaderField: "Authorization"),
                "Bearer \(token)"
            )
            
            let data = try XCTUnwrap(expectedData.data(using: .utf8))
            let response = try XCTUnwrap(
                HTTPURLResponse(
                    url: URL(string: "https://dragonball.keepcoding.education")!,
                    statusCode: 200,
                    httpVersion: nil,
                    headerFields: ["Content-Type": "application/json"]
                )
            )
            return (response, data)
        }
        
        let expectation = expectation(description: "Transformations successfully achieved")
        
        sut .getTransformations(for: hero) { result in
            guard case let .success(resource) = result else {
                XCTFail("Expected success but received \(result)")
                return
            }
            
            XCTAssertEqual(resource, [transformation1, transformation2])
            print(resource)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
}

final class MockURLProtocol: URLProtocol {
    static var error: APIClient.NetworkError?
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        if let error = MockURLProtocol.error {
            client?.urlProtocol(self, didFailWithError: error)
            return
        }
        
        guard let handler = MockURLProtocol.requestHandler else {
            assertionFailure("Received unexpected request with no handler")
            return
        }
        
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() { }

}

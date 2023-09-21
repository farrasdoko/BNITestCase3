//
//  MobileAppPortfolioFarrasTests.swift
//  MobileAppPortfolioFarrasTests
//
//  Created by Farras on 21/09/23.
//

import XCTest
@testable import MobileAppPortfolioFarras

final class MobileAppPortfolioFarrasTests: XCTestCase {
    
    override class func setUp() {
        super.setUp()
    }
    override class func tearDown() {
        super.tearDown()
    }
    
    func testDecodeDifferentData_Nil() {
        let sut: String? = nil
        let data: [Any]? = serializeStringToAny(from: sut)
        XCTAssertNil(data, "Invalid JSON string")
    }
    
    func testDecodeDifferentData_DecodeFailed() {
        let sut = "asdadasd"
        let data: [Any]? = serializeStringToAny(from: sut)
        XCTAssertNil(data, "Error decoding JSON: JSON text did not start with array or object and option to allow fragments not set.")
    }
    
    func testDecodeDifferentData_Success() {
        let jsonExample = "[1, \"2\"]"
        
        let data: [Any]? = serializeStringToAny(from: jsonExample)
        var sutArray: [Any] = []
        
        if let data = data {
            for element in data {
                if let intValue = element as? Int {
                    sutArray.append(intValue)
                } else if let stringValue = element as? String {
                    sutArray.append(stringValue)
                } else {
                    XCTFail("Unknown type: \(type(of: element))")
                }
            }
        }
        
        XCTAssertEqual(sutArray.count, 2)
        XCTAssertEqual(sutArray.first as? Int, 1)
        XCTAssertEqual(sutArray[1] as? String, "2")
    }
    
    private func serializeStringToAny<T>(from string: String?, file: StaticString = #filePath, line: UInt = #line) -> T? {
        if let jsonData = string?.data(using: .utf8) {
            do {
                let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: []) as? T
                return jsonArray
            } catch {
                // XCTFail("Error decoding JSON: \(error)", file: file, line: line)
                return nil
            }
        } else {
            // XCTFail("Invalid JSON string", file: file, line: line)
            return nil
        }
    }
}

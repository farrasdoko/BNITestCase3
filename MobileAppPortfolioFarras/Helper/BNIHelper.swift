//
//  BNIHelper.swift
//  MobileAppPortfolioFarras
//
//  Created by Farras on 22/09/23.
//

import Foundation

struct BNIHelper {
    static func serializeStringToAny<T>(from string: String?, file: StaticString = #filePath, line: UInt = #line) -> T? {
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
    static func decodeJson<T: Codable>(from data: Data, file: StaticString = #filePath, line: UInt = #line) -> T? {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
//            print("Error: \(error)")
            return nil
        }
    }
    static func decodeJson<T: Codable>(from str: String, file: StaticString = #filePath, line: UInt = #line) -> T? {
        if let jsonData = str.data(using: .utf8) {
            return decodeJson(from: jsonData, file: file, line: line)
        } else {
            return nil
        }
    }
}

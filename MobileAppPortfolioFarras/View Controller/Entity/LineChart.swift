//
//  LineChart.swift
//  MobileAppPortfolioFarras
//
//  Created by Farras on 22/09/23.
//

import Foundation

struct LineChart: Codable, Equatable {
    let type: String
    let data: [String: [Int]]
    
    enum CodingKeys: String, CodingKey {
        case type
        case data
    }
}

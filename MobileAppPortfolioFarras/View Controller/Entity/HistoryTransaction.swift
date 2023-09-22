//
//  HistoryTransaction.swift
//  MobileAppPortfolioFarras
//
//  Created by Farras on 22/09/23.
//

import Foundation

struct HistoryTransaction: Codable, Equatable {
    let trxDate: String
    let nominal: Int
    
    enum CodingKeys: String, CodingKey {
        case trxDate = "trx_date"
        case nominal = "nominal"
    }
}

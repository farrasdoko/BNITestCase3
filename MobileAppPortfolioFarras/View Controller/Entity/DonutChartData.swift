//
//  DonutChartData.swift
//  MobileAppPortfolioFarras
//
//  Created by Farras on 22/09/23.
//

import Foundation

struct DonutChartData: Codable, Equatable {
    let label: String
    let percentage: String
    let data: [HistoryTransaction]
}

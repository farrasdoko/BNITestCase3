//
//  DonutChart.swift
//  MobileAppPortfolioFarras
//
//  Created by Farras on 22/09/23.
//

import Foundation

struct DonutChart: Codable, Equatable {
    let type: String
    let data: [DonutChartData]
}

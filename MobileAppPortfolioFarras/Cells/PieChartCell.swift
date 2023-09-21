//
//  PieChartCell.swift
//  MobileAppPortfolioFarras
//
//  Created by Farras on 21/09/23.
//

import UIKit
import Charts

class PieChartCell: UITableViewCell {
    
    static let reuseIdentifier = "PieChartCell"

    @IBOutlet weak var chartView: PieChartView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupPieChart()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupPieChart() {
        chartView.holeRadiusPercent = 0.1
        chartView.chartDescription.enabled = true
        chartView.noDataText = "No data available"
        chartView.chartDescription.text = "Portfolio Chart"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}

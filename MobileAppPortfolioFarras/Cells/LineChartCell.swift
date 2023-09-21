//
//  LineChartCell.swift
//  MobileAppPortfolioFarras
//
//  Created by Farras on 21/09/23.
//

import UIKit
import Charts

class LineChartCell: UITableViewCell {
    
    static let reuseIdentifier = "LineChartCell"

    @IBOutlet weak var chartView: LineChartView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLineChart()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupLineChart() {
        chartView.noDataText = "No data available"
        chartView.chartDescription.text = "Portfolio Chart"
        chartView.chartDescription.enabled = true
        chartView.dragEnabled = true
        chartView.setScaleEnabled(true)
        chartView.pinchZoomEnabled = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}

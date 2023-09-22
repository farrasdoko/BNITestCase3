//
//  ViewController.swift
//  MobileAppPortfolioFarras
//
//  Created by Farras on 21/09/23.
//

import UIKit
import Charts

protocol ViewViewProtocol: AnyObject {
    var presenter: ViewPresenterProtocol? { get set }
    
    // MARK: Presenter to View
    func showChartData(chart: [Any])
}

class ViewController: UIViewController {
    
    var presenter: ViewPresenterProtocol?
    
    @IBOutlet weak var tableView: UITableView!
    var chartData: [Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        presenter?.viewDidLoad()
    }
    
    var highlightIndexPath: IndexPath? = nil
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        chartData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let value = chartData[indexPath.row]
        if let donutValue = value as? DonutChart {
            let cell = tableView.dequeueReusableCell(withIdentifier: PieChartCell.reuseIdentifier)! as! PieChartCell
            
            let entries: [PieChartDataEntry] = donutValue.data.map { data in
                return PieChartDataEntry(value: Double(data.percentage) ?? 0, label: data.label, data: data)
            }
            
            let dataSet = PieChartDataSet(entries: entries, label: "Portfolio Chart")
            dataSet.colors = ChartColorTemplates.material()
            
            let data = PieChartData(dataSet: dataSet)
            
            data.setValueFormatter(DefaultValueFormatter(formatter: NumberFormatter()))
            data.setValueFont(UIFont.systemFont(ofSize: 12))
            data.setValueTextColor(UIColor.black)
            
            cell.chartView.data = data
            
            cell.chartView.delegate = self
            
            return cell
        } else if let lineValue = value as? LineChart {
            let cell = tableView.dequeueReusableCell(withIdentifier: LineChartCell.reuseIdentifier)! as! LineChartCell
            
            let entries: [ChartDataEntry] = lineValue.data["month"]!.enumerated().map { (i, yData) in
                return ChartDataEntry(x: Double(i), y: Double(yData))
            }
            
            let dataSet = LineChartDataSet(entries: entries, label: "Portfolio Data")
            dataSet.colors = [NSUIColor.blue]
            
            let data = LineChartData(dataSet: dataSet)
            
            data.setValueFormatter(DefaultValueFormatter(formatter: NumberFormatter()))
            data.setValueFont(UIFont.systemFont(ofSize: 12))
            data.setValueTextColor(UIColor.black)
            
            cell.chartView.data = data
            
            return cell
        } else {
            fatalError("Type is undefined")
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ViewController: ViewViewProtocol {
    func showChartData(chart: [Any]) {
        self.chartData = chart
        tableView.reloadData()
    }
}

extension ViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        guard let data = entry.data as? DonutChartData else { return }
        presenter?.showHistoryTransactionScreen(from: navigationController, data: data)
    }
}

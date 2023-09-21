//
//  ViewController.swift
//  MobileAppPortfolioFarras
//
//  Created by Farras on 21/09/23.
//

import UIKit
import Charts

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

struct LineChart: Codable, Equatable {
    let type: String
    let data: [String: [Int]]
    
    enum CodingKeys: String, CodingKey {
        case type
        case data
    }
}

struct DonutChart: Codable, Equatable {
    let type: String
    let data: [DonutChartData]
}

struct DonutChartData: Codable, Equatable {
    let label: String
    let percentage: String
    let data: [HistoryTransaction]
}

struct HistoryTransaction: Codable, Equatable {
    let trxDate: String
    let nominal: Int
    
    enum CodingKeys: String, CodingKey {
        case trxDate = "trx_date"
        case nominal = "nominal"
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var chartData: [Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        // *
        let staticData = """
    [{
        "type": "donutChart",
        "data": [{
                "label": "Tarik Tunai",
                "percentage": "55",
                "data": [{
                    "trx_date": "21/01/2023",
                    "nominal": 1000000
                }, {
                    "trx_date": "20/01/2023",
                    "nominal": 500000
                }, {
                    "trx_date": "19/01/2023",
                    "nominal": 1000000
                }]
            },
            {
                "label": "QRIS Payment",
                "percentage": "31",
                "data": [{
                    "trx_date": "21/01/2023",
                    "nominal": 159000
                }, {
                    "trx_date": "20/01/2023",
                    "nominal": 35000
                }, {
                    "trx_date": "19/01/2023",
                    "nominal": 1500
                }]
            },
            {
                "label": "Topup Gopay",
                "percentage": "7.7",
                "data": [{
                    "trx_date": "21/01/2023",
                    "nominal": 200000
                }, {
                    "trx_date": "20/01/2023",
                    "nominal": 195000
                }, {
                    "trx_date": "19/01/2023",
                    "nominal": 5000000
                }]
            },
            {
                "label": "Lainnya",
                "percentage": "6.3",
                "data": [{
                    "trx_date": "21/01/2023",
                    "nominal": 1000000
                }, {
                    "trx_date": "20/01/2023",
                    "nominal": 500000
                }, {
                    "trx_date": "19/01/2023",
                    "nominal": 1000000
                }]
            }
        ]
    },
    {
        "type": "lineChart",
        "data": {
            "month": [3, 7, 8, 10, 5, 10, 1, 3, 5, 10, 7, 7]
        }
    }
    ]
    """
        
        let data: [NSDictionary]? = BNIHelper.serializeStringToAny(from: staticData)
        guard let data = data else {
            return
        }
        
        var values: [Any] = []
        
        do {
            for element in data {
                let jsonData = try JSONSerialization.data(withJSONObject: element, options: [])
                
                if let donutValue: DonutChart = BNIHelper.decodeJson(from: jsonData) {
                    values.append(donutValue)
//                    print("123: - Donat value: \(donutValue)")
                } else if let lineValue: LineChart = BNIHelper.decodeJson(from: jsonData) {
                    values.append(lineValue)
//                    print("123: - Line value: \(lineValue)")
                } else {
//                    XCTFail("Unknown type: \(type(of: element))")
//                    XCTFail("It is: \(element))")
                }
            }
        } catch {
            print("Error serializing NSDictionary: \(error)")
        }
        
        self.chartData = values
        tableView.reloadData()
        
//        for value in values {
//            if let donutValue = value as? DonutChart {
//                // TODO: operate donutValue
//            } else if let lineValue = value as? LineChart {
//                // TODO: operate lineValue
//            }
//        }
        
        //*/
    }
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
//        tableView.register(PieChartCell.self, forCellReuseIdentifier: PieChartCell.reuseIdentifier)
//        tableView.register(LineChartCell.self, forCellReuseIdentifier: LineChartCell.reuseIdentifier)
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
                return PieChartDataEntry(value: Double(data.percentage) ?? 0, label: data.label)
            }
            
            let dataSet = PieChartDataSet(entries: entries, label: "Portfolio Chart")
            dataSet.colors = ChartColorTemplates.material()
            
            let data = PieChartData(dataSet: dataSet)
            
            data.setValueFormatter(DefaultValueFormatter(formatter: NumberFormatter()))
            data.setValueFont(UIFont.systemFont(ofSize: 12))
            data.setValueTextColor(UIColor.black)
            
            cell.chartView.data = data
            
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

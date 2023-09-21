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
    
    @IBOutlet weak var chartView: PieChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPieChart()
        
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
        
        for value in values {
            if let donutValue = value as? DonutChart {
                // TODO: operate donutValue
            } else if let lineValue = value as? LineChart {
                // TODO: operate lineValue
            }
        }
        
        let entries: [PieChartDataEntry] = (values[0] as! DonutChart).data.map { data in
            return PieChartDataEntry(value: Double(data.percentage) ?? 0, label: data.label)
        }
        
        let dataSet = PieChartDataSet(entries: entries, label: "-")
        dataSet.colors = ChartColorTemplates.material()
        
        let data2 = PieChartData(dataSet: dataSet)
        
        // Optionally, add value formatting and styling here
        data2.setValueFormatter(DefaultValueFormatter(formatter: NumberFormatter()))
        data2.setValueFont(UIFont.systemFont(ofSize: 12))
        data2.setValueTextColor(UIColor.black)
        
        chartView.data = data2
    }
    func setupPieChart() {
        chartView.holeRadiusPercent = 0.1
        chartView.chartDescription.enabled = true
        chartView.noDataText = "No data available"
        chartView.chartDescription.text = "Portfolio Chart"
    }
}

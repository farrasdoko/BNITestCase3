//
//  ViewInteractor.swift
//  MobileAppPortfolioFarras
//
//  Created by Farras on 22/09/23.
//

import Foundation

protocol ViewInteractorProtocol: AnyObject {
    var presenter: ViewPresenterProtocol? { get set }
    
    // MARK: Presenter to Interactor
    func fetchPortfolio()
}

class ViewInteractor: ViewInteractorProtocol {
    var presenter: ViewPresenterProtocol?
    
    init(presenter: ViewPresenterProtocol? = nil) {
        self.presenter = presenter
    }
    
    func fetchPortfolio() {
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
        
        presenter?.updateChartData(chart: values)
    }
    
    private let staticData = """
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
}

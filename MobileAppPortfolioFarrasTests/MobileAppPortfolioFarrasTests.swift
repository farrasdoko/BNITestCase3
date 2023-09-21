//
//  MobileAppPortfolioFarrasTests.swift
//  MobileAppPortfolioFarrasTests
//
//  Created by Farras on 21/09/23.
//

import XCTest
@testable import MobileAppPortfolioFarras

final class MobileAppPortfolioFarrasTests: XCTestCase {
    
    override class func setUp() {
        super.setUp()
    }
    override class func tearDown() {
        super.tearDown()
    }
    
    func testDecodeDifferentData_Nil() {
        let sut: String? = nil
        let data: [Any]? = BNIHelper.serializeStringToAny(from: sut)
        XCTAssertNil(data, "Invalid JSON string")
    }
    
    func testDecodeDifferentData_DecodeFailed() {
        let sut = "asdadasd"
        let data: [Any]? = BNIHelper.serializeStringToAny(from: sut)
        XCTAssertNil(data, "Error decoding JSON: JSON text did not start with array or object and option to allow fragments not set.")
    }
    
    func testDecodeDifferentData_Success() {
        let jsonExample = "[1, \"2\"]"
        
        let data: [Any]? = BNIHelper.serializeStringToAny(from: jsonExample)
        var sutArray: [Any] = []
        
        if let data = data {
            for element in data {
                if let intValue = element as? Int {
                    sutArray.append(intValue)
                } else if let stringValue = element as? String {
                    sutArray.append(stringValue)
                } else {
                    XCTFail("Unknown type: \(type(of: element))")
                }
            }
        }
        
        XCTAssertEqual(sutArray.count, 2)
        XCTAssertEqual(sutArray.first as? Int, 1)
        XCTAssertEqual(sutArray[1] as? String, "2")
    }
    func testDecodeJson_Error() {
        let lineChart = """
            {}
        """
        
        let sut: LineChart? = BNIHelper.decodeJson(from: lineChart)
        XCTAssertNil(sut, "No value associated with key ...")
    }
    func testLineChartData_Success() {
        let lineChart = """
            {
                "type": "lineChart",
                "data": {
                    "month": [3, 7, 8, 10, 5, 10, 1, 3, 5, 10, 7, 7]
                }
            }
        """
        
        let sut: LineChart? = BNIHelper.decodeJson(from: lineChart)
        XCTAssertEqual(sut?.type, "lineChart")
        XCTAssertEqual(sut?.data, ["month": [3, 7, 8, 10, 5, 10, 1, 3, 5, 10, 7, 7]] )
    }
    
    func testDonutChartData() {
        let donutChart = """
            {
                    "type": "donutChart",
                    "data": [{
                            "label": "Tarik Tunai",
                            "percentage": "55",
                            "data": []
                        },
                        {
                            "label": "QRIS Payment",
                            "percentage": "31",
                            "data": []
                        },
                        {
                            "label": "Topup Gopay",
                            "percentage": "7.7",
                            "data": []
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
                }
        """
        
        let sut: DonutChart? = BNIHelper.decodeJson(from: donutChart)
        let typeExpectation = [
            DonutChartData(label: "Tarik Tunai", percentage: "55", data: []),
            DonutChartData(label: "QRIS Payment", percentage: "31", data: []),
            DonutChartData(label: "Topup Gopay", percentage: "7.7", data: []),
            DonutChartData(label: "Lainnya", percentage: "6.3", data: [
                HistoryTransaction(trxDate: "21/01/2023", nominal: 1000000),
                HistoryTransaction(trxDate: "20/01/2023", nominal: 500000),
                HistoryTransaction(trxDate: "19/01/2023", nominal: 1000000),
            ])
        ]
        XCTAssertEqual(sut?.type, "donutChart")
        XCTAssertEqual(sut?.data, typeExpectation)
    }
    
    func testStaticData() {
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
            XCTFail("Data can't be nil")
            return
        }
        
        var sut: [Any] = []
        
        do {
            for element in data {
                let jsonData = try JSONSerialization.data(withJSONObject: element, options: [])
                
                if let donutValue: DonutChart = BNIHelper.decodeJson(from: jsonData) {
                    sut.append(donutValue)
                } else if let lineValue: LineChart = BNIHelper.decodeJson(from: jsonData) {
                    sut.append(lineValue)
                } else {
                    XCTFail("Unknown type: \(type(of: element))")
                    XCTFail("It is: \(element))")
                }
            }
        } catch {
            print("Error serializing NSDictionary: \(error)")
        }
        
        XCTAssertEqual(sut.count, 2)
        XCTAssertEqual(sut[0] as? DonutChart, DonutChart(type: "donutChart", data: [
            DonutChartData(label: "Tarik Tunai", percentage: "55", data: [
                HistoryTransaction(trxDate: "21/01/2023", nominal: 1000000),
                HistoryTransaction(trxDate: "20/01/2023", nominal: 500000),
                HistoryTransaction(trxDate: "19/01/2023", nominal: 1000000),
            ]),
            DonutChartData(label: "QRIS Payment", percentage: "31", data: [
                HistoryTransaction(trxDate: "21/01/2023", nominal: 159000),
                HistoryTransaction(trxDate: "20/01/2023", nominal: 35000),
                HistoryTransaction(trxDate: "19/01/2023", nominal: 1500),
            ]),
            DonutChartData(label: "Topup Gopay", percentage: "7.7", data: [
                HistoryTransaction(trxDate: "21/01/2023", nominal: 200000),
                HistoryTransaction(trxDate: "20/01/2023", nominal: 195000),
                HistoryTransaction(trxDate: "19/01/2023", nominal: 5000000),
            ]),
            DonutChartData(label: "Lainnya", percentage: "6.3", data: [
                    HistoryTransaction(trxDate: "21/01/2023", nominal: 1000000),
                    HistoryTransaction(trxDate: "20/01/2023", nominal: 500000),
                    HistoryTransaction(trxDate: "19/01/2023", nominal: 1000000),
            ]),
        ]))
        XCTAssertEqual(sut[1] as? LineChart, LineChart(type: "lineChart", data: [
            "month": [3, 7, 8, 10, 5, 10, 1, 3, 5, 10, 7, 7]
        ]))
    }
}

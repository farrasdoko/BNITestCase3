//
//  Int+Extension.swift
//  MobileAppPortfolioFarras
//
//  Created by Farras on 22/09/23.
//

import Foundation

extension Int {
    // Returns `Rp1.800.000`
    var asIdr: String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale(identifier: "id_ID")
        return numberFormatter.string(from: NSNumber(value: self))
    }
}

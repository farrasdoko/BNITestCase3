//
//  TableViewInteractor.swift
//  MobileAppPortfolioFarras
//
//  Created by Farras on 22/09/23.
//

import Foundation

protocol TableViewInteractorProtocol: AnyObject {
    var presenter: TableViewPresenterProtocol? { get set }
    
    // MARK: Presenter to Interactor
//    func fetchPortfolio()
}

class TableViewInteractor: TableViewInteractorProtocol {
    var presenter: TableViewPresenterProtocol?
    
    init(presenter: TableViewPresenterProtocol? = nil) {
        self.presenter = presenter
    }
}

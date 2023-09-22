//
//  ViewPresenter.swift
//  MobileAppPortfolioFarras
//
//  Created by Farras on 22/09/23.
//

import Foundation
import UIKit

protocol ViewPresenterProtocol: AnyObject {
    var view: ViewViewProtocol? { get set }
    var interactor: ViewInteractorProtocol? { get set }
    var router: ViewRouterProtocol? { get set }
    
    // MARK: View to Presenter
    func viewDidLoad()
    func showHistoryTransactionScreen(from nav: UINavigationController?, data: DonutChartData)
    
    // MARK: Interactor to Presenter
    func updateChartData(chart: [Any])
}

class ViewPresenter: ViewPresenterProtocol {
    weak var view: ViewViewProtocol?
    var interactor: ViewInteractorProtocol?
    var router: ViewRouterProtocol?
    
    func viewDidLoad() {
        interactor?.fetchPortfolio()
    }
    
    func updateChartData(chart: [Any]) {
        view?.showChartData(chart: chart)
    }
    
    func showHistoryTransactionScreen(from nav: UINavigationController?, data: DonutChartData) {
        router?.navigateToHistoryTransaction(from: nav, data: data)
    }
}

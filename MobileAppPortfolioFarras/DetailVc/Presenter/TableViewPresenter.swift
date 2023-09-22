//
//  TableViewPresenter.swift
//  MobileAppPortfolioFarras
//
//  Created by Farras on 22/09/23.
//

import Foundation

protocol TableViewPresenterProtocol: AnyObject {
    var view: TableViewViewProtocol? { get set }
    var interactor: TableViewInteractorProtocol? { get set }
    var router: TableViewRouterProtocol? { get set }
    
    // MARK: View to Presenter
    func viewDidLoad(data: DonutChartData?)
    
    // MARK: Interactor to Presenter
}

class TableViewPresenter: TableViewPresenterProtocol {
    weak var view: TableViewViewProtocol?
    var interactor: TableViewInteractorProtocol?
    var router: TableViewRouterProtocol?
    
    func viewDidLoad(data: DonutChartData?) {
        guard let data = data else { return }
        view?.showTitle(with: "\(data.label) History Transaction")
    }
}

//
//  TableViewRouter.swift
//  MobileAppPortfolioFarras
//
//  Created by Farras on 22/09/23.
//

import Foundation
import UIKit

protocol TableViewRouterProtocol: AnyObject {
    static func createModule(data: DonutChartData) -> UIViewController
}

class TableViewRouter: TableViewRouterProtocol {
    weak var viewController: UIViewController?
    
    static func createModule(data: DonutChartData) -> UIViewController {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "TableViewController") as! TableViewController
        view.data = data
        let interactor = TableViewInteractor()
        let presenter = TableViewPresenter()
        let router = TableViewRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }
    
    // MARK: Presenter to Router
}

//
//  ViewRouter.swift
//  MobileAppPortfolioFarras
//
//  Created by Farras on 22/09/23.
//

import Foundation
import UIKit

protocol ViewRouterProtocol: AnyObject {
    static func createModule() -> UIViewController
    func navigateToHistoryTransaction(from nav: UINavigationController?, data: DonutChartData)
}

class ViewRouter: ViewRouterProtocol {
    weak var viewController: UIViewController?
    
    static func createModule() -> UIViewController {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        let interactor = ViewInteractor()
        let presenter = ViewPresenter()
        let router = ViewRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }
    
    // MARK: Presenter to Router
    func navigateToHistoryTransaction(from nav: UINavigationController?, data: DonutChartData) {
        let historyVc = TableViewRouter.createModule(data: data)
        nav?.pushViewController(historyVc, animated: true)
    }
}

//
//  VIPER_Router.swift
//  RSSFeed App (VIPER)
//
//  Created by Tsibulko on 02.08.2021.
//

import UIKit


typealias EntryPoint = AnyView & UIViewController

protocol AnyRouter {
    var entry: EntryPoint? { get }
    static func start() -> AnyRouter
}

class NewsRouter: AnyRouter {
    
    var entry: EntryPoint?
    
    static func start() -> AnyRouter {
        
        let router = NewsRouter()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var view: AnyView = storyboard.instantiateViewController(identifier: "NewsViewController") as! NewsViewController
        var presenter: AnyPresenter = NewsPresenter()
        var interactor: AnyInteractor = NewsInteractor()
        
        view.presenter = presenter
        
        interactor.presenter = presenter
        
        presenter.router = router
        presenter.view = view
        presenter.interactor = interactor
        
        router.entry = view as? EntryPoint
        
        return router
    }
    
} // end of class NewsRouter

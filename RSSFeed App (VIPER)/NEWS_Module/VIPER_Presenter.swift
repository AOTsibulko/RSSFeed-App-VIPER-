//
//  VIPER_Presenter.swift
//  RSSFeed App (VIPER)
//
//  Created by Tsibulko on 02.08.2021.
//

import UIKit


protocol AnyPresenter {
    var router: AnyRouter? { get set }
    var interactor: AnyInteractor? { get set }
    var view: AnyView? { get set }
    
    func interactorDidFetchNews(with result: Result<[RSSItem], Error>)
}

class NewsPresenter: AnyPresenter {
    
    var router: AnyRouter?
    var interactor: AnyInteractor? {
        didSet {
            interactor?.getNews()
        }
    }
    var view: AnyView?
    
    func interactorDidFetchNews(with result: Result<[RSSItem], Error>) {
        
        switch result {
        case .success(let rssItems):
            view?.update(with: rssItems)
        case .failure(let error):
            view?.update(with: error.localizedDescription)
        }
        
    }
    
    
    
} // end of class NewsPresenter

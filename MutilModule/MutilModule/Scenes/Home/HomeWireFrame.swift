//
//  HomeWireFrame.swift
//  MutilModule
//
//  Created by NguyenHao on 18/11/2023.
//

import Foundation

final class HomeWireframe {
    static func createHomeModule() -> HomeViewController {
        let homeViewController = HomeViewController()
        let homePresenter = HomePresenterImplement()
        
        homeViewController.presenter = homePresenter
        homePresenter.view = homeViewController

        return homeViewController
    }
}

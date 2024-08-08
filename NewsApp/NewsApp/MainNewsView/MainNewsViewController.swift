//
//  ViewController.swift
//  NewsApp
//
//  Created by Максим Жуин on 08.08.2024.
//

import UIKit

protocol MainNewsVCDelegate: AnyObject {

}

class MainNewsViewController: UIViewController {

    // MARK: - Properties
    let mainView: MainNewsView
    let networkService: NetworkService

    // MARK: - LifeCycle

    init(mainView: MainNewsView, networkService: NetworkService) {
        self.mainView = mainView
        self.networkService = networkService
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        networkService.fetchNews { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                self.mainView.updateDataForView(data: success)
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }

    // MARK: - Funcs
}


extension MainNewsViewController: MainNewsVCDelegate {
    
}

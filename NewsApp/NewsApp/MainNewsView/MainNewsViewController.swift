//
//  ViewController.swift
//  NewsApp
//
//  Created by Максим Жуин on 08.08.2024.
//

import UIKit

protocol MainNewsVCDelegate: AnyObject {
    func fetchMoreNews(page: String, text: String?)
}

class MainNewsViewController: UIViewController {

    // MARK: - Properties
   private let mainView: MainNewsView
   private let networkService: NetworkService

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
        setupNavigation()
        fetchNews()
        mainView.mainNewsVCDelegate = self
    }

    // MARK: - Funcs

    private func setupNavigation() {
        let title = "Главная"
        self.title = title
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(enableSearchField(_:)))
    }

    @objc private func enableSearchField(_ sender: UIBarButtonItem) {

    }

    private func fetchNews() {
        networkService.fetchNews(text: nil, page: nil) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                print(success.nextPage)
                self.mainView.updateDataForView(data: success)
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
}


extension MainNewsViewController: MainNewsVCDelegate {
    func fetchMoreNews(page: String, text: String?) {
        networkService.fetchNews(text: text, page: page) { [weak self] result in
            switch result {
            case .success(let success):
                self?.mainView.updateDataForView(data: success)
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    
}

//
//  ViewController.swift
//  NewsApp
//
//  Created by Максим Жуин on 08.08.2024.
//

import UIKit

protocol MainNewsVCDelegate: AnyObject {
    func fetchMoreNews(page: String, text: String?)
    func goToDetailNews(model: ResultedFetch)
}

class MainNewsViewController: UIViewController {

    // MARK: - Properties
   private let mainView: MainNewsView
   private let networkService: NetworkService
    private let coredataModelService: CoredataModelService

    // MARK: - LifeCycle

    init(mainView: MainNewsView, networkService: NetworkService, coredataModelService: CoredataModelService) {
        self.mainView = mainView
        self.networkService = networkService
        self.coredataModelService = coredataModelService
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
        print(coredataModelService.modelsArray)
    }

    // MARK: - Funcs

    private func setupNavigation() {
        let title = "Главная"
        self.title = title
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(enableSearchField(_:)))
    }

    @objc private func enableSearchField(_ sender: UIBarButtonItem) {

    }

    private func fetchNews() {
        networkService.fetchNews(text: nil, page: nil) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                self.mainView.updateDataForView(data: success, networkService: self.networkService)
                guard let coredataModel = coredataModelService.modelsArray else {return }
                if coredataModel.isEmpty {
                    DispatchQueue.global(qos: .background).async {
                        self.coredataModelService.saveModelToCoreData(model: success)
                    }
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
}


extension MainNewsViewController: MainNewsVCDelegate {
    func fetchMoreNews(page: String, text: String?) {
        if networkService.isPaginating {
            mainView.addSpinningActivityIndicator()
        }
        networkService.fetchNews(text: text, page: page) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                self.mainView.updateDataForView(data: success, networkService: self.networkService)
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    func goToDetailNews(model: ResultedFetch) {
        let detailNewsView = DetailNewsView(frame: .zero)
        let detailNewsViewController = DetailNewsViewController(detailNewsView: detailNewsView, fetchedResult: model, networkService: self.networkService)
        navigationController?.pushViewController(detailNewsViewController, animated: true)
    }
}

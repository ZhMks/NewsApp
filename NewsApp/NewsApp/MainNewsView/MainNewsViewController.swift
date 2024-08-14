//
//  ViewController.swift
//  NewsApp
//
//  Created by Максим Жуин on 08.08.2024.
//

import UIKit

protocol MainNewsVCDelegate: AnyObject {
    func fetchMoreNews(page: String)
    func goToDetailNews(model: ResultedFetchResponse)
    func saveIntoFavourites(data: ResultedFetchResponse, image: UIImage?)
    func removeModelFromCoredata(data: ResultedFetchResponse)
}

class MainNewsViewController: UIViewController {

    // MARK: - Properties
    private let mainView: MainNewsView
    private let dataSourceService: DataSourceService
    private let favouritesCoredataService: FavouriteModelService
    private var fetchedNews: [MainNewsResponse] = []

    // MARK: - LifeCycle

    init(mainView: MainNewsView, dataSourceService: DataSourceService, favouritesCoredataService: FavouriteModelService) {
        self.mainView = mainView
        self.dataSourceService = dataSourceService
        self.favouritesCoredataService = favouritesCoredataService
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        self.view = mainView
        NotificationCenter.default.addObserver(self, selector: #selector(reloadRows), name: NSNotification.Name(.buttonTouched), object: nil)
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
        self.title = "Главная"
    }

    private func fetchNews() {
        dataSourceService.fetchNews(page: nil) { [weak self] result in
            switch result {
            case .success(let fetchedNews):
                self?.fetchedNews = fetchedNews
                guard let favouriteNews = self?.favouritesCoredataService.modelsArray else { return }
                self?.mainView.updateDataForView(data: (self?.fetchedNews)!, favouritesNews: favouriteNews)
            case .failure(let failure):
                print(failure.localizedDescription)
                return
            }
        }
    }

    @objc private func reloadRows() {
        guard let favouriteNews = self.favouritesCoredataService.modelsArray else { return }
        mainView.reloadTableViewRowsWith(data: favouriteNews)
    }
}


extension MainNewsViewController: MainNewsVCDelegate {

    func removeModelFromCoredata(data: ResultedFetchResponse) {
        favouritesCoredataService.remove(fetchedModel: data, savedModel: nil)
    }


    func saveIntoFavourites(data: ResultedFetchResponse, image: UIImage?) {
        favouritesCoredataService.saveToFavouriteModel(model: data, image: image)
    }

    func fetchMoreNews(page: String) {
        if dataSourceService.networkService.isPaginating {
            mainView.addSpinningActivityIndicator()
        }
        dataSourceService.fetchNews(page: page) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                guard let favouriteNews = self.favouritesCoredataService.modelsArray else { return }
                self.fetchedNews = success
                self.mainView.updateDataForView(data: self.fetchedNews, favouritesNews: favouriteNews)
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }

    func goToDetailNews(model: ResultedFetchResponse) {

        let detailNewsView = DetailNewsView(frame: .zero)

        let detailNewsViewController = DetailNewsViewController(detailNewsView: detailNewsView, fetchedResult: model, favouritesService: self.favouritesCoredataService)
        navigationController?.pushViewController(detailNewsViewController, animated: true)
    }
}




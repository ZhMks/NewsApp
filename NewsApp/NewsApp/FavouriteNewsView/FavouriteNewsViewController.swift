//
//  FavouriteNewsViewController.swift
//  NewsApp
//
//  Created by Максим Жуин on 09.08.2024.
//

import UIKit

protocol FavouriteNewsProtocol: AnyObject {
    func goToDetailFavourite(model: FavouriteNewsModel)
}

class FavouriteNewsViewController: UIViewController {

    // MARK: - Properties
    let favouritesView: FavouriteNewsView
    let networkService: NetworkService
    let favouritesCoredataService: FavouriteModelService

    // MARK: - Lifecycle

    init(favouritesView: FavouriteNewsView, networkService: NetworkService, favouritesCoredataService: FavouriteModelService) {
        self.favouritesView = favouritesView
        self.networkService = networkService
        self.favouritesCoredataService = favouritesCoredataService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = favouritesView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        favouritesView.favouritesVCDelegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(reloadRowsWith), name: Notification.Name(.buttonTouched), object: nil)
    }


    // MARK: - Funcs

    func updateView() {
        guard let modelsArray = favouritesCoredataService.modelsArray else { return }
        favouritesView.updateDataForView(data: modelsArray, networkService: self.networkService)
    }

    @objc private func reloadRowsWith() {
        guard let favouriteNews = self.favouritesCoredataService.modelsArray else { return }
        favouritesView.reloadTableViewRowsWith(data: favouriteNews)
    }
}


// MARK: - Delegate methods
extension FavouriteNewsViewController: FavouriteNewsProtocol {
    func goToDetailFavourite(model: FavouriteNewsModel) {
        let favouriteDetailView = DetailFavouriteView()
        let detailFavouriteVC = DetailFavouriteViewController(detailNewsView: favouriteDetailView, networkService: self.networkService, favouriteModel: model, favouriteService: self.favouritesCoredataService)
        navigationController?.pushViewController(detailFavouriteVC, animated: true)
    }
    

}

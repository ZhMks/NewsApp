//
//  DetailFavouriteViewController.swift
//  NewsApp
//
//  Created by Максим Жуин on 11.08.2024.
//

import UIKit

protocol DetailFavouriteDelegate: AnyObject {
}

final class DetailFavouriteViewController: UIViewController {

    // MARK: - Properties
    let detailNewsView: DetailFavouriteView
    let networkService: NetworkService
    let favouriteModel: FavouriteNewsModel
    let favouriteService: FavouriteModelService

    // MARK: - Lifecycle
    init(detailNewsView: DetailFavouriteView, networkService: NetworkService, favouriteModel: FavouriteNewsModel, favouriteService: FavouriteModelService) {
        self.detailNewsView = detailNewsView
        self.networkService = networkService
        self.favouriteModel = favouriteModel
        self.favouriteService = favouriteService
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = detailNewsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        detailNewsView.detailFavouriteDelegate = self
        updateViewData()
        setupNavigationBar()
    }


    // MARK: - Funcs

    private func updateViewData() {
        detailNewsView.updateViewData(data: self.favouriteModel, networkService: self.networkService)
    }

    private func setupNavigationBar() {
        let rightButton = UIBarButtonItem(title: "Удалить из избранного",
                                          style: .plain,
                                          target: self,
                                          action: #selector(rightButtonTouched(_:)))

        navigationItem.rightBarButtonItem = rightButton
    }

    @objc private func rightButtonTouched(_ sender: UIBarButtonItem) {
        favouriteService.remove(fetchedModel: nil, savedModel: self.favouriteModel)
        NotificationCenter.default.post(name: NSNotification.Name(.buttonTouched), object: nil)
        self.navigationController?.popViewController(animated: true)
    }

    @objc func dismissController() {
        self.navigationController?.popViewController(animated: true)
    }
}


// MARK: - Delegate Methods

extension DetailFavouriteViewController: DetailFavouriteDelegate {

}

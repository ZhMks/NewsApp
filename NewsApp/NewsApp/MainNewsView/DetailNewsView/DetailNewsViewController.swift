//
//  DetailNewsViewController.swift
//  NewsApp
//
//  Created by Максим Жуин on 09.08.2024.
//

import UIKit

protocol DetailNewsVCDelegate: AnyObject {
}

final class DetailNewsViewController: UIViewController {

    // MARK: - Properties
    let detailNewsView: DetailNewsView
    let fetchedResult: ResultedFetchResponse
    let favouritesService: FavouriteModelService

    // MARK: - Lifecycle
    init(detailNewsView: DetailNewsView, fetchedResult: ResultedFetchResponse, favouritesService: FavouriteModelService) {
        self.detailNewsView = detailNewsView
        self.fetchedResult = fetchedResult
        self.favouritesService = favouritesService
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
        detailNewsView.detailNewsVCDelegate = self
        updateViewData()
        setupNavigationBar()
    }


    // MARK: - Funcs

    private func updateViewData() {
        detailNewsView.updateViewData(data: self.fetchedResult)
    }

    private func setupNavigationBar() {
        let rightButton = UIBarButtonItem(title: "Добавить в избранное",
                                          style: .plain,
                                          target: self,
                                          action: #selector(rightButtonTouched(_:)))

        setupButtonTitle(rightButton)
        navigationItem.rightBarButtonItem = rightButton
    }

    private func setupButtonTitle(_ button: UIBarButtonItem) {
        if let favouriteNewsModels = self.favouritesService.modelsArray, !favouriteNewsModels.isEmpty {
            if favouriteNewsModels.contains(where: { $0.title! == fetchedResult.title }) {
                button.title = "Удалить из избранного"
            } else {
                button.title = "Добавить в избранное"
            }
        }
    }

    @objc private func rightButtonTouched(_ sender: UIBarButtonItem) {

        if sender.title == "Добавить в избранное" {
            favouritesService.saveToFavouriteModel(model: fetchedResult)
            sender.title = "Удалить из избранного"
        } else {
            favouritesService.remove(fetchedModel: fetchedResult, savedModel: nil)
            sender.title = "Добавить в избранное"
        }
        NotificationCenter.default.post(name: NSNotification.Name(.buttonTouched), object: nil)
    }

    @objc func dismissController() {
        self.navigationController?.popViewController(animated: true)
    }
}


// MARK: - Delegate Methods

extension DetailNewsViewController: DetailNewsVCDelegate {

}


extension String {
    static let buttonTouched = "ButtonTouched"
}

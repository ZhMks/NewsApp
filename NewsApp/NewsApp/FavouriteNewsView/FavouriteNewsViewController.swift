//
//  FavouriteNewsViewController.swift
//  NewsApp
//
//  Created by Максим Жуин on 09.08.2024.
//

import UIKit

protocol FavouriteNewsProtocol: AnyObject {
}

class FavouriteNewsViewController: UIViewController {

    // MARK: - Properties
    let favouritesView: FavouriteNewsView
    let networkService: NetworkService

    // MARK: - Lifecycle

    init(favouritesView: FavouriteNewsView, networkService: NetworkService) {
        self.favouritesView = favouritesView
        self.networkService = networkService
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
    }


    // MARK: - Funcs

    func updateView() {
        let modelService = FavouriteModelService()
        guard let modelsArray = modelService.modelsArray else { return }
        print(modelsArray.count)
        favouritesView.updateDataForView(data: modelsArray, networkService: self.networkService)
    }
}


// MARK: - Delegate methods
extension FavouriteNewsViewController: FavouriteNewsProtocol {

}

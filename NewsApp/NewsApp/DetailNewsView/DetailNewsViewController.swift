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
    let fetchedResult: ResultedFetch
    let networkService: NetworkService


    // MARK: - Lifecycle
    init(detailNewsView: DetailNewsView, fetchedResult: ResultedFetch, networkService: NetworkService) {
        self.detailNewsView = detailNewsView
        self.fetchedResult = fetchedResult
        self.networkService = networkService
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
    }
    

    // MARK: - Funcs

    private func updateViewData() {
        detailNewsView.updateViewData(data: self.fetchedResult, networkService: self.networkService)
    }
}


// MARK: - Delegate Methods

extension DetailNewsViewController: DetailNewsVCDelegate {
    
}

//
//  MainNewsView.swift
//  NewsApp
//
//  Created by Максим Жуин on 08.08.2024.
//

import UIKit


final class MainNewsView: UIView {
    // MARK: - Properties
    var dataSourceForTable: [NetworkModel] = []

    private lazy var newsTableView: UITableView = {
        let newsTableView = UITableView()
        newsTableView.translatesAutoresizingMaskIntoConstraints = false
        newsTableView.delegate = self
        newsTableView.dataSource = self
        return newsTableView
    }()
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        layout()
    }



    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Funcs

    private func addSubviews() {
        addSubview(newsTableView)
    }

    private func layout() {
        let safeArea = safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            newsTableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            newsTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            newsTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            newsTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            newsTableView.widthAnchor.constraint(equalTo: widthAnchor)
        ])
    }
}

// MARK: -TableView DataSource
extension MainNewsView: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSourceForTable.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

// MARK: - TableView Delegate
extension MainNewsView: UITableViewDelegate {

}

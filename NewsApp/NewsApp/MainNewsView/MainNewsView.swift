//
//  MainNewsView.swift
//  NewsApp
//
//  Created by Максим Жуин on 08.08.2024.
//

import UIKit


final class MainNewsView: UIView {
    // MARK: - Properties
    var dataSourceForTable: NetworkModel? = nil

    weak var mainNewsVCDelegate: MainNewsVCDelegate?

    private lazy var newsTableView: UITableView = {
        let newsTableView = UITableView()
        newsTableView.translatesAutoresizingMaskIntoConstraints = false
        newsTableView.delegate = self
        newsTableView.dataSource = self
        newsTableView.register(MainNewsTableViewCell.self, forCellReuseIdentifier: MainNewsTableViewCell.identifier)
        return newsTableView
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        layout()
        setupTableView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Funcs

    func updateDataForView(data: NetworkModel) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.dataSourceForTable = data
            self.newsTableView.reloadData()
        }
    }

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

    func setupTableView() {
        newsTableView.rowHeight = UITableView.automaticDimension
        newsTableView.estimatedRowHeight = 44.0
        newsTableView.tableFooterView = UIView()
        newsTableView.separatorStyle = .singleLine
    }
}

// MARK: -TableView DataSource
extension MainNewsView: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let numberOfRows = dataSourceForTable?.fetchedResults.count else { return 0 }
        return numberOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainNewsTableViewCell.identifier, for: indexPath) as? MainNewsTableViewCell else { return UITableViewCell() }
        guard let networkModel = dataSourceForTable else { return UITableViewCell() }
        let dataForCell = networkModel.fetchedResults[indexPath.row]
        cell.updateCell(data: dataForCell)
        return cell
    }
}

// MARK: - TableView Delegate
extension MainNewsView: UITableViewDelegate {

}

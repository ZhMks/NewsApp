//
//  MainNewsView.swift
//  NewsApp
//
//  Created by Максим Жуин on 08.08.2024.
//

import UIKit


final class MainNewsView: UIView {
    // MARK: - Properties
   private var dataSourceForTable: [NetworkModel]? = []

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
            self.dataSourceForTable?.append(data)
            self.newsTableView.reloadData()
            print(dataSourceForTable?.count)
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

    private func setupTableView() {
        newsTableView.rowHeight = UITableView.automaticDimension
        newsTableView.estimatedRowHeight = 44.0
        newsTableView.tableFooterView = UIView()
        newsTableView.separatorStyle = .singleLine
        newsTableView.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
}

// MARK: -TableView DataSource
extension MainNewsView: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        guard let numberOfSections = dataSourceForTable?.count else { return 0 }
        return numberOfSections
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let numberOfRows = dataSourceForTable?[section].fetchedResults.count else { return 10 }
        return numberOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainNewsTableViewCell.identifier, for: indexPath) as? MainNewsTableViewCell else { return UITableViewCell() }
        guard let networkModel = dataSourceForTable?[indexPath.section] else { return UITableViewCell() }
        let dataForCell = networkModel.fetchedResults[indexPath.row]
        cell.updateCell(data: dataForCell)
        return cell
    }
}

// MARK: - TableView Delegate
extension MainNewsView: UITableViewDelegate, UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y

        if position > (newsTableView.contentSize.height - 100-scrollView.frame.size.height) {
            guard let page = dataSourceForTable?.last?.nextPage else { return }
            mainNewsVCDelegate?.fetchMoreNews(page: page, text: nil)
        }
    }

}

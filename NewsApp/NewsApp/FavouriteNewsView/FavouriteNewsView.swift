//
//  FavouriteNewsView.swift
//  NewsApp
//
//  Created by Максим Жуин on 09.08.2024.
//

import UIKit

final class FavouriteNewsView: UIView {

    weak var favouritesVCDelegate: FavouriteNewsProtocol?
    var favouriteNews: [FavouriteNewsModel]?

    private lazy var newsTableView: UITableView = {
        let newsTableView = UITableView()
        newsTableView.translatesAutoresizingMaskIntoConstraints = false
        newsTableView.delegate = self
        newsTableView.dataSource = self
        newsTableView.register(FavouriteNewsCell.self, forCellReuseIdentifier: FavouriteNewsCell.identifier)
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

    func updateDataForView(data: [FavouriteNewsModel]) {
        self.favouriteNews = data
        newsTableView.reloadData()
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
        newsTableView.estimatedRowHeight = 80.0
        newsTableView.tableFooterView = UIView()
        newsTableView.separatorStyle = .singleLine
        newsTableView.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }

    func reloadTableViewRowsWith(data: [FavouriteNewsModel]) {
        self.favouriteNews = data
        self.newsTableView.reloadData()
    }
}

// MARK: - TableView DataSource
extension FavouriteNewsView: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let number = favouriteNews?.count else { return 0 }
        return number
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavouriteNewsCell.identifier, for: indexPath) as? FavouriteNewsCell else { return UITableViewCell() }
        guard let dataForCell = favouriteNews?[indexPath.row] else { return UITableViewCell() }
        cell.updateCell(with: dataForCell)
        return cell
    }
    

}


// MARK: - TableView Delegate
extension FavouriteNewsView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let favouriteNews = self.favouriteNews?[indexPath.row] else { return }
        favouritesVCDelegate?.goToDetailFavourite(model: favouriteNews)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

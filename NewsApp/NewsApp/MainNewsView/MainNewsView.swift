//
//  MainNewsView.swift
//  NewsApp
//
//  Created by Максим Жуин on 08.08.2024.
//

import UIKit



final class MainNewsView: UIView {
    // MARK: - Properties
   private var dataSourceForTable: [MainNewsResponse]? = []

   weak var mainNewsVCDelegate: MainNewsVCDelegate?

    private var favouriteNews: [FavouriteNewsModel]?

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

    func updateDataForView(data: [MainNewsResponse], favouritesNews: [FavouriteNewsModel]) {
        DispatchQueue.main.async {
            self.favouriteNews = favouritesNews
            self.dataSourceForTable? = data
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

    private func setupTableView() {
        newsTableView.estimatedRowHeight = 80.0
        newsTableView.tableFooterView = UIView()
        newsTableView.separatorStyle = .singleLine
        newsTableView.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }

    func addSpinningActivityIndicator() {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 80))
        let uiactivityindicator = UIActivityIndicatorView(style: .medium)
        uiactivityindicator.center = footerView.center
        footerView.addSubview(uiactivityindicator)
        uiactivityindicator.startAnimating()
        newsTableView.tableFooterView = footerView
    }

    func reloadTableViewRowsWith(data: [FavouriteNewsModel]) {
        self.favouriteNews = data
        self.newsTableView.reloadData()
    }
}

// MARK: -TableView DataSource
extension MainNewsView: UITableViewDataSource {


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        380
    }


    func numberOfSections(in tableView: UITableView) -> Int {
        guard let numberOfSections = dataSourceForTable?.count else { return 0 }
        return numberOfSections
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let numberOfRows = dataSourceForTable?[section].resultedFetch.count else { return 10 }
        return numberOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainNewsTableViewCell.identifier, for: indexPath) as? MainNewsTableViewCell else { return UITableViewCell() }
        guard let networkModel = dataSourceForTable?[indexPath.section] else { return UITableViewCell() }
        let dataForCell = networkModel.resultedFetch[indexPath.row]
        guard let favouriteNews = self.favouriteNews else { return UITableViewCell() }
        cell.updateCell(with: dataForCell, favouriteNews: favouriteNews)
        cell.mainCellDelegate = self
        return cell
    }
}

// MARK: - TableView Delegate
extension MainNewsView: UITableViewDelegate, UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        
        if position > (newsTableView.contentSize.height - 100-scrollView.frame.size.height) {
            guard let page = dataSourceForTable?.last?.nexPage else { return }
            mainNewsVCDelegate?.fetchMoreNews(page: page)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let fetchedModel = dataSourceForTable?[indexPath.section].resultedFetch[indexPath.row] else { return }
        mainNewsVCDelegate?.goToDetailNews(model: fetchedModel)
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

extension MainNewsView: MainNewsCellDelegate {
    
    func removeModelFromCoredata(data: ResultedFetchResponse) {
        mainNewsVCDelegate?.removeModelFromCoredata(data: data)
    }
    

    func saveIntoFavourites(data: ResultedFetchResponse, image: UIImage?) {
        mainNewsVCDelegate?.saveIntoFavourites(data: data, image: image)
    }

}

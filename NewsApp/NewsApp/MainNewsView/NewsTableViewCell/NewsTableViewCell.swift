//
//  NewsTableViewCell.swift
//  NewsApp
//
//  Created by Максим Жуин on 08.08.2024.
//

import UIKit

protocol MainNewsCellDelegate: AnyObject {
    func saveIntoFavourites(data: ResultedFetch)
    func removeModelFromCoredata(data: ResultedFetch)
}


final class MainNewsTableViewCell: UITableViewCell {
    // MARK: - Properties

    static let identifier = String.mainNewsIdentifier
    var networkService: NetworkService?
    var data: ResultedFetch?
    weak var mainCellDelegate: MainNewsCellDelegate?
    private var withImageConstraints: [NSLayoutConstraint] = []
    private var withoutImageConstraints: [NSLayoutConstraint] = []


    private lazy var creatorLabel: UILabel = {
        let creatorLabel = UILabel()
        creatorLabel.translatesAutoresizingMaskIntoConstraints = false
        creatorLabel.font = UIFont.boldSystemFont(ofSize: 12.0)
        return creatorLabel
    }()

    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .left
        return titleLabel
    }()

    private lazy var shortDescriptionLabel: UILabel = {
        let shortDescriptionLabel = UILabel()
        shortDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        shortDescriptionLabel.font = UIFont.systemFont(ofSize: 16.0)
        shortDescriptionLabel.numberOfLines = 4
        shortDescriptionLabel.textAlignment = .left
        shortDescriptionLabel.lineBreakMode = .byTruncatingTail
        return shortDescriptionLabel
    }()

    private lazy var shortImagePreview: UIImageView = {
        let shortImagePreview = UIImageView()
        shortImagePreview.translatesAutoresizingMaskIntoConstraints = false
        shortImagePreview.layer.masksToBounds = true
        shortImagePreview.layer.cornerRadius = 6.0
        return shortImagePreview
    }()

    private lazy var newsLink: UILabel = {
        let newsLink = UILabel()
        newsLink.translatesAutoresizingMaskIntoConstraints = false
        newsLink.font = UIFont.systemFont(ofSize: 12.0)
        newsLink.textColor = .systemBlue
        newsLink.textAlignment = .left
        newsLink.lineBreakMode = .byTruncatingTail
        return newsLink
    }()

    private lazy var publicationDate: UILabel = {
        let publicationDate = UILabel()
        publicationDate.translatesAutoresizingMaskIntoConstraints = false
        publicationDate.font = UIFont.boldSystemFont(ofSize: 12.0)
        return publicationDate
    }()

    private lazy var favouritesButton: UIButton = {
        let favouritesButton = UIButton(type: .system)
        favouritesButton.translatesAutoresizingMaskIntoConstraints = false
        favouritesButton.setBackgroundImage(UIImage(systemName: "star"), for: .normal)
        favouritesButton.addTarget(self, action: #selector(saveIntoFavourites(_:)), for: .touchUpInside)
        return favouritesButton
    }()

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        addSubviews()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        shortImagePreview.image = nil
        favouritesButton.setBackgroundImage(UIImage(systemName: "star"), for: .normal)
    }


    // MARK: - Funcs

    func updateCell(data: ResultedFetch, networkService: NetworkService, favouriteNews: [FavouriteNewsModel]) {

        self.networkService = networkService
        self.data = data
        checkFavouriteNews(news: data, favouriteNews: favouriteNews)

        titleLabel.text = data.title
        shortDescriptionLabel.text = data.description
        newsLink.text = data.link
        creatorLabel.text = data.creator?.first
        publicationDate.text = data.pubDate

        if let imageURL = data.imageUrl {
            networkService.fetchImage(imageUrl: imageURL) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let fetchedImage):
                    DispatchQueue.main.async { [weak self] in
                        guard let self else { return }
                        self.shortImagePreview.image = fetchedImage
                        self.shortImagePreview.isHidden = false
                        NSLayoutConstraint.deactivate(withoutImageConstraints)
                        NSLayoutConstraint.activate(withImageConstraints)
                        self.setNeedsLayout()
                        self.layoutIfNeeded()
                    }
                case .failure(let failure):
                    print(failure.localizedDescription)
                    return
                }
            }
        } else {
            shortImagePreview.image = nil
            shortImagePreview.isHidden = true

            NSLayoutConstraint.deactivate(withImageConstraints)
            NSLayoutConstraint.activate(withoutImageConstraints)
        }

        self.setNeedsLayout()
        self.layoutIfNeeded()
    }


    @objc private func saveIntoFavourites(_ sender: UIButton) {
        guard let data = self.data else { return }

        if sender.backgroundImage(for: .normal) == UIImage(systemName: "star") {
            sender.setBackgroundImage(UIImage(systemName: "star.fill"), for: .normal)
            mainCellDelegate?.saveIntoFavourites(data: data)
        } else if sender.backgroundImage(for: .normal) == UIImage(systemName: "star.fill") {
            sender.setBackgroundImage(UIImage(systemName: "star"), for: .normal)
            mainCellDelegate?.removeModelFromCoredata(data: data)
        }
    }

    private func checkFavouriteNews(news: ResultedFetch, favouriteNews: [FavouriteNewsModel]) {
        if favouriteNews.contains(where: { $0.title == news.title }) {
            favouritesButton.setBackgroundImage(UIImage(systemName: "star.fill"), for: .normal)
        }
    }

    private func addSubviews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(shortImagePreview)
        contentView.addSubview(shortDescriptionLabel)
        contentView.addSubview(newsLink)
        contentView.addSubview(creatorLabel)
        contentView.addSubview(publicationDate)
    }

    private func configureLayout() {
        let safeArea = contentView.safeAreaLayoutGuide

        withImageConstraints = [
            titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            titleLabel.bottomAnchor.constraint(equalTo: shortImagePreview.topAnchor, constant: -10),

            shortImagePreview.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            shortImagePreview.heightAnchor.constraint(lessThanOrEqualToConstant: 140),
            shortImagePreview.widthAnchor.constraint(equalToConstant: 250),
            shortImagePreview.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),

            shortDescriptionLabel.topAnchor.constraint(equalTo: shortImagePreview.bottomAnchor, constant: 10),
            shortDescriptionLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            shortDescriptionLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10),
            shortDescriptionLabel.bottomAnchor.constraint(equalTo: newsLink.topAnchor, constant: -10),

            newsLink.topAnchor.constraint(equalTo: shortDescriptionLabel.bottomAnchor, constant: 10),
            newsLink.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            newsLink.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -190),
            newsLink.bottomAnchor.constraint(equalTo: creatorLabel.topAnchor, constant: -10),

            creatorLabel.topAnchor.constraint(equalTo: newsLink.bottomAnchor, constant: 10),
            creatorLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            creatorLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -190),
            creatorLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -10),

            publicationDate.topAnchor.constraint(equalTo: newsLink.bottomAnchor, constant: 10),
            publicationDate.leadingAnchor.constraint(equalTo: creatorLabel.trailingAnchor, constant: 50),
            publicationDate.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -5),
            publicationDate.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -10)
        ]

        withoutImageConstraints = [
            titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            titleLabel.bottomAnchor.constraint(equalTo: shortDescriptionLabel.topAnchor, constant: -10),

            shortDescriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            shortDescriptionLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            shortDescriptionLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10),
            shortDescriptionLabel.bottomAnchor.constraint(equalTo: newsLink.topAnchor, constant: -10),

            newsLink.topAnchor.constraint(equalTo: shortDescriptionLabel.bottomAnchor, constant: 10),
            newsLink.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            newsLink.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -190),
            newsLink.bottomAnchor.constraint(equalTo: creatorLabel.topAnchor, constant: -10),

            creatorLabel.topAnchor.constraint(equalTo: newsLink.bottomAnchor, constant: 10),
            creatorLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            creatorLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -190),
            creatorLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -10),

            publicationDate.topAnchor.constraint(equalTo: newsLink.bottomAnchor, constant: 10),
            publicationDate.leadingAnchor.constraint(equalTo: creatorLabel.trailingAnchor, constant: 50),
            publicationDate.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -5),
            publicationDate.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -10)
        ]
    }


}

 extension String {
    static let mainNewsIdentifier = "MainNewsTableCell"
     static let favouriteNewsIdentifier = "FavouriteNewsCell"
}

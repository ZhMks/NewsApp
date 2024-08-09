//
//  FavouriteNewsCell.swift
//  NewsApp
//
//  Created by Максим Жуин on 09.08.2024.
//

import UIKit


final class FavouriteNewsCell: UITableViewCell {

    // MARK: - Properties
    static let identifier = String.favouriteNewsIdentifier

    var networkService: NetworkService?


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
        shortImagePreview.contentMode = .scaleAspectFill
        shortImagePreview.layer.masksToBounds = true
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

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        addSubviews()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        shortImagePreview.image = nil
    }


    // MARK: - Funcs

    func updateCell(data: FavouriteNewsModel, networkService: NetworkService) {

        self.networkService = networkService

        titleLabel.text = data.title
        shortDescriptionLabel.text = data.newsText
        newsLink.text = data.link
        creatorLabel.text = data.author
        publicationDate.text = data.pubDate

//        if let imageURL = data.imageUrl {
//            networkService.fetchImage(imageUrl: imageURL) { [weak self] result in
//                switch result {
//                case .success(let fetchedImage):
//                    DispatchQueue.main.async { [weak self] in
//                        self?.shortImagePreview.image = fetchedImage
//                        self?.layoutWithImage()
//                    }
//                case .failure(let failure):
//                    print(failure.localizedDescription)
//                    return
//                }
//            }
//        } else {
//            addSubviews()
//            layout()
//        }
    }

    private func addSubviews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(shortDescriptionLabel)
        contentView.addSubview(newsLink)
        contentView.addSubview(creatorLabel)
        contentView.addSubview(publicationDate)
    }

    private func layout() {
        let safeArea = contentView.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 5),
            titleLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -30),

            shortDescriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            shortDescriptionLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 5),
            shortDescriptionLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10),

            newsLink.topAnchor.constraint(equalTo: shortDescriptionLabel.bottomAnchor, constant: 15),
            newsLink.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            newsLink.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -190),
            newsLink.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -20),

            publicationDate.topAnchor.constraint(equalTo: shortDescriptionLabel.bottomAnchor, constant: 15),
            publicationDate.leadingAnchor.constraint(equalTo: newsLink.trailingAnchor, constant: 25),
            publicationDate.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10),
            publicationDate.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -25),

            creatorLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            creatorLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -190),
            creatorLabel.topAnchor.constraint(equalTo: publicationDate.bottomAnchor, constant: 5),
            creatorLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -5)
        ])
    }

    private func layoutWithImage() {
        addSubviewsWithImage()

        let safeArea = contentView.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 5),
            titleLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -30),

            shortImagePreview.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            shortImagePreview.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 5),
            shortImagePreview.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -15),
            shortImagePreview.heightAnchor.constraint(lessThanOrEqualToConstant: 180),

            shortDescriptionLabel.topAnchor.constraint(equalTo: shortImagePreview.bottomAnchor, constant: 5),
            shortDescriptionLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 5),
            shortDescriptionLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10),

            newsLink.topAnchor.constraint(equalTo: shortDescriptionLabel.bottomAnchor, constant: 15),
            newsLink.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            newsLink.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -190),
            newsLink.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -20),

            publicationDate.topAnchor.constraint(equalTo: shortDescriptionLabel.bottomAnchor, constant: 15),
            publicationDate.leadingAnchor.constraint(equalTo: newsLink.trailingAnchor, constant: 25),
            publicationDate.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10),
            publicationDate.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -25),

            creatorLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            creatorLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -190),
            creatorLabel.topAnchor.constraint(equalTo: publicationDate.bottomAnchor, constant: 5),
            creatorLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -5)
        ])
    }

    private func addSubviewsWithImage() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(shortImagePreview)
        contentView.addSubview(shortDescriptionLabel)
        contentView.addSubview(newsLink)
        contentView.addSubview(creatorLabel)
        contentView.addSubview(publicationDate)
    }

}

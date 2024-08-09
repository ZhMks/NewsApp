//
//  NewsTableViewCell.swift
//  NewsApp
//
//  Created by Максим Жуин on 08.08.2024.
//

import UIKit

protocol MainNewsCellDelegate: AnyObject {
    func saveIntoFavourites(data: ResultedFetch)
}


final class MainNewsTableViewCell: UITableViewCell {
    // MARK: - Properties

    static let identifier = String.mainNewsIdentifier
    var networkService: NetworkService?
    var data: ResultedFetch?
    weak var mainCellDelegate: MainNewsCellDelegate?


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

    func updateCell(data: ResultedFetch, networkService: NetworkService) {

        self.networkService = networkService
        self.data = data

        titleLabel.text = data.title
        shortDescriptionLabel.text = data.description
        newsLink.text = data.link
        creatorLabel.text = data.creator?.first
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

    @objc private func saveIntoFavourites(_ sender: UIButton) {
        guard let data = self.data else { return }
        mainCellDelegate?.saveIntoFavourites(data: data)
    }

    private func addSubviews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(shortDescriptionLabel)
        contentView.addSubview(newsLink)
        contentView.addSubview(creatorLabel)
        contentView.addSubview(publicationDate)
        contentView.addSubview(favouritesButton)
    }

    private func layout() {
        let safeArea = contentView.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 5),
            titleLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -50),

            favouritesButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            favouritesButton.heightAnchor.constraint(equalToConstant: 24),
            favouritesButton.widthAnchor.constraint(equalToConstant: 24),
            favouritesButton.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 10),

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

 extension String {
    static let mainNewsIdentifier = "MainNewsTableCell"
     static let favouriteNewsIdentifier = "FavouriteNewsCell"
}

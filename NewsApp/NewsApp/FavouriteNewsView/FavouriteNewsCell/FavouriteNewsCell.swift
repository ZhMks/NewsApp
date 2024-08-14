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
    var data: FavouriteNewsModel?
    private var withImageConstraints: [NSLayoutConstraint] = []
    private var withImageWithoutDescr: [NSLayoutConstraint] = []


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
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        shortImagePreview.image = nil
    }


    // MARK: - Funcs

    func updateCell(with data: FavouriteNewsModel, networkService: NetworkService) {

        self.networkService = networkService
        self.data = data

        configureLabels(with: data)

        if let imageUrl = data.image, let requestURL = URL(string: imageUrl) {
            shortImagePreview.kf.setImage(with: requestURL, placeholder: UIImage(systemName: "photo.artframe")) { [weak self] result in
                switch result {
                case .success(let retrivedImage):
                    self?.shortImagePreview.image = retrivedImage.image
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        } else {
            shortImagePreview.image = UIImage(systemName: "photo.artframe")
        }

        if data.description.isEmpty {
            shortDescriptionLabel.text = nil
            shortDescriptionLabel.isHidden = true

            NSLayoutConstraint.deactivate(withImageConstraints)
            NSLayoutConstraint.activate(withImageWithoutDescr)
        } else {
            shortDescriptionLabel.isHidden = false
            shortDescriptionLabel.text = data.newsText
            NSLayoutConstraint.deactivate(withImageWithoutDescr)
            NSLayoutConstraint.activate(withImageConstraints)
        }

        setNeedsUpdateConstraints()
        setNeedsLayout()
    }

    private func configureLabels(with data: FavouriteNewsModel) {
        titleLabel.text = data.title
        newsLink.text = data.link
        creatorLabel.text = data.author
        publicationDate.text = data.pubDate
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
            titleLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -50),
            titleLabel.heightAnchor.constraint(equalToConstant: 80),

            shortImagePreview.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            shortImagePreview.heightAnchor.constraint(equalToConstant: 140),
            shortImagePreview.widthAnchor.constraint(equalToConstant: 180),
            shortImagePreview.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),

            shortDescriptionLabel.topAnchor.constraint(equalTo: shortImagePreview.bottomAnchor, constant: 10),
            shortDescriptionLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            shortDescriptionLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10),
            shortDescriptionLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -80),

            newsLink.topAnchor.constraint(equalTo: shortDescriptionLabel.bottomAnchor, constant: 10),
            newsLink.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            newsLink.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -130),
            newsLink.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -30),

            creatorLabel.topAnchor.constraint(equalTo: newsLink.bottomAnchor, constant: 10),
            creatorLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 15),
            creatorLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -180),
            creatorLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -10),

            publicationDate.topAnchor.constraint(equalTo: newsLink.bottomAnchor, constant: 10),
            publicationDate.leadingAnchor.constraint(equalTo: creatorLabel.trailingAnchor, constant: 30),
            publicationDate.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -5),
            publicationDate.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -10)
        ]

        withImageWithoutDescr = [

            titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -30),
            titleLabel.heightAnchor.constraint(equalToConstant: 80),

            shortImagePreview.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            shortImagePreview.heightAnchor.constraint(equalToConstant: 140),
            shortImagePreview.widthAnchor.constraint(equalToConstant: 180),
            shortImagePreview.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),

            newsLink.topAnchor.constraint(equalTo: shortImagePreview.bottomAnchor, constant: 15),
            newsLink.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            newsLink.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -130),
            newsLink.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -30),

            creatorLabel.topAnchor.constraint(equalTo: newsLink.bottomAnchor, constant: 10),
            creatorLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 15),
            creatorLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -180),
            creatorLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -10),

            publicationDate.topAnchor.constraint(equalTo: newsLink.bottomAnchor, constant: 10),
            publicationDate.leadingAnchor.constraint(equalTo: creatorLabel.trailingAnchor, constant: 30),
            publicationDate.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -5),
            publicationDate.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -10)
        ]
    }

}

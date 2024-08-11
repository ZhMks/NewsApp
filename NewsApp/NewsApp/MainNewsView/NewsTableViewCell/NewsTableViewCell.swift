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
    private var withoutDescriptionWithoutImage: [NSLayoutConstraint] = []
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
        shortImagePreview.layer.masksToBounds = true
        shortImagePreview.layer.cornerRadius = 6.0
        shortImagePreview.contentMode = .scaleToFill
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

    func updateCell(with data: ResultedFetch, networkService: NetworkService, favouriteNews: [FavouriteNewsModel]) {
        self.networkService = networkService
        self.data = data

        checkFavouriteNews(news: data, favouriteNews: favouriteNews)

        configureLabels(with: data)
        updateImageAndDescription(with: data)

        setNeedsUpdateConstraints()
        layoutIfNeeded()
    }

    private func configureLabels(with data: ResultedFetch) {
        titleLabel.text = data.title
        newsLink.text = data.link
        creatorLabel.text = data.creator?.first
        publicationDate.text = data.pubDate
    }

    private func updateImageAndDescription(with data: ResultedFetch) {
        
        guard let brokenImage = UIImage(systemName: "photo.artframe") else { return }
        updateUIWithImage(brokenImage, description: data.description)

        guard let imageUrl = data.imageUrl else {
            handleNoImage(data: data)
            return
        }

        networkService!.fetchImage(imageUrl: imageUrl) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let fetchedImage):
                DispatchQueue.main.async {
                    self.updateUIWithImage(fetchedImage, description: data.description)
                }
            case .failure(let error):
                guard let brokenImage = UIImage(systemName: "photo.artframe") else { return }
                DispatchQueue.main.async {
                    self.updateUIWithImage(brokenImage, description: data.description)
                }
                print(error.localizedDescription)
            }
        }
    }

    private func handleNoImage(data: ResultedFetch) {
        print("Data without data: \(data.description)")
        if data.description == nil {
            updateUIWithNoImageNoDescription()
        } else {
            updateUIWithNoImage(with: data.description)
        }
    }

    private func updateUIWithImage(_ image: UIImage, description: String?) {
        print("Data withImage data: \(description), image: \(image.description)")
        shortImagePreview.image = image
        shortImagePreview.isHidden = false
        shortDescriptionLabel.text = description
        shortDescriptionLabel.isHidden = false

        NSLayoutConstraint.deactivate(withoutImageConstraints)
        NSLayoutConstraint.deactivate(withoutDescriptionWithoutImage)
        NSLayoutConstraint.deactivate(withImageConstraints)
        NSLayoutConstraint.deactivate(withImageWithoutDescr)

        if let description = description, !description.isEmpty {
            NSLayoutConstraint.activate(withImageConstraints)
        } else {
            NSLayoutConstraint.activate(withImageWithoutDescr)
        }
    }


    private func updateUIWithNoImageNoDescription() {
        shortImagePreview.image = nil
        shortImagePreview.isHidden = true
        shortDescriptionLabel.text = nil
        shortDescriptionLabel.isHidden = true

        NSLayoutConstraint.deactivate(withoutImageConstraints)
        NSLayoutConstraint.deactivate(withImageConstraints)
        NSLayoutConstraint.activate(withoutDescriptionWithoutImage)
    }

    private func updateUIWithNoImage(with description: String?) {
        print("Description: \(description), Image Is NIL")
        shortImagePreview.image = nil
        shortImagePreview.isHidden = true
        shortDescriptionLabel.text = description
        shortDescriptionLabel.isHidden = false

        NSLayoutConstraint.deactivate(withoutImageConstraints)
        NSLayoutConstraint.deactivate(withoutDescriptionWithoutImage)
        NSLayoutConstraint.deactivate(withImageConstraints)
        NSLayoutConstraint.deactivate(withImageWithoutDescr)

        if let description = description, !description.isEmpty {
            NSLayoutConstraint.activate(withoutImageConstraints)
        } else {
            NSLayoutConstraint.activate(withoutDescriptionWithoutImage)
        }
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
        contentView.addSubview(favouritesButton)
    }

    private func configureLayout() {
        let safeArea = contentView.safeAreaLayoutGuide

        withImageConstraints = [
            titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -50),
            titleLabel.heightAnchor.constraint(equalToConstant: 80),

            favouritesButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 25),
            favouritesButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -15),
            favouritesButton.heightAnchor.constraint(equalToConstant: 24),
            favouritesButton.widthAnchor.constraint(equalToConstant: 24),

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


        withoutImageConstraints = [
            titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -30),
            titleLabel.heightAnchor.constraint(equalToConstant: 80),

            favouritesButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 25),
            favouritesButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -15),
            favouritesButton.heightAnchor.constraint(equalToConstant: 24),
            favouritesButton.widthAnchor.constraint(equalToConstant: 24),

            shortDescriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
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

        withoutDescriptionWithoutImage = [
            titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -30),
            titleLabel.heightAnchor.constraint(equalToConstant: 80),

            favouritesButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 25),
            favouritesButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -15),
            favouritesButton.heightAnchor.constraint(equalToConstant: 24),
            favouritesButton.widthAnchor.constraint(equalToConstant: 24),

            newsLink.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
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

            favouritesButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 25),
            favouritesButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -15),
            favouritesButton.heightAnchor.constraint(equalToConstant: 24),
            favouritesButton.widthAnchor.constraint(equalToConstant: 24),

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

extension String {
    static let mainNewsIdentifier = "MainNewsTableCell"
    static let favouriteNewsIdentifier = "FavouriteNewsCell"
}

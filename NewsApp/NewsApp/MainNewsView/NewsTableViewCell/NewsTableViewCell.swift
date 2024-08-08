//
//  NewsTableViewCell.swift
//  NewsApp
//
//  Created by Максим Жуин on 08.08.2024.
//

import UIKit


final class MainNewsTableViewCell: UITableViewCell {
    // MARK: - Properties

    static let identifier = String.identifier

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
        return titleLabel
    }()

    private lazy var shortDescriptionLabel: UILabel = {
        let shortDescriptionLabel = UILabel()
        shortDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        shortDescriptionLabel.font = UIFont.systemFont(ofSize: 16.0)
        shortDescriptionLabel.numberOfLines = 4
        return shortDescriptionLabel
    }()

    private lazy var newsLink: UILabel = {
        let newsLink = UILabel()
        newsLink.translatesAutoresizingMaskIntoConstraints = false
        newsLink.font = UIFont.systemFont(ofSize: 12.0)
        newsLink.textColor = .systemBlue
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
    

    // MARK: - Funcs

    func updateCell(data: ResultedFetch) {
        titleLabel.text = data.title
        shortDescriptionLabel.text = data.description
        newsLink.text = data.link
        creatorLabel.text = data.creator?.first
        publicationDate.text = data.pubDate
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
            titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 5),
            titleLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -50),
            titleLabel.bottomAnchor.constraint(equalTo: shortDescriptionLabel.topAnchor, constant: -10),

            shortDescriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            shortDescriptionLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 5),
            shortDescriptionLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10),
            shortDescriptionLabel.bottomAnchor.constraint(equalTo: newsLink.topAnchor, constant: -10),

            newsLink.topAnchor.constraint(equalTo: shortDescriptionLabel.bottomAnchor, constant: 5),
            newsLink.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 5),
            newsLink.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -150),
            newsLink.bottomAnchor.constraint(equalTo: publicationDate.topAnchor, constant: -5),

            publicationDate.topAnchor.constraint(equalTo: newsLink.bottomAnchor, constant: 5),
            publicationDate.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 5),
            publicationDate.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -180),
            publicationDate.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -20),

            creatorLabel.leadingAnchor.constraint(equalTo: publicationDate.trailingAnchor, constant: 30),
            creatorLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10),
            creatorLabel.topAnchor.constraint(equalTo: newsLink.bottomAnchor, constant: 5),
            creatorLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -20),
        ])
    }
}


private extension String {
    static let identifier = "MainNewsTableCell"
}

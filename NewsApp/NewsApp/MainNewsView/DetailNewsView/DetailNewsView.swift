//
//  DetailNewsView.swift
//  NewsApp
//
//  Created by Максим Жуин on 09.08.2024.
//

import UIKit
import Kingfisher

final class DetailNewsView: UIView {

    // MARK: - Properties
    weak var detailNewsVCDelegate: DetailNewsVCDelegate?

    private var withImageConstraints: [NSLayoutConstraint] = []
    private var withImageWithoutDescr: [NSLayoutConstraint] = []

    private lazy var newsTitle: UILabel = {
        let newsTitle = UILabel()
        newsTitle.translatesAutoresizingMaskIntoConstraints = false
        newsTitle.font = UIFont.boldSystemFont(ofSize: 20.0)
        newsTitle.textAlignment = .left
        newsTitle.numberOfLines = 0
        return newsTitle
    }()

    private lazy var newsImage: UIImageView = {
        let newsImage = UIImageView()
        newsImage.translatesAutoresizingMaskIntoConstraints = false
        newsImage.contentMode = .scaleAspectFit
        newsImage.clipsToBounds = true
        return newsImage
    }()

    private lazy var newsText: UILabel = {
        let newsText = UILabel()
        newsText.translatesAutoresizingMaskIntoConstraints = false
        newsText.textAlignment = .left
        newsText.font = UIFont.systemFont(ofSize: 16.0)
        newsText.numberOfLines = 0
        return newsText
    }()

    private lazy var newsDate: UILabel = {
        let newsDate = UILabel()
        newsDate.translatesAutoresizingMaskIntoConstraints = false
        newsDate.textAlignment = .left
        newsDate.font = UIFont.systemFont(ofSize: 12.0)
        return newsDate
    }()

    private lazy var newsAuthor: UILabel = {
        let newsAuthor = UILabel()
        newsAuthor.translatesAutoresizingMaskIntoConstraints = false
        newsAuthor.font = UIFont.boldSystemFont(ofSize: 12.0)
        newsAuthor.textAlignment = .left
        return newsAuthor
    }()

    private lazy var newsLink: UILabel = {
        let newsLink = UILabel()
        newsLink.translatesAutoresizingMaskIntoConstraints = false
        newsLink.font = UIFont.systemFont(ofSize: 12.0)
        newsLink.textColor = .systemBlue
        newsLink.textAlignment = .left
        newsLink.numberOfLines = 0
        return newsLink
    }()


    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    // MARK: - Funcs

    func updateViewData(data: ResultedFetchResponse) {

        configureLabels(with: data)
        
        if let imageUrl = data.imageURL, let requestURL = URL(string: imageUrl) {
            newsImage.kf.setImage(with: requestURL, placeholder: UIImage(systemName: "photo.artframe")) { [weak self] result in
                switch result {
                case .success(let retrivedImage):
                    self?.newsImage.image = retrivedImage.image
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        } else {
            newsImage.image = UIImage(systemName: "photo.artframe")
        }

        if data.description == nil {
            newsText.text = nil
            newsText.isHidden = true

            NSLayoutConstraint.deactivate(withImageConstraints)
            NSLayoutConstraint.activate(withImageWithoutDescr)
        } else {
            newsText.text = data.description
            NSLayoutConstraint.deactivate(withImageWithoutDescr)
            NSLayoutConstraint.activate(withImageConstraints)
        }

        setNeedsUpdateConstraints()
        layoutIfNeeded()
        setNeedsLayout()
    }

    private func configureLabels(with data: ResultedFetchResponse) {
        newsTitle.text = data.title
        newsLink.text = data.link
        newsAuthor.text = data.creator?.first
        newsDate.text = data.pubDate
    }

    private func addSubviews() {
        addSubview(newsTitle)
        addSubview(newsImage)
        addSubview(newsText)
        addSubview(newsAuthor)
        addSubview(newsLink)
        addSubview(newsDate)
    }


    private func configureLayout() {
        let safeArea = safeAreaLayoutGuide

        withImageConstraints = [
            newsTitle.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
            newsTitle.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            newsTitle.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -50),
            newsTitle.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -630),

            newsImage.topAnchor.constraint(equalTo: newsTitle.bottomAnchor, constant: 30),
            newsImage.heightAnchor.constraint(equalToConstant: 160),
            newsImage.widthAnchor.constraint(equalToConstant: 180),
            newsImage.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),

            newsText.topAnchor.constraint(equalTo: newsImage.bottomAnchor, constant: 10),
            newsText.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            newsText.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10),
            newsText.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -140),

            newsLink.topAnchor.constraint(equalTo: newsText.bottomAnchor, constant: 10),
            newsLink.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            newsLink.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10),
            newsLink.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -60),

            newsAuthor.topAnchor.constraint(equalTo: newsLink.bottomAnchor, constant: 10),
            newsAuthor.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 15),
            newsAuthor.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -180),
            newsAuthor.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -40),

            newsDate.topAnchor.constraint(equalTo: newsLink.bottomAnchor, constant: 10),
            newsDate.leadingAnchor.constraint(equalTo: newsAuthor.trailingAnchor, constant: 30),
            newsDate.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -5),
            newsDate.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -40)
        ]

        withImageWithoutDescr = [

            newsTitle.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
            newsTitle.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            newsTitle.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -30),
            newsTitle.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -630),

            newsImage.topAnchor.constraint(equalTo: newsTitle.bottomAnchor, constant: 30),
            newsImage.heightAnchor.constraint(equalToConstant: 160),
            newsImage.widthAnchor.constraint(equalToConstant: 180),
            newsImage.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),

            newsLink.topAnchor.constraint(equalTo: newsText.bottomAnchor, constant: 10),
            newsLink.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            newsLink.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10),
            newsLink.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -60),

            newsAuthor.topAnchor.constraint(equalTo: newsLink.bottomAnchor, constant: 10),
            newsAuthor.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 15),
            newsAuthor.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -180),
            newsAuthor.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -40),

            newsDate.topAnchor.constraint(equalTo: newsLink.bottomAnchor, constant: 10),
            newsDate.leadingAnchor.constraint(equalTo: newsAuthor.trailingAnchor, constant: 30),
            newsDate.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -5),
            newsDate.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -40)
        ]
    }

}

 extension String {

    var underLined: NSAttributedString {
        NSMutableAttributedString(string: self, attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
    }

}

//
//  DetailNewsView.swift
//  NewsApp
//
//  Created by Максим Жуин on 09.08.2024.
//

import UIKit

final class DetailNewsView: UIView {

    // MARK: - Properties
    weak var detailNewsVCDelegate: DetailNewsVCDelegate?
    var networkService: NetworkService?

    private var withImageConstraints: [NSLayoutConstraint] = []
    private var withoutImageConstraints: [NSLayoutConstraint] = []
    private var withoutDescriptionWithoutImage: [NSLayoutConstraint] = []
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

    func updateViewData(data: ResultedFetch, networkService: NetworkService?) {
        self.networkService = networkService
        print("DATA FOR VIEW: \(data.description), title: \(data.title), image: \(data.imageUrl)")
        configureLabels(with: data)
        updateImageAndDescription(with: data)

        setNeedsUpdateConstraints()
        layoutIfNeeded()
    }

    private func configureLabels(with data: ResultedFetch) {
        newsTitle.text = data.title
        newsLink.text = data.link
        newsAuthor.text = data.creator?.first
        newsDate.text = data.pubDate
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
                DispatchQueue.main.async {
                    self.updateUIWithImage(brokenImage, description: data.description)
                }
                print(error.localizedDescription)
            }
        }
    }

    private func handleNoImage(data: ResultedFetch) {

        if data.description == nil {
            updateUIWithNoImageNoDescription()
        } else {
            updateUIWithNoImage(with: data.description)
        }
    }

    private func updateUIWithImage(_ image: UIImage, description: String?) {

        newsImage.image = image
        newsImage.isHidden = false
        newsText.text = description
        newsText.isHidden = false

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
        newsImage.image = nil
        newsImage.isHidden = true
        newsText.text = nil
        newsText.isHidden = true

        NSLayoutConstraint.deactivate(withoutImageConstraints)
        NSLayoutConstraint.deactivate(withImageConstraints)
        NSLayoutConstraint.activate(withoutDescriptionWithoutImage)
    }

    private func updateUIWithNoImage(with description: String?) {

        newsImage.image = nil
        newsImage.isHidden = true
        newsText.text = description
        newsText.isHidden = false

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
            newsTitle.heightAnchor.constraint(greaterThanOrEqualToConstant: 80),

            newsImage.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 120),
            newsImage.heightAnchor.constraint(equalToConstant: 160),
            newsImage.widthAnchor.constraint(equalToConstant: 180),
            newsImage.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),

            newsText.topAnchor.constraint(equalTo: newsImage.bottomAnchor, constant: 10),
            newsText.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            newsText.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10),
            newsText.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -80),

            newsLink.topAnchor.constraint(equalTo: newsText.bottomAnchor, constant: 10),
            newsLink.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            newsLink.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -130),
            newsLink.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -30),

            newsAuthor.topAnchor.constraint(equalTo: newsLink.bottomAnchor, constant: 10),
            newsAuthor.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 15),
            newsAuthor.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -180),
            newsAuthor.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -10),

            newsDate.topAnchor.constraint(equalTo: newsLink.bottomAnchor, constant: 10),
            newsDate.leadingAnchor.constraint(equalTo: newsAuthor.trailingAnchor, constant: 30),
            newsDate.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -5),
            newsDate.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -10)
        ]


        withoutImageConstraints = [
            newsTitle.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
            newsTitle.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            newsTitle.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -30),
            newsTitle.heightAnchor.constraint(greaterThanOrEqualToConstant: 80),

            newsText.topAnchor.constraint(equalTo: newsTitle.bottomAnchor, constant: 20),
            newsText.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            newsText.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10),
            newsText.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -80),

            newsLink.topAnchor.constraint(equalTo: newsText.bottomAnchor, constant: 10),
            newsLink.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            newsLink.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -130),
            newsLink.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -30),

            newsAuthor.topAnchor.constraint(equalTo: newsLink.bottomAnchor, constant: 10),
            newsAuthor.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 15),
            newsAuthor.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -180),
            newsAuthor.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -10),

            newsDate.topAnchor.constraint(equalTo: newsLink.bottomAnchor, constant: 10),
            newsDate.leadingAnchor.constraint(equalTo: newsAuthor.trailingAnchor, constant: 30),
            newsDate.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -5),
            newsDate.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -10)
        ]

        withoutDescriptionWithoutImage = [
            newsTitle.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
            newsTitle.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            newsTitle.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -30),
            newsTitle.heightAnchor.constraint(greaterThanOrEqualToConstant: 80),

            newsLink.topAnchor.constraint(equalTo: newsTitle.bottomAnchor, constant: 15),
            newsLink.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            newsLink.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -130),
            newsLink.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -30),

            newsAuthor.topAnchor.constraint(equalTo: newsLink.bottomAnchor, constant: 10),
            newsAuthor.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 15),
            newsAuthor.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -180),
            newsAuthor.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -10),

            newsDate.topAnchor.constraint(equalTo: newsLink.bottomAnchor, constant: 10),
            newsDate.leadingAnchor.constraint(equalTo: newsAuthor.trailingAnchor, constant: 30),
            newsDate.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -5),
            newsDate.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -10)
        ]

        withImageWithoutDescr = [

            newsTitle.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
            newsTitle.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            newsTitle.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -30),
            newsTitle.heightAnchor.constraint(greaterThanOrEqualToConstant: 80),

            newsImage.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 120),
            newsImage.heightAnchor.constraint(equalToConstant: 160),
            newsImage.widthAnchor.constraint(equalToConstant: 180),
            newsImage.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),

            newsLink.topAnchor.constraint(equalTo: newsImage.bottomAnchor, constant: 15),
            newsLink.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            newsLink.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -130),
            newsLink.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -30),

            newsAuthor.topAnchor.constraint(equalTo: newsLink.bottomAnchor, constant: 10),
            newsAuthor.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 15),
            newsAuthor.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -180),
            newsAuthor.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -10),

            newsDate.topAnchor.constraint(equalTo: newsLink.bottomAnchor, constant: 10),
            newsDate.leadingAnchor.constraint(equalTo: newsAuthor.trailingAnchor, constant: 30),
            newsDate.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -5),
            newsDate.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -10)
        ]
    }

}

 extension String {

    var underLined: NSAttributedString {
        NSMutableAttributedString(string: self, attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
    }

}

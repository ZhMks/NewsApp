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
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    // MARK: - Funcs

    func updateViewData(data: ResultedFetch, networkService: NetworkService?) {
        self.networkService = networkService
        newsTitle.attributedText = data.title.underLined
        newsText.text = data.description
        newsAuthor.text = data.creator?.first
        newsDate.text = data.pubDate
        newsLink.attributedText = data.link.underLined

        if let imageURl = data.imageUrl {
            networkService?.fetchImage(imageUrl: imageURl, completion: { [weak self] result in
                switch result {
                case .success(let fetchedImage):
                    DispatchQueue.main.async { 
                        self?.newsImage.image = fetchedImage
                    }
                case .failure(let failure):
                    print(failure.localizedDescription)
                    return
                }
            })
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


    private func layout() {
        let safeArea = safeAreaLayoutGuide

        NSLayoutConstraint.activate( [
            newsTitle.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
            newsTitle.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            newsTitle.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10),
            newsTitle.bottomAnchor.constraint(equalTo: newsImage.topAnchor, constant: -10),

            newsImage.topAnchor.constraint(equalTo: newsTitle.bottomAnchor, constant: 10),
            newsImage.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 5),
            newsImage.heightAnchor.constraint(lessThanOrEqualToConstant: 250),
            newsImage.widthAnchor.constraint(equalToConstant: 300),

            newsText.topAnchor.constraint(equalTo: newsImage.bottomAnchor, constant: 10),
            newsText.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            newsText.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10),
            newsText.bottomAnchor.constraint(equalTo: newsAuthor.topAnchor, constant: -5),

            newsAuthor.topAnchor.constraint(equalTo: newsText.bottomAnchor, constant: 10),
            newsAuthor.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            newsAuthor.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10),
            newsAuthor.heightAnchor.constraint(equalToConstant: 30),

            newsLink.topAnchor.constraint(equalTo: newsAuthor.bottomAnchor, constant: 10),
            newsLink.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            newsLink.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -30),
            newsLink.heightAnchor.constraint(equalToConstant: 30),

            newsDate.topAnchor.constraint(equalTo: newsLink.bottomAnchor, constant: 10),
            newsDate.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            newsDate.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -5),
            newsDate.heightAnchor.constraint(equalToConstant: 30)
        ] )
    }
}

 extension String {

    var underLined: NSAttributedString {
        NSMutableAttributedString(string: self, attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
    }

}

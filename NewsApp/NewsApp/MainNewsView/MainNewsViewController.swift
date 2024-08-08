//
//  ViewController.swift
//  NewsApp
//
//  Created by Максим Жуин on 08.08.2024.
//

import UIKit

class MainNewsViewController: UIViewController {

    let networkService = NetworkServiceClass()
    override func viewDidLoad() {
        super.viewDidLoad()
        if let preferredLanguage = Locale.preferredLanguages.first {
            print("System Language: \(preferredLanguage)")
        } else {
            print("Unable to retrieve system language.")
        }
        view.backgroundColor = .systemBackground
        networkService.fetchSpecificNews(text: "sports") { [weak self] result in
            switch result {
            case .success(let success):
                print(success.totalResults)
                success.fetchedResults.forEach { element in
                    print(element.title)
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }


}


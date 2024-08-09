//
//  CoredataModelService.swift
//  NewsApp
//
//  Created by Максим Жуин on 09.08.2024.
//

import Foundation

final class FavouriteModelService {

    private(set) var  modelsArray: [FavouriteNewsModel]?
    let coredataService = CoreDataService.shared

    init() {
        initialFetch()
    }

    private func initialFetch() {
        let request = FavouriteNewsModel.fetchRequest()
        do {
            modelsArray = try coredataService.context.fetch(request)
        } catch {
            modelsArray = []
            print("Cannot fetch data for request")
        }
    }


    func saveToFavouriteModel(model: ResultedFetch) {
        guard let modelsArray = self.modelsArray else { return }
        let favouriteToSave = FavouriteNewsModel(context: coredataService.context)

        if modelsArray.contains(where: { $0.title == model.title }) {
            return
        }

        favouriteToSave.author = model.creator?.first
        favouriteToSave.imageURL = model.imageUrl
        favouriteToSave.title = model.title
        favouriteToSave.newsText = model.description
        favouriteToSave.link = model.link
        favouriteToSave.pubDate = model.pubDate

        coredataService.saveContext()
        initialFetch()
    }
}

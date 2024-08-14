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


    func saveToFavouriteModel(model: ResultedFetchResponse) {
        guard let modelsArray = self.modelsArray else { return }
        let favouriteToSave = FavouriteNewsModel(context: coredataService.context)

        if modelsArray.contains(where: { $0.title == model.title }) {
            return
        }

        favouriteToSave.author = model.creator?.first
        favouriteToSave.title = model.title
        favouriteToSave.newsText = model.description
        favouriteToSave.link = model.link
        favouriteToSave.pubDate = model.pubDate
        favouriteToSave.image = model.imageURL

        coredataService.saveContext()
        initialFetch()
    }

    func remove(fetchedModel: ResultedFetchResponse?, savedModel: FavouriteNewsModel?) {
        if let fetchedModel = fetchedModel {
            guard let modelToDelete = modelsArray?.first(where: { model in
                guard let title = model.title else { return false }
                return title == fetchedModel.title
            }) else { return }
            coredataService.deleteObject(model: modelToDelete)
        } else {
            guard let savedModel = savedModel, let modelToDelete = modelsArray?.first(where: { $0.title == savedModel.title }) else { return }
            coredataService.deleteObject(model: modelToDelete)
        }
        coredataService.saveContext()
        initialFetch()
    }

}

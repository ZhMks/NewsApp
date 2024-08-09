//
//  CoredataModelService.swift
//  NewsApp
//
//  Created by Максим Жуин on 09.08.2024.
//

import Foundation

final class CoredataModelService {
    private(set) var  modelsArray: [MainNewsModel]?
    let coredataService = CoreDataService.shared

    init() {
        initialFetch()
    }

    private func initialFetch() {
        let request = MainNewsModel.fetchRequest()
        do {
            modelsArray = try coredataService.context.fetch(request)
        } catch {
            modelsArray = []
            print("Cannot fetch data for request")
        }
    }

    func saveModelToCoreData(model: NetworkModel) {
        guard let modelsArray = modelsArray else { return }

        let modelToSave = MainNewsModel(context: coredataService.context)

        modelToSave.nextPage = model.nextPage
        modelToSave.totalResults = Int64(model.totalResults)

        for element in model.fetchedResults {
            saveDetailedNews(mainModel: modelToSave, networkModel: element)
        }

        coredataService.saveContext()
        initialFetch()
    }

    func saveDetailedNews(mainModel: MainNewsModel, networkModel: ResultedFetch) {
        guard let context = mainModel.managedObjectContext else { return }
        let detailedModelToSave = DetailNewsModel(context: context)

        detailedModelToSave.creator = networkModel.creator?.first
        detailedModelToSave.imageURL = networkModel.imageUrl
        detailedModelToSave.link = networkModel.link
        detailedModelToSave.pubDate = networkModel.pubDate
        detailedModelToSave.descriptiontext = networkModel.description
        detailedModelToSave.title = networkModel.title
    }

}


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
        let favouriteToSave = FavouriteNewsModel(context: coredataService.context)

        favouriteToSave.author = model.creator?.first
        favouriteToSave.imageURL = model.imageUrl
        favouriteToSave.title = model.title
        favouriteToSave.newsText = model.description
        favouriteToSave.link = model.link
        favouriteToSave.pubDate = model.pubDate

        coredataService.saveContext()
    }
}

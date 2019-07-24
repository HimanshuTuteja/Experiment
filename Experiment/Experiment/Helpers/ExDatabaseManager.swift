//
//  ExDatabaseManager.swift
//  Experiment
//
//  Created by Himanshu Tuteja on 24/07/19.
//  Copyright © 2019 Himanshu Tuteja. All rights reserved.
//

import UIKit
import CoreData

enum EntityKeys: String{
    case id = "id"
    case name = "name"
    case title = "title"
    case author = "author"
    case content = "content"
    case descriptions = "descriptions"
    case url = "url"
    case urlToImage = "urlToImage"
    case publishedAt = "publishedAt"
}

final class ExDatabaseManager: NSObject{
    internal static var shared: ExDatabaseManager!
    private static let serialQueue = DispatchQueue(label: "database.serialQueue")
    @objc static func sharedInstance() -> ExDatabaseManager{
        serialQueue.sync { () -> Void in
            if shared == nil {
                shared = ExDatabaseManager()
            }
        }
        return shared
    }
    
    func getModel()->[HeadArticlesModel]?{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: kCoreDataEntity)
        do {
            let results = try managedContext.fetch(fetchRequest)
            return mapModel(results)
        }catch let err as NSError {
            print(err.debugDescription)
            return nil
        }
    }
    
    private func mapModel(_ model: [Any])-> [HeadArticlesModel]?{
        var response: [HeadArticlesModel] = [HeadArticlesModel]()
        for mod in model{
            guard let obj = mod as? NSManagedObject else {return nil}
            let id = obj.value(forKey: EntityKeys.id.rawValue) as? String
            let name = obj.value(forKey: EntityKeys.name.rawValue) as? String
            let source = SourceArticleModel(id: id, name: name)
            let title = obj.value(forKey: EntityKeys.title.rawValue) as? String
            let author = obj.value(forKey: EntityKeys.author.rawValue) as? String
            let content = obj.value(forKey: EntityKeys.content.rawValue) as? String
            let description = obj.value(forKey: EntityKeys.descriptions.rawValue) as? String
            let url = obj.value(forKey: EntityKeys.url.rawValue) as? String
            let urlToImage = obj.value(forKey: EntityKeys.urlToImage.rawValue) as? String
            let publishedAt = obj.value(forKey: EntityKeys.publishedAt.rawValue) as? String
            let mData = HeadArticlesModel(source: source, author: author, content: content, title: title, description: description, url: url, urlToImage: urlToImage, publishedAt: publishedAt)
            response.append(mData)
        }
        return response
    }
    
    func clearDB(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: kCoreDataEntity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try managedContext.execute(deleteRequest)
            try managedContext.save()
        } catch (let error){
            print(error)
        }
    }
    
    func logModel(_ model: HeadArticlesModel){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        guard let userEntity = NSEntityDescription.entity(forEntityName: kCoreDataEntity, in: managedContext) else {return}
        let headData = NSManagedObject(entity: userEntity, insertInto: managedContext)
        headData.setValue(model.source?.id, forKey: EntityKeys.id.rawValue)
        headData.setValue(model.source?.name, forKey: EntityKeys.name.rawValue)
        headData.setValue(model.title, forKey: EntityKeys.title.rawValue)
        headData.setValue(model.author, forKey: EntityKeys.author.rawValue)
        headData.setValue(model.content, forKey: EntityKeys.content.rawValue)
        headData.setValue(model.description, forKey: EntityKeys.descriptions.rawValue)
        headData.setValue(model.url, forKey: EntityKeys.url.rawValue)
        headData.setValue(model.urlToImage, forKey: EntityKeys.urlToImage.rawValue)
        headData.setValue(model.publishedAt, forKey: EntityKeys.publishedAt.rawValue)
        do{
            try managedContext.save()
        }catch (let error){
            print(error)
        }
    }
    
}

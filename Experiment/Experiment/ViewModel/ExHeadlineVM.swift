//
//  ExHeadlineVM.swift
//  Experiment
//
//  Created by Himanshu Tuteja on 23/07/19.
//  Copyright © 2019 Himanshu Tuteja. All rights reserved.
//

import Foundation

enum ExHeadLoadStatus:Int{
    case loaded = 0
    case none
}

final class ExHeadlineVM: NSObject{
    
    private var headlineDataSource: ExHeadModel?
    private var cellViewModel: [ExHeadlineCellVM] = [ExHeadlineCellVM]()
    var status: ExHeadLoadStatus = .none
    
    override init() {
        super.init()
    }
    
    func getHeadLineRows()->Int{
        if status == .none {return 5}
        return headlineDataSource?.articles?.count ?? 0
    }
    
    func getCellVM(for indexPath: IndexPath)-> ExHeadlineCellVM?{
        guard let models = headlineDataSource?.articles, models.indices.contains(indexPath.row) else {return nil}
        return ExHeadlineCellVM(model: models[indexPath.row])
    }
    
    func getCellModel(for indexPath: IndexPath)-> HeadArticlesModel?{
        guard let models = headlineDataSource?.articles, models.indices.contains(indexPath.row) else {return nil}
        return models[indexPath.row]
    }
    
    private func settleOfflineData(){
        ExDatabaseManager.sharedInstance().clearDB()
        guard let models = headlineDataSource?.articles else {return}
        for mod in models{
            ExDatabaseManager.sharedInstance().logModel(mod)
        }
    }
    
    func requestHeadlines(success: @escaping (Bool, Error?) -> Void){
        ExServiceHandler.shared.getHeadlines { [weak self](response, error) in
            self?.status = .loaded
            guard let err = error else {
                self?.headlineDataSource = response
                self?.settleOfflineData()
                success(true,nil)
                return
            }
            guard let offlineData = ExDatabaseManager.sharedInstance().getModel(), offlineData.count > 0 else {
                success(false,err)
                return
            }
            
            self?.headlineDataSource = ExHeadModel(articles: offlineData, totalResults: offlineData.count, status: kStatusOk)
            success(true,nil)
            return
            
        }
    }
}

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
    
    func requestHeadlines(success: @escaping (Bool, Error?) -> Void){
        ExServiceHandler.shared.getHeadlines { [weak self](response, error) in
            self?.status = .loaded
            guard let err = error else {
                self?.headlineDataSource = response
                success(true,nil)
                return
            }
            success(false,err)
        }
    }
}

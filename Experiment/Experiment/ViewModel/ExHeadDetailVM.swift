//
//  ExHeadDetailVM.swift
//  Experiment
//
//  Created by Himanshu Tuteja on 24/07/19.
//  Copyright © 2019 Himanshu Tuteja. All rights reserved.
//

import Foundation
import SDWebImage

typealias HeadLineDetailData = (String?,String?,String?,String?) // Title,Source,Description,Date

final class ExHeadDetailVM: NSObject{
    
    var dataSource: HeadArticlesModel!
    
    init(model: HeadArticlesModel) {
        dataSource = model
    }
    
    func fetchImage(imgView: UIImageView){
        guard let url = dataSource.urlToImage else {return}
        imgView.sd_setImage(with: URL(string: url), completed: nil)
    }
    
    func getVisualData()->HeadLineDetailData{
        return (dataSource?.title, dataSource?.source?.name, dataSource?.description,getFormattedDate())
    }
    
    private func getFormattedDate()-> String?{
        guard let publish = dataSource.publishedAt else {return nil}
        return String(describing: publish.prefix(10))
    }
    
}

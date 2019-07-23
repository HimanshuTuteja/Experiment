//
//  ExHeadlineCellVM.swift
//  Experiment
//
//  Created by Himanshu Tuteja on 23/07/19.
//  Copyright © 2019 Himanshu Tuteja. All rights reserved.
//

import Foundation
import SDWebImage

typealias VisualData = (String?,String?,String?) // Title, Source, Date

final class ExHeadlineCellVM: NSObject{
    let headlineModel: HeadArticlesModel?
    
    init(model: HeadArticlesModel) {
        headlineModel = model
    }
    
    func getVisualData()-> VisualData?{
        return (headlineModel?.title, headlineModel?.source?.name, getFormattedDate())
    }
    
    private func getFormattedDate()-> String?{
        guard let publish = headlineModel?.publishedAt else {return nil}
        return String(describing: publish.prefix(10))
    }
    
    func fetchImage(imgView: UIImageView){
        guard let url = headlineModel?.urlToImage else {return}
        imgView.sd_setImage(with: URL(string: url), completed: nil)
    }
}

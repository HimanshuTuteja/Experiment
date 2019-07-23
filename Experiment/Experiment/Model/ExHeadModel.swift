//
//  ExHeadModel.swift
//  Experiment
//
//  Created by Himanshu Tuteja on 22/07/19.
//  Copyright © 2019 Himanshu Tuteja. All rights reserved.
//

import Foundation

struct ExHeadModel:Codable{
    let articles                        : [HeadArticlesModel]?
    let totalResults                    : Int
    let status                          : String
}

struct HeadArticlesModel :Codable{
    var source                         : SourceArticleModel?
    let author                         : String?
    let content                        : String?
    let title                          : String?
    let description                    : String?
    let url                            : String?
    let urlToImage                     : String?
    let publishedAt                    : String?
}

struct SourceArticleModel :Codable{
    let id                             : String?
    let name                           : String?
}

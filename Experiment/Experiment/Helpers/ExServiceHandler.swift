//
//  ExServiceHandler.swift
//  Experiment
//
//  Created by Himanshu Tuteja on 23/07/19.
//  Copyright © 2019 Himanshu Tuteja. All rights reserved.
//

import Foundation

private enum NetworkConstant: String{
    case apiKey = "5e04c57f686d4f0ebbd5572632e2b08a"
}

private enum EndPoints: String{
    case getHeadlines = "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey="
}

private struct HeadRequestBuilder: RequestType {
    typealias ResponseType = ExHeadModel
    var data: RequestData
}

private struct ImageRequestBuilder: RequestType {
    typealias ResponseType = Data
    var data: RequestData
}

final class ExServiceHandler{
    static let shared = ExServiceHandler()
    func getHeadlines(completion: @escaping(ExHeadModel?,Error?)->Void){
        let reqData = RequestData(path: EndPoints.getHeadlines.rawValue + NetworkConstant.apiKey.rawValue, method: .get)
        let request = HeadRequestBuilder(data: reqData)
        request.execute(onSuccess: { (response) in
            completion(response,nil)
        }) { (error) in
            completion(nil,error)
        }
    }
}

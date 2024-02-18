//
//  QuestionsRequest.swift
//  SurveyApp
//
//  Created by Антон Петренко on 15/02/2024.
//

import Foundation

struct QuestionsRequest: NetworkRequestInterface {
    typealias ResponseDataType = [QuestionModel]
    
    let host: URL
    
    func create() -> URLRequest {
        let modifiedHost = host.appending(path: "questions")
        var request = URLRequest(url: modifiedHost)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return request
    }
    
    func parse(data: Data) throws -> [QuestionModel] {
        let decoder = JSONDecoder()
        
        return try decoder.decode([QuestionModel].self, from: data)
    }
}

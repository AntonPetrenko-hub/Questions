//
//  SubmitQuestionRequest.swift
//  SurveyApp
//
//  Created by Антон Петренко on 15/02/2024.
//

import Foundation

struct SubmitQuestionRequest: NetworkUploadInterface {    
    let host: URL
    
    func create() -> URLRequest {
        let modifiedHost = host.appending(path: "question/submit")
        var request = URLRequest(url: modifiedHost)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        return request
    }
}

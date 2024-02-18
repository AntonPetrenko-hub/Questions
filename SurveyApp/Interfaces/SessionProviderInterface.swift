//
//  SessionProviderInterface.swift
//  SurveyApp
//
//  Created by Антон Петренко on 15/02/2024.
//

import Foundation

public protocol SessionProviderInterface {
    func fetch(request: URLRequest) async throws -> (Data, URLResponse)
    func upload(request: URLRequest, data: Data) async throws -> (Data, URLResponse) 
}

extension URLSession: SessionProviderInterface {
    public func fetch(request: URLRequest) async throws -> (Data, URLResponse) {
        let (data, response) = try await data(from: request.url!)
        return (data, response)
    }
    
    public func upload(request: URLRequest, data: Data) async throws -> (Data, URLResponse) {
        let (data, response) = try await upload(for: request, from: data, delegate: nil)
        return (data, response)
    }
}

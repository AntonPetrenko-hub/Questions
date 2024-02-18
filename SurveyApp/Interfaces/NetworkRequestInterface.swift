//
//  NetworkRequestInterface.swift
//  SurveyApp
//
//  Created by Антон Петренко on 15/02/2024.
//

import UIKit

public protocol NetworkRequestInterface {
    associatedtype ResponseDataType
    
    func create() -> URLRequest
    func parse(data: Data) throws -> ResponseDataType
}

public protocol NetworkUploadInterface {    
    func create() -> URLRequest
}

//
//  QuestionModel.swift
//  SurveyApp
//
//  Created by Антон Петренко on 15/02/2024.
//

import Foundation

struct QuestionModel: Codable, Hashable {
    let id: UInt
    let question: String
}

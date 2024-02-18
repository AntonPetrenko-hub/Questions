//
//  DIContainer.swift
//  SurveyApp
//
//  Created by Антон Петренко on 18/02/2024.
//

import SwiftUI

protocol DIContainerInterface {
    var questionsManager: QuestionsManagerInterface { get }
}

class DIContainer: ObservableObject, DIContainerInterface{
    let questionsManager: QuestionsManagerInterface
    
    init(surveyService: SurveyServiceInterface) {
        questionsManager = QuestionsManager(surveyService: surveyService)
    }
}

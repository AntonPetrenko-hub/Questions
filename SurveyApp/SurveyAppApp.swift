//
//  SurveyAppApp.swift
//  SurveyApp
//
//  Created by Антон Петренко on 15/02/2024.
//

import SwiftUI

@main
struct SurveyAppApp: App {
    
    init() {
        DIContainer.shared.register(scope: .container) { _ in
            let surveyInterface: SurveyServiceInterface = SurveyService(host: URL(string: "https://xm-assignment.web.app/")!, session: URLSession.shared)
            return surveyInterface
        }
        
        DIContainer.shared.register(scope: .container) { resolver in
            let manager: QuestionsManagerInterface = QuestionsManager(surveyService: resolver.resolveDependency())
            return manager
        }
    }
    
    var body: some Scene {
        WindowGroup {
            CoordinatorView()
        }
    }
}

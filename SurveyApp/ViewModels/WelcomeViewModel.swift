//
//  WelcomeViewModel.swift
//  SurveyApp
//
//  Created by Антон Петренко on 15/02/2024.
//

import Foundation

@MainActor
class WelcomeViewModel: ObservableObject {
    @Published var screenState: WelcomeScreenState = .loaded
    let questionsManager: QuestionsManagerInterface
    
    init(questionsManager: QuestionsManagerInterface) {
        self.questionsManager =  questionsManager
    }
    
    func getQuestions() async {
        screenState = .isLoading
        do {
            try await questionsManager.getQuestions()
            screenState = .loaded
        } catch {
            screenState = .error
        }
    }
}

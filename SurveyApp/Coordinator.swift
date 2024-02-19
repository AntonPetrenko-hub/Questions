//
//  Coordinator.swift
//  SurveyApp
//
//  Created by Антон Петренко on 16/02/2024.
//

import SwiftUI

enum Page: String, Identifiable {
    case welcome, question
    
    var id: String {
        self.rawValue
    }
}

@MainActor
class Coordinator: ObservableObject {
    
    @Published var path = NavigationPath()
    
    func push(_ page: Page) {
        path.append(page)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    @ViewBuilder
    func build(_ page: Page) -> some View {
        switch page {
        case .welcome:
            WelcomeView(viewModel: WelcomeViewModel(questionsManager: DIContainer.shared.resolveDependency()))
        case .question:
            QuestionView(viewModel: .init(questionsManager: DIContainer.shared.resolveDependency()))
        }
    }
}

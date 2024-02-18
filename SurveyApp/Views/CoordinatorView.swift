//
//  CoordinatorView.swift
//  SurveyApp
//
//  Created by Антон Петренко on 16/02/2024.
//

import SwiftUI

struct CoordinatorView: View {
    
    @StateObject private var coordinator = Coordinator(diContainer: DIContainer(surveyService: SurveyService(host: URL(string: "https://xm-assignment.web.app/")!, session: URLSession.shared)))
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.build(.welcome)
                .navigationDestination(for: Page.self) { page in
                    coordinator.build(page)
                }
        }
        .environmentObject(coordinator)
    }
}

#Preview {
    CoordinatorView()
}

//
//  WelcomeView.swift
//  SurveyApp
//
//  Created by Антон Петренко on 15/02/2024.
//

import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject private var coordinator: Coordinator
    @StateObject private var viewModel: WelcomeViewModel
    
    private struct Constants {
        static let navigationTitle: String = "Welcome!"
        static let buttonTitle: String = "Start survey"
        static let errorTitle: String = "Something went wrong"
        static let errorButtonTitle: String = "Try again"
    }
    
    init(viewModel: WelcomeViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            switch viewModel.screenState {
            case .isLoading:
                loader
            case .loaded:
                loadedView
            case .error:
                errorView
            }
        }
        .task {
            await viewModel.getQuestions()
        }
        .navigationTitle(Constants.navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var loadedView: some View {
        VStack(alignment: .center, content: {
            Button(Constants.buttonTitle) {
                coordinator.push(.question)
            }
            .buttonStyle(MainButtonStyle())
        })
    }
    
    private var loader: LoaderView {
        LoaderView()
    }
    
    private var errorView: some View {
        VStack {
            Text(Constants.errorTitle)
                .font(.headline)
            Button(Constants.errorButtonTitle) {
                Task { @MainActor in
                    await viewModel.getQuestions()
                }
            }
            .buttonStyle(MainButtonStyle())
        }
    }
}

enum WelcomeScreenState {
    case isLoading, loaded, error
}

//
//  QuestionView.swift
//  SurveyApp
//
//  Created by Антон Петренко on 16/02/2024.
//

import SwiftUI

struct QuestionView: View {
    @EnvironmentObject private var coordinator: Coordinator
    @StateObject var viewModel: QuestionViewModel
    
    private struct Constants {
        static let previousButtonTitle: String = "Previous"
        static let nextButtonTitle: String = "Next"
        static let textFieldPrompt: String = "Type here for an answer..."
        static let submitButtonTitle: String = "Submit"
        static let errorTitle: String = "Something went wrong"
    }
    
    var body: some View {
        VStack {
            switch viewModel.screenState {
            case .error:
                Text(Constants.errorTitle)
            case .isLoading:
                loader
            case .loaded:
                VStack(alignment: .leading, content: {
                    Text(viewModel.getCurrentQuestionText())
                        .foregroundColor(.black.opacity(0.7))
                        .font(.title.weight(.semibold))
                    TextField(text: $viewModel.enteredText,
                              prompt: Text(Constants.textFieldPrompt)) {
                        Text("Enter")
                    }
                              .textFieldStyle(PlainTextFieldStyle())
                              .multilineTextAlignment(.leading)
                              .accentColor(.blue)
                              .foregroundColor(.blue)
                              .font(.title.weight(.semibold))
                    Spacer()
                    Button(Constants.submitButtonTitle) {
                        if viewModel.enteredTextIsValid() {
                            Task { @MainActor in
                                // also we'd need to prevent multiple tapping on button during uploading process
                                await viewModel.uploadAnswer()
                            }
                        }
                    }
                    .padding()
                    .background(viewModel.enteredText.isEmpty ? Color.gray : Color(red: 0, green: 0, blue: 0.5))
                    .foregroundStyle(.white)
                    .clipShape(Capsule())
                    .disabled(viewModel.submitButtonIsDisabled)
                    Spacer()
                })
                .toolbar {
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        Button(Constants.previousButtonTitle) {
                            viewModel.switchToPreviousQuestion()
                            coordinator.pop()
                        }
                        .disabled(viewModel.isFirst)
                        Button(Constants.nextButtonTitle) {
                            viewModel.switchToNextQuestion()
                            coordinator.push(.question)
                        }
                        .disabled(viewModel.isLast)
                    }
                }
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading: Button(action: {
                    
                    coordinator.popToRoot()
                }, label: {
                    Image(systemName: "chevron.left")
                }))
                .padding()
                .navigationTitle(viewModel.navTitle)
            }
        }
        .toast(isShowing: $viewModel.toastIsShown, config: viewModel.getToastConfig())
    }
    
    private var loader: some View {
        LoaderView()
    }
}

enum QuestionViewState {
    case isLoading, loaded, error
}

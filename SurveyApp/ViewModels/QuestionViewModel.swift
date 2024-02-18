//
//  QuestionViewModel.swift
//  SurveyApp
//
//  Created by Антон Петренко on 16/02/2024.
//

import Foundation

@MainActor
class QuestionViewModel: ObservableObject {
    @Published var enteredText: String = ""
    @Published var screenState: QuestionViewState = .loaded
    @Published var toastIsShown = false
    private var kindOfToast: Toast.KindOfToast = .success
    private let questionsManager: QuestionsManagerInterface
    
    init(questionsManager: QuestionsManagerInterface) {
        self.questionsManager =  questionsManager
    }
    
    var isLast: Bool {
        questionsManager.isLast
    }
    
    var isFirst: Bool {
        questionsManager.isFirst
    }
    
    var submitButtonIsDisabled: Bool {
        let enteredTextIsEmpty = enteredText.isEmpty
        let currentQuestionIsAnswered = questionsManager.currentQuestionIsAnswered
        let result = enteredTextIsEmpty || currentQuestionIsAnswered
        print("enteredTextIsEmpty: \(enteredTextIsEmpty)")
        print("currentQuestionIsAnswered: \(currentQuestionIsAnswered)")
        print("result: \(result)")
        return result
    }
    
    var navTitle: String {
        "Question \(questionsManager.submittedQuestionIds.count)/\(questionsManager.savedQuestions.count)"
    }
    
    func enteredTextIsValid() -> Bool {
        !enteredText.isEmpty
    }
    
    func switchToPreviousQuestion() {
        questionsManager.switchToThePreviousQuestion()
    }
    
    func switchToNextQuestion() {
        questionsManager.switchToTheNextQuestion()
    }
    
    func uploadAnswer() async {
        guard let currentQuestion = questionsManager.currentQuestion else {
            changeScreenStateToError()
            return
        }
        
        toastIsShown = false
        screenState = .isLoading
        do {
            let _ = try await questionsManager.submitAnswer(.init(id: currentQuestion.id, answer: enteredText))
            screenState = .loaded
            showToast(.success)
        } catch {
            debugPrint("Error: \(String(describing: error))")
            screenState = .loaded
            showToast(.failure)
        }
    }
    
    func changeScreenStateToError() {
        screenState = .error
    }
    
    func getToastConfig() -> Toast.Config {
        switch kindOfToast {
        case .success:
            Toast.Config(message: "Succcess 👌", addButton: false, buttonAction: nil, duration: Toast.short)
        case .failure:
            Toast.Config(message: "Failure", addButton: true, buttonAction: {
                Task { @MainActor [weak self] in
                    await self?.uploadAnswer()
                }
            }, duration: Toast.long)
        }
    }
    
    func resetSubmittedQuestions() {
        questionsManager.resetSubmittedQuestions()
    }
    
    func getCurrentQuestionText() -> String {
        // Ideally we should throw an error and handle the case where question is absent separately.
        // I use such solution to speed up the process.
        questionsManager.currentQuestion?.question ?? ""
    }
    
    private func showToast(_ kind: Toast.KindOfToast) {
        kindOfToast = kind
        toastIsShown = true
    }
}

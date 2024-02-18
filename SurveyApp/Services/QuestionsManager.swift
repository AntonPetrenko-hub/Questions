//
//  QuestionsManager.swift
//  SurveyApp
//
//  Created by Антон Петренко on 17/02/2024.
//

import SwiftUI

protocol QuestionsManagerInterface {
    var isFirst: Bool { get }
    var isLast: Bool { get }
    var currentQuestion: QuestionModel? { get }
    var currentQuestionIsAnswered: Bool { get }
    var savedQuestions: [QuestionModel] { get set }
    var submittedQuestionIds: [UInt] { get }
    func getQuestions() async throws
    func switchToTheNextQuestion()
    func switchToThePreviousQuestion()
    func submitAnswer(_ answerModel: AnswerModel) async throws
    func resetSubmittedQuestions()
}

class QuestionsManager: ObservableObject, QuestionsManagerInterface {
        
    enum QuestionsManagerError: Error {
        case indexOutOfBound
    }
    
    private let surveyService: SurveyServiceInterface
    private var selectedQuestionID: UInt = 0
    
    var submittedQuestionIds: [UInt] = []
    var savedQuestions: [QuestionModel] = []
    
    var isLast: Bool {
        savedQuestions.last?.id == selectedQuestionID
    }
    
    var isFirst: Bool {
        savedQuestions.first?.id == selectedQuestionID
    }
    
    var currentQuestionIsAnswered: Bool {
        submittedQuestionIds.contains(selectedQuestionID)
    }
    
    var currentQuestion: QuestionModel? {
        guard !savedQuestions.isEmpty, let currentQuestion = savedQuestions.first(where: { $0.id == selectedQuestionID }) else {
            return nil
        }
        return currentQuestion
    }
    
    init(surveyService: SurveyServiceInterface) {
        self.surveyService = surveyService
    }
    
    func getQuestions() async throws {
        let questions = try await surveyService.getQuestions()
        savedQuestions = questions
        preselectFirstQuestion()
        debugPrint("Retrieved questions: \(savedQuestions)")
    }
    
    func switchToTheNextQuestion() {
        if !isLast {
            selectedQuestionID += 1
        }
    }
    
    func switchToThePreviousQuestion() {
        if !isFirst {
            selectedQuestionID -= 1
        }
    }
    
    func submitAnswer(_ answerModel: AnswerModel) async throws {
        _ = try await surveyService.submitAnswer(model: answerModel)
        print("submittedQuestionIds before: \(submittedQuestionIds)")
        submittedQuestionIds.append(answerModel.id)
        print("submittedQuestionIds after: \(submittedQuestionIds)")
    }
    
    func resetSubmittedQuestions() {
        submittedQuestionIds = []
    }
    
    private func preselectFirstQuestion() {
        guard let firstQuestionId = savedQuestions.first?.id else {
            return
        }
        selectedQuestionID = firstQuestionId
    }
}

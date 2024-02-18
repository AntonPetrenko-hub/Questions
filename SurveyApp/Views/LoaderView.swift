//
//  LoaderView.swift
//  SurveyApp
//
//  Created by Антон Петренко on 16/02/2024.
//

import SwiftUI

struct LoaderView: View {
    var body: some View {
        ZStack {
            Color.gray.opacity(0.7)
                .ignoresSafeArea()
            ProgressView()
        }
    }
}

#Preview {
    LoaderView()
}

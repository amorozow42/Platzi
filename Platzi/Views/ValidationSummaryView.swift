//
//  ValidationSummaryView.swift
//  Platzi
//
//  Created by Mohammad Azam on 7/17/25.
//

import SwiftUI

struct ValidationSummaryView: View {
    
    let errors: [String]
    
    var body: some View {
        if !errors.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                ForEach(errors, id: \.self) { error in
                    HStack(alignment: .top) {
                        Image(systemName: "exclamationmark.circle")
                            .foregroundColor(.red)
                        Text(error)
                            .foregroundColor(.red)
                            .font(.subheadline)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            .padding()
            .background(Color.red.opacity(0.1))
            .cornerRadius(10)
        }
    }
}

#Preview {
    ValidationSummaryView(errors: [
        "Name is required.",
        "Username must be a valid email.",
        "Password must be at least 8 characters."
    ])
    .padding()
}


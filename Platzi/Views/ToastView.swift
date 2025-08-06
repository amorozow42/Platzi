//
//  ToastView.swift
//  Platzi
//
//  Created by Mohammad Azam on 7/25/25.
//

import Foundation
import SwiftUI

enum ToastType {
    case success(String)
    case error(String)
    case info(String)
    
    var backgroundColor: Color {
        switch self {
            case .success:
                return Color.green.opacity(0.9)
            case .error:
                return Color.red.opacity(0.9)
            case .info:
                return Color.blue.opacity(0.9)
        }
    }
    
    var icon: Image {
        switch self {
            case .success:
                return Image(systemName: "checkmark.circle")
            case .error:
                return Image(systemName: "xmark.octagon")
            case .info:
                return Image(systemName: "info.circle")
        }
    }
    
    var message: String {
        switch self {
            case .success(let msg), .error(let msg), .info(let msg):
                return msg
        }
    }
    
}

struct ToastView: View {
    
    let type: ToastType
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            type.icon
                .foregroundStyle(.white)
            Text(type.message)
                .foregroundColor(.white)
                .font(.subheadline)
                .multilineTextAlignment(.leading)
        }  .padding()
            .background(type.backgroundColor)
            .cornerRadius(12)
            .shadow(radius: 4)
            .padding(.horizontal, 16)
    }
}

struct ShowToastAction {
    typealias Action = (ToastType) -> Void
    let action: Action
    
    func callAsFunction(_ type: ToastType) {
        action(type)
    }
}

//
//  ToastModifier.swift
//  Platzi
//
//  Created by Mohammad Azam on 7/25/25.
//

import Foundation
import SwiftUI 

struct ToastModifier: ViewModifier {
    
    @State private var type: ToastType?
    @State private var dismissTask: DispatchWorkItem?
    
    func body(content: Content) -> some View {
        content
            .environment(\.showToast, ShowToastAction(action: { type in
                withAnimation(.easeInOut) {
                    self.type = type
                }
                
                // cancel previous dismissal task if any
                dismissTask?.cancel()
                
                // schedule a new dismisal
                let task = DispatchWorkItem {
                    withAnimation(.easeInOut) {
                        self.type = nil
                    }
                }
                
                self.dismissTask = task
                DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: task)
                
            }))
            .overlay(alignment: .top) {
                if let type {
                    ToastView(type: type)
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .padding(.top, 50)
                }
            }
    }
}

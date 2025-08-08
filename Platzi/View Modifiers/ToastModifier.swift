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
    @State private var placement: ToastPlacement = .bottom
    @State private var dismissTask: DispatchWorkItem?
    
    func body(content: Content) -> some View {
        content
            .environment(\.showToast, ShowToastAction(action: { type, placement in
                withAnimation(.easeInOut) {
                    self.type = type
                    self.placement = placement
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
            .overlay(alignment: placement == .top ? .top: .bottom) {
                if let type {
                    ToastView(type: type)
                        .transition(.move(edge: placement == .top ? .top: .bottom).combined(with: .opacity))
                        .padding(.top, 50)
                }
            }
    }
}

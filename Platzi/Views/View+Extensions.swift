//
//  View+Extensions.swift
//  Platzi
//
//  Created by Mohammad Azam on 7/25/25.
//

import Foundation
import SwiftUI 

extension View {
    func withToast() -> some View {
        modifier(ToastModifier())
    }
}

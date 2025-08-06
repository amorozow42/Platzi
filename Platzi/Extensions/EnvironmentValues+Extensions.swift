//
//  EnvironmentValues+Extensions.swift
//  Platzi
//
//  Created by Mohammad Azam on 7/17/25.
//

import Foundation
import SwiftUI

extension EnvironmentValues {
    @Entry var authenticationController = AuthenticationController(httpClient: HTTPClient())
    @Entry var showToast = ShowToastAction(action: { _ in })
}


import Foundation
import SwiftUI 

@main
struct PlatziApp: App {

    @AppStorage("isAuthenticated") private var isAuthenticated: Bool = false
    @Environment(\.authenticationController) private var authenticationController
    @State private var isLoading: Bool = true
    
    let httpClient = HTTPClient()

    var body: some Scene {
        WindowGroup {
            ZStack {
                if isLoading {
                    ProgressView("Loading...")
                        .task {
                            isAuthenticated = await authenticationController.checkAuthentication()
                            isLoading = false
                        }
                } else if isAuthenticated {
                    HomeScreen()
                        .environment(PlatziStore(httpClient: httpClient))
                } else {
                    VStack {
                        RegistrationScreen()
                        LoginScreen()
                    }
                }
            }
            .withToast()
        }
    }
}

//
//  AuthenticationController.swift
//  Platzi
//
//  Created by Mohammad Azam on 7/17/25.
//

import Foundation

struct AuthenticationController {
    
    let httpClient: HTTPClient
    
    func checkAuthentication() async -> Bool {
        guard let accessToken: String = Keychain.get("accessToken") else {
            return false
        }

        if JWTDecoder.isExpired(token: accessToken) {
            do {
                try await httpClient.refreshToken()
                return true
            } catch {
                return false
            }
        }

        return true
    }

    
    func signOut() {
        UserDefaults.standard.removeObject(forKey: "isAuthenticated")
        let _ = Keychain<String>.delete("accessToken")
        let _ = Keychain<String>.delete("refreshToken")
    }
    
    func register(name: String, email: String, password: String) async throws -> RegistrationResponse {
        
        let request = RegistrationRequest(name: name, email: email, password: password, avatar: URL(string: "https://picsum.photos/800")!)
        
        let resource = Resource<RegistrationResponse>(endpoint: .register, method: .post(try request.encode()))
        
        let response = try await httpClient.load(resource)
        return response
    }
    
    func login(email: String, password: String) async throws -> Bool {
        
        let request = LoginRequest(email: email, password: password)
        
        let resource = Resource<LoginResponse>(endpoint: .login, method: .post(try request.encode()))
        let response = try await httpClient.load(resource)
        
        Keychain.set(response.accessToken, forKey: "accessToken")
        Keychain.set(response.refreshToken, forKey: "refreshToken")
        return true
    }
}

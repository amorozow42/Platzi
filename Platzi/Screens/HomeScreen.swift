//
//  HomeScreen.swift
//  Platzi
//
//  Created by Mohammad Azam on 7/19/25.
//

import SwiftUI

struct HomeScreen: View {
    
    @Environment(\.authenticationController) private var authenticationController
    
    var body: some View {
        
        TabView {
            Tab {
                NavigationStack {
                    CategoryListScreen()
                }
            } label: {
                Label("Categories", systemImage: "square.grid.2x2")
            }
            
            Tab {
                NavigationStack {
                    LocationsScreen()
                }
            } label: {
                Label("Locations", systemImage: "map")
            }
            
            Tab {
                ProfileScreen() 
            } label: {
                Label("Profile", systemImage: "person.crop.circle")
            }

        }
        
    }
}

#Preview {
    HomeScreen()
        .environment(PlatziStore(httpClient: MockHTTPClient.preview))
}

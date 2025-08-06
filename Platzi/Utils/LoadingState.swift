//
//  LoadingState.swift
//  Platzi
//
//  Created by Mohammad Azam on 7/19/25.
//

import Foundation 

enum LoadingState<T: Equatable>: Equatable {
    case loading
    case success(T)
    case failure(String)
}

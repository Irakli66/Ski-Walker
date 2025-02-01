//
//  LoginResponse.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 15.01.25.
//
import Foundation

enum LoginError: Error {
    case invalidEmail
    case invalidPassword
    case invalidCredentials
}

struct LoginResponse: Decodable {
    let refreshToken: String
    let accessToken: String
}

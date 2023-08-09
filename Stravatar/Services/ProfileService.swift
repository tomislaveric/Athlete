//
//  ProfileService.swift
//  Stravatar
//
//  Created by Tomislav Eric on 19.03.23.
//

import Foundation
import SharedModels
import HTTPRequest

protocol ProfileService {
    func create(profile: Profile) async throws -> Profile
    func fetchUser() async throws -> User
}

class ProfileServiceImpl: ProfileService {
    private let httpRequest: HTTPRequest
    private let baseURL: String
    
    init(httpRequest: HTTPRequest = HTTPRequestImpl(), baseURL: String = "") {
        self.httpRequest = httpRequest
        self.baseURL = baseURL
    }
    
    func create(profile: SharedModels.Profile) async throws -> SharedModels.Profile {
        guard let url = URL(string: "\(self.baseURL)/profile") else {
            throw ProfileServiceError.badUrl
        }
        return try await httpRequest.post(url: url, header: nil, body: profile)
    }
    
    func fetchUser() async throws -> SharedModels.User {
        guard let url = URL(string: "\(self.baseURL)/user") else {
            throw ProfileServiceError.badUrl
        }
        let user: User
        do {
            user = try await httpRequest.get(url: url, header: nil)
        }
        catch {
            if case HTTPRequestError.requestFailed(let response) = error {
                if let response = response as? HTTPURLResponse {
                    switch response.statusCode {
                    case 401:
                        throw ProfileServiceError.unauthorized
                    default:
                        throw ProfileServiceError.unmapped
                    }
                }
            }
            throw ProfileServiceError.unmapped
        }
        return user
    }
    
}

enum ProfileServiceError: Error {
    case badUrl
    case unauthorized
    case unmapped
}

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
    
}

enum ProfileServiceError: Error {
    case badUrl
}

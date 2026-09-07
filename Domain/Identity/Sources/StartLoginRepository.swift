//
//  StartLoginRepository.swift
//  iOSTemplate
//
//  Created by Hakan Uğraş on 24.07.2026.
//
import Foundation

public struct StartLoginRequest: Sendable, Equatable {
    public let deviceUUID: String
    public let osVersion: String
    public let model: String
    public let appVersion: String

    public init(deviceUUID: String, osVersion: String, model: String, appVersion: String) {
        self.deviceUUID = deviceUUID
        self.osVersion = osVersion
        self.model = model
        self.appVersion = appVersion
    }
}

public struct RecognizedUser: Sendable, Equatable {
    public let firstName: String
    public let lastName: String

    public init(firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
    }
}

public protocol StartLoginRepository: Sendable {
    func startLogin(_ request: StartLoginRequest) async -> SabancimResult<RecognizedUser?>
}

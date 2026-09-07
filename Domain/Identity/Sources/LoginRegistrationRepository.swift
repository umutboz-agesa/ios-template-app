//
//  LoginRegistrationRepository.swift
//  iOSTemplate
//
//  Created by Hakan Uğraş on 27.07.2026.
//
import Foundation

public struct LoginRegistrationCredentials: Sendable, Equatable {
    public let identityNumber: String
    public let password: String
    public let contractTextReaded: Bool
    public let deviceUUID: String
    public let brand: String
    public let model: String
    public let osVersion: String
    public let appVersion: String

    public init(
        identityNumber: String,
        password: String,
        contractTextReaded: Bool,
        deviceUUID: String,
        brand: String,
        model: String,
        osVersion: String,
        appVersion: String
    ) {
        self.identityNumber = identityNumber
        self.password = password
        self.contractTextReaded = contractTextReaded
        self.deviceUUID = deviceUUID
        self.brand = brand
        self.model = model
        self.osVersion = osVersion
        self.appVersion = appVersion
    }
}

public protocol LoginRegistrationRepository: Sendable {
    func loginRegistration(_ credentials: LoginRegistrationCredentials) async -> SabancimResult<Void>
}

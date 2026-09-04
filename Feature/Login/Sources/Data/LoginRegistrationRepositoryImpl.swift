//
//  LoginRegistrationRepositoryImpl.swift
//  iOSTemplate
//
//  Created by Hakan Uğraş on 27.07.2026.
//
import Foundation
import CoreCommon

final class LoginRegistrationRepositoryImpl: LoginRegistrationRepository, @unchecked Sendable {
    private let remote: LoginRegistrationRemoteDataSource

    init(remote: LoginRegistrationRemoteDataSource) {
        self.remote = remote
    }

    func loginRegistration(_ credentials: LoginRegistrationCredentials) async -> SabancimResult<Void> {
        let request = LoginRegistrationRequestDTO(
            uuid: credentials.deviceUUID,
            identityNo: credentials.identityNumber,
            password: credentials.password,
            brand: credentials.brand,
            model: credentials.model,
            osVersion: credentials.osVersion,
            contractTextReaded: credentials.contractTextReaded,
            appVersion: credentials.appVersion
        )
        return await remote.loginRegistration(request)
    }
}

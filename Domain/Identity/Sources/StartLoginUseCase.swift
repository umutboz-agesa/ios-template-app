//
//  StartLoginUseCase.swift
//  iOSTemplate
//
//  Created by Hakan Uğraş on 24.07.2026.
//
import Foundation
import CoreCommon

public struct StartLoginUseCase: Sendable {
    private let repository: any StartLoginRepository

    public init(repository: any StartLoginRepository) {
        self.repository = repository
    }
    
    public func callAsFunction(_ input: StartLoginRequest) async throws -> SabancimResult<RecognizedUser?> {
        return await repository.startLogin(input)
    }
}

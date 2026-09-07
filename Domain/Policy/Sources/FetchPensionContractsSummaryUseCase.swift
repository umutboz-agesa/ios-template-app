//
//  FetchPensionContractsSummaryUseCase.swift
//  iOSTemplate
//
//  Created by Hakan Uğraş on 29.07.2026.
//
import Foundation

/// Girdi/validation gerektirmiyor (GET, parametresiz) — yine de UseCase katmanı
/// var, ileride bir iş kuralı (ör. cache-first davranışı) eklenirse buraya gider.
public struct FetchPensionContractsSummaryUseCase: Sendable {
    private let repository: any PensionContractsSummaryRepository

    public init(repository: any PensionContractsSummaryRepository) {
        self.repository = repository
    }

    public func callAsFunction() async -> SabancimResult<PensionContractsSummary> {
        await repository.fetchSummary()
    }
}

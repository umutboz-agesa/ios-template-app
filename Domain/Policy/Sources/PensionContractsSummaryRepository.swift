//
//  PensionContractsSummaryRepository.swift
//  iOSTemplate
//
//  Created by Hakan Uğraş on 29.07.2026.
//
import Foundation

public protocol PensionContractsSummaryRepository: Sendable {
    func fetchSummary() async -> SabancimResult<PensionContractsSummary>
}

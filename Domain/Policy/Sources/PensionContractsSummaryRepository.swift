//
//  PensionContractsSummaryRepository.swift
//  iOSTemplate
//
//  Created by Hakan Uğraş on 3.09.2026.
//
import Foundation
import CoreCommon

public protocol PensionContractsSummaryRepository: Sendable {
    func fetchSummary() async -> SabancimResult<PensionContractsSummary>
}

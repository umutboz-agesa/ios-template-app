//
//  PensionContractsSummaryModels.swift
//  iOSTemplate
//
//  Created by Hakan Uğraş on 29.07.2026.
//
import Foundation

public struct MoneyAmount: Sendable, Equatable {
    public let amount: String
    public let currency: String

    public init(amount: String, currency: String) {
        self.amount = amount
        self.currency = currency
    }
}

public struct PensionContract: Sendable, Equatable, Identifiable {
    public let contractCode: Int
    public var id: Int { contractCode }
    public let isActive: Bool
    public let isEighteenAgeContract: Bool
    public let cancelledDate: String?
    public let isLegalRepresentative: Bool
    public let contractCategory: Int
    /// Not: gerçek response'ta hep `null` — tipi kesin değil, `String?` varsayıldı.
    public let cancelledContract: String?
    /// Not: gerçek response'ta hep `null` — tipi kesin değil, `String?` varsayıldı.
    public let paymentDate: String?
    public let packageCode: String
    public let order: Int
    public let statusCode: String
    public let participantStatus: Int
    public let contractPlanName: String
    public let status: String
    public let totalSavingAmount: MoneyAmount

    public init(
        contractCode: Int,
        isActive: Bool,
        isEighteenAgeContract: Bool,
        cancelledDate: String?,
        isLegalRepresentative: Bool,
        contractCategory: Int,
        cancelledContract: String?,
        paymentDate: String?,
        packageCode: String,
        order: Int,
        statusCode: String,
        participantStatus: Int,
        contractPlanName: String,
        status: String,
        totalSavingAmount: MoneyAmount
    ) {
        self.contractCode = contractCode
        self.isActive = isActive
        self.isEighteenAgeContract = isEighteenAgeContract
        self.cancelledDate = cancelledDate
        self.isLegalRepresentative = isLegalRepresentative
        self.contractCategory = contractCategory
        self.cancelledContract = cancelledContract
        self.paymentDate = paymentDate
        self.packageCode = packageCode
        self.order = order
        self.statusCode = statusCode
        self.participantStatus = participantStatus
        self.contractPlanName = contractPlanName
        self.status = status
        self.totalSavingAmount = totalSavingAmount
    }
}

public struct PensionContractsSummary: Sendable, Equatable {
    public let totalAmount: MoneyAmount
    public let youAmount: MoneyAmount
    public let companyAmount: MoneyAmount
    public let governmentAmount: MoneyAmount
    public let investmentAmount: MoneyAmount
    /// Not: anlamı/kullanımı belirsiz — sadece `0` görüldü, Bool olarak varsayıldı.
    public let isBanner: Bool
    public let activeContractCount: Int
    public let contracts: [PensionContract]

    public init(
        totalAmount: MoneyAmount,
        youAmount: MoneyAmount,
        companyAmount: MoneyAmount,
        governmentAmount: MoneyAmount,
        investmentAmount: MoneyAmount,
        isBanner: Bool,
        activeContractCount: Int,
        contracts: [PensionContract]
    ) {
        self.totalAmount = totalAmount
        self.youAmount = youAmount
        self.companyAmount = companyAmount
        self.governmentAmount = governmentAmount
        self.investmentAmount = investmentAmount
        self.isBanner = isBanner
        self.activeContractCount = activeContractCount
        self.contracts = contracts
    }
}

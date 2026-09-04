//
//  PensionContractsAndSummaryMapper.swift
//  iOSTemplate
//
//  Created by Hakan Uğraş on 29.07.2026.
//
import Foundation

extension MoneyAmountDTO {
    func toDomain() -> MoneyAmount {
        MoneyAmount(amount: amount, currency: currency)
    }
}

extension PensionContractDTO {
    func toDomain() -> PensionContract {
        PensionContract(
            contractCode: contractCode,
            isActive: isActive == 1,
            isEighteenAgeContract: eigteenAgeContract == 1,
            cancelledDate: cancelledDate,
            isLegalRepresentative: legalRepresentative == 1,
            contractCategory: contractCategory,
            cancelledContract: cancelledContract,
            paymentDate: paymentDate,
            packageCode: packageCode,
            order: order,
            statusCode: statusCode,
            participantStatus: participantStatus,
            contractPlanName: contractPlanName,
            status: status,
            totalSavingAmount: totalSavingAmount.toDomain()
        )
    }
}

extension PensionContractsAndSummaryDataDTO {
    func toDomain() -> PensionContractsSummary {
        PensionContractsSummary(
            totalAmount: totalAmount.toDomain(),
            youAmount: youAmount.toDomain(),
            companyAmount: companyAmount.toDomain(),
            governmentAmount: governmentAmount.toDomain(),
            investmentAmount: investmentAmount.toDomain(),
            isBanner: isBanner == 1,
            activeContractCount: activeContractCount,
            contracts: pensionContracts.map { $0.toDomain() }
        )
    }
}

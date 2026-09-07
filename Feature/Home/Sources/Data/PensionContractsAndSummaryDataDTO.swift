//
//  PensionContractsAndSummaryDataDTO.swift
//  iOSTemplate
//
//  Created by Hakan Uğraş on 29.07.2026.
//
import Foundation

struct MoneyAmountDTO: Decodable, Sendable {
    let amount: String
    let currency: String
}

struct PensionContractsAndSummaryDataDTO: Decodable, Sendable {
    let companyAmount: MoneyAmountDTO
    let totalAmount: MoneyAmountDTO
    let youAmount: MoneyAmountDTO
    /// Ham `Int` (0/1) — `Decodable` bunu doğrudan `Bool`'a çeviremez, mapper'da dönüştürülüyor.
    let isBanner: Int
    let activeContractCount: Int
    let governmentAmount: MoneyAmountDTO
    let investmentAmount: MoneyAmountDTO
    let pensionContracts: [PensionContractDTO]

    /// Backend'de `govermentAmount` yazılmış (n eksik) — Swift tarafında doğru
    /// yazıp CodingKeys ile hatalı key'e bağlıyoruz, yazım hatasını taşımıyoruz.
    enum CodingKeys: String, CodingKey {
        case companyAmount, totalAmount, youAmount, isBanner, activeContractCount
        case governmentAmount = "govermentAmount"
        case investmentAmount, pensionContracts
    }
}

struct PensionContractDTO: Decodable, Sendable {
    let contractCode: Int
    /// Ham `Int` (0/1) — mapper'da `Bool`'a çevriliyor.
    let isActive: Int
    /// Ham `Int` (0/1) — backend'de `eigteenAgeContract` yazılmış ("eighteen" değil),
    /// JSON key'i olduğu gibi bırakıldı, Swift tarafında da aynı isim (tutarlılık için
    /// CodingKeys'e gerek yok, sadece property adı JSON'la birebir).
    let eigteenAgeContract: Int
    let cancelledDate: String?
    /// Ham `Int` (0/1) — mapper'da `Bool`'a çevriliyor.
    let legalRepresentative: Int
    let contractCategory: Int
    /// Not: gerçek response'ta hep `null` — tipi kesin değil, `String?` varsayıldı.
    let cancelledContract: String?
    /// Not: gerçek response'ta hep `null` — tipi kesin değil, `String?` varsayıldı.
    let paymentDate: String?
    let packageCode: String
    let order: Int
    let statusCode: String
    let participantStatus: Int
    let contractPlanName: String
    let status: String
    let totalSavingAmount: MoneyAmountDTO
}

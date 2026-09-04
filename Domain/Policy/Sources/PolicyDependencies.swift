//
//  PolicyDependencies.swift
//  iOSTemplate
//
//  Created by Hakan Uğraş on 29.07.2026.
//
import Dependencies
import CoreCommon

/// `PensionContractsSummaryRepository` için DI anahtarı. `VersionCheckRepositoryKey`
/// ile aynı desen — gerçek veri çeken kritik bir yol, bootstrap'ta bağlanmazsa
/// canlı context'te fatalError vermeli, sessizce boş veri dönmemeli.
public enum PensionContractsSummaryRepositoryKey: DependencyKey {
    public static let liveValue: PensionContractsSummaryRepository = DefaultPensionContractsSummaryRepository()

    public static let testValue: PensionContractsSummaryRepository = UnimplementedPensionContractsSummaryRepository()
}

public extension DependencyValues {
    var pensionContractsSummaryRepository: any PensionContractsSummaryRepository {
        get { self[PensionContractsSummaryRepositoryKey.self] }
        set { self[PensionContractsSummaryRepositoryKey.self] = newValue }
    }
}

struct UnimplementedPensionContractsSummaryRepository: PensionContractsSummaryRepository {
    func fetchSummary() async -> SabancimResult<PensionContractsSummary> {
        .failure(.unknown(message: "PensionContractsSummaryRepository bağlanmadı."))
    }
}

/// Mock flavor / bootstrap'ta gerçek implementasyon bağlanmazsa kullanılan
/// varsayılan — superapp'teki gerçek "SavingsMock" ile birebir tutarlı sayılar.
struct DefaultPensionContractsSummaryRepository: PensionContractsSummaryRepository {
    func fetchSummary() async -> SabancimResult<PensionContractsSummary> {
        // Toplam = Katkı + Devlet + Getiri + İşveren = 52.500 + 13.750 + 44.233,37 + 52.500 = 162.983,37
        .success(.init(totalAmount: .init(amount: "162983.37", currency: "TL"),
                       youAmount: .init(amount: "52500.00", currency: "TL"),
                       companyAmount: .init(amount: "52500.00", currency: "TL"),
                       governmentAmount: .init(amount: "13750.00", currency: "TL"),
                       investmentAmount: .init(amount: "44233.37", currency: "TL"),
                       isBanner: false,
                       activeContractCount: 2,
                       contracts: []
                      )
        )
    }
}

import Foundation
import Observation
import Dependencies

@MainActor
@Observable
public final class HomeViewModel {
    @ObservationIgnored @Dependency(\.userSession) private var userSession
    @ObservationIgnored @Dependency(\.sessionManager) private var session
    @ObservationIgnored @Dependency(\.pensionContractsSummaryRepository) private var pensionContractsSummaryRepository

    public private(set) var summaryState: Loadable<Void> = .idle
    public private(set) var savingsTotal: Decimal = 0
    public private(set) var savingsSlices: [SabancimSavingsOverviewCard.Slice] = []
    public private(set) var savingsActiveCount: Int = 0

    private let onFinished: (SabancimRoute) -> Void

    public init(onFinished: @escaping (SabancimRoute) -> Void = { _ in }) {
        self.onFinished = onFinished
    }

    public var profile: UserProfile { userSession.profile }

    /// use-case → `PensionContractsSummary` → donut dilimleri (Katkı/Devlet/Getiri/İşveren).
    public func loadSummary() async {
        summaryState = .loading
        let useCase = FetchPensionContractsSummaryUseCase(repository: pensionContractsSummaryRepository)
        guard case let .success(summary) = await useCase() else {
            summaryState = .failed(.unknown(message: "Özet yüklenemedi."))
            return
        }
        savingsTotal = Self.decimal(summary.totalAmount)
        savingsSlices = [
            .init(label: "Katkı payım", value: Self.decimal(summary.youAmount), color: SabancimTheme.Brand.blue),
            .init(label: "Devlet katkısı", value: Self.decimal(summary.governmentAmount), color: SabancimTheme.Brand.purple),
            .init(label: "Getirilerim", value: Self.decimal(summary.investmentAmount), color: SabancimTheme.Colors.success),
            .init(label: "İşveren katkısı", value: Self.decimal(summary.companyAmount), color: SabancimTheme.Brand.indigo),
        ]
        savingsActiveCount = summary.activeContractCount
        summaryState = .loaded(())
    }

    /// Backend tutarları "535000.00" (nokta ondalık) String — locale sabitlenerek parse.
    private static func decimal(_ m: MoneyAmount) -> Decimal {
        Decimal(string: m.amount, locale: Locale(identifier: "en_US_POSIX")) ?? 0
    }
}

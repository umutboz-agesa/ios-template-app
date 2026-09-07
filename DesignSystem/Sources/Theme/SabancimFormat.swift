import Foundation

/// Ekranda gösterim formatları (para, yüzde). DesignSystem saf kalır — bu bir util, view değil.
/// Component'ler ham `Decimal`/`Double` alır ama metni buradan üretir → tek kaynak, tekrar yok.
public enum SabancimFormat {

    private static let trLocale = Locale(identifier: "tr_TR")

    /// "₺125.750,00" — mockup stili: ₺ önde, TR gruplama (nokta binlik, virgül kuruş).
    public static func currencyTRY(_ value: Decimal, fractionDigits: Int = 2) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = trLocale
        formatter.minimumFractionDigits = fractionDigits
        formatter.maximumFractionDigits = fractionDigits
        let number = formatter.string(from: value as NSDecimalNumber) ?? "\(value)"
        return "₺\(number)"
    }

    /// "%12,4" — TR ondalık, yüzde işareti önde.
    public static func percent(_ value: Double, fractionDigits: Int = 1) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = trLocale
        formatter.maximumFractionDigits = fractionDigits
        let number = formatter.string(from: value as NSNumber) ?? "\(value)"
        return "%\(number)"
    }
}

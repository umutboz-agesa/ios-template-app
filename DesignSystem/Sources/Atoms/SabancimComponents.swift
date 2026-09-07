import SwiftUI
import UIKit

/// Android `SabancimButton` karşılığı.
public struct SabancimButton: View {
    @Environment(\.isEnabled) private var isEnabled
    
    private let title: String
    private let systemImage: String?
    private let isLoading: Bool
    private let action: () -> Void

    public init(_ title: String, systemImage: String? = nil, isLoading: Bool = false, action: @escaping () -> Void) {
        self.title = title
        self.systemImage = systemImage
        self.isLoading = isLoading
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            ZStack {
                if isLoading {
                    ProgressView().tint(SabancimTheme.Colors.onPrimary)
                } else {
                    HStack(spacing: SabancimTheme.Spacing.sm) {
                        if let systemImage {
                            Image(systemName: systemImage).fontWeight(.semibold)
                        }
                        Text(title).fontWeight(.semibold)
                    }
                }
            }
            .frame(maxWidth: .infinity, minHeight: 50)
        }
        .foregroundStyle(SabancimTheme.Colors.onPrimary)
        .background(isEnabled ? SabancimTheme.Colors.primary : SabancimTheme.Colors.primary.opacity(0.4))
        .clipShape(RoundedRectangle(cornerRadius: SabancimTheme.Radius.button))
        .disabled(isLoading)
    }
}

/// Android `SabancimInputs` (text field) karşılığı.
public struct SabancimTextField: View {
    private let placeholder: String
    @Binding private var text: String
    private let isSecure: Bool
    private let keyboardType: UIKeyboardType
    private let onlyDigits: Bool
    private let warning: String?

    public init(_ placeholder: String,
                text: Binding<String>,
                isSecure: Bool = false,
                keyboardType: UIKeyboardType = .default,
                onlyDigits: Bool = false,
                warning: String? = nil) {
        self.placeholder = placeholder
        self._text = text
        self.isSecure = isSecure
        self.keyboardType = keyboardType
        self.onlyDigits = onlyDigits
        self.warning = warning
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Group {
                if isSecure {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                }
            }
            .keyboardType(keyboardType)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .onChange(of: text) { _, newValue in
                guard onlyDigits else { return }
                let filtered = newValue.filter { $0.isNumber }
                if filtered != newValue { text = filtered }
            }
            .padding(SabancimTheme.Spacing.md)
            .background(SabancimTheme.Colors.surface)
            .clipShape(RoundedRectangle(cornerRadius: SabancimTheme.Radius.button))

            if let warning {
                Text(warning)
                    .font(.caption)
                    .foregroundStyle(SabancimTheme.Colors.error)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

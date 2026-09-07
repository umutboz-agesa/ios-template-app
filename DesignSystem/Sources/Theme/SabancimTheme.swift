import SwiftUI

/// Android `:designsystem` tema (Material3 theme) karşılığı.
/// Reusable component'ler buradan renk/tipografi çeker.
public enum SabancimTheme {
    public enum Colors {
        public static let primary = Color(red: 0.0, green: 0.40, blue: 0.80)
        public static let onPrimary = Color.white
        public static let background = Color(.systemBackground)
        public static let error = Color(red: 0.78, green: 0.13, blue: 0.13)
        public static let surface = Color(.secondarySystemBackground)
        public static let onSurface = Color(.label)
        public static let muted = Color(.secondaryLabel)
    }

    public enum Spacing {
        public static let xs: CGFloat = 4
        public static let sm: CGFloat = 8
        public static let md: CGFloat = 16
        public static let lg: CGFloat = 24
    }

    public enum Radius {
        public static let button: CGFloat = 12
        public static let card: CGFloat = 16
    }
}

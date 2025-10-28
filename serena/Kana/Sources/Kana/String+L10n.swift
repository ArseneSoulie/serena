import Foundation

/// Helper for interpolated string l10n
extension String {
    init(localizedInterpolated: String) {
        self = String(
            format: NSLocalizedString(
                localizedInterpolated,
                bundle: .module,
                comment: "",
            ),
        )
    }
}

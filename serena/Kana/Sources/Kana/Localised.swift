import Foundation

func localized(_ key: String) -> String {
    String(format: NSLocalizedString(key, bundle: .module, comment: ""))
}

func localized(_ resource: LocalizedStringResource) -> String {
    String(localized: resource)
}

func localized(_ key: String, _ args: CVarArg...) -> String {
    String(format: NSLocalizedString(key, bundle: .module, comment: ""), arguments: args)
}

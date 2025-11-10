import SwiftUI
import UIKit

// MARK: - UITextField Subclass

final class KanaTextField: UITextField {
    var preferredLanguageCode: String?

    override var textInputMode: UITextInputMode? {
        guard let code = preferredLanguageCode else {
            return super.textInputMode
        }
        for inputMode in UITextInputMode.activeInputModes {
            if let primary = inputMode.primaryLanguage, primary.contains(code) {
                return inputMode
            }
        }
        return super.textInputMode
    }
}

// MARK: - UIViewRepresentable

struct KanaTextFieldView: UIViewRepresentable {
    @Binding var text: String
    @Binding var isFirstResponder: Bool

    let languageCode: String
    var placeholder: String = ""
    var onSubmit: () -> Void = {}

    func makeUIView(context: Context) -> KanaTextField {
        let textField = KanaTextField()
        textField.preferredLanguageCode = languageCode
        textField.placeholder = placeholder
        textField.returnKeyType = .done
        textField.clearButtonMode = .whileEditing
        textField.delegate = context.coordinator
        textField.addTarget(
            context.coordinator,
            action: #selector(Coordinator.textFieldDidChange),
            for: .editingChanged,
        )
        return textField
    }

    func updateUIView(_ uiView: KanaTextField, context: Context) {
        uiView.text = text

        if isFirstResponder, !context.coordinator.isEditing {
            DispatchQueue.main.async {
                uiView.becomeFirstResponder()
            }
        } else if !isFirstResponder, context.coordinator.isEditing {
            DispatchQueue.main.async {
                uiView.resignFirstResponder()
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    // MARK: - Coordinator (Rollback Version)

    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: KanaTextFieldView
        var isEditing: Bool = false

        init(_ parent: KanaTextFieldView) {
            self.parent = parent
        }

        @objc func textFieldDidChange(_ textField: UITextField) {
            parent.text = textField.text ?? ""
        }

        func textFieldDidBeginEditing(_: UITextField) {
            isEditing = true
            parent.isFirstResponder = true
        }

        func textFieldDidEndEditing(_: UITextField) {
            isEditing = false
            parent.isFirstResponder = false
        }

        func textFieldShouldReturn(_: UITextField) -> Bool {
            parent.onSubmit()
            return false
        }
    }
}

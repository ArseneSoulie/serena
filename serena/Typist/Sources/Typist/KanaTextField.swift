import SwiftUI

// MARK: - UITextField subclass with preferred input mode

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
    // MARK: Bindings

    @Binding var text: String
    @Binding var isFirstResponder: Bool

    // MARK: Configuration

    let preferredLanguageCode: String?
    let onSubmit: () -> Void

    // MARK: Init

    init(
        text: Binding<String>,
        preferredLanguageCode: String?,
        onSubmit: @escaping () -> Void,
        isFirstResponder: Binding<Bool> = .constant(false),
    ) {
        _text = text
        self.preferredLanguageCode = preferredLanguageCode
        self.onSubmit = onSubmit
        _isFirstResponder = isFirstResponder
    }

    // MARK: UIViewRepresentable

    func makeUIView(context: Context) -> KanaTextField {
        let field = KanaTextField()
        field.preferredLanguageCode = preferredLanguageCode
        field.delegate = context.coordinator

        field.addTarget(
            context.coordinator,
            action: #selector(Coordinator.textFieldDidChange(_:)),
            for: .editingChanged,
        )

        field.borderStyle = .none
        field.returnKeyType = .done
        field.clearButtonMode = .whileEditing

        // Defer initial focus until the field is in the view hierarchy.
        if isFirstResponder {
            DispatchQueue.main.async {
                guard field.window != nil else { return }
                if !field.isFirstResponder {
                    field.becomeFirstResponder()
                    context.coordinator.didBecomeFirstResponder = true
                }
            }
        }

        return field
    }

    func updateUIView(_ uiView: KanaTextField, context: Context) {
        if uiView.text != text {
            uiView.text = text
        }

        if uiView.preferredLanguageCode != preferredLanguageCode {
            uiView.preferredLanguageCode = preferredLanguageCode
        }

        if isFirstResponder {
            if !context.coordinator.didBecomeFirstResponder {
                DispatchQueue.main.async {
                    guard uiView.window != nil else { return }
                    if !uiView.isFirstResponder {
                        uiView.becomeFirstResponder()
                    }
                    context.coordinator.didBecomeFirstResponder = true
                }
            }
        } else {
            if uiView.isFirstResponder {
                DispatchQueue.main.async {
                    uiView.resignFirstResponder()
                }
            }
            if context.coordinator.didBecomeFirstResponder {
                context.coordinator.didBecomeFirstResponder = false
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    // MARK: - Coordinator

    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: KanaTextFieldView
        var didBecomeFirstResponder: Bool = false

        init(_ parent: KanaTextFieldView) {
            self.parent = parent
        }

        @objc func textFieldDidChange(_ textField: UITextField) {
            // Defer binding write to avoid "Modifying state during view update"
            let newText = textField.text ?? ""
            if parent.text == newText { return }
            DispatchQueue.main.async {
                self.parent.text = newText
            }
        }

        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            parent.onSubmit()
            // Maintain requested focus state after submit
            if parent.isFirstResponder {
                // Defer to avoid cycles during submit
                DispatchQueue.main.async {
                    if !textField.isFirstResponder {
                        textField.becomeFirstResponder()
                    }
                }
                didBecomeFirstResponder = true
            } else {
                DispatchQueue.main.async {
                    if textField.isFirstResponder {
                        textField.resignFirstResponder()
                    }
                }
                didBecomeFirstResponder = false
            }
            return false
        }
    }
}

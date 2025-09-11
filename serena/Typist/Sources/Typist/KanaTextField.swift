import SwiftUI

class KanaTextField: UITextField {
    var preferredLanguageCode: String?

    override var textInputMode: UITextInputMode? {
        if let code = preferredLanguageCode {
            for inputMode in UITextInputMode.activeInputModes {
                if let primary = inputMode.primaryLanguage, primary.contains(code) {
                    return inputMode
                }
            }
        }
        return super.textInputMode
    }
}

struct KanaTextFieldView: UIViewRepresentable {
    @Binding var text: String
    let preferredLanguageCode: String?
    let onSubmit: () -> Void

    func makeUIView(context: Context) -> KanaTextField {
        let field = KanaTextField()
        field.preferredLanguageCode = preferredLanguageCode
        field.delegate = context.coordinator

        field.addTarget(
            context.coordinator,
            action: #selector(Coordinator.textFieldDidChange(_:)),
            for: .editingChanged,
        )

        return field
    }

    func updateUIView(_ uiView: KanaTextField, context _: Context) {
        if uiView.text != text {
            uiView.text = text
        }
        uiView.preferredLanguageCode = preferredLanguageCode
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: KanaTextFieldView

        init(_ parent: KanaTextFieldView) {
            self.parent = parent
        }

        @objc func textFieldDidChange(_ textField: UITextField) {
            parent.text = textField.text ?? ""
        }

        func textFieldShouldReturn(_: UITextField) -> Bool {
            parent.onSubmit()
            return false
        }
    }
}

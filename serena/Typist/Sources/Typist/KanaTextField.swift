import SwiftUI

class KanaTextField: UITextField {
    var preferredLanguageCode: String?

    override var textInputMode: UITextInputMode? {
        if let code = preferredLanguageCode {
            for tim in UITextInputMode.activeInputModes {
                if
                    let primary = tim.primaryLanguage,
                    primary.contains(code) {
                    return tim
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
        return field
    }

    func updateUIView(_ uiView: KanaTextField, context _: Context) {
        uiView.text = text
        uiView.preferredLanguageCode = preferredLanguageCode
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: KanaTextFieldView
        init(_ parent: KanaTextFieldView) { self.parent = parent }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            parent.text = textField.text ?? ""
        }

        func textFieldShouldReturn(_: UITextField) -> Bool {
            parent.onSubmit()
            return false
        }
    }
}

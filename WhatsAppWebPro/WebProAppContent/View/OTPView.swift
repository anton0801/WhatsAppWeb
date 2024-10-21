import SwiftUI

struct OTPBoxView: View {
    @State private var otpCode: [String] = Array(repeating: "", count: 4)
    @State private var currentIndex = 0
    var completedCode: (String) -> Void

    var body: some View {
        HStack(spacing: 10) {
            ForEach(0..<4, id: \.self) { index in
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(currentIndex == index ? Color.blue : (otpCode[index].isEmpty ? Color.init(red: 169/255, green: 169/255, blue: 169/255) : Color.init(red: 1, green: 185/255, blue: 96/255)), lineWidth: 2)
                        .background(RoundedRectangle(cornerRadius: 10).fill(otpCode[index].isEmpty ? Color.init(red: 233/255, green: 233/255, blue: 233/255) : Color.init(red: 230/255, green: 1, blue: 218/255)))
                        .frame(width: 62, height: 62)

                    Text(otpCode[index].isEmpty ? "" : "✱")
                        .font(.system(size: 42, weight: .bold))
                        .foregroundColor(Color.init(red: 1, green: 185/255, blue: 96/255))
                }
            }
        }
        .padding()
        .background(OTPTextField(otpCode: $otpCode, currentIndex: $currentIndex))
        .onChange(of: otpCode) { newValue in
            let otpCodeString = otpCode.joined(separator: "")
            if otpCodeString.count == 4 {
                completedCode(otpCodeString)
            }
        }
    }
}

struct OTPTextField: UIViewRepresentable {
    @Binding var otpCode: [String]
    @Binding var currentIndex: Int

    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var otpCode: [String]
        @Binding var currentIndex: Int

        init(otpCode: Binding<[String]>, currentIndex: Binding<Int>) {
            _otpCode = otpCode
            _currentIndex = currentIndex
        }

        // Метод, который вызывается при изменении текста
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            // Проверяем, является ли символ цифрой
            if let char = string.first, char.isNumber {
                if currentIndex < otpCode.count {
                    otpCode[currentIndex] = String(char)
                    currentIndex += 1
                }
            } else if string.isEmpty { // Если удаляем символ
                if currentIndex > 0 {
                    currentIndex -= 1
                    otpCode[currentIndex] = ""
                }
            }

            return false
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(otpCode: $otpCode, currentIndex: $currentIndex)
    }

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.delegate = context.coordinator
        textField.keyboardType = .numberPad
        textField.becomeFirstResponder()
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {}
}

#Preview {
    OTPBoxView { otpCode in
        
    }
}

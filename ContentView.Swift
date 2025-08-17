import SwiftUI

struct ContentView: View {
    @State private var display = "0"
    @State private var currentOperation: String? = nil
    @State private var previousValue: Double? = nil
    @State private var isTypingNumber = false

    let buttons: [[String]] = [
        ["C", "÷", "×", "⌫"],
        ["7", "8", "9", "−"],
        ["4", "5", "6", "+"],
        ["1", "2", "3", "="],
        ["0", ".", "", ""]
    ]

    var body: some View {
        VStack(spacing: 12) {
            Spacer()

            // Display
            HStack {
                Spacer()
                Text(display)
                    .font(.system(size: 64))
                    .foregroundColor(.white)
                    .padding()
            }

            // Buttons
            ForEach(buttons, id: \.self) { row in
                HStack(spacing: 12) {
                    ForEach(row, id: \.self) { button in
                        Button(action: {
                            self.buttonTapped(button)
                        }) {
                            Text(button)
                                .font(.system(size: 28))
                                .frame(width: self.buttonWidth(button), height: self.buttonHeight())
                                .background(self.buttonColor(button))
                                .foregroundColor(.white)
                                .cornerRadius(self.buttonWidth(button) / 2)
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }

    // MARK: - Helper Methods

    func buttonTapped(_ button: String) {
        switch button {
        case "0"..."9", ".":
            if isTypingNumber {
                if button == "." && display.contains(".") { return }
                display += button
            } else {
                display = button == "." ? "0." : button
                isTypingNumber = true
            }

        case "+", "−", "×", "÷":
            currentOperation = button
            previousValue = Double(display)
            isTypingNumber = false

        case "=":
            guard let operation = currentOperation,
                  let prev = previousValue,
                  let current = Double(display) else { return }

            switch operation {
            case "+": display = String(prev + current)
            case "−": display = String(prev - current)
            case "×": display = String(prev * current)
            case "÷": display = current != 0 ? String(prev / current) : "Error"
            default: break
            }
            isTypingNumber = false
            currentOperation = nil
            previousValue = nil

        case "C":
            display = "0"
            currentOperation = nil
            previousValue = nil
            isTypingNumber = false

        case "⌫":
            if isTypingNumber && !display.isEmpty {
                display.removeLast()
                if display.isEmpty {
                    display = "0"
                    isTypingNumber = false
                }
            }

        default: break
        }
    }

    func buttonColor(_ symbol: String) -> Color {
        if ["+", "−", "×", "÷", "="].contains(symbol) {
            return .orange
        } else if symbol == "C" || symbol == "⌫" {
            return .gray
        } else {
            return .darkGray
        }
    }

    func buttonWidth(_ button: String) -> CGFloat {
        return button == "0" ? (UIScreen.main.bounds.width - 5 * 12) / 2 : (UIScreen.main.bounds.width - 5 * 12) / 4
    }

    func buttonHeight() -> CGFloat {
        return (UIScreen.main.bounds.width - 5 * 12) / 4
    }
}

// MARK: - Dark Gray Color Extension
extension Color {
    static let darkGray = Color(UIColor.darkGray)
}

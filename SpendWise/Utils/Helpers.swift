import Foundation

func formatNumberToDecimal(value:Double) -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.locale = Locale(identifier: "pt_BR")
    numberFormatter.minimumFractionDigits = 2
    numberFormatter.numberStyle = .decimal
    return numberFormatter.string(from: NSNumber(value:value)) ?? "0,00"
}

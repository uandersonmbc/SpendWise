import SwiftUI
import UIKit

struct ListIcons: View {
    @Binding var selectedIcon: String
    var selectedColor: Color
    
    var body: some View {
        ScrollView{
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 50))]){
                ForEach(systemIcons, id: \.self) { iconName in
                    HStack {
                        Button{
                            selectedIcon = iconName
                            generateHapticFeedback()
                            self.hideKeyboard()
                        } label: {
                            Image(systemName: iconName)
                                .fontWeight(.bold)
                        }
                    }
                    .frame(width: 50, height: 50, alignment: .center)
                    .background(selectedIcon == iconName ? selectedColor.opacity(0.2) : .clear)
                    .foregroundColor(selectedIcon == iconName ? selectedColor : .gray)
                    .cornerRadius(25)
                    .onTapGesture {
                        generateHapticFeedback()
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .padding(.horizontal, 5)
            .padding(.vertical, 10)
        }
    }
    
    func generateHapticFeedback() {
        let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
        impactFeedbackGenerator.prepare()
        impactFeedbackGenerator.impactOccurred()
    }
}

#Preview {
    ListIcons(selectedIcon: .constant(systemIcons[0]), selectedColor: .red)
}

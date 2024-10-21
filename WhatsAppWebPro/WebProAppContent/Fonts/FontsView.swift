import SwiftUI

struct FontsView: View {
    
    @Environment(\.presentationMode) var presMode
    
    @State var textInput = ""
    @State private var showCopyMessage: Bool = false
    @State var selectedFont: Font = .system(size: 20)
    
    var fonts: [FontFamily] = [.system, .aboreto, .afacad, .agbalumo, .akshar, .andika, .asset, .jersey10, .seymourOne, .tacOne, .yanoneKaffeesatz, .zain]
    
    enum FontFamily: String, CaseIterable {
        case system = "System"
        case aboreto = "Aboreto"
        case afacad = "Afacad"
        case agbalumo = "Agbalumo"
        case akshar = "Akshar"
        case andika = "Andika"
        case asset = "Asset"
        case jersey10 = "Jersey 10"
        case seymourOne = "Seymour One"
        case tacOne = "Tac One"
        case yanoneKaffeesatz = "Yanone Kaffeesatz"
        case zain = "Zain"
        
        func toFont() -> Font {
            switch self {
            case .system:
                return .system(size: 18)
            default:
                return .custom(self.rawValue, size: 18)
            }
        }
    }
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Button {
                        presMode.wrappedValue.dismiss()
                    } label: {
                        Image("back")
                            .resizable()
                            .frame(width: 12, height: 20)
                    }
                    
                    Spacer()
                    
                    Text("Fonts")
                    
                    Spacer()
                    
                    Image("back")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .opacity(0)
                }
                .padding(.horizontal)
                
                VStack {
                    HStack {
                        Text("The last text")
                        
                        Spacer()
                        
                        Button {
                            copyTextWithFont()
                        } label: {
                            Image("copy")
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                    
                    TextField("Enter text...", text: $textInput)
                        .font(selectedFont)
                        .foregroundColor(Color.init(red: 10/255, green: 10/255, blue: 10/255))
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal)
                        .keyboardType(.default)
                        .lineLimit(8)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: 200)
                .background(
                    RoundedRectangle(cornerRadius: 16.0, style: .continuous)
                        .fill(Color.init(red: 230/255, green: 1, blue: 218/255))
                )
                .background(
                    RoundedRectangle(cornerRadius: 16.0, style: .continuous)
                        .stroke(Color.init(red: 1, green: 185/255, blue: 96/255), lineWidth: 1)
                )
                .padding(.horizontal)
                .padding(.top)
                
                if showCopyMessage {
                    Text("Copied to clipboard!")
                        .font(.headline)
                        .foregroundColor(.green)
                        .padding(.top, 10)
                        .transition(.opacity)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                withAnimation {
                                    showCopyMessage = false
                                }
                            }
                        }
                }
            }
            .frame(maxWidth: .infinity)
            .background(
                Image("top_main_bg")
                    .resizable()
                    .frame(height: 380)
            )
            
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.fixed(100)),
                    GridItem(.fixed(100)),
                    GridItem(.fixed(100))
                ]) {
                    ForEach(fonts, id: \.self) { font in
                        Button {
                            selectedFont = font.toFont()
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 16.0, style: .continuous)
                                    .fill(Color.init(red: 230/255, green: 1, blue: 218/255))
                                    .frame(width: 100, height: 100)
                                
                                if selectedFont == font.toFont() {
                                    RoundedRectangle(cornerRadius: 16.0, style: .continuous)
                                        .stroke(
                                            LinearGradient(colors: [
                                                Color.init(red: 30/255, green: 229/255, blue: 111/255),
                                                Color.init(red: 0, green: 184/255, blue: 95/255)
                                            ], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 3
                                        )
                                        .frame(width: 100, height: 100)
                                }
                                
                                Text("ABC")
                                    .font(font.toFont())
                                    .foregroundColor(.black)
                                    .fontWeight(.regular)
                            }
                        }
                    }
                }
            }
            .padding(.top, 72)
        }
    }
    
    func copyTextWithFont() {
        let pasteboard = UIPasteboard.general
        pasteboard.string = textInput
        withAnimation {
            showCopyMessage = true
        }
    }
    
}

#Preview {
    FontsView()
}

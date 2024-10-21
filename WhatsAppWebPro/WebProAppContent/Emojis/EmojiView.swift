import SwiftUI

struct EmojiView: View {
    
    enum Emojis: String, CaseIterable {
        case emoji1 = "¯\\_(ツ)_/¯"
        case emoji2 = "(˶ᵔ ᵕ ᵔ˶)"
        case emoji3 = "≽^•⩊•^≼"
        case emoji4 = "•ᴗ•"
        case emoji5 = "◕⩊◕"
        case emoji6 = "◝(ᵔᵕᵔ)◜"
        case emoji7 = "✘_ ✘"
        case emoji8 = "ツ"
        case emoji9 = "(⊙ _ ⊙ )"
    }
    
    var emojis: [Emojis] = [
        .emoji1, .emoji2, .emoji3, .emoji4, .emoji5, .emoji6, .emoji7, .emoji8, .emoji9
    ]
    
    @Binding var visibleBottomNav: Bool
    
    @Environment(\.presentationMode) var presMode
    
    @State var textInput = ""
    @State private var showCopyMessage: Bool = false
    @State var selectedEmoji: Emojis = .emoji1
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Button {
                        withAnimation(.linear) {
                            visibleBottomNav = true
                        }
                        presMode.wrappedValue.dismiss()
                    } label: {
                        Image("back")
                            .resizable()
                            .frame(width: 12, height: 20)
                    }
                    
                    Spacer()
                    
                    Text("Emojis")
                    
                    Spacer()
                    
                    Image("back")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .opacity(0)
                }
                .padding(.horizontal)
                
                VStack {
                    Text(selectedEmoji.rawValue)
                        .font(.system(size: 42))
                }
                .frame(maxWidth: .infinity, maxHeight: 200)
                .background(
                    Image("emoji_background")
                        .resizable()
                        .frame(width: 350, height: 200)
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
                    ForEach(emojis, id: \.rawValue) { emoji in
                        Button {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedEmoji = emoji
                            }
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 16.0, style: .continuous)
                                    .fill(Color.init(red: 230/255, green: 1, blue: 218/255))
                                    .frame(width: 100, height: 100)
                                
                                if selectedEmoji == emoji {
                                    RoundedRectangle(cornerRadius: 16.0, style: .continuous)
                                        .stroke(
                                            LinearGradient(colors: [
                                                Color.init(red: 30/255, green: 229/255, blue: 111/255),
                                                Color.init(red: 0, green: 184/255, blue: 95/255)
                                            ], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 3
                                        )
                                        .frame(width: 100, height: 100)
                                }
                                
                                Text(emoji.rawValue)
                                    .font(.system(size: 24))
                                    .foregroundColor(.black)
                                    .fontWeight(.regular)
                            }
                        }
                    }
                }
            }
            .padding(.top, 82)
            
            HStack {
                Button {
                    withAnimation(.easeInOut) {
                        selectedEmoji = emojis.randomElement() ?? emojis[0]
                    }
                } label: {
                    Text("Random")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .padding()
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(
                                    LinearGradient(colors: [
                                        Color.init(red: 30/255, green: 229/255, blue: 111/255),
                                        Color.init(red: 0, green: 184/255, blue: 95/255)
                                    ], startPoint: .trailing, endPoint: .leading)
                                )
                        )
                        .padding()
                }
                .padding(.leading)
                
                Button {
                    copyTextWithFont()
                } label: {
                    Image("copy_button")
                        .resizable()
                        .frame(width: 62, height: 62)
                }
                .padding(.trailing)
            }
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(.white)
            )
            .shadow(color: .black.opacity(0.1), radius: 15)
        }
        .edgesIgnoringSafeArea(.bottom)
        .onAppear {
            withAnimation(.linear) {
                visibleBottomNav = false
            }
        }
        .onDisappear {
            withAnimation(.linear) {
                visibleBottomNav = true
            }
        }
    }
    
    func copyTextWithFont() {
        let pasteboard = UIPasteboard.general
        pasteboard.string = selectedEmoji.rawValue
        withAnimation {
            showCopyMessage = true
        }
    }
    
}

#Preview {
    EmojiView(visibleBottomNav: .constant(false))
}

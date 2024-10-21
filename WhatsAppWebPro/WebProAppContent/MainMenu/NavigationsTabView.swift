import SwiftUI

struct NavigationsTabView: View {
    
    @State var selectedPage = 0
    
    @State var visibleBottomNav: Bool = true
    
    var body: some View {
        VStack {
            
            if selectedPage == 0 {
                ContentView(visibleBottomNav: $visibleBottomNav)
                    .preferredColorScheme(.light)
            } else if selectedPage == 1 {
                ScanQRCodeView()
                    .preferredColorScheme(.light)
            } else {
                SettingsView()
            }
            
            Spacer()
            
            if visibleBottomNav {
                
                NavigationTabView(page: $selectedPage)
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .preferredColorScheme(.light)
    }
}

struct NavigationTabView: View {
    
    @Binding var page: Int
    
    var body: some View {
        HStack {
            HStack {
                Spacer()
                Button {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        page = 0
                    }
                } label: {
                    VStack {
                        Image("main")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .opacity(page == 0 ? 1 : 0.6)
                        Text("Home")
                            .fontWeight(.regular)
                            .foregroundColor(page == 0 ? Color.init(red: 26/255, green: 26/255, blue: 26/255) : Color.init(red: 178/255, green: 179/255, blue: 179/255))
                    }
                }
                Spacer()
                Button {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        page = 1
                    }
                } label: {
                    VStack {
                        Image("qr_code")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .opacity(page == 1 ? 1 : 0.6)
                        Text("QR-code")
                            .fontWeight(.regular)
                            .foregroundColor(page == 1 ? Color.init(red: 26/255, green: 26/255, blue: 26/255) : Color.init(red: 178/255, green: 179/255, blue: 179/255))
                    }
                }
                Spacer()
                Button {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        page = 2
                    }
                } label: {
                    VStack {
                        Image("settings")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .opacity(page == 2 ? 1 : 0.6)
                        Text("Settings")
                            .fontWeight(.regular)
                            .foregroundColor(page == 2 ? Color.init(red: 26/255, green: 26/255, blue: 26/255) : Color.init(red: 178/255, green: 179/255, blue: 179/255))
                    }
                }
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.init(red: 243/255, green: 244/255, blue: 245/255))
            )
            .padding(24)
        }
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 42, style: .continuous)
                .fill(.white)
        )
        .shadow(color: .black.opacity(0.1), radius: 15)
    }
    
}

#Preview {
    NavigationsTabView()
}

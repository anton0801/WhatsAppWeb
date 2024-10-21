import SwiftUI
import StoreKit
import WebKit

struct SettingsView: View {
    
    @Environment(\.requestReview) var requestReview
    
    @State var sheetFeedback = false
    @State var sheetTermsOfUse = false
    @State var sheetPrivacyPolicy = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Settings")
                .font(.system(size: 32))
                .fontWeight(.bold)
                .padding(.leading)
            
            HStack(spacing: 12) {
                Button {
                    sheetFeedback.toggle()
                } label: {
                    Image("feedback")
                        .resizable()
                        .frame(maxWidth: .infinity, maxHeight: 110)
                }
                
                Button {
                    sheetTermsOfUse.toggle()
                } label: {
                    Image("terms_of_use")
                        .resizable()
                        .frame(maxWidth: .infinity, maxHeight: 110)
                }
                
                Button {
                    sheetPrivacyPolicy.toggle()
                } label: {
                    Image("privacy_policy")
                        .resizable()
                        .frame(maxWidth: .infinity, maxHeight: 110)
                }
            }
            .padding([.horizontal, .top])
            
            HStack(spacing: 16) {
                ShareLink(item: URL(string: "https://apps.apple.com/us/app/messenger-tool-whatsapp-web/id6737196208")!) {
                    Image("tell_a_friend")
                        .resizable()
                        .frame(maxWidth: .infinity, maxHeight: 110)
                }
                
                Button {
                    requestReview()
                } label: {
                    Image("rate_us")
                        .resizable()
                        .frame(width: 120, height: 110)
                }
            }
            .padding([.horizontal, .top])
            
            Spacer()
        }
        .sheet(isPresented: $sheetFeedback) {
            AppDataViewer(url: URL(string: "https://forms.gle/iqi2ZpTfrb4VTp7x8")!)
        }
        .sheet(isPresented: $sheetTermsOfUse) {
            AppDataViewer(url: URL(string: "https://docs.google.com/document/d/171akTBxGW2lWdm83-PCRcukjuJiT0yWENct_9O9WoOE")!)
        }
        .sheet(isPresented: $sheetPrivacyPolicy) {
            AppDataViewer(url: URL(string: "https://docs.google.com/document/d/13m8cdNcsJ5a07l4UH8-Kay7vZz1BqU2eXyctPrBNPIQ")!)
        }
    }
}

#Preview {
    SettingsView()
}

struct AppDataViewer: UIViewRepresentable {
    
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
}

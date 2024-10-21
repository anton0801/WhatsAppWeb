import SwiftUI
import WebKit

struct WhatsAppWeb: View {
    
    @Environment(\.presentationMode) var presMode
    @EnvironmentObject var loggedInUserManager: LoggedInUserManager
    
    var body: some View {
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
                Text("WhatsApp Web")
                    .fontWeight(.bold)
                Spacer()
                Image("CaretRight")
                    .resizable()
                    .frame(width: 26, height: 26)
                    .opacity(0)
            }
            .padding(.horizontal)
            
            WhatsAppWebView(url: URL(string: "https://web.whatsapp.com")!)
        }
    }
}

struct WhatsAppWebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        
        let prefs = WKPreferences()
        prefs.javaScriptCanOpenWindowsAutomatically = true
        prefs.javaScriptEnabled = true
        
        config.preferences = prefs
        
        let view = WKWebView(frame: .zero, configuration: config)
        view.navigationDelegate = context.coordinator
        view.customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 14_0) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.5 Safari/605.1.15"
        return view
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WhatsAppWebView
        
        init(_ parent: WhatsAppWebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {
            preferences.preferredContentMode = .desktop
            decisionHandler(.allow, preferences)
        }
        
        // Можно добавить обработку событий загрузки страниц
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        }
    }
    
}

#Preview {
    WhatsAppWeb()
        .environmentObject(LoggedInUserManager())
}

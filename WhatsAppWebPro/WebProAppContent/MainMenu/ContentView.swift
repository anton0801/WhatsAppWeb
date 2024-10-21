import SwiftUI
import PhotosUI

class LoggedInUserManager: ObservableObject {
    
    @Published var loggedIn = UserDefaults.standard.bool(forKey: "logged_in") {
        didSet {
            UserDefaults.standard.set(loggedIn, forKey: "logged_in")
        }
    }
    
}

struct ContentView: View {
    
    @StateObject var loggedInWhatsApp = LoggedInUserManager()
    @State private var selectedImage: UIImage? = nil
    @State var showImages = false
    
    @Binding var visibleBottomNav: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                VStack(spacing: 0) {
                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .frame(width: 120, height: 120)
                            .scaledToFit()
                            .cornerRadius(100)
                            .padding(.top, 82)
                    } else {
                        Button {
                            showImages.toggle()
                        } label: {
                            Image("base_profile")
                                .resizable()
                                .frame(width: 120, height: 120)
                                .padding(.top, 82)
                        }
                    }
                    
                    Text("Profile")
                        .font(.system(size: 24))
                        .fontWeight(.bold)
                        .padding(.top)
                    
                    NavigationLink(destination: WhatsAppWeb()
                        .environmentObject(loggedInWhatsApp)
                        .navigationBarBackButtonHidden()) {
                            Text(loggedInWhatsApp.loggedIn ? "Go to chats" : "Log in to your account")
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
                        .padding(.top, 24)
                }
                .frame(maxWidth: .infinity)
                .background(
                    Image("top_main_bg")
                        .resizable()
                        .frame(height: 380)
                )
                
                HStack(spacing: 16) {
                    NavigationLink(destination: QuotesView()
                        .navigationBarBackButtonHidden()) {
                            Image("quotes")
                                .resizable()
                                .frame(maxWidth: .infinity, maxHeight: 150)
                        }
//                    NavigationLink(destination: SetPasswordView()
//                        .navigationBarBackButtonHidden()) {
//                            Image("password")
//                                .resizable()
//                                .frame(width: 120, height: 110)
//                        }
                }
                .padding([.horizontal, .top])
                
                HStack(spacing: 12) {
                    NavigationLink(destination: FontsView()
                        .navigationBarBackButtonHidden()) {
                            Image("font")
                                .resizable()
                                .frame(maxWidth: .infinity, maxHeight: 110)
                        }
                    NavigationLink(destination: EmojiView(visibleBottomNav: $visibleBottomNav)
                        .navigationBarBackButtonHidden()) {
                            Image("emoji")
                                .resizable()
                                .frame(maxWidth: .infinity, maxHeight: 110)
                        }
                    NavigationLink(destination: AudioToTextView(visibleBottomNav: $visibleBottomNav)
                        .navigationBarBackButtonHidden()) {
                            Image("audio_to_text")
                                .resizable()
                                .frame(maxWidth: .infinity, maxHeight: 110)
                        }
                }
                .padding([.horizontal, .top])
                
                Spacer()
            }
            .edgesIgnoringSafeArea(.top)
            .onAppear {
                if let savedImage = loadImageFromUserDefaults() {
                    selectedImage = savedImage
                }
            }
            .sheet(isPresented: $showImages) {
                ImagePicker(selectedImage: $selectedImage)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func saveImageToUserDefaults(image: UIImage) {
        if let imageData = image.pngData() {
            UserDefaults.standard.set(imageData, forKey: "savedImage")
        }
    }

    func loadImageFromUserDefaults() -> UIImage? {
        if let imageData = UserDefaults.standard.data(forKey: "savedImage") {
            return UIImage(data: imageData)
        }
        return nil
    }
    
}

#Preview {
    ContentView(visibleBottomNav: .constant(true))
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true, completion: nil)

            guard let provider = results.first?.itemProvider else { return }

            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    DispatchQueue.main.async {
                        if let uiImage = image as? UIImage {
                            self.parent.selectedImage = uiImage
                            // Автоматически сохраняем изображение после выбора
                            self.saveImageToUserDefaults(image: uiImage)
                        }
                    }
                }
            }
        }
        
        // Функция для сохранения изображения в UserDefaults
        func saveImageToUserDefaults(image: UIImage) {
            if let imageData = image.pngData() {
                UserDefaults.standard.set(imageData, forKey: "savedImage")
            }
        }
    }

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
}

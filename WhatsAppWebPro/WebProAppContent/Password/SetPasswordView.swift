import SwiftUI

struct SetPasswordView: View {
    
    @Environment(\.presentationMode) var presMode
    
    @State var otpCode = ""
    @State var successSetPasswordAlert = false
    
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
                
                Text("Password")
                
                Spacer()
                
                Image("back")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .opacity(0)
            }
            .padding(.horizontal)
            
            Spacer()
            
            Text("Enter a new password")
                .fontWeight(.bold)
            
            OTPBoxView { otpCode in
                self.otpCode = otpCode
                saveOtpCode()
            }
            
            Spacer()
        }
        .alert(isPresented: $successSetPasswordAlert) {
            Alert(title: Text("Password set successfuly"))
        }
    }
    
    private func saveOtpCode() {
        UserDefaults.standard.set(otpCode, forKey: "otp_code")
        presMode.wrappedValue.dismiss()
    }
    
}

#Preview {
    SetPasswordView()
}

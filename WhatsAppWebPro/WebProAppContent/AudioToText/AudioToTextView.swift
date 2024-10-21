import SwiftUI
import AVFoundation
import Speech

struct AudioToTextView: View {
    
    @Environment(\.presentationMode) var presMode
    @State var textInput = "Press the button to turn on the microphone"
    @State private var showCopyMessage: Bool = false
    @State private var audioRecord: Bool = false
    @State private var audioRecording: Bool = false
    
    @State var processOfAudio: ProcessOfAudio = .empty
    
    @State var showAlert = false
    @State var alertMessage = ""
    
    @StateObject private var audioRecorder = AudioRecorder()
    @StateObject private var speechToTextConverter = SpeechToTextConverter()
    
    @Binding var visibleBottomNav: Bool
    
    var body: some View {
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
                
                Text("Audio to text")
                
                Spacer()
                
                Image("back")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .opacity(0)
            }
            .padding(.horizontal)
            
            ZStack {
                VStack(alignment: .leading) {
                    HStack {
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
                    
                    Text(textInput)
                        .foregroundColor(Color.init(red: 10/255, green: 10/255, blue: 10/255))
                        .font(.system(size: 14))
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal)
                        .keyboardType(.default)
                        .opacity(audioRecord ? 1 : 0.6)
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
                
                if processOfAudio == .processing {
                    ProgressView()
                }
            }
            
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
            
            Spacer()
            
            HStack {
                Button {
                    if audioRecording {
                        stopRecording()
                    } else {
                        recordAudio()
                    }
                } label: {
                    ZStack {
                        Rectangle()
                            .fill(Color.red)
                            .frame(width: 42, height: 42)
                            .cornerRadius(audioRecording ? 0 : 100)
                            .scaleEffect(audioRecording ? 0.5 : 1)
                            .animation(.easeInOut(duration: 0.4), value: audioRecording)
                        
                        RoundedRectangle(cornerRadius: 100, style: .continuous)
                            .stroke(Color.init(red: 118/255, green: 119/255, blue: 121/255), lineWidth: 2)
                            .frame(width: 46, height: 46)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 42, style: .continuous)
                    .fill(.white)
            )
            .shadow(color: .black.opacity(0.1), radius: 15)
        }
        .edgesIgnoringSafeArea(.bottom)
        .background(
            Image("top_main_bg")
                .resizable()
                .frame(minWidth: UIScreen.main.bounds.width, minHeight: UIScreen.main.bounds.height)
                .ignoresSafeArea()
        )
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Alert!"), message: Text(alertMessage))
        }
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
    
    @State private var microGranted = UserDefaults.standard.bool(forKey: "micro_granted")
    @State private var recognitionGranted = UserDefaults.standard.bool(forKey: "recognitionGranted")
    
    func copyTextWithFont() {
        let pasteboard = UIPasteboard.general
        pasteboard.string = textInput
        withAnimation {
            showCopyMessage = true
        }
    }
    
    private func recordAudio() {
        if !microGranted || !recognitionGranted {
            requestPermissions()
            return
        }
        
        audioRecording = true
        audioRecorder.startRecording()
    }
    
    private func stopRecording() {
        audioRecording = false
        audioRecorder.stopRecording()
        processAudio()
    }
    
    func requestPermissions() {
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            if granted {
                self.microGranted = true
                UserDefaults.standard.set(true, forKey: "micro_granted")
                if recognitionGranted {
                    recordAudio()
                }
            } else {
                alertMessage = "To use this feature you must allow our app access to record audio and convert audio to text!"
                showAlert = true
            }
        }
        
        SFSpeechRecognizer.requestAuthorization { authStatus in
            switch authStatus {
            case .authorized:
                self.recognitionGranted = true
                UserDefaults.standard.set(true, forKey: "recognitionGranted")
                if microGranted {
                    recordAudio()
                }
            case .denied:
                alertMessage = "To use this feature you must allow our app access to record audio and convert audio to text!"
                showAlert = true
            case .restricted:
                alertMessage = "Speech recognition restricted"
                showAlert = true
            case .notDetermined:
                alertMessage = "Speech recognition not determined"
                showAlert = true
            @unknown default:
                break
            }
        }
    }
    
    func processAudio() {
        let audioURL = audioRecorder.getAudioFileURL()
        processOfAudio = .processing
        speechToTextConverter.convertAudioToText(audioURL: audioURL) { text in
            if let text = text {
                textInput = text
            } else {
                textInput = "Failed to recognize speech."
            }
            processOfAudio = .ready
            audioRecord = true
        }
    }
    
}

enum ProcessOfAudio {
    case empty, processing, ready
}

#Preview {
    AudioToTextView(visibleBottomNav: .constant(false))
}

class AudioRecorder: ObservableObject {
    var audioRecorder: AVAudioRecorder?
    
    func startRecording() {
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true)
            
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 12000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            let url = getAudioFileURL()
            audioRecorder = try AVAudioRecorder(url: url, settings: settings)
            audioRecorder?.record()
        } catch {
            print("Failed to start recording: \(error.localizedDescription)")
        }
    }
    
    func stopRecording() {
        audioRecorder?.stop()
    }
    
    func getAudioFileURL() -> URL {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = urls[0]
        let audioFileName = documentDirectory.appendingPathComponent("recordedAudio.m4a")
        return audioFileName
    }
}

class SpeechToTextConverter: ObservableObject {
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private var recognitionRequest: SFSpeechURLRecognitionRequest?
    
    func convertAudioToText(audioURL: URL, completion: @escaping (String?) -> Void) {
        recognitionRequest = SFSpeechURLRecognitionRequest(url: audioURL)
        
        speechRecognizer?.recognitionTask(with: recognitionRequest!) { result, error in
            if let error = error {
                print("Error recognizing speech: \(error.localizedDescription)")
                completion(nil)
            } else if let result = result {
                if result.isFinal {
                    completion(result.bestTranscription.formattedString)
                }
            }
        }
    }
}

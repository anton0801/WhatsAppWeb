import SwiftUI

struct QuotesView: View {
    
    @Environment(\.presentationMode) var presMode
    
    var body: some View {
        VStack {
            let randomQuote = quotes.randomElement() ?? quotes[0]
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
                    
                    Text("Quotes")
                    
                    Spacer()
                    
                    Image("back")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .opacity(0)
                }
                .padding(.horizontal)
                
                VStack {
                    Text(randomQuote.text)
                        .font(.system(size: 20))
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding(.top, 34)
                    
                    Rectangle()
                        .fill(Color.init(red: 1, green: 185/255, blue: 96/255))
                        .frame(width: 60, height: 2)
                    
                    Text(randomQuote.author)
                        .font(.system(size: 18))
                        .foregroundColor(.black)
                        .fontWeight(.regular)
                }
                .frame(maxWidth: 300)
                .background(
                    Image("quote_background")
                        .resizable()
                        .frame(width: 350, height: 200)
                )
                .padding(.horizontal)
                .padding(.top, 52)
            }
            .frame(maxWidth: .infinity)
            .background(
                Image("top_main_bg")
                    .resizable()
                    .frame(height: 380)
            )
            
            ScrollView {
                VStack(alignment: .leading) {
                    
                    Text("Quotes from the great ones")
                        .font(.system(size: 24))
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                        .padding(.leading)
                    
                    let lestQuotes = quotes.filter { $0.text != randomQuote.text }
                    ForEach(lestQuotes, id: \.text) { quote in
                        VStack(alignment: .leading) {
                            Text(quote.text)
                                .font(.system(size: 20))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.leading)
                            
                            Text(quote.author)
                                .font(.system(size: 14))
                                .multilineTextAlignment(.leading)
                                .foregroundColor(Color.init(red: 118/255, green: 119/255, blue: 121/255))
                            
                            HStack {
                                Spacer()
                            }
                        }
                        .frame(height: 100)
                        .padding(.horizontal)
                        .background(
                            RoundedRectangle(cornerRadius: 16.0, style: .continuous)
                                .fill(Color.init(red: 230/255, green: 1, blue: 218/255))
                                .frame(height: 100)
                        )
                        .padding(.top, 12)
                        .padding(.horizontal)
                    }
                }
            }
            .padding(.top, 102)
        }
    }
}

#Preview {
    QuotesView()
}

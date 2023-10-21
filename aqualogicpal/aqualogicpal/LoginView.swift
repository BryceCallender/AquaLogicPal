import SwiftUI
import Liquid

struct LoginView: View {
    enum Field: Hashable {
        case username, password
    }
    
    @State var email = ""
    @State var password = ""
    @State var error: Error?
    
    @FocusState private var focusedField: Field?
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack {
                Text("AquaLogicPal")
                    .font(.system(size: 42).weight(.bold))
                    .foregroundColor(.white)
                    .shadow(radius: 10.0)
                    .padding()
                
                Image("LaunchImage")
                    .resizable()
                    .frame(width: 250, height: 250)
                    .clipShape(Circle())
                    .shadow(radius: 10)
                    .padding(.bottom)
                
                VStack(alignment: .leading, spacing: 16) {
                    TextField("Email", text: $email)
                        .padding()
                        .background(.cardBackground)
                        .cornerRadius(10.0)
                        .shadow(radius: 10.0)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .focused($focusedField, equals: .username)
                    
                    SecureField("Password", text: $password)
                        .padding()
                        .background(.cardBackground)
                        .cornerRadius(10.0)
                        .shadow(radius: 10.0)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .focused($focusedField, equals: .password)
                    
                }
                .padding([.horizontal, .bottom], 24)
                .onSubmit {
                    if focusedField == .username {
                        focusedField = .password
                    } else {
                        focusedField = nil
                    }
                }
                
                AsyncButton {
                    await login()
                } label: {
                    Text("Sign In")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .cornerRadius(10.0)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .padding([.horizontal], 24)
                
                if let error {
                    Text(error.localizedDescription)
                        .foregroundColor(.red)
                        .font(.footnote)
                }
            }
        }
    }
    
    func login() async {
        do {
            try await supabase.auth.signIn(email: email, password: password)
            let session = try await supabase.auth.session
            print("### Session Info: \(session)")
        } catch {
            withAnimation {
                self.error = error
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
        
        LoginView()
            .preferredColorScheme(.dark)
    }
}

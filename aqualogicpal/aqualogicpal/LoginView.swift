import SwiftUI
import Firebase
import Liquid

struct LoginView: View {
    @State var email = ""
    @State var password = ""

    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack {
                Text("AquaLogic Pal")
                    .font(.largeTitle)
                    .bold()
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
                        .background(.white)
                        .cornerRadius(10.0)
                        .shadow(radius: 10.0)
                        .keyboardType(.emailAddress)
                    
                  SecureField("Password", text: $password)
                        .padding()
                        .background(.white)
                        .cornerRadius(10.0)
                        .shadow(radius: 10.0)
                    
                }.padding([.leading, .trailing, .bottom], 24)
                
                Button(action: login) {
                    Text("Sign In")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .cornerRadius(10.0)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .padding([.leading, .trailing], 24)
            }
        }
    }

    func login() {
        // todo: swap to supabase auth in order to conform to RLS
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            } else {
                print("success")
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

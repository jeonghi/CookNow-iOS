//
//  AuthService.swift
//  Onboading
//
//  Created by 쩡화니 on 7/21/24.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import AuthenticationServices
import GoogleSignIn
import Dependencies

protocol AuthServiceType {
  func googleSignIn()
  func googleSignOut()
  func appleSignIn()
  func appleSignOut()
}

struct AuthServiceDependencyKey: DependencyKey {
  static let liveValue: AuthServiceType = AuthServiceImpl.shared
}

extension DependencyValues {
  var authService: AuthServiceType {
    get { self[AuthServiceDependencyKey.self] }
    set { self[AuthServiceDependencyKey.self] = newValue }
  }
}

final class AuthServiceImpl: AuthServiceType {
  
  static let shared: AuthServiceType = AuthServiceImpl()
  
  private init() {}
  
  func googleSignIn() {
    
    // As you’re not using view controllers to retrieve the presentingViewController, access it through
    // the shared instance of the UIApplication
    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
    guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
    
    guard let clientID = FirebaseApp.app()?.options.clientID else { return }
    
    // Create Google Sign In configuration object.
    let config = GIDConfiguration(clientID: clientID) // GoogleSignIn
    
    GIDSignIn.sharedInstance.configuration = config
    // Start the sign in flow!
    GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [unowned self] result, error in
      
      if let error {
        print("Error doing Google Sign-In, \(error)")
        return
      }
      
      guard
        let user = result?.user,
        let idToken = user.idToken?.tokenString
      else {
        print("Error during Google Sign-In authentication, \(error)")
        return
      }
      
      let credential = GoogleAuthProvider.credential(
        withIDToken: idToken,
        accessToken: user.accessToken.tokenString
      )
      
      
      // Authenticate with Firebase
      Auth.auth().signIn(with: credential) { authResult, error in
        if let error {
          print(error.localizedDescription)
          return
        }
        
        print("Signed in with Google \(authResult)")
      }
    }
  }
  
  func googleSignOut() {
    let firebaseAuth = Auth.auth()
    do {
      try firebaseAuth.signOut()
      GIDSignIn.sharedInstance.signOut()
    } catch let signOutError as NSError {
      print("Error signing out: %@", signOutError)
    }
  }
  
  func appleSignIn() {
    
  }
  
  func appleSignOut() {
    
  }
}

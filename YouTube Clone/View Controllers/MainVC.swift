//
//  MainVC.swift
//  YouTube Clone
//
//  Created by Michał Nowak on 27/09/2020.
//

import GoogleAPIClientForREST
import GoogleSignIn
import UIKit

class MainVC: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {
    private let scopes = [kGTLRAuthScopeYouTubeReadonly]
    private let service = GTLRYouTubeService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewSetup()
    }
    
    private func viewSetup() {
        self.signInButton.isHidden = true
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().scopes = scopes
        GIDSignIn.sharedInstance()?.signInSilently()
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            showAlert(title: "Authentication Error", message: error.localizedDescription)
            self.service.authorizer = nil
            self.signInButton.isHidden = false
        } else {
            if let profile = user.profile {
                googleUser.email = profile.email ?? ""
                googleUser.name = profile.name ?? ""
                googleUser.imageURL = profile.imageURL(withDimension: .max)?.absoluteString ?? ""
                googleUser.accessToken = user.authentication.accessToken ?? ""
            }
            self.service.authorizer = user.authentication.fetcherAuthorizer()
            self.presentTabBarController()
        }
    }
    
    private func presentTabBarController() {
        performSegue(withIdentifier: "presentTabBarController", sender: self)
    }
    
    func showAlert(title : String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertController.Style.alert
        )
        let ok = UIAlertAction(
            title: "OK",
            style: UIAlertAction.Style.default,
            handler: nil
        )
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var signInButton: UIButton!
    
    @IBAction func sigInButtonPressed(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.signIn()
    }
}

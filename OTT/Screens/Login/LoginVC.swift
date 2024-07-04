//
//  LoginVC.swift
//  OTT
//
//  Created by Akash Sen on 29/06/24.
//

import UIKit
import GoogleSignIn

var GLOBAL_USER: User?

class LoginVC: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var googleSignInBtn: GIDSignInButton!
    
    // MARK: Properties
    private let userDataManager = UserDataManager()
    
    
    // MARK: VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Utility.lockOrientation(.portrait)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        Utility.lockOrientation(.all)
    }
    
}


extension LoginVC {
    
    @objc private func signInWithGoogleTapped() {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [weak self] signInResult, error in
            guard let signInResult = signInResult else {
                return
            }
            if let userEmail = signInResult.user.userID {
                if let user = self?.userDataManager.getUserByEmail(email: userEmail) {
                    GLOBAL_USER = user
                } else {
                    let user = User(pKey: UUID(), email: userEmail)
                    self?.userDataManager.createUser(record: user)
                    GLOBAL_USER = user
                }
                self?.showHomeVC()
            } else {
                debugPrint("Warning: Couldn't fetch user email from Google Sign In")
            }
        }
    }
    
}


extension LoginVC {
    
    private func setupView() {
        googleSignInBtn.style = .wide
        googleSignInBtn.addTarget(self, action: #selector(signInWithGoogleTapped), for: .touchUpInside)
    }
    
}


extension LoginVC {
    
    private func showHomeVC() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            self.navigationController?.setViewControllers([vc], animated: false)
        }
    }
    
}

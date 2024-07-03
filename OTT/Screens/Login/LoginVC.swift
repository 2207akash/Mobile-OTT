//
//  LoginVC.swift
//  OTT
//
//  Created by Akash Sen on 29/06/24.
//

import UIKit
import GoogleSignIn

class LoginVC: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var googleSignInBtn: GIDSignInButton!
    
    
    // MARK: VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.showHomeVC()
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
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            guard let _ = signInResult else {
                return
            }
            self.showHomeVC()
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

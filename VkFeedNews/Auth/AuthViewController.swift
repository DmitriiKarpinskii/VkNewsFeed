//
//  ViewController.swift
//  VkFeedNews
//
//  Created by Dmitry Karpinsky on 05.06.2021.
//

import UIKit

class AuthViewController: UIViewController {
    
    private var authService: AuthService!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        authService = SceneDelegate.shared().authService
        view.backgroundColor = .red
    }
    
    @IBAction func signInTouch(_ sender: Any) {
        print("sign in")
        authService.wakeUpSession()
    }
}


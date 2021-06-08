//
//  AuthService.swift
//  VkFeedNews
//
//  Created by Dmitry Karpinsky on 05.06.2021.
//

import Foundation
import VKSdkFramework

protocol AuthServiceDelegate: class {
    func authServiceShouldShow(viewController: UIViewController)
    func authServicesSignIn()
    func authServicesSignInDidFail()
}

class AuthService : NSObject, VKSdkDelegate , VKSdkUIDelegate {
 
    private let appId = "7870837"
    private let vkSdk : VKSdk
    weak var delegate : AuthServiceDelegate?

    var token : String? {
        return VKSdk.accessToken().accessToken
    }
    
    override init() {
        vkSdk = VKSdk.initialize(withAppId: appId)
        super.init()
        print("VKSdk.initialize")
        vkSdk.register(self)
        vkSdk.uiDelegate = self
       
    }
    
    
    func wakeUpSession() {
        let scope = ["wall, friends"]
        VKSdk.wakeUpSession(scope) { [delegate] (state , error) in
            switch state {
           
            case .initialized:
                print("initialized")
                VKSdk.authorize(scope)
            case .authorized:
                print("authorized")
                delegate?.authServicesSignIn()
            default:
                delegate?.authServicesSignInDidFail()
            }
        }
    }
    
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        print(#function)
        
        if result.token != nil {
        // Пользователь успешно авторизован
            delegate?.authServicesSignIn()
        }
    }
    
    func vkSdkUserAuthorizationFailed() {
        print(#function)
        delegate?.authServicesSignInDidFail()
    }
    
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        print(#function)
        delegate?.authServiceShouldShow(viewController: controller)
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        print(#function)
    }
    
}

// https://api.vk.com/method/newsfeed.get?&filters=post,photo&access_token=6f956ac5923892b7c1d71ff566302914fab4e9a0ac74ada58d00cf6a3fd978d9e4625f019d9aa9720f183&v=5.131


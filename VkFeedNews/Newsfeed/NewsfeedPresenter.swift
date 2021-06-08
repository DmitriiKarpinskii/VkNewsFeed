//
//  NewsfeedPresenter.swift
//  VkFeedNews
//
//  Created by Dmitry Karpinsky on 08.06.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol NewsfeedPresentationLogic {
  func presentData(response: Newsfeed.Model.Response.ResponseType)
}

class NewsfeedPresenter: NewsfeedPresentationLogic {
  weak var viewController: NewsfeedDisplayLogic?
  
  func presentData(response: Newsfeed.Model.Response.ResponseType) {
  
    switch response {
        
    case .some:
        print(".some presenter")
    case .presentNewsfeed:
        print(".presentNewsfeed presenter")
        viewController?.displayData(viewModel: .displayNewsfeed)
    }
    
    
  }
  
}

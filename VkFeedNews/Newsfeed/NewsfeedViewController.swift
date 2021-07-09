//
//  NewsfeedViewController.swift
//  VkFeedNews
//
//  Created by Dmitry Karpinsky on 08.06.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol NewsfeedDisplayLogic: class {
    func displayData(viewModel: Newsfeed.Model.ViewModel.ViewModelData)
}

class NewsfeedViewController: UIViewController, NewsfeedDisplayLogic, NewsFeedCodeCellDelegate {
    
    
    
    var interactor: NewsfeedBusinessLogic?
    var router: (NSObjectProtocol & NewsfeedRoutingLogic)?
    private var feedViewModel = FeedViewModel(cells: [], footerTitle: nil)
    
    @IBOutlet weak var table: UITableView!
    private var titleView = TitleView()
    private lazy var footerView = FooterView()
    private var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    
    }()
    
    // MARK: Setup
    
    private func setup() {
        let viewController        = self
        let interactor            = NewsfeedInteractor()
        let presenter             = NewsfeedPresenter()
        let router                = NewsfeedRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        presenter.viewController  = viewController
        router.viewController     = viewController
    }
    
    // MARK: Routing
    
    
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //    table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        setup()
        setupTopBars()
        setupTable()
    
//        view.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        
        interactor?.makeRequest(request: .getNewsfeed)
        interactor?.makeRequest(request: .getUser)
    
    }
    
    private func setupTable() {
        
        let topInset: CGFloat = 8
        table.contentInset.top = topInset
        
        table.separatorStyle = .none
        table.backgroundColor = .clear
        table.register(UINib(nibName: "NewsfeedCell", bundle: nil), forCellReuseIdentifier: NewsfeedCell.reuseId)
        table.register(NewsfeedCodeCell.self, forCellReuseIdentifier: NewsfeedCodeCell.reuseId)
        table.addSubview(refreshControl)
        table.tableFooterView = footerView
    }
    
    private func setupTopBars() {
        
        let topBar = UIView(frame: UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
        self.view.addSubview(topBar)
        topBar.backgroundColor = .white
        topBar.layer.shadowColor = UIColor.black.cgColor
        topBar.layer.shadowOpacity = 0.3
        topBar.layer.shadowOffset = CGSize.zero
        topBar.layer.shadowRadius = 8
        
        
        self.navigationController?.hidesBarsOnSwipe = true
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationItem.titleView = titleView
        
    }
    
    @objc private func refresh() {
        interactor?.makeRequest(request: .getNewsfeed)
        
    }
    
    func displayData(viewModel: Newsfeed.Model.ViewModel.ViewModelData) {
        
        switch viewModel {
        
        case .displayNewsfeed(let feedViewModel):
            self.feedViewModel = feedViewModel
            table.reloadData()
            refreshControl.endRefreshing()
            footerView.setTitle(feedViewModel.footerTitle)
        case .displayUser(userViewModel: let userViewModel):
            titleView.set(userViewModel: userViewModel)
        case .displayFooterLoader:
            footerView.showLoader()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y > scrollView.contentSize.height / 1.1 {
            interactor?.makeRequest(request: Newsfeed.Model.Request.RequestType.getNextBatch)
        }
    }
    
    
    //MARK: newsFeedCodeCellDelegate
    func revealPost(for cell: NewsfeedCodeCell) {
        guard let indexPath = table.indexPath(for: cell) else { return }
        let cellViewModel = feedViewModel.cells[indexPath.row]
        
        interactor?.makeRequest(request: .revealPostIds(postId: cellViewModel.postId))
        print("delegate inside vc")
    }
    
}

extension NewsfeedViewController : UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedViewModel.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: NewsfeedCell.reuseId, for: indexPath) as! NewsfeedCell
        
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsfeedCodeCell.reuseId, for: indexPath) as! NewsfeedCodeCell
        let cellViewModel = feedViewModel.cells[indexPath.row]
        cell.set(viewModel: cellViewModel)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellViewModel = self.feedViewModel.cells[indexPath.row]
        return cellViewModel.sizes.totalHeight
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellViewModel = self.feedViewModel.cells[indexPath.row]
        return cellViewModel.sizes.totalHeight
    }
}

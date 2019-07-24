//
//  ExHeadlinesVCswift
//  Experiment
//
//  Created by Himanshu Tuteja on 22/07/19.
//  Copyright © 2019 Himanshu Tuteja. All rights reserved.
//

import UIKit

final class ExHeadlinesVC: ExBaseVC {

    @IBOutlet private weak var tableView: UITableView!
    var viewModel: ExHeadlineVM = ExHeadlineVM()
    let refreshControl: UIRefreshControl = UIRefreshControl()
    
    @objc private func populateHeadlines(){
        viewModel.requestHeadlines { [weak self](success, error) in
            self?.refreshControl.endRefreshing()
            if success{
                self?.tableView.reloadData()
            }else{
                self?.tableView.reloadData()
                ExSnackBar.showSnackBar(for: (error?.localizedDescription ?? kSomethingWentWrong) + kTryAgain, for: kOops, visibility: .high)
            }
        }
    }
    
    private func configureRefreshControl(){
        refreshControl.tintColor = UIColor.white
        refreshControl.addTarget(self, action: #selector(populateHeadlines), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureRefreshControl()
        populateHeadlines()
    }
}

extension ExHeadlinesVC: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getHeadLineRows()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.status == .none{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ExHeadShimmerTableCell.identifier, for: indexPath) as? ExHeadShimmerTableCell else {return UITableViewCell()}
            return cell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ExHeadlinesTableCell.identifier, for: indexPath) as? ExHeadlinesTableCell else {return UITableViewCell()}
        cell.cellViewModel = viewModel.getCellVM(for: indexPath)
        return cell
    }
}
extension ExHeadlinesVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (tableView.bounds.width - 16) * 0.54
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let mod = viewModel.getCellModel(for: indexPath), let detailVC = ExHeadDetailVC.instance(model: mod), viewModel.status != .none else {return}
        navigationController?.pushViewController(detailVC, animated: true)
    }
}


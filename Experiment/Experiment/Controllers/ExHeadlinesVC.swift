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
    
    private func populateHeadlines(){
        viewModel.requestHeadlines { [weak self](success, error) in
            if success{
                self?.tableView.reloadData()
            }else{
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ExHeadlinesTableCell.identifier, for: indexPath) as? ExHeadlinesTableCell else {return UITableViewCell()}
        cell.cellViewModel = viewModel.getCellVM(for: indexPath)
        return cell
    }
}
extension ExHeadlinesVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.width * 0.54
    }
}


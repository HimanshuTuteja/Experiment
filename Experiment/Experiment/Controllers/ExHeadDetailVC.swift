//
//  ExHeadDetailVC.swift
//  Experiment
//
//  Created by Himanshu Tuteja on 24/07/19.
//  Copyright © 2019 Himanshu Tuteja. All rights reserved.
//

import UIKit

final class ExHeadDetailVC: ExBaseVC {

    @IBOutlet private weak var imgView: UIImageView!
    @IBOutlet private weak var lblDesc: UILabel!
    @IBOutlet private weak var lblTitle: UILabel!
    @IBOutlet private weak var lblSource: UILabel!
    @IBOutlet private weak var lblDate: UILabel!
    @IBOutlet private weak var btnBack: UIButton!
    var viewModel: ExHeadDetailVM!
    
    @IBAction func btnBackPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    class func instance(model: HeadArticlesModel)-> ExHeadDetailVC?{
        let vc =  UIStoryboard(name: kStoryboard, bundle: nil).instantiateViewController(withIdentifier: String(describing: ExHeadDetailVC.self)) as? ExHeadDetailVC
        vc?.viewModel = ExHeadDetailVM(model: model)
        return vc
    }
    
    private func configureUI(){
        viewModel.fetchImage(imgView: imgView)
        let visualData = viewModel.getVisualData()
        lblTitle.text = visualData.0
        lblSource.text = visualData.1
        lblDesc.text = visualData.2
        lblDate.text = visualData.3
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        btnBack.layer.cornerRadius = btnBack.bounds.width/2
        btnBack.clipsToBounds = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//
//  ExHeadlinesTableCell.swift
//  Experiment
//
//  Created by Himanshu Tuteja on 22/07/19.
//  Copyright © 2019 Himanshu Tuteja. All rights reserved.
//

import UIKit

final class ExHeadlinesTableCell: UITableViewCell {
    
    static let identifier = String(describing: ExHeadlinesTableCell.self)
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblSource: UILabel!
    
    var cellViewModel: ExHeadlineCellVM!{
        didSet{
            guard let cvm = cellViewModel, let visualData = cvm.getVisualData() else {return}
            lblTitle.text = visualData.0
            lblSource.text = visualData.1
            lblDate.text = visualData.2
            cvm.fetchImage(imgView: imgView)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imgView.image = nil
        lblTitle.text = nil
        lblDate.text = nil
        lblSource.text = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

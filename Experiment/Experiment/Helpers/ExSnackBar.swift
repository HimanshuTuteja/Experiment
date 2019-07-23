//
//  ExSnackBar.swift
//  Experiment
//
//  Created by Himanshu Tuteja on 23/07/19.
//  Copyright © 2019 Himanshu Tuteja. All rights reserved.
//

import UIKit

enum ExSnackBarPresentingMode: Int{
    case priority = 0
    case overlap
}

enum ExSnackBarState: Int{
    case presenting = 0
    case free
}

enum ExSnackBarVisibility: Double {
    case low = 2.0
    case medium = 4.0
    case high = 6.0
}

final class ExSnackBar: UIView {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    private var presentingState: ExSnackBarState = .free
    internal static var shared: ExSnackBar!
    private static let serialQueue = DispatchQueue(label: "snackbar.serialQueue")
    @objc static func sharedInstance() -> ExSnackBar {
        serialQueue.sync { () -> Void in
            if shared == nil {
                shared = ExSnackBar.instanceFromNib()
            }
        }
        return shared
    }
    
    private var bottomSafeArea: CGFloat {
        if #available(iOS 11.0, *) {
            return getKeyWindow()?.safeAreaInsets.bottom ?? 0
        } else {
            return 0
        }
    }
    
    private class func getSnackInstance(for mode: ExSnackBarPresentingMode)-> ExSnackBar{
        return mode == .priority ? ExSnackBar.sharedInstance() : ExSnackBar.instanceFromNib()
    }
    
    public class func showSnackBar(for msg: String, for title: String? = nil, includes backgroundColor: UIColor = .white, includes textColor: UIColor = .black, with presentingMode:ExSnackBarPresentingMode = .priority, visibility: ExSnackBarVisibility){
        let snack: ExSnackBar = ExSnackBar.getSnackInstance(for: presentingMode)
        if snack.presentingState == .presenting || msg.count == 0 {return}
        snack.backgroundColor = backgroundColor
        snack.lblTitle.textColor = textColor
        snack.lblContent.textColor = textColor
        snack.lblTitle.text = title
        snack.lblContent.text = msg
        snack.topConstraint.constant = (snack.bottomSafeArea > 0) ? snack.bottomSafeArea + 10 : 30
        let height = msg.height(withConstrainedWidth: UIScreen.main.bounds.width - 40, font: snack.lblContent.font) + 45
        var titleHeight: CGFloat = 0
        if let titleExist = title{
            titleHeight = titleExist.height(withConstrainedWidth: UIScreen.main.bounds.width - 40, font: snack.lblTitle.font)
        }
        snack.sizeFit(height: height + titleHeight)
        snack.addWithAutoDismiss(visibility: visibility)
    }
    
    private func addWithAutoDismiss(visibility: ExSnackBarVisibility){
        presentingState = .presenting
        addTap()
        add()
        perform(#selector(dismissTapped), with: nil, afterDelay: visibility.rawValue)
    }
    
    private func sizeFit(height: CGFloat) {
        let calHeight = height + ((bottomSafeArea > 0) ? bottomSafeArea/2 : 0)
        frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: calHeight)
        layoutIfNeeded()
    }
    
    private func add(){
        let tempFrame  = self.frame
        self.frame = CGRect(x: tempFrame.minX, y: tempFrame.minY - tempFrame.height, width: tempFrame.width, height: tempFrame.height)
        self.getKeyWindow()?.addSubview(self)
        self.layoutIfNeeded()
        UIView.animate(withDuration: 0.5, delay: 0, options: [.beginFromCurrentState, .curveEaseIn], animations: { [weak self] in
            guard let strongSelf = self else {return}
            strongSelf.frame = CGRect(x: tempFrame.minX, y: tempFrame.minY, width: tempFrame.width, height: tempFrame.height)
            strongSelf.layoutIfNeeded()
            }, completion: { completed in
                print("Completed")
        })
    }
    
    private class func instanceFromNib() -> ExSnackBar {
        let snack = ExSnackBar.nib.instantiate(withOwner: nil, options: nil)[0] as! ExSnackBar
        snack.frame = .zero
        return snack
    }
    
    private static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    private static var identifier: String {
        return String(describing: self)
    }
    
    private func addTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        self.addGestureRecognizer(tap)
    }
    
    @objc private func handleTap(sender: UITapGestureRecognizer? = nil) {
        dismissTapped()
    }
    
    @objc private func dismissTapped() {
        UIView.animate(withDuration: 0.5, delay: 0, options: [.beginFromCurrentState, .curveEaseIn], animations: { [weak self] in
            guard let strongSelf = self else {return}
            strongSelf.frame = CGRect(x: strongSelf.frame.minX, y: strongSelf.frame.minY - strongSelf.frame.height, width: strongSelf.frame.width, height: strongSelf.frame.height)
            strongSelf.layoutIfNeeded()
            }, completion: { [weak self] completed in
                guard let strongSelf = self else {return}
                strongSelf.removeFromSuperview()
                strongSelf.presentingState = .free
        })
    }
    
    private func getKeyWindow() -> UIWindow? {
        var window: UIWindow?
        let appDelegate: UIApplicationDelegate? = UIApplication.shared.delegate
        // Otherwise fall back on the first window of the app's collection, if present.
        window = appDelegate?.window ?? nil
        return window ?? UIApplication.shared.windows.first
    }
}

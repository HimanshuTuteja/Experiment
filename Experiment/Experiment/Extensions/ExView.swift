//
//  ExView.swift
//  Experiment
//
//  Created by Himanshu Tuteja on 23/07/19.
//  Copyright © 2019 Himanshu Tuteja. All rights reserved.
//

import UIKit

extension UIView{
    func hideView(){
        UIView.transition(with: self, duration: 0.1, options: .transitionCrossDissolve, animations: {[weak self] in
            self?.stopAnimation()
        })
    }
    
    func showView(){
        startAnimation()
    }
    
    //MARK:- Shimmer animations
    private func startAnimation() {
        self.clipsToBounds = true
        let gradientLayer = CAGradientLayer()
        gradientLayer.backgroundColor = UIColor.clear.cgColor
        let light = UIColor.white.withAlphaComponent(0.1).cgColor
        let alpha = UIColor.white.withAlphaComponent(0.6).cgColor
        gradientLayer.name = "ShimmerLayer"
        gradientLayer.colors = [light,light,light,light,light,light,alpha,alpha,alpha,light,light,light,light,light,light]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.2, y: 0.6)
        gradientLayer.frame = CGRect(x: 0, y: 0, width:self.frame.size.width , height: self.bounds.size.height)
        self.layer.mask = nil
        self.layer.addSublayer(gradientLayer)
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.duration = 0.75
        animation.fromValue = -self.frame.size.width
        animation.toValue = self.frame.size.width
        animation.repeatCount = .infinity
        animation.isRemovedOnCompletion = false
        gradientLayer.add(animation, forKey: "")
    }
    
    private func stopAnimation() {
        if let layer = self.layer.sublayers {
            for layerObj in layer {
                if layerObj.name == "ShimmerLayer" {
                    layerObj.removeFromSuperlayer()
                    self.layer.mask = nil
                    break
                }
            }
        }
    }
}

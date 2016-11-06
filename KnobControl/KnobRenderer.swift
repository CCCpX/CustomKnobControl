//
//  KnobRenderer.swift
//  KnobControl
//
//  Created by chen peixiang on 05/11/2016.
//  Copyright © 2016 chen peixiang. All rights reserved.
//

import UIKit
import Foundation

class KnobRenderer {
    
    //Properties associated with all parts of the renderer
    var color = UIColor.clear {
        didSet {
            trackLayer.strokeColor = color.cgColor
            pointerLayer.strokeColor = color.cgColor
        }
    }
    var lineWidth:CGFloat = 0.0 {
        didSet {
            trackLayer.lineWidth = lineWidth
            pointerLayer.lineWidth = lineWidth
            updateTrackShape()
            updatePointerShape()
        }
    }
    
    //Properties associated with all parts of the background track
    var trackLayer: CAShapeLayer = {
        $0.fillColor = UIColor.clear.cgColor
        return $0
    }(CAShapeLayer())
    
    var startAngle:CGFloat = 0.0 {
        didSet {
            updateTrackShape()
        }
    }
    var endAngle:CGFloat = 0.0 {
        didSet {
            updateTrackShape()
        }
    }
    
    //Properties associated with all parts of the pointer element
    var pointerLayer: CAShapeLayer = {
        $0.fillColor = UIColor.clear.cgColor
        return $0
    }(CAShapeLayer())
    
    var pointerAngle:CGFloat = 0.0 {
        didSet {
            setPointAngle(pointerAngle, animated: false)
        }
    }
    
    var pointerLength:CGFloat = 0.0 {
        didSet {
            updateTrackShape()
            updatePointerShape()
        }
    }
    
    fileprivate func updateTrackShape() {
        let center = CGPoint(x: trackLayer.bounds.width/2, y: trackLayer.bounds.height/2)
        let offset = max(pointerLength, lineWidth/2)
        let radius = min(trackLayer.bounds.height, trackLayer.bounds.width)/2 - offset
        
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        trackLayer.path = path.cgPath
    }
    
    //PointerShape is a simple straight line
    fileprivate func updatePointerShape() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: pointerLayer.bounds.width - pointerLength - lineWidth/2, y: pointerLayer.bounds.height/2))
        path.addLine(to: CGPoint(x: pointerLayer.bounds.width, y: pointerLayer.bounds.height/2))
        pointerLayer.path = path.cgPath
    }
    
    public func updateWithBounds(bounds:CGRect) {
        trackLayer.bounds = bounds
        trackLayer.position = CGPoint(x: bounds.width/2, y: bounds.height/2)
        updateTrackShape()
        
        pointerLayer.bounds = trackLayer.bounds
        pointerLayer.position = trackLayer.position
        updatePointerShape()
    }
    
    func setPointAngle(_ pointerAngle: CGFloat, animated: Bool) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        pointerLayer.transform = CATransform3DMakeRotation(pointerAngle, 0, 0, 1)
        if animated {
            let midAngle = (max(pointerAngle, self.pointerAngle) - min(pointerAngle, self.pointerAngle)) /
            2.0 + min(pointerAngle, self.pointerAngle)
            let animation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
            animation.duration = 0.25
            animation.values = [self.pointerAngle,midAngle,pointerAngle]
            animation.keyTimes = [0,0.5,1.0]
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            pointerLayer.add(animation, forKey: nil)
        }
        CATransaction.commit()
    }
    
}

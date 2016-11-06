//
//  KnobRotationGestureRecognizer.swift
//  KnobControl
//
//  Created by chen peixiang on 06/11/2016.
//  Copyright © 2016 chen peixiang. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

class KnobRotationGestureRecognizer: UIPanGestureRecognizer {
    var touchAngle:CGFloat = 0.0
    
    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
        maximumNumberOfTouches = 1
        minimumNumberOfTouches = 1
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        updateTouchAngleWithTouches(touches: touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        updateTouchAngleWithTouches(touches: touches)
    }
    
    func updateTouchAngleWithTouches(touches: Set<UITouch>) {
        guard let touch = touches.first else {
            debugPrint("Ops, no touch found...")
            return
        }
        let touchPoint = touch.location(in: view)
        touchAngle = calculateAngleToPoint(point: touchPoint)
    }
    
    func calculateAngleToPoint(point: CGPoint) -> CGFloat{
        let centerOffset = CGPoint(x: point.x - view!.bounds.midX, y: point.y - view!.bounds.midY)
        return atan2(centerOffset.y, centerOffset.x)
    }
    
}

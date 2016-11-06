//
//  KnobControl.swift
//  KnobControl
//
//  Created by chen peixiang on 04/11/2016.
//  Copyright © 2016 chen peixiang. All rights reserved.
//https://www.raywenderlich.com/56885/custom-control-for-ios-tutorial-a-reusable-knob

import UIKit

///Since KnobControl will function similary to UISlider, the API should match as well
class KnobControl: UIControl {
    
    var startAngle: CGFloat {
        set {
            knobRenderer.startAngle = newValue
        }
        get {
            return knobRenderer.startAngle
        }
    }
    var endAngle: CGFloat {
        set {
            knobRenderer.endAngle = newValue
        }
        get {
            return knobRenderer.endAngle
        }
    }
    var lineWidth: CGFloat {
        set {
            knobRenderer.lineWidth = newValue
        }
        get {
            return knobRenderer.lineWidth
        }
    }
    var pointerLength: CGFloat {
        set {
            knobRenderer.pointerLength = newValue
        }
        get {
            return knobRenderer.pointerLength
        }
    }
    
    var knobRenderer:KnobRenderer! = nil
    var gestureRecognizer: KnobRotationGestureRecognizer! = nil
    
    ///Contains the current value.
    private var _value: CGFloat = 0.0
    var value: CGFloat {
        set {
            setValue(newValue, animated: false)
        }
        get {
            return _value
        }
    }
    
    
    ///The minimum value of the knob, Default to `0`.
    var minimumValue:CGFloat = 0.0
    
    ///The maximum value of the knob, Default to `1`.
    var maximumValue:CGFloat = 1.0
    
    ///Contains a Boolean value indicating whether changes in the value of the knob generate continuous update events. The default value is `true`.
    var continuous:Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        minimumValue = 0.0
        maximumValue = 1.0
        value = 0.0
        continuous = true
        
        gestureRecognizer = KnobRotationGestureRecognizer(target: self, action: #selector(KnobControl.handleGesture(_:)))
        addGestureRecognizer(gestureRecognizer)
        
        createKnobUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - API Methods
    ///Sets the value the knob should represent, with optional animation of the change.
    public func setValue(_ value: CGFloat, animated: Bool) {
        if value != _value {
            willChangeValue(forKey: "value")
            _value = min(maximumValue, max(minimumValue, value))
            
            //update the knob with the correct angle
            let angleRange = endAngle - startAngle
            let valueRange = maximumValue - minimumValue
            let angleForValue = (value - minimumValue) / valueRange * angleRange + startAngle
            knobRenderer.setPointAngle(angleForValue, animated: animated)
            didChangeValue(forKey: "value")
        }
    }
    
    override func tintColorDidChange() {
        knobRenderer.color = tintColor
    }
    
    func createKnobUI() {
        knobRenderer = KnobRenderer()
        knobRenderer.updateWithBounds(bounds: bounds)
        knobRenderer.color = tintColor
        knobRenderer.startAngle = CGFloat(-M_PI * 11 / 8.0)
        knobRenderer.endAngle = CGFloat(M_PI * 3 / 8.0)
        knobRenderer.pointerAngle = knobRenderer.startAngle
        knobRenderer.lineWidth = 2.0
        knobRenderer.pointerLength = 6.0
        layer.addSublayer(knobRenderer.trackLayer)
        layer.addSublayer(knobRenderer.pointerLayer)
    }
    //extracts the angle from the custom gesture recognizer, convert it to the value represented by this angle on the knob control, and then sets the value which triggers the UI updates
    func handleGesture(_ sender: KnobRotationGestureRecognizer) {
        //1. Mid-point angle
        let pi = CGFloat(M_PI)
        let midPointAngle = (2 * pi + startAngle - endAngle) / 2 + endAngle
        //2. Ensure the angle is within a suitable range
        var boundedAngle = sender.touchAngle
        if boundedAngle > midPointAngle {
            boundedAngle -= 2 * pi
        }else if boundedAngle < (midPointAngle - 2 * pi) {
            boundedAngle += 2 * pi
        }
        //3. Bound the angle to within the suitable range
        boundedAngle = min(endAngle, max(startAngle, boundedAngle))
        //4. Convert the angle to a value
        let angleRange = endAngle - startAngle
        let valueRange = maximumValue - minimumValue
        let valueForAngle = (boundedAngle - startAngle) / angleRange * valueRange + minimumValue
        //5. Set the control to this value
        value = valueForAngle
        //Notify of value change
        if continuous {
            sendActions(for: .valueChanged)
        }else{
            //Only send an update if the gesture has completed
            if sender.state == .ended || sender.state == .cancelled{
                sendActions(for: .valueChanged)
            }
        }
    }
}

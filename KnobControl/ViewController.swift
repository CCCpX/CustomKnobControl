//
//  ViewController.swift
//  KnobControl
//
//  Created by chen peixiang on 04/11/2016.
//  Copyright © 2016 chen peixiang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var knobPlaceholder: UIView!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var valueSlider: UISlider!
    @IBOutlet weak var valueButton: UIButton!
    
    var knobControl: KnobControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        knobControl = KnobControl(frame: knobPlaceholder.bounds)
        knobPlaceholder.addSubview(knobControl)
        knobPlaceholder.bringSubview(toFront: valueLabel)
        
        knobControl.lineWidth = 4.0
        knobControl.pointerLength = 8.0
        view.tintColor = UIColor.red
        knobControl.addObserver(self, forKeyPath: "value", options: NSKeyValueObservingOptions(rawValue: 0), context: nil)
        knobControl.addTarget(self, action: #selector(ViewController.handleValueChanged(_:)), for: .valueChanged)
    }
    
    @IBAction func handleValueChanged(_ sender: UISlider) {
        if sender == valueSlider {
            knobControl.value = CGFloat(valueSlider.value)
        }else if sender == knobControl{
            valueSlider.value = Float(knobControl.value)
        }
    }
    
    @IBAction func handleRandomButtonPressed(_ sender: UIButton) {
        let randomValue = CGFloat(arc4random_uniform(101)) / 100
        knobControl.setValue(CGFloat(randomValue), animated: true)
        valueSlider.setValue(Float(randomValue), animated: true)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        let obj = object as? KnobControl
        if obj == knobControl && keyPath == "value"{
            valueLabel.text = String(format: "%.2f", knobControl.value)
        }
    }
}

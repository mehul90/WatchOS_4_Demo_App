//
//  InterfaceController.swift
//  FirstWatchApp WatchKit Extension
//
//  Created by Mehul Parmar on 1/11/18.
//  Copyright © 2018 org. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController {

    @IBOutlet var titleLabel: WKInterfaceLabel!
    @IBOutlet var countLabel: WKInterfaceLabel!
    
    @IBAction func buttonTapped() {
        count = 0
    }
    
    private var crownDelta = 0.0
    
    private var count: Int = 0 {
        didSet {
            setCount(count: String(count))
            updateAppContext()
        }
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
       // if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
      //  }

        crownSequencer.delegate = self
    }
    
    private func setCount(count: String) {
        let fontAttrs = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 80)]
        let attrString = NSAttributedString(string: count, attributes: fontAttrs)
        countLabel.setAttributedText(attrString)
    }
    
    private func updateAppContext() {
        guard WCSession.isSupported() else {
            return
        }
        do{
            try WCSession.default.updateApplicationContext(["WatchCountKey" : count])
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    override func willActivate() {
        super.willActivate()
        crownSequencer.focus()
    }
    
    override func willDisappear() {
        super.willDisappear()
    }
}

extension InterfaceController: WKCrownDelegate {
    
    func crownDidRotate(_ crownSequencer: WKCrownSequencer?, rotationalDelta: Double) {
        crownDelta += rotationalDelta
        if crownDelta > 0.1 {
            count += 1
            crownDelta = 0.0
        } else if crownDelta < -0.1 {
            count -= 1
            crownDelta = 0.0
        }
    }
}

extension InterfaceController: WCSessionDelegate {
    
    func session(_ session: WCSession,
                 activationDidCompleteWith activationState: WCSessionActivationState,
                 error: Error?) { }
    
    func session(_ session: WCSession,
                 didReceiveApplicationContext applicationContext: [String : Any]) { }
}

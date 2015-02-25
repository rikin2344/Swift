//
//  StepManager.swift
//  Pedometer
//
//  Created by Desai, Rikin on 2/25/15.
//  Copyright (c) 2015 Desai, Rikin. All rights reserved.
//

import Foundation
import CoreMotion
import UIKit

typealias Steps = Int

class StepManager:NSObject {
    
    
    dynamic var stepsToday:Steps
    private var pedometer: CMPedometer?
    var isUpdating:Bool = false
    
    static let sharedInstance:StepManager = StepManager()
    
    private override init(){
        if CMPedometer.isStepCountingAvailable() {
            pedometer = CMPedometer()
        }
        stepsToday = 0
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "dateChanged:", name: UIApplicationSignificantTimeChangeNotification, object: nil)

    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
        stopCounting()
    }


    func beginningOfDay(date: NSDate)->NSDate{
        let calender = NSCalendar.autoupdatingCurrentCalendar()
        let component = calender.components(.CalendarUnitMonth | .CalendarUnitYear | .CalendarUnitDay, fromDate: date)
        let beginning = calender.dateFromComponents(component)
        return beginning!
    }
    

    func startCounting(){
        
        if isUpdating{
            return
        }
        let date = beginningOfDay(NSDate())
        pedometer?.startPedometerUpdatesFromDate(date, withHandler: {
            data,error in
            if error == nil {
                let stepCount = data.numberOfSteps.integerValue
                self.stepsToday = stepCount
            }
        })
        isUpdating = true
    }
    
    func stopCounting(){
        if isUpdating{
            pedometer?.stopPedometerUpdates()
            isUpdating = false
        }
    }

}
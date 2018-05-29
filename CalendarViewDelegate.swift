//
//  CalendarViewDelegate.swift
//  BTTeterboroApp
//
//  Created by GKB on 3/28/18.
//  Copyright © 2018 Gabriel Baffo. All rights reserved.
//
import UIKit
import EventKit

protocol CalendarViewDelegate {
    func calendar(_ calendar : CalendarView, canSelectDate date : Date) -> Bool /* default implementation */
    func calendar(_ calendar : CalendarView, didScrollToMonth date : Date) -> Void
    func calendar(_ calendar : CalendarView, didSelectDate date : Date, withEvents events: [CalendarEvent]) -> Void
    func calendar(_ calendar : CalendarView, didDeselectDate date : Date) -> Void /* default implementation */
}

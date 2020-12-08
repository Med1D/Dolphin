//
//  MessageDateFormatter.swift
//  Dolphin
//
//  Created by Иван Медведев on 08.12.2020.
//

import Foundation

final class MessageDateFormatter
{
// MARK: - Properties
	static let shared = MessageDateFormatter()
	private var formatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.locale = Locale(identifier: "ru_RU")
		return formatter
	}()

// MARK: - Initializer
	private init() {}

// MARK: - Methods
	func string(from date: Date) -> String {
		configureDateFormatter(for: date)
		return formatter.string(from: date)
	}

	func attributedString(from date: Date, with attributes: [NSAttributedString.Key: Any]) -> NSAttributedString {
		let dateString = string(from: date)
		return NSAttributedString(string: dateString, attributes: attributes)
	}

	func configureDateFormatter(for date: Date) {
		switch true {
		case Calendar.current.isDateInToday(date) || Calendar.current.isDateInYesterday(date):
			formatter.doesRelativeDateFormatting = true
			formatter.dateStyle = .short
			formatter.timeStyle = .short
		case Calendar.current.isDate(date, equalTo: Date(), toGranularity: .weekOfYear):
			formatter.dateFormat = "EEEE h:mm a"
		case Calendar.current.isDate(date, equalTo: Date(), toGranularity: .year):
			formatter.dateFormat = "E, d MMM, h:mm a"
		default:
			formatter.dateFormat = "MMM d, yyyy, h:mm a"
		}
	}
}

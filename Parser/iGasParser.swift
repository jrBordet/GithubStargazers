//
//  iGasParser.swift
//  Parser
//
//  Created by Jean Raphael Bordet on 12/02/21.
//

import Foundation

public let dateParser = Parser<Date> { value -> Date? in
	let dateFormatter = DateFormatter()
	
	let dateFormat = "dd/MM/yyyy HH:mm:ss"
	
	let date = value.prefix(dateFormat.count)
	
	dateFormatter.dateFormat = dateFormat
	
	guard let result = dateFormatter.date(from: String(date)) else {
		return nil
	}
	
	value.removeFirst(dateFormat.count)
	
	return result
}

public struct ExtractionDate {
	let day: Int
	let month: Int
	let year: Int
	let hour: Int
	let minutes: Int
	let seconds: Int
	
	public init(
		day: Int,
		month: Int,
		year: Int,
		hour: Int,
		minutes: Int,
		seconds: Int
	) {
		self.day = day
		self.month = month
		self.year = year
		self.hour = hour
		self.minutes = minutes
		self.seconds = seconds
	}
}

public let literalDateParser = zip(
	int,
	literal("/"),
	int,
	literal("/"),
	int,
	literal(" "),
	int,
	literal(":"),
	int,
	literal(":"),
	int
).map { (d: Int, _, mt: Int, _, y: Int, _, h: Int, _, m: Int, _, s: Int) -> ExtractionDate in
	ExtractionDate(
		day: d,
		month: mt,
		year: y,
		hour: h,
		minutes: m,
		seconds: s
	)
}

public let rateLine = zip(
	int,
	literal(";"),
	Parser.prefix(through: ";").map { $0.dropLast() },
	double,
	literal(";"),
	int,
	literal(";"),
	dateParser
)

public let signleRateLine = zip(
	int,
	literal(";"),
	Parser.prefix(through: ";").map { $0.dropLast() },
	double,
	literal(";"),
	int,
	literal(";"),
	literalDateParser
)

public let rateList = zeroOrMore(
	signleRateLine,
	separatedBy: commaOrNewline
)

public let dropHeader = Parser.ignore(until: "\n").flatMap { _ in Parser.ignore(until: "\n") }

public let extractionBody = dropHeader.flatMap { _ in rateList }

public enum Fuel {
	case HiQDiesel, metano
}

let fuelParser = Parser
	.prefix(through: ";")
	.map { $0.dropLast() }
	.flatMap {
		$0 == "Hi-Q Diesel" ? always(Fuel.HiQDiesel)
			: $0 == "Metano" ? always(Fuel.metano)
			: .never
	}


//["Hi-Q Diesel", "Metano", "GPL", "Benzina Plus 98", "HiQ Perform+", "Blue Super", "Blue Diesel", "Gasolio Premium", "Gasolio Oro Diesel", "Gasolio", "Benzina", "Gasolio artico", "Benzina WR 100", "Gasolio Alpino", "Excellium Diesel", "Gasolio Gelo", "V-Power", "Benzina speciale", "Gasolio speciale", "Diesel e+10", "Magic Diesel", "DieselMax", "V-Power Diesel", "R100", "Benzina Speciale", "Gasolio Speciale", "Blu Diesel Alpino", "Supreme Diesel", "Gasolio Artico", "GNL", "L-GNC", "GP DIESEL", "F101", "E-DIESEL", "Gasolio Ecoplus", "Excellium diesel", "Benzina 100 ottani", "S-Diesel", "SSP98", "Gasolio Energy D", "Benzina Energy 98 ottani", "Benzina Shell V Power", "Diesel Shell V Power"]

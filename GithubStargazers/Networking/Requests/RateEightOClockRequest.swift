//
//  RateEightOClockRequest.swift
//  Networking
//
//  Created by Jean Raphael Bordet on 27/01/21.
//

import Foundation
import RxSwift

/// Retrieve the rate at height o'clock
/// Example: [Url example](/prezzo_alle_8.csv)
/// Return a csv file
//    Estrazione del 2021-01-26
//    idImpianto;descCarburante;prezzo;isSelf;dtComu
//    6492;Hi-Q Diesel;1.644;1;21/01/2021 01:43:55
// 	  6612;Hi-Q Diesel;1.669;1;23/01/2021 01:13:02
/// - Returns: a collection of Rate

public struct RateEightOClockRequest: APIRequest, CustomDebugStringConvertible {
	public var debugDescription: String {
		request.debugDescription
	}
	
	public typealias Response = [Rate]
	
	public var endpoint: String = "https://www.mise.gov.it/images/exportCSV/prezzo_alle_8.csv"
		
	public var request: URLRequest? {
		guard
			let baseUrl = ProcessInfo.processInfo.environment["BASE_URL"],
			let url = URL(string: baseUrl) else {
			return nil
		}
		
		var request = URLRequest(url: url)
		request.httpMethod = "GET"
		
		return request
	}
	
	public init() {
	}
}

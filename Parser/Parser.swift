//
//  Parser.swift
//  Parser
//
//  Created by Jean Raphael Bordet on 27/01/21.
//

import Foundation

public struct Parser<A> {
	let run: (inout Substring) -> A?
	
	public init(run: @escaping(inout Substring) -> A?) {
		self.run = run
	}
}

public let int = Parser<Int> { str in
	let prefix = str.prefix(while: { $0.isNumber })
	let match = Int(prefix)
	str.removeFirst(prefix.count)
	return match
}

public let double = Parser<Double> { str in
	let prefix = str.prefix(while: { $0.isNumber || $0 == "." })
	let match = Double(prefix)
	str.removeFirst(prefix.count)
	return match
}

public let char = Parser<Character> { str in
	guard !str.isEmpty else { return nil }
	return str.removeFirst()
}

public func literal(_ p: String) -> Parser<Void> {
	return Parser<Void> { str in
		guard str.hasPrefix(p) else { return nil }
		str.removeFirst(p.count)
		return ()
	}
}

public func always<A>(_ a: A) -> Parser<A> {
	return Parser<A> { _ in a }
}

extension Parser {
	public static func always(_ output: A) -> Self {
	  Self { _ in output }
	}
	
	public static var never: Parser {
		return Parser { _ in nil }
	}
}

extension Parser {
	public func map<B>(_ f: @escaping (A) -> B) -> Parser<B> {
		return Parser<B> { str -> B? in
			self.run(&str).map(f)
		}
	}
	
	public func flatMap<B>(_ f: @escaping (A) -> Parser<B>) -> Parser<B> {
		return Parser<B> { str -> B? in
			let original = str
			let matchA = self.run(&str)
			let parserB = matchA.map(f)
			guard let matchB = parserB?.run(&str) else {
				str = original
				return nil
			}
			return matchB
		}
	}
}

public func zip<A, B>(_ a: Parser<A>, _ b: Parser<B>) -> Parser<(A, B)> {
	return Parser<(A, B)> { str -> (A, B)? in
		let original = str
		guard let matchA = a.run(&str) else { return nil }
		guard let matchB = b.run(&str) else {
			str = original
			return nil
		}
		return (matchA, matchB)
	}
}

public func zip<A, B, C>(
	_ a: Parser<A>,
	_ b: Parser<B>,
	_ c: Parser<C>
) -> Parser<(A, B, C)> {
	return zip(a, zip(b, c))
		.map { a, bc in (a, bc.0, bc.1) }
}

public func zip<A, B, C, D>(
	_ a: Parser<A>,
	_ b: Parser<B>,
	_ c: Parser<C>,
	_ d: Parser<D>
) -> Parser<(A, B, C, D)> {
	return zip(a, zip(b, c, d))
		.map { a, bcd in (a, bcd.0, bcd.1, bcd.2) }
}

public func zip<A, B, C, D, E>(
	_ a: Parser<A>,
	_ b: Parser<B>,
	_ c: Parser<C>,
	_ d: Parser<D>,
	_ e: Parser<E>
) -> Parser<(A, B, C, D, E)> {
	
	return zip(a, zip(b, c, d, e))
		.map { a, bcde in (a, bcde.0, bcde.1, bcde.2, bcde.3) }
}

public func zip<A, B, C, D, E, F>(
	_ a: Parser<A>,
	_ b: Parser<B>,
	_ c: Parser<C>,
	_ d: Parser<D>,
	_ e: Parser<E>,
	_ f: Parser<F>
) -> Parser<(A, B, C, D, E, F)> {
	return zip(a, zip(b, c, d, e, f))
		.map { a, bcdef in (a, bcdef.0, bcdef.1, bcdef.2, bcdef.3, bcdef.4) }
}

public func zip<A, B, C, D, E, F, G>(
	_ a: Parser<A>,
	_ b: Parser<B>,
	_ c: Parser<C>,
	_ d: Parser<D>,
	_ e: Parser<E>,
	_ f: Parser<F>,
	_ g: Parser<G>
) -> Parser<(A, B, C, D, E, F, G)> {
	return zip(a, zip(b, c, d, e, f, g))
		.map { a, bcdefg in (a, bcdefg.0, bcdefg.1, bcdefg.2, bcdefg.3, bcdefg.4, bcdefg.5) }
}
public func zip<A, B, C, D, E, F, G, H>(
	_ a: Parser<A>,
	_ b: Parser<B>,
	_ c: Parser<C>,
	_ d: Parser<D>,
	_ e: Parser<E>,
	_ f: Parser<F>,
	_ g: Parser<G>,
	_ h: Parser<H>
) -> Parser<(A, B, C, D, E, F, G, H)> {
	return zip(a, zip(b, c, d, e, f, g, h))
		.map { a, bcdefgh in (a, bcdefgh.0, bcdefgh.1, bcdefgh.2, bcdefgh.3, bcdefgh.4, bcdefgh.5, bcdefgh.6) }
}

public func zip<A, B, C, D, E, F, G, H, I>(
	_ a: Parser<A>,
	_ b: Parser<B>,
	_ c: Parser<C>,
	_ d: Parser<D>,
	_ e: Parser<E>,
	_ f: Parser<F>,
	_ g: Parser<G>,
	_ h: Parser<H>,
	_ i: Parser<I>
) -> Parser<(A, B, C, D, E, F, G, H, I)> {
	return zip(a, zip(b, c, d, e, f, g, h, i))
		.map { a, bcdefghi in (a, bcdefghi.0, bcdefghi.1, bcdefghi.2, bcdefghi.3, bcdefghi.4, bcdefghi.5, bcdefghi.6, bcdefghi.7) }
}

public func zip<A, B, C, D, E, F, G, H, I, J>(
	_ a: Parser<A>,
	_ b: Parser<B>,
	_ c: Parser<C>,
	_ d: Parser<D>,
	_ e: Parser<E>,
	_ f: Parser<F>,
	_ g: Parser<G>,
	_ h: Parser<H>,
	_ i: Parser<I>,
	_ j: Parser<J>
) -> Parser<(A, B, C, D, E, F, G, H, I, J)> {
	return zip(a, zip(b, c, d, e, f, g, h, i, j))
		.map { a, bcdefghij in (a, bcdefghij.0, bcdefghij.1, bcdefghij.2, bcdefghij.3, bcdefghij.4, bcdefghij.5, bcdefghij.6, bcdefghij.7, bcdefghij.8) }
}

public func zip<A, B, C, D, E, F, G, H, I, J, K>(
	_ a: Parser<A>,
	_ b: Parser<B>,
	_ c: Parser<C>,
	_ d: Parser<D>,
	_ e: Parser<E>,
	_ f: Parser<F>,
	_ g: Parser<G>,
	_ h: Parser<H>,
	_ i: Parser<I>,
	_ j: Parser<J>,
	_ k: Parser<K>
) -> Parser<(A, B, C, D, E, F, G, H, I, J, K)> {
	return zip(a, zip(b, c, d, e, f, g, h, i, j, k))
		.map { a, bcdefghijk in (a, bcdefghijk.0, bcdefghijk.1, bcdefghijk.2, bcdefghijk.3, bcdefghijk.4, bcdefghijk.5, bcdefghijk.6, bcdefghijk.7, bcdefghijk.8, bcdefghijk.9) }
}

extension Parser {
	public func run(_ str: String) -> (match: A?, rest: Substring) {
		var str = str[...]
		let match = self.run(&str)
		return (match, str)
	}
}

//extension Parser {
//  public func skip<B>(_ p: Parser<B>) -> Parser {
//	zip(self, p).map { a, _ in a }
//  }
//
////	public func take<B>(_ p: Parser<B>) -> Parser<(A, B)> {
////		zip(self, p)
////	}
//}
//
//extension Parser {
//  func take<NewOutput>(_ p: Parser<NewOutput>) -> Parser<(Output, NewOutput)> {
//	zip(self, p)
//  }
//}

public func zip<A, B>(take a: Parser<A>, skip b: Parser<B>) -> Parser<A> {
	zip(a, b).map { a, _ in a }
}

public func zip<A, B>(skip a: Parser<A>, take b: Parser<B>) -> Parser<B> {
	zip(a, b).map { _, b in b }
}

public func zeroOrMore<A>(_ p: Parser<A>, separatedBy s: Parser<Void>) -> Parser<[A]> {
	return Parser<[A]> { str in
		var original = str
		var matches: [A] = []
		
		while let match = p.run(&str) {
			original = str
			matches.append(match)
			
			if s.run(&str) == nil {
				return matches
			}
		}
		
		str = original
		return matches
	}
}

public let oneOrMoreSpaces = prefix(while: { $0 == " " }).flatMap { $0.isEmpty ? .never : always(()) }

public let zeroOrMoreSpaces = prefix(while: { $0 == " " }).map { _ in () }

public let commaOrNewline = char.flatMap { $0 == "," || $0 == "\n" ? always(()) : .never }

public let semicolon = char.flatMap { $0 == ";" ? always(()) : .never }

func prefix(while p: @escaping (Character) -> Bool) -> Parser<Substring> {
	return Parser<Substring> { str in
		let prefix = str.prefix(while: p)
		str.removeFirst(prefix.count)
		return prefix
	}
}

public enum Currency { case eur, gbp, usd }

public let currency = char.flatMap {
	$0 == "€" ? always(Currency.eur)
		: $0 == "£" ? always(.gbp)
		: $0 == "$" ? always(.usd)
		: .never
}

public struct Money {
	public let currency: Currency
	public let value: Double
	
	public init(
		currency: Currency,
		value: Double
	) {
		self.currency = currency
		self.value = value
	}
}

public let money = zip(currency, double).map(Money.init)

public func oneOf<A>(_ p1: Parser<A>, _ p2: Parser<A>) -> Parser<A> {
	return Parser<A> { str -> A? in
		if let match = p1.run(&str) {
			return match
		}
		
		if let match = p2.run(&str) {
			return match
		}
		
		return nil
	}
}

public func oneOf<A>(_ ps: [Parser<A>]) -> Parser<A> {
	return Parser<A> { str in
		for p in ps {
			if let match = p.run(&str) {
				return match
			}
		}
		return nil
	}
}

extension Parser where A == Substring {
	public static func prefix(upTo substring: Substring) -> Self {
		Self { input in
			guard let endIndex = input.range(of: substring)?.lowerBound
			else { return nil }
			
			let match = input[..<endIndex]
			
			input = input[endIndex...]
			
			return match
		}
	}
	
	public static func prefix(through substring: Substring) -> Self {
		Self { input in
			guard let endIndex = input.range(of: substring)?.upperBound
			else { return nil }
			
			let match = input[..<endIndex]
			
			input = input[endIndex...]
			
			return match
		}
	}
}

extension Parser where A == Substring {
	public static func ignore(until s: A) -> Parser<A> {
		Parser.prefix(through: s)
	}
}

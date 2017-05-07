import Foundation

struct FlightFormatter {

    func generalInfo(of flight: Flight) -> String {
        return "\(flight.name) → \(flight.destinations?.first?.name ?? "unknown")"
    }

    func details(of flight: Flight) -> String {
        return "\(flight.serviceType.description) | (\(flight.statuses.map { $0.description }.joined(separator: ", ")))"
    }
}

struct AirportFormatter {

    func geolocalizableAddress(from airport: Airport) -> String {
        return "\(airport.name)"
    }
}

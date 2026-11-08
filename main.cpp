#include <iomanip>
#include <iostream>
#include <memory>
#include <stdexcept>
#include <string>
#include <vector>

class Ride {
private:
    std::string rideID_, pickupLocation_, dropoffLocation_;
    double distanceMiles_;

public:
    Ride(std::string id, std::string pickup, std::string dropoff, double miles)
        : rideID_(std::move(id)), pickupLocation_(std::move(pickup)),
          dropoffLocation_(std::move(dropoff)), distanceMiles_(miles) {
        if (miles <= 0) throw std::invalid_argument("Distance must be positive");
    }
    virtual ~Ride() = default;
    const std::string& getRideID() const { return rideID_; }
    double getDistance() const { return distanceMiles_; }
    virtual std::string getType() const = 0;
    virtual double fare() const = 0;
    virtual void rideDetails() const {
        std::cout << getType() << " [" << rideID_ << "] " << pickupLocation_
                  << " -> " << dropoffLocation_ << " | " << distanceMiles_
                  << " miles | $" << std::fixed << std::setprecision(2) << fare() << '\n';
    }
};

class StandardRide final : public Ride {
public:
    using Ride::Ride;
    std::string getType() const override { return "Standard"; }
    double fare() const override { return 3.00 + 1.80 * getDistance(); }
};

class PremiumRide final : public Ride {
public:
    using Ride::Ride;
    std::string getType() const override { return "Premium"; }
    double fare() const override { return 7.00 + 3.20 * getDistance(); }
};

class Driver {
private:
    std::string driverID_, name_;
    double rating_;
    std::vector<std::shared_ptr<Ride>> assignedRides_;
public:
    Driver(std::string id, std::string name, double rating)
        : driverID_(std::move(id)), name_(std::move(name)), rating_(rating) {
        if (rating < 0 || rating > 5) throw std::invalid_argument("Rating must be 0-5");
    }
    void addRide(const std::shared_ptr<Ride>& ride) {
        if (!ride) throw std::invalid_argument("Ride cannot be null");
        assignedRides_.push_back(ride);
    }
    std::size_t getRideCount() const { return assignedRides_.size(); }
    void getDriverInfo() const {
        std::cout << "Driver " << name_ << " (" << driverID_ << "), rating "
                  << rating_ << ", completed rides: " << getRideCount() << '\n';
    }
};

class Rider {
private:
    std::string riderID_, name_;
    std::vector<std::shared_ptr<Ride>> requestedRides_;
public:
    Rider(std::string id, std::string name)
        : riderID_(std::move(id)), name_(std::move(name)) {}
    void requestRide(const std::shared_ptr<Ride>& ride) {
        if (!ride) throw std::invalid_argument("Ride cannot be null");
        requestedRides_.push_back(ride);
    }
    std::size_t getRideCount() const { return requestedRides_.size(); }
    void viewRides() const {
        std::cout << "Ride history for " << name_ << " (" << riderID_ << "):\n";
        for (const auto& ride : requestedRides_) ride->rideDetails();
    }
};

int main() {
    // One collection stores different concrete ride types.
    std::vector<std::shared_ptr<Ride>> rides = {
        std::make_shared<StandardRide>("R101", "Library", "Station", 10.0),
        std::make_shared<PremiumRide>("R102", "Airport", "Hotel", 10.0),
        std::make_shared<StandardRide>("R103", "Campus", "Museum", 4.5)
    };
    Driver driver("D201", "Morgan", 4.9);
    Rider rider("U301", "Taylor");
    std::cout << "=== Available rides (dynamic dispatch) ===\n";
    for (const auto& ride : rides) {
        ride->rideDetails();  // Virtual calls dispatch to the actual ride type.
        rider.requestRide(ride);
        driver.addRide(ride);
    }
    std::cout << "\n=== Driver summary ===\n";
    driver.getDriverInfo();
    std::cout << "\n=== Rider history ===\n";
    rider.viewRides();
}

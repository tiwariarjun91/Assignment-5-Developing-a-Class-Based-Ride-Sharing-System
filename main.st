"GNU Smalltalk implementation. Run: gst main.st"

Object subclass: Ride [
    | rideID pickupLocation dropoffLocation distance |
    Ride class >> id: anID pickup: aPickup dropoff: aDropoff miles: miles [
        ^self new initializeID: anID pickup: aPickup dropoff: aDropoff miles: miles
    ]
    initializeID: anID pickup: aPickup dropoff: aDropoff miles: miles [
        miles <= 0 ifTrue: [self error: 'Distance must be positive'].
        rideID := anID. pickupLocation := aPickup.
        dropoffLocation := aDropoff. distance := miles.
        ^self
    ]
    rideID [ ^rideID ]
    pickupLocation [ ^pickupLocation ]
    dropoffLocation [ ^dropoffLocation ]
    distance [ ^distance ]

    pickupLocation: aLocation [
        pickupLocation := aLocation
    ]

    dropoffLocation: aLocation [
        dropoffLocation := aLocation
    ]

    distance: miles [
        miles <= 0 ifTrue: [self error: 'Distance must be positive'].
        distance := miles
    ]
    rideType [ self subclassResponsibility ]
    fare [ self subclassResponsibility ]
    rideDetails [
        Transcript show: self rideType; show: ' ['; show: rideID;
            show: '] '; show: pickupLocation; show: ' -> ';
            show: dropoffLocation; show: ' | ';
            show: distance printString; show: ' miles | $';
            show: ((self fare asScaledDecimal: 2) printString copyUpTo: $s); cr.
    ]
]

Ride subclass: StandardRide [
    rideType [ ^'Standard' ]
    fare [ ^3.00 + (1.80 * self distance) ]
]

Ride subclass: PremiumRide [
    rideType [ ^'Premium' ]
    fare [ ^7.00 + (3.20 * self distance) ]
]

Object subclass: Driver [
    | driverID name rating assignedRides |
    Driver class >> id: anID name: aName rating: aRating [
        ^self new initializeID: anID name: aName rating: aRating
    ]
    initializeID: anID name: aName rating: aRating [
        (aRating < 0 or: [aRating > 5]) ifTrue: [self error: 'Rating must be 0-5'].
        driverID := anID. name := aName. rating := aRating.
        assignedRides := OrderedCollection new. ^self
    ]
    addRide: aRide [
        (aRide isKindOf: Ride) ifFalse: [self error: 'Expected a Ride'].
        assignedRides add: aRide
    ]
    rideCount [ ^assignedRides size ]
    getDriverInfo [
        Transcript show: 'Driver '; show: name; show: ' ('; show: driverID;
            show: '), rating '; show: ((rating asScaledDecimal: 1) printString copyUpTo: $s);
            show: ', completed rides: '; show: self rideCount printString; cr
    ]
]

Object subclass: Rider [
    | riderID name requestedRides |
    Rider class >> id: anID name: aName [
        ^self new initializeID: anID name: aName
    ]
    initializeID: anID name: aName [
        riderID := anID. name := aName.
        requestedRides := OrderedCollection new. ^self
    ]
    requestRide: aRide [
        (aRide isKindOf: Ride) ifFalse: [self error: 'Expected a Ride'].
        requestedRides add: aRide
    ]
    rideCount [ ^requestedRides size ]
    viewRides [
        Transcript show: 'Ride history for '; show: name;
            show: ' ('; show: riderID; show: '):'; cr.
        requestedRides do: [:each | each rideDetails]
    ]
]

| rides driver rider |
rides := OrderedCollection new.
rides add: (StandardRide id: 'R101' pickup: 'Library' dropoff: 'Station' miles: 10.0).
rides add: (PremiumRide id: 'R102' pickup: 'Airport' dropoff: 'Hotel' miles: 10.0).
rides add: (StandardRide id: 'R103' pickup: 'Campus' dropoff: 'Museum' miles: 4.5).
driver := Driver id: 'D201' name: 'Morgan' rating: 4.9.
rider := Rider id: 'U301' name: 'Taylor'.
Transcript show: '=== Available rides (dynamic dispatch) ==='; cr.
rides do: [:each | each rideDetails. rider requestRide: each. driver addRide: each].
Transcript cr; show: '=== Driver summary ==='; cr.
driver getDriverInfo.
Transcript cr; show: '=== Rider history ==='; cr.
rider viewRides.

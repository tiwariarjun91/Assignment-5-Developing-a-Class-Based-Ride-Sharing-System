# Assignment 5: Class-Based Ride-Sharing System

**Course:** MSCS-632 Advanced Programming Languages  
**Languages:** C++17 and GNU Smalltalk

## Overview

This project demonstrates encapsulation, inheritance, and polymorphism through a ride-sharing system implemented in C++ and GNU Smalltalk.

## Classes

- Ride: Base class containing ride information and defining fare behavior.
- StandardRide: Calculates fares using $3.00 plus $1.80 per mile.
- PremiumRide: Calculates fares using $7.00 plus $3.20 per mile.
- Driver: Manages assigned rides and driver information.
- Rider: Maintains requested rides and displays ride history.

## Object-Oriented Programming Concepts

### Encapsulation

Ride attributes are encapsulated and accessed through methods. Getters and setters provide controlled access to ride information, including distance validation.

### Inheritance

StandardRide and PremiumRide inherit from Ride and implement their own fare calculations.

### Polymorphism

Both implementations store different ride types in a common collection. Method dispatch invokes the appropriate behavior for each ride.

## Running C++

Compile and execute:

    clang++ -std=c++17 -Wall -Wextra -pedantic main.cpp -o rides
    ./rides

## Running GNU Smalltalk

Execute using GNU Smalltalk:

    gst main.st

The Smalltalk implementation was tested using GNU Smalltalk 3.2.5 in an Ubuntu 22.04 Docker container.

## Expected Results

| Ride | Distance | Fare |
|---|---:|---:|
| Standard R101 | 10 miles | $21.00 |
| Premium R102 | 10 miles | $39.00 |
| Standard R103 | 4.5 miles | $11.10 |

Both implementations display driver information and rider history.

## Project Files

- main.cpp - C++ implementation
- main.st - GNU Smalltalk implementation
- screenshots/cpp_output.png - C++ execution screenshot
- screenshots/smalltalk_output.png - Smalltalk execution screenshot

## GitHub Repository

https://github.com/tiwariarjun91/Assignment-5-Developing-a-Class-Based-Ride-Sharing-System

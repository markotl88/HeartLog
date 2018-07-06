//
//  ResponseStructures.swift
//  FTN
//
//  Created by Marko Stajic on 12/2/16.
//  Copyright © 2018 FTN. All rights reserved.
//

import Foundation

public struct GeneralResponse {
    public let success: Bool
    public let error: DMSGenericError?
    public let message: String
}

public struct AuthTokenResponse {
    public let success: Bool
    public let authToken: String?
    public let error: DMSGenericError?
    public let message: String
}

public struct BloodPressureReadingsResponse {
    public let success: Bool
    public let bloodPressureReadings: BloodPressureReadingList?
    public let error: DMSGenericError?
    public let message: String
}

public struct SingleBloodPressureReadingResponse {
    public let success: Bool
    public let bloodPressureReading: BloodPressureReading?
    public let error: DMSGenericError?
    public let message: String
}

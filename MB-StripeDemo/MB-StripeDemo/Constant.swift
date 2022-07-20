//
//  Constant.swift
//  MB-StripeDemo
//
//  Created by Meet's MAC on 19/07/22.
//

import Foundation
import Alamofire

//MARK: - Keys
let Publisher_Key = "Your Publisher Key"
let Secret_Key = "Your Secret Key"
var Customer_ID = UserDefaults.standard.string(forKey: "CustID")
var ephemeral_key = UserDefaults.standard.string(forKey: "ephemeral_key")
var client_secret = UserDefaults.standard.string(forKey: "client_secret")

//MARK: - API's
let api_customers = "https://api.stripe.com/v1/customers"
let api_ephemeral_keys = "https://api.stripe.com/v1/ephemeral_keys"
let api_payment_intents = "https://api.stripe.com/v1/payment_intents"

let header:HTTPHeaders = ["Authorization": "Bearer \(Secret_Key)"]

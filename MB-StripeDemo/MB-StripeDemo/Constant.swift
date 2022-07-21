//
//  Constant.swift
//  MB-StripeDemo
//
//  Created by Meet's MAC on 19/07/22.
//

import Foundation
import Alamofire

//MARK: - Keys
let Publisher_Key = "pk_test_51LMrFDSFNuTs3bsZUez5VtIxb1QAcyFXiQW1vW0gA1KrfZ8pTWThtHSZvpu2ToDMdFFV90dMyw96R4Dd1nCyDkQR00Dzut5JXS"
let Secret_Key = "sk_test_51LMrFDSFNuTs3bsZo7eSbB0hG80ZHksWzQSilXYghhfI68yasVZH5CEI06BLn9uJbyzXWRkukE7zUpUrNNYUinFu00JA19WIuk"
var Customer_ID = UserDefaults.standard.string(forKey: "CustID")
var ephemeral_key = UserDefaults.standard.string(forKey: "ephemeral_key")
var client_secret = UserDefaults.standard.string(forKey: "client_secret")
var payment_intent = UserDefaults.standard.string(forKey: "payment_intent")

//MARK: - API's
let api_customers = "https://api.stripe.com/v1/customers"
let api_ephemeral_keys = "https://api.stripe.com/v1/ephemeral_keys"
let api_payment_intents = "https://api.stripe.com/v1/payment_intents"

let header:HTTPHeaders = ["Authorization": "Bearer \(Secret_Key)"]

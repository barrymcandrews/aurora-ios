//
//  RequestArray.swift
//  Aurora
//
//  Created by Barry McAndrews on 4/7/17.
//  Copyright © 2017 Barry McAndrews. All rights reserved.
//

import UIKit
import WatchConnectivity

public protocol RequestContainerDelegate {
    func requestsChanged()
}

public class RequestContainer: NSObject {
    public static let shared = RequestContainer()
    static let ApplicationSupportDirectory = FileManager().urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
    static let ArchiveURL = ApplicationSupportDirectory.appendingPathComponent("requests.dat")
    public var delegate: RequestContainerDelegate?
    
    public var requests: [Request] = [
        ColorRequest(name:"Off", color: UIColor.black),
        ServiceRequest(name: "Spotify", service: ServiceType.LightShowService),
        ColorRequest(name: "Blue", color: UIColor.blue),
        ColorRequest(name: "Red", color: UIColor.red),
        ColorRequest(name: "Orange", color: UIColor.orange),
        ColorRequest(name: "Yellow", color: UIColor.yellow),
        ColorRequest(name: "Green", color: UIColor.green),
        ColorRequest(name: "White", color: UIColor.white),
        ColorRequest(name: "Purple", color: UIColor.purple),
        ColorRequest(name: "Pink", color: UIColor.magenta),
        SequenceRequest(name: "Police", dict: [
            "type":"sequence",
            "delay":0.25,
            "sequence":[
                [
                    "type":"sequence",
                    "repeat":4,
                    "delay":0.0625,
                    "sequence":[
                        [
                            "type":"color",
                            "red":100,
                            "green":0,
                            "blue":0
                        ],
                        [
                            "type":"color",
                            "red":0,
                            "green":0,
                            "blue":0
                        ]
                    ]
                ],
                [
                    "type":"color",
                    "red":100,
                    "green":0,
                    "blue":0
                ],
                [
                    "type":"sequence",
                    "repeat":4,
                    "delay":0.0625,
                    "sequence":[
                        [
                            "type":"color",
                            "red":0,
                            "green":0,
                            "blue":0
                        ],
                        [
                            "type":"color",
                            "red":0,
                            "green":0,
                            "blue":100
                        ]
                    ]
                ],
                [
                    "type":"color",
                    "red":0,
                    "green":0,
                    "blue":100
                ]
            ]
            ]),
        SequenceRequest(name: "Rainbow", dict: [
            "type": "fade",
            "delay": 2,
            "colors": [
                [
                    "red": 100,
                    "green": 0,
                    "blue": 0
                ],
                [
                    "red": 100,
                    "green": 100,
                    "blue": 0
                ],
                [
                    "red": 0,
                    "green": 100,
                    "blue": 0
                ],
                [
                    "red": 0,
                    "green": 100,
                    "blue": 100
                ],
                [
                    "red": 0,
                    "green": 0,
                    "blue": 100
                ],
                [
                    "red": 100,
                    "green": 0,
                    "blue": 100
                ],
                [
                    "red": 100,
                    "green": 0,
                    "blue": 0
                ]
            ]
            ]),
        SequenceRequest(name: "Sunset", dict: [
            "type": "fade",
            "delay": 2,
            "colors": [
                [
                    "red": 100,
                    "green": 30,
                    "blue": 0
                ],
                [
                    "red": 100,
                    "green": 0,
                    "blue": 0
                ],
                [
                    "red": 0,
                    "green": 0,
                    "blue": 0
                ],
                [
                    "red": 100,
                    "green": 0,
                    "blue": 0
                ],
                [
                    "red": 100,
                    "green": 30,
                    "blue": 0
                ]
            ]
            ]),
        SequenceRequest(name: "Pitt", dict: [
            "type": "sequence",
            "delay": 1,
            "sequence": [
                [
                    "type": "color",
                    "red": 0,
                    "green": 0,
                    "blue": 100
                ],
                [
                    "type": "color",
                    "red": 100,
                    "green": 25,
                    "blue": 0
                ]
            ]
            ]),
        SequenceRequest(name: "Strobe", dict: [
            "type": "sequence",
            "delay": 0.0625,
            "sequence": [
                [
                    "type": "color",
                    "red": 100,
                    "green": 100,
                    "blue": 100
                ],
                [
                    "type": "color",
                    "red": 0,
                    "green": 0,
                    "blue": 0
                ]
            ]
            ]),
        SequenceRequest(name: "Acid Trip", dict: [
            "type": "sequence",
            "delay": 0.1,
            "sequence": [
                [
                    "type": "color",
                    "red": 100,
                    "green": 0,
                    "blue": 0
                ],
                [
                    "type": "color",
                    "red": 0,
                    "green": 100,
                    "blue": 0
                ],
                [
                    "type": "color",
                    "red": 0,
                    "green": 0,
                    "blue": 100
                ]
            ]
            ]),
        SequenceRequest(name: "Cyclone", dict: [
            "type": "fade",
            "delay": 0.25,
            "colors": [
                [
                    "red": 100,
                    "green": 0,
                    "blue": 0
                ],
                [
                    "red": 0,
                    "green": 100,
                    "blue": 0
                ],
                [
                    "red": 0,
                    "green": 0,
                    "blue": 100
                ],
                [
                    "red": 100,
                    "green": 0,
                    "blue": 0
                ]
            ]
            ])
        ] {
        didSet {
            #if os(iOS)
            WatchSessionManager.shared.updateApplicationContext()
            #endif
            delegate?.requestsChanged()
        }
    }
    
    
    public static func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    public static func saveRequests() -> Bool {
        do {
            try FileManager.default.createDirectory(atPath: ApplicationSupportDirectory.path, withIntermediateDirectories: false, attributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription);
        }
        
        return NSKeyedArchiver.archiveRootObject(shared.requests, toFile: ArchiveURL.path)
    }
    
    public static func loadRequests() -> Bool {
        if let loaded = NSKeyedUnarchiver.unarchiveObject(withFile: ArchiveURL.path) as? [Request] {
            shared.requests = loaded
            return true
        } else {
            return false
        }
    }
}


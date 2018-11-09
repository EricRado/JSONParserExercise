//
//  main.swift
//  ViewParser
//
//  Created by Eric Rado on 11/5/18.
//  Copyright © 2018 Eric. All rights reserved.
//

import Foundation

// MARK: - Instance Variables
private var identifiers = [String: Int]()
private var classes = [String: Int]()
private var classNames = [String: Int]()

// MARK: - Parser functions
private func parseViewFields(_ view: Subview) {
    if let identifier = view.identifier?.lowercased() {
        if let count = identifiers[identifier] {
            identifiers[identifier] = count + 1
        } else {
            identifiers[identifier] = 1
        }
    }
    
    let classStr = view.classStr.lowercased()
    if let count = classes[classStr] {
        classes[classStr] = count + 1
    } else {
        classes[classStr] = 1
    }
    
    if let classNameArr = view.classNames {
        for className in classNameArr {
            let name = className.lowercased()
            if let count = classNames[name] {
                classNames[name] = count + 1
            } else {
                classNames[name] = 1
            }
        }
    }
}

private func parseControlFields(_ control: Control) {
    let classStr = control.classStr.lowercased()
    if let count = classes[classStr] {
        classes[classStr] = count + 1
    } else {
        classes[classStr] = 1
    }
    
    if let identifier = control.identifier?.lowercased() {
        if let count = identifiers[identifier] {
            identifiers[identifier] = count + 1
        } else {
            identifiers[identifier] = 1
        }
    }
}

// MARK: - JSON Processing Functions
private func traverseSubviewArray(_ arr: [Subview]?) {
    guard let subViews = arr else { return }
  
    for view in subViews {
        if let contentViews = view.contentView?.subViews {
            for contentView in contentViews {
                parseViewFields(contentView)
                if let control = contentView.control {
                    parseControlFields(control)
                }
            }
        }
        parseViewFields(view)
        traverseSubviewArray(view.subViews)
    }
}

func retrieveJSONFile(completion: @escaping () -> Void) {
    print("Retrieving JSON data...")
    let urlString = "https://raw.githubusercontent.com/jdolan/quetoo/master/src/cgame/default/ui/settings/SystemViewController.json"
    guard let url = URL(string: urlString) else { return }
    
    let sessionConfig = URLSessionConfiguration.default
    let session = URLSession(configuration: sessionConfig)
    let task = session.dataTask(with: url) { (data, response, error) in
        guard let dataResponse = data, error == nil else {
            print(error?.localizedDescription ?? "Unspecified error")
            return
        }
        do {
            // turn the JSON data to a struct
            let response = try JSONDecoder().decode(ViewResponse.self, from: dataResponse)
            identifiers[response.identifier] = 1
            
            // traverse the nested Subviews arrays
            let subViews: [Subview]? = response.subviews
            traverseSubviewArray(subViews)
            
            // parsing complete, program transfers to user input
            completion()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    task.resume()
}

// MARK: - Handle User Input Functions
private func searchForInput(input: String, option: String) {
    var count = 0
    let inputLowered = input.lowercased()
    
    switch option {
    case "1":
        count = identifiers[inputLowered] ?? 0
    case "2":
        count = classes[inputLowered] ?? 0
    case "3":
        count = classNames[inputLowered] ?? 0
    default:
        break
    }
    
    print("\(input) count: \(count)\n")
}

private func checkOption(_ option: String) -> Bool {
    let choice = option.replacingOccurrences(of: " ", with: "")
    var result = true
    
    switch choice {
    case "1":
        print("Type the identifier your looking for")
    case "2":
        print("Type the class your looking for")
    case "3":
        print("Type the className your looking for")
    case "4":
        print("Bye")
        exit(0)
    default:
        print("Invalid input")
        result = false
    }
    
    return result
}

func retrieveUserInput() {
    let optionStr = """
    Choose a selector from the options below by typing the number
    1.Identifier
    2.Class
    3.ClassName
    4.Quit\n
    """
    while true {
        print(optionStr)
        let option = readLine() ?? "No input was found"
        if !checkOption(option) { continue }
        let input = readLine() ?? "No input was found"
        searchForInput(input: input, option: option)
    }
}

retrieveJSONFile(completion: retrieveUserInput)
dispatchMain()


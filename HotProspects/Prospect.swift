//
//  Prospect.swift
//  HotProspects
//
//  Created by Nick Pavlov on 3/11/23.
//

import SwiftUI

// Main class of contact
class Prospect: Identifiable, Codable {
    var id = UUID()
    var name = "Anonymous"
    var emailAddress = ""
    fileprivate(set) var isContacted = false
}

// Main array of contacts
@MainActor class Prospects: ObservableObject {
    @Published private(set) var people: [Prospect]
    let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedData")
    
    // Getting data from File Manager
    init() {
        do {
            let data = try Data(contentsOf: savePath)
            people = try JSONDecoder().decode([Prospect].self, from: data)
        } catch {
            people = []
        }
    }
    
    // Saving data to File manager
    private func save() {
        do {
            let data = try JSONEncoder().encode(people)
            try data.write(to: savePath)
        } catch {
            print("Can't get data!")
        }
    }
    
    // Adding new contact
    func add(_ prospect: Prospect) {
        people.append(prospect)
        save()
    }
    
    // Deleting contact on a swipe action
    func deleteContact(at offsets: IndexSet) {
        people.remove(atOffsets: offsets)
        save()
    }
    
    // Method for mark if contacted or not, making sure ui sees changes
    func toggle(_ prospect: Prospect) {
        objectWillChange.send()
        prospect.isContacted.toggle()
        save()
    }
    
    // Making icon for contact
    func contactIcon(isContacted: Bool) -> some View {
        var systemName = "person.crop.circle.badge.xmark"
        var color = Color.blue
        if isContacted {
            systemName = "person.crop.circle.fill.badge.checkmark"
            color = Color.green
        }
        
        return Image(systemName: systemName)
            .foregroundColor(color)
    }
}




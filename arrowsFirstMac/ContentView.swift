//Created by me on 03/10/20

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Member.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Member.name, ascending: true)]) var members:FetchedResults<Member>
    
    @State private var showAddMember = false
    
    var body: some View {
        VStack {
            NavigationView {
                List {
                    ForEach(members,id:\.alterEgo){ member in
                        NavigationLink(destination: Text(member.otherAffiliations).frame(maxWidth:.infinity,maxHeight:.infinity)){
                            EmojiView(for: member.alterEgo)
                            Text(member.name)
                        }
                    }
                    .onDelete(perform: removeMembers)
                    Button("Add Member"){
                        self.showAddMember.toggle()
                    }
                }.listStyle(SidebarListStyle())
                
                
                
            }
            Text("").sheet(isPresented: $showAddMember){
                AddMemberView().environment(\.managedObjectContext,self.moc)
            }
        }
        
    }
    func removeMembers(at offsets:IndexSet){
        for index in offsets {
            let member=members[index]
            moc.delete(member)
        }
        try? moc.save()
    }
}



struct EmojiView: View {
    var alterEgo: String
    
    var body: some View {
        
        switch alterEgo {
        case "Arrow":
            return Text("🏹")
        case "Overwatch":
            return Text("👩🏼‍💻")
        case "Spartan":
            return Text("♞")
        default:
            return Text("😑")
        }
    }
    init(for alterEgo:String) {
        self.alterEgo=alterEgo
    }
    
}

struct AddMemberView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name=""
    @State private var alterEgo=""
    @State private var otherAffiliations="Bratva"
    var listOfAffiliations=["Bratva","ARGUS","Legends"]
    
    var body: some View {
        NavigationView {
            Form {
                Section{
                    TextField("Name",text:$name)
                    TextField("Alter Ego",text:$alterEgo)
                    
                    Picker("Other Affiliation",selection: $otherAffiliations){
                        ForEach(listOfAffiliations,id:\.self){ affiliation in
                            Text(affiliation)
                        }
                    }
                    
                }
                Button("Add Member") {
                    let newMember=Member(context:self.moc)
                    newMember.name=self.name
                    newMember.alterEgo=self.alterEgo
                    newMember.otherAffiliations=self.otherAffiliations
                    
                    do {
                        try self.moc.save()
                        self.presentationMode.wrappedValue.dismiss()
                    } catch {
                        print("Whoops \(error.localizedDescription)")
                    }
                }
            }
            .frame(minWidth:400)
            .padding()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

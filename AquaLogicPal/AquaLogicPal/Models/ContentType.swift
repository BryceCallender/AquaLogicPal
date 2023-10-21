enum ContentType: String, CaseIterable, Identifiable {
    case graph, list
    var id: Self { self }
}

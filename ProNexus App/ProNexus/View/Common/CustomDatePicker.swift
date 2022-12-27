import SwiftUI

struct CalendarContentView: View {
    
    @Environment(\.calendar) var calendar
    private var year: DateInterval {
        calendar.dateInterval(of: .month, for: Date())!
    }
    
    var body: some View {
        VStack {
            VStack{
                CalendarView(interval: self.year) { date in
                    Text(String(self.calendar.component(.day, from: date)))
                        .padding(4)
                    //                    .background(checkSelected(date: date) ? Color(hex: "#E3F2FF") : .white) // Make your logic
                        .clipShape(Rectangle())
                        .cornerRadius(4)
                        .frame(width: 26, height: 16)
                        .padding(2)
                        .appFont(style: .body)
                    //                    .overlay(
                    //                        Text(String(self.calendar.component(.day, from: date))).appFont(style: .body)
                    //                        //                                .underline(2 == 2) //Make your own logic
                    //                    )
                        .onTapGesture {
                            
                        }
                }
                Spacer()
            }.padding(.horizontal, 37)
            
            Divider()
            
            VStack{
                CalendarWeekView(interval: self.year) { date in
                    Text(String(self.calendar.component(.day, from: date)))
                        .padding(4)
                    //                    .background(checkSelected(date: date) ? Color(hex: "#E3F2FF") : .white) // Make your logic
                        .clipShape(Rectangle())
                        .cornerRadius(4)
                        .frame(width: 24, height: 16)
                        .padding(2)
                        .appFont(style: .body)
                    //                    .overlay(
                    //                        Text(String(self.calendar.component(.day, from: date))).appFont(style: .body)
                    //                        //                                .underline(2 == 2) //Make your own logic
                    //                    )
                        .onTapGesture {
                            
                        }
                }
                Spacer()
            }.padding(.horizontal, 37)
        }
    }
}


struct CalendarContentView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarContentView()
    }
}




fileprivate extension DateFormatter {
    static var month: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter
    }
    
    static var monthAndYear: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }
}

fileprivate extension Calendar {
    func generateDates(
        inside interval: DateInterval,
        matching components: DateComponents
    ) -> [Date] {
        var dates: [Date] = []
        dates.append(interval.start)
        
        enumerateDates(
            startingAfter: interval.start,
            matching: components,
            matchingPolicy: .nextTime
        ) { date, _, stop in
            if let date = date {
                if date < interval.end {
                    dates.append(date)
                } else {
                    stop = true
                }
            }
        }
        
        return dates
    }
}

struct WeekView<DateView>: View where DateView: View {
    @Environment(\.calendar) var calendar
    
    let week: Date
    let content: (Date) -> DateView
    
    init(week: Date, @ViewBuilder content: @escaping (Date) -> DateView) {
        self.week = week
        self.content = content
    }
    
    private var days: [Date] {
        guard
            let weekInterval = calendar.dateInterval(of: .weekOfYear, for: week)
        else { return [] }
        return calendar.generateDates(
            inside: weekInterval,
            matching: DateComponents(hour: 0, minute: 0, second: 0)
        )
    }
    
    var body: some View {
        HStack {
            ForEach(days, id: \.self) { date in
                VStack {
                    if self.calendar.isDate(self.week, equalTo: date, toGranularity: .month) {
                        self.content(date)
                    } else {
                        self.content(date).hidden()
                    }
                }
            }
        }
    }
}

struct MonthView<DateView>: View where DateView: View {
    @Environment(\.calendar) var calendar
    
    @State private var month: Date
    let showHeader: Bool
    let content: (Date) -> DateView
    
    init(
        month: Date,
        showHeader: Bool = true,
        localizedWeekdays: [String] = [],
        @ViewBuilder content: @escaping (Date) -> DateView
    ) {
        self._month = State(initialValue: month)
        self.content = content
        self.showHeader = showHeader
    }
    
    private var weeks: [Date] {
        guard
            let monthInterval = calendar.dateInterval(of: .month, for: month)
        else { return [] }
        return calendar.generateDates(
            inside: monthInterval,
            matching: DateComponents(hour: 0, minute: 0, second: 0, weekday: calendar.firstWeekday)
        )
    }
    
    func changeDateBy(_ months: Int) {
        if let date = Calendar.current.date(byAdding: .month, value: months, to: month) {
            self.month = date
        }
    }
    
    private var header: some View {
        let component = calendar.component(.month, from: month)
        let formatter = component == 1 ? DateFormatter.month : .month
        let year = month.toString(format: .custom("yyyy"))
        return HStack{
            Group {
                Button(action: {
                    self.changeDateBy(-1)
                }) {
                    Image(systemName: "arrowtriangle.left.fill") //
                        .resizable()
                }
            }.foregroundColor(Color(hex: "#4D4D4D"))
                .frame(width: 6, height: 8)
            
            Text("\(translateMonth(text: formatter.string(from: month)))/\(year)")
                .appFont(style: .body, weight: .bold, size: 14, color: Color(hex: "#4D4D4D"))
                .padding(.horizontal)
            
            Group {
                Button(action: {
                    self.changeDateBy(1)
                }) {
                    Image(systemName: "arrowtriangle.right.fill") //
                        .resizable()
                }
            }.foregroundColor(Color(hex: "#4D4D4D"))
                .frame(width: 6, height: 8)
        }
    }
    
    var body: some View {
        VStack {
            if showHeader {
                header
            }
            HStack{
                ForEach(0..<7, id: \.self) { index in
                    Text("")
                        .hidden()
                        .padding(4)
                        .padding(.horizontal, 11)
                        .appFont(style: .body, weight: .bold, size: 14, color: Color(hex: "#4D4D4D"))
                        .fixedSize(horizontal: false, vertical: true)
                        .overlay(
                            Text(translate(text: getWeekDaysSorted()[index].uppercased())).appFont(style: .body, size: 13)
                        )
                }
            }.padding(.horizontal, 15)
            
            ForEach(weeks, id: \.self) { week in
                WeekView(week: week, content: self.content)
            }
        }.gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onEnded({ value in
                        if value.translation.width < 0 {
                            // left
                            self.changeDateBy(1)
                        }

                        if value.translation.width > 0 {
                            // right
                            self.changeDateBy(-1)
                        }
                    }))
    }
    
    func translate(text: String) -> String {
        if text == "MON" {
            return "Hai"
        }
        if text == "TUE" {
            return "Ba"
        }
        if text == "WED" {
            return "Bốn"
        }
        if text == "THU" {
            return "Năm"
        }
        if text == "FRI" {
            return "Sáu"
        }
        if text == "SAT" {
            return "Bảy"
        }
        if text == "SUN" {
            return "CN"
        }
        return text
    }
    
    func translateMonth(text: String) -> String {
        if text == "January" {
            return "Tháng 1"
        }
        if text == "February" {
            return "Tháng 2"
        }
        if text == "March" {
            return "Tháng 3"
        }
        if text == "April" {
            return "Tháng 4"
        }
        if text == "May" {
            return "Tháng 5"
        }
        if text == "June" {
            return "Tháng 6"
        }
        if text == "July" {
            return "Tháng 7"
        }
        if text == "August" {
            return "Tháng 8"
        }
        if text == "September" {
            return "Tháng 9"
        }
        if text == "October" {
            return "Tháng 10"
        }
        if text == "November" {
            return "Tháng 11"
        }
        if text == "December" {
            return "Tháng 12"
        }
        return text
    }
    
    func getWeekDaysSorted() -> [String]{
        let weekDays = Calendar.current.shortWeekdaySymbols
        let sortedWeekDays = Array(weekDays[Calendar.current.firstWeekday - 1 ..< Calendar.current.shortWeekdaySymbols.count] + weekDays[0 ..< Calendar.current.firstWeekday - 1])
        return sortedWeekDays
    }
}

struct CalendarView<DateView>: View where DateView: View {
    @Environment(\.calendar) var calendar
    
    let interval: DateInterval
    let content: (Date) -> DateView
    
    init(interval: DateInterval, @ViewBuilder content: @escaping (Date) -> DateView) {
        self.interval = interval
        self.content = content
    }
    
    private var months: [Date] {
        calendar.generateDates(
            inside: interval,
            matching: DateComponents(day: 1, hour: 0, minute: 0, second: 0)
        )
    }
    
    var body: some View {
        
        ForEach(months, id: \.self) { month in
            MonthView(month: month, content: self.content)
        }
        
    }
}


struct MonthHScrollView<DateView>: View where DateView: View {
    @Environment(\.calendar) var calendar
    
    @State private var month: Date
    let showHeader: Bool
    let content: (Date) -> DateView
    
    init(
        month: Date,
        showHeader: Bool = true,
        localizedWeekdays: [String] = [],
        @ViewBuilder content: @escaping (Date) -> DateView
    ) {
        self._month = State(initialValue: month)
        self.content = content
        self.showHeader = showHeader
    }
    
    private var weeks: [Date] {
        guard
            let monthInterval = calendar.dateInterval(of: .weekday, for: month)
        else { return [] }
        return calendar.generateDates(
            inside: monthInterval,
            matching: DateComponents(hour: 0, minute: 0, second: 0, weekday: calendar.firstWeekday)
        )
    }
    
    func changeDateBy(_ weeks: Int) {
        if let date = Calendar.current.date(byAdding: .day, value: weeks, to: month) {
            self.month = date
        }
    }
    
    private var header: some View {
        let component = calendar.component(.month, from: month)
        let formatter = component == 1 ? DateFormatter.month : .month
        let year = month.toString(format: .custom("yyyy"))
        return HStack{
            Spacer()
            Text("\(translateMonth(text: formatter.string(from: month)))/\(year)")
                .appFont(style: .body, weight: .bold, size: 14, color: Color(hex: "#4D4D4D"))
                .padding(.horizontal)
//                .padding(.trailing, 10)
            Spacer()
        }
    }
    
    var body: some View {
        VStack {
            if showHeader {
                header
            }
            HStack{
                ForEach(0..<7, id: \.self) { index in
                    Text("")
                        .hidden()
                        .padding(4)
                        .padding(.horizontal, 11)
                        .appFont(style: .body, weight: .bold, size: 14, color: Color(hex: "#4D4D4D"))
                        .fixedSize(horizontal: false, vertical: true)
                        .overlay(
                            Text(translate(text: getWeekDaysSorted()[index].uppercased())).appFont(style: .body, size: 13)
                        )
                }
            }
//            .padding(.horizontal, 15)
            
            HStack{
                Group {
                    Button(action: {
                        self.changeDateBy(-7)
                    }) {
                        Image(systemName: "arrowtriangle.left.fill") //
                            .resizable()
                        
                    }
                    
                }.foregroundColor(Color(hex: "#4D4D4D"))
                    .frame(width: 6, height: 8)
                
                ForEach(weeks, id: \.self) { week in
                    WeekView(week: week, content: self.content)
                }
                
                Group {
                    Button(action: {
                        self.changeDateBy(7)
                    }) {
                        Image(systemName: "arrowtriangle.right.fill") //
                            .resizable()
                    }
                }.foregroundColor(Color(hex: "#4D4D4D"))
                    .frame(width: 6, height: 8)
                
            }
            
        }
        .onAppear {
            self.month = Date()
        }
        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onEnded({ value in
                        if value.translation.width < 0 {
                            // left
                            self.changeDateBy(7)
                        }

                        if value.translation.width > 0 {
                            // right
                            self.changeDateBy(-7)
                        }
        }))
    }
    
    func translate(text: String) -> String {
        if text == "MON" {
            return "Hai"
        }
        if text == "TUE" {
            return "Ba"
        }
        if text == "WED" {
            return "Bốn"
        }
        if text == "THU" {
            return "Năm"
        }
        if text == "FRI" {
            return "Sáu"
        }
        if text == "SAT" {
            return "Bảy"
        }
        if text == "SUN" {
            return "CN"
        }
        return text
    }
    
    func translateMonth(text: String) -> String {
        if text == "January" {
            return "Tháng 1"
        }
        if text == "February" {
            return "Tháng 2"
        }
        if text == "March" {
            return "Tháng 3"
        }
        if text == "April" {
            return "Tháng 4"
        }
        if text == "May" {
            return "Tháng 5"
        }
        if text == "June" {
            return "Tháng 6"
        }
        if text == "July" {
            return "Tháng 7"
        }
        if text == "August" {
            return "Tháng 8"
        }
        if text == "September" {
            return "Tháng 9"
        }
        if text == "October" {
            return "Tháng 10"
        }
        if text == "November" {
            return "Tháng 11"
        }
        if text == "December" {
            return "Tháng 12"
        }
        return text
    }
    
    func getWeekDaysSorted() -> [String]{
        let weekDays = Calendar.current.shortWeekdaySymbols
        let sortedWeekDays = Array(weekDays[Calendar.current.firstWeekday - 1 ..< Calendar.current.shortWeekdaySymbols.count] + weekDays[0 ..< Calendar.current.firstWeekday - 1])
        return sortedWeekDays
    }
}

struct CalendarWeekView<DateView>: View where DateView: View {
    @Environment(\.calendar) var calendar
    
    let interval: DateInterval
    let content: (Date) -> DateView
    
    init(interval: DateInterval, @ViewBuilder content: @escaping (Date) -> DateView) {
        self.interval = interval
        self.content = content
    }
    
    private var months: [Date] {
        calendar.generateDates(
            inside: interval,
            matching: DateComponents(day: 1, hour: 0, minute: 0, second: 0)
        )
    }
    
    var body: some View {
        
        ForEach(months, id: \.self) { month in
            MonthHScrollView(month: month, content: self.content)
        }
        
    }
}

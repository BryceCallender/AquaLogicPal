import SwiftUI
import Charts

struct SaltLevelChartView: View {
    @EnvironmentObject private var networkManager: NetworkManager
    @State private var showEmptyState = false
    @State private var data: [SaltData] = []
    @State private var rawSelectedDate: Date?
    @State private var loading: Bool = true
    
    var selectedData: SaltData? {
        if rawSelectedDate == nil {
            return nil
        }
        
        if let saltData = data.first(where: { Calendar.current.isDate($0.eventTime, equalTo: rawSelectedDate!, toGranularity: .month) }) {
            return saltData
        }
        
        return nil
    }
    
    let lineGradient = LinearGradient(
        gradient: Gradient(
            colors: [
                .blue,
                .green,
            ]
        ),
        startPoint: .leading,
        endPoint: .trailing
    )
    
    let areaGradient = LinearGradient(
        gradient: Gradient(
            colors: [
                .blue.opacity(0.5),
                .green.opacity(0.2),
            ]
        ),
        startPoint: .leading,
        endPoint: .trailing
    )
    
    var body: some View {
        VStack(alignment: .leading) {
            TitleView("Salt Levels")
            
            if loading {
                ProgressView()
                    .padding()
                    .tint(.dragoonBlue)
                    .scaleEffect(2.0)
            } else {
                Chart {
                    if showEmptyState {
                        RuleMark(y: .value("No Data", 0))
                            .foregroundStyle(lineGradient)
                            .annotation(content: {
                                Text("No salt level information found.")
                                    .font(.footnote)
                                    .padding(10)
                            })
                    } else {
                        ForEach(data) { saltData in
                            //                        AreaMark(
                            //                            x: .value("Date", saltData.eventTime, unit: .month),
                            //                            y: .value("Salt (PPM)", saltData.salt)
                            //                        )
                            //                        .foregroundStyle(lineGradient.opacity(0.5))
                            //                        .alignsMarkStylesWithPlotArea()
                            //                        .accessibilityHidden(true)
                            
                            LineMark(
                                x: .value("Date", saltData.eventTime, unit: .month),
                                y: .value("Salt (PPM)", saltData.salt)
                            )
                            .accessibilityLabel("\(saltData.salt) PPM")
                            .foregroundStyle(lineGradient)
                            .lineStyle(StrokeStyle(lineWidth: 4))
                            .alignsMarkStylesWithPlotArea()
                        }
                        if let selectedData {
                            RuleMark(
                                x: .value("Selected", selectedData.eventTime, unit: .day)
                            )
                            .foregroundStyle(.gray.opacity(0.3))
                            .offset(yStart: -10)
                            .zIndex(-1)
                            .annotation(
                                position: .top, spacing: 0,
                                overflowResolution: .init(
                                    x: .fit(to: .chart),
                                    y: .disabled
                                )
                            ) {
                                if selectedData != nil {
                                    ChartPopoverView()
                                }
                            }
                        }
                    }
                }
                .chartXSelection(value: $rawSelectedDate)
            }
        }
        .onAppear {
            showEmptyState = data.isEmpty
        }
        .padding()
        .frame(height: 300)
        .animation(.easeInOut, value: showEmptyState)
        .task {
            do {
                loading = true
                try await networkManager.get(type: [SaltData].self, route: NetworkManager.saltLevelEndpoint) { response in
                    if response != nil {
                        data = response!
                        showEmptyState = false
                    }
                    
                    loading = false
                }
            } catch {
                showEmptyState = true
                loading = false
            }
        }
    }
    
    func fallback() -> Void {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromPascalCase
        decoder.dateDecodingStrategy = .customISO8601
        
        showEmptyState = false
        do {
            let json = """
            [{"id":419,"eventTime":"2023-07-22T21:01:48.4977+00:00","salt":2500},{"id":418,"eventTime":"2023-07-21T18:02:08.5534+00:00","salt":2600},{"id":417,"eventTime":"2023-07-21T06:48:22.2599+00:00","salt":2700},{"id":416,"eventTime":"2023-07-20T21:01:54.9847+00:00","salt":2500},{"id":415,"eventTime":"2023-07-19T15:13:36.8906+00:00","salt":2600},{"id":414,"eventTime":"2023-07-18T15:06:01.0964+00:00","salt":2500},{"id":413,"eventTime":"2023-07-17T06:51:29.2027+00:00","salt":2600},{"id":412,"eventTime":"2023-07-16T15:06:16.1239+00:00","salt":2500},{"id":411,"eventTime":"2023-07-15T18:05:00.5454+00:00","salt":2600},{"id":410,"eventTime":"2023-07-15T06:51:26.2787+00:00","salt":2700},{"id":409,"eventTime":"2023-07-15T04:10:32.9898+00:00","salt":2500},{"id":408,"eventTime":"2023-07-14T15:05:53.2726+00:00","salt":2500},{"id":407,"eventTime":"2023-07-14T01:43:13.7012+00:00","salt":2600},{"id":406,"eventTime":"2023-07-13T18:05:51.5807+00:00","salt":2500},{"id":405,"eventTime":"2023-07-13T06:51:25.2787+00:00","salt":2600},{"id":404,"eventTime":"2023-07-12T21:05:56.0484+00:00","salt":2400},{"id":403,"eventTime":"2023-07-12T00:05:27.4744+00:00","salt":2500},{"id":402,"eventTime":"2023-07-11T18:04:59.6365+00:00","salt":2600},{"id":401,"eventTime":"2023-07-11T06:51:19.299+00:00","salt":2700},{"id":400,"eventTime":"2023-07-10T21:05:00.0371+00:00","salt":2500},{"id":399,"eventTime":"2023-07-09T18:05:44.6802+00:00","salt":2600},{"id":398,"eventTime":"2023-07-09T06:51:18.4029+00:00","salt":2700},{"id":397,"eventTime":"2023-07-08T18:06:01.1447+00:00","salt":2600},{"id":396,"eventTime":"2023-07-08T16:30:14.4779+00:00","salt":2700},{"id":395,"eventTime":"2023-07-04T05:49:15.3196+00:00","salt":2600},{"id":394,"eventTime":"2023-07-03T22:39:27.6855+00:00","salt":2500},{"id":393,"eventTime":"2023-07-03T18:14:06.9667+00:00","salt":2500},{"id":392,"eventTime":"2023-07-03T16:22:05.2915+00:00","salt":2600},{"id":391,"eventTime":"2023-07-03T16:20:42.6116+00:00","salt":2600},{"id":390,"eventTime":"2023-07-03T15:51:16.2317+00:00","salt":2600},{"id":389,"eventTime":"2023-07-03T15:50:32.2091+00:00","salt":2600},{"id":388,"eventTime":"2023-07-03T05:15:11.2192+00:00","salt":2600},{"id":387,"eventTime":"2023-07-03T05:14:07.1959+00:00","salt":2600},{"id":386,"eventTime":"2023-07-02T18:38:39.1205+00:00","salt":2600},{"id":385,"eventTime":"2023-07-02T11:04:47.1137+00:00","salt":2500},{"id":384,"eventTime":"2023-07-01T23:51:12.8341+00:00","salt":2600},{"id":383,"eventTime":"2023-06-30T21:03:26.8598+00:00","salt":2500},{"id":382,"eventTime":"2023-06-30T20:55:06.5776+00:00","salt":2500},{"id":381,"eventTime":"2023-06-29T11:05:26.7396+00:00","salt":2500},{"id":380,"eventTime":"2023-06-28T23:51:08.4413+00:00","salt":2600},{"id":379,"eventTime":"2023-06-28T08:05:55.237+00:00","salt":2400},{"id":378,"eventTime":"2023-06-27T19:17:39.4851+00:00","salt":2500},{"id":377,"eventTime":"2023-06-27T19:13:29.3481+00:00","salt":2500},{"id":376,"eventTime":"2023-06-26T23:15:07.6831+00:00","salt":2500},{"id":375,"eventTime":"2023-06-25T11:05:22.2611+00:00","salt":2500},{"id":374,"eventTime":"2023-06-24T23:51:03.9726+00:00","salt":2600},{"id":373,"eventTime":"2023-06-24T10:14:45.1599+00:00","salt":2400},{"id":372,"eventTime":"2023-06-23T11:04:25.4533+00:00","salt":2400},{"id":371,"eventTime":"2023-06-23T08:05:39.5013+00:00","salt":2500},{"id":370,"eventTime":"2023-06-22T21:06:45.735+00:00","salt":2600},{"id":369,"eventTime":"2023-06-22T18:35:45.8216+00:00","salt":2600},{"id":368,"eventTime":"2023-06-21T14:05:07.8347+00:00","salt":2700},{"id":367,"eventTime":"2023-06-20T23:50:49.6983+00:00","salt":2800},{"id":366,"eventTime":"2023-06-19T23:51:04.1502+00:00","salt":2700},{"id":365,"eventTime":"2023-06-19T22:04:41.6375+00:00","salt":2600},{"id":364,"eventTime":"2023-06-19T17:21:08.4298+00:00","salt":2700},{"id":363,"eventTime":"2023-06-19T12:10:50.2083+00:00","salt":2600},{"id":362,"eventTime":"2023-06-17T11:05:02.5196+00:00","salt":2700},{"id":361,"eventTime":"2023-06-16T17:29:37.696+00:00","salt":2800},{"id":360,"eventTime":"2023-06-16T11:05:00.0471+00:00","salt":2700},{"id":359,"eventTime":"2023-06-15T23:50:45.8438+00:00","salt":2800},{"id":358,"eventTime":"2023-06-15T17:09:05.5393+00:00","salt":2700},{"id":357,"eventTime":"2023-06-14T11:04:23.0038+00:00","salt":2800},{"id":356,"eventTime":"2023-06-13T23:50:44.8216+00:00","salt":2900},{"id":355,"eventTime":"2023-06-11T23:51:07.3162+00:00","salt":2800},{"id":354,"eventTime":"2023-06-11T16:22:58.5472+00:00","salt":2700},{"id":353,"eventTime":"2023-06-11T14:05:35.0264+00:00","salt":2800},{"id":352,"eventTime":"2023-06-11T00:55:04.9083+00:00","salt":2900},{"id":351,"eventTime":"2023-06-05T14:05:03.1989+00:00","salt":2800},{"id":350,"eventTime":"2023-06-04T17:20:25.1884+00:00","salt":2700},{"id":349,"eventTime":"2023-06-03T11:04:55.1559+00:00","salt":2800},{"id":348,"eventTime":"2023-06-02T11:05:31.7952+00:00","salt":2900},{"id":347,"eventTime":"2023-06-01T23:50:45.5199+00:00","salt":3000},{"id":346,"eventTime":"2023-06-01T14:04:25.3784+00:00","salt":2800},{"id":345,"eventTime":"2023-05-31T11:04:51.0157+00:00","salt":2900},{"id":344,"eventTime":"2023-05-30T23:50:36.8167+00:00","salt":3000},{"id":343,"eventTime":"2023-05-29T11:04:57.3873+00:00","salt":2900},{"id":342,"eventTime":"2023-05-28T23:50:42.0238+00:00","salt":3000},{"id":341,"eventTime":"2023-05-28T14:04:22.8169+00:00","salt":2800},{"id":340,"eventTime":"2023-05-27T11:04:47.5412+00:00","salt":2900},{"id":339,"eventTime":"2023-05-26T23:50:34.3464+00:00","salt":3000},{"id":338,"eventTime":"2023-05-26T14:04:54.0762+00:00","salt":2800},{"id":337,"eventTime":"2023-05-24T23:50:33.5344+00:00","salt":2900},{"id":336,"eventTime":"2023-05-24T11:05:19.3234+00:00","salt":2800},{"id":335,"eventTime":"2023-05-23T23:51:02.996+00:00","salt":2900},{"id":334,"eventTime":"2023-05-23T11:04:37.6362+00:00","salt":2800},{"id":333,"eventTime":"2023-05-22T23:50:50.8432+00:00","salt":2900},{"id":332,"eventTime":"2023-05-22T14:04:42.2658+00:00","salt":2700},{"id":331,"eventTime":"2023-05-21T11:04:48.9745+00:00","salt":2800},{"id":330,"eventTime":"2023-05-20T23:50:38.6575+00:00","salt":2900},{"id":329,"eventTime":"2023-05-20T11:05:19.5745+00:00","salt":2800},{"id":328,"eventTime":"2023-05-19T23:50:30.3154+00:00","salt":2900},{"id":327,"eventTime":"2023-05-19T11:04:02.2216+00:00","salt":2800},{"id":326,"eventTime":"2023-05-18T23:50:51.8374+00:00","salt":2900},{"id":325,"eventTime":"2023-05-17T23:50:46.6054+00:00","salt":2800},{"id":324,"eventTime":"2023-05-17T14:05:03.4289+00:00","salt":2700},{"id":323,"eventTime":"2023-05-15T11:05:10.4203+00:00","salt":2800},{"id":322,"eventTime":"2023-05-14T23:50:28.0672+00:00","salt":2900},{"id":321,"eventTime":"2023-05-14T14:04:24.8219+00:00","salt":2800},{"id":320,"eventTime":"2023-05-13T11:04:17.6732+00:00","salt":2900},{"id":319,"eventTime":"2023-05-12T23:50:25.4239+00:00","salt":3000},{"id":318,"eventTime":"2023-05-12T11:05:06.2281+00:00","salt":2800},{"id":317,"eventTime":"2023-05-11T11:05:04.8548+00:00","salt":2900},{"id":316,"eventTime":"2023-05-10T23:50:24.6857+00:00","salt":3000},{"id":315,"eventTime":"2023-05-10T08:04:57.5893+00:00","salt":2800},{"id":314,"eventTime":"2023-05-08T23:51:03.8449+00:00","salt":2900},{"id":313,"eventTime":"2023-05-08T11:05:00.7059+00:00","salt":2800},{"id":312,"eventTime":"2023-05-07T11:05:05.3713+00:00","salt":2900},{"id":311,"eventTime":"2023-05-06T23:50:23.0973+00:00","salt":3000},{"id":310,"eventTime":"2023-05-06T11:05:03.9864+00:00","salt":2800},{"id":309,"eventTime":"2023-05-05T11:04:12.6382+00:00","salt":2900},{"id":308,"eventTime":"2023-05-04T23:50:20.4815+00:00","salt":3000},{"id":307,"eventTime":"2023-05-04T14:04:17.2623+00:00","salt":2800},{"id":306,"eventTime":"2023-05-03T11:04:59.955+00:00","salt":2900},{"id":305,"eventTime":"2023-05-02T23:50:19.8169+00:00","salt":3000},{"id":304,"eventTime":"2023-05-02T11:04:58.6472+00:00","salt":2900},{"id":303,"eventTime":"2023-05-01T23:50:18.4937+00:00","salt":3000},{"id":302,"eventTime":"2023-05-01T11:04:57.3395+00:00","salt":2900},{"id":301,"eventTime":"2023-04-30T23:50:18.1835+00:00","salt":3000},{"id":300,"eventTime":"2023-04-30T14:04:07.9462+00:00","salt":2800},{"id":299,"eventTime":"2023-04-29T11:04:34.6419+00:00","salt":2900},{"id":298,"eventTime":"2023-04-28T23:50:24.3936+00:00","salt":3000},{"id":297,"eventTime":"2023-04-28T11:04:29.278+00:00","salt":2800},{"id":296,"eventTime":"2023-04-27T23:50:16.1921+00:00","salt":2900},{"id":295,"eventTime":"2023-04-27T11:05:05.9803+00:00","salt":2800},{"id":294,"eventTime":"2023-04-26T23:50:15.8714+00:00","salt":2900},{"id":293,"eventTime":"2023-04-26T11:03:54.6155+00:00","salt":2800},{"id":292,"eventTime":"2023-04-25T11:04:31.3273+00:00","salt":2900},{"id":291,"eventTime":"2023-04-24T23:50:21.0913+00:00","salt":3000},{"id":290,"eventTime":"2023-04-23T23:50:21.5721+00:00","salt":2800},{"id":289,"eventTime":"2023-04-23T18:51:27.6589+00:00","salt":2700},{"id":288,"eventTime":"2023-04-23T14:04:58.239+00:00","salt":2600},{"id":287,"eventTime":"2023-04-20T23:50:17.9731+00:00","salt":2700},{"id":286,"eventTime":"2023-04-20T17:05:00.6761+00:00","salt":2600},{"id":285,"eventTime":"2023-04-20T11:04:16.8348+00:00","salt":2700},{"id":284,"eventTime":"2023-04-19T23:50:36.5989+00:00","salt":2800},{"id":283,"eventTime":"2023-04-19T11:04:39.5488+00:00","salt":2700},{"id":282,"eventTime":"2023-04-18T17:36:33.6815+00:00","salt":2600},{"id":281,"eventTime":"2023-04-18T14:05:08.7527+00:00","salt":2700},{"id":280,"eventTime":"2023-04-17T11:03:45.3523+00:00","salt":2800},{"id":279,"eventTime":"2023-04-16T23:50:32.1032+00:00","salt":2900},{"id":278,"eventTime":"2023-04-16T14:04:18.8832+00:00","salt":2700},{"id":277,"eventTime":"2023-04-15T23:50:26.7823+00:00","salt":2800},{"id":276,"eventTime":"2023-04-15T11:04:37.6145+00:00","salt":2700},{"id":275,"eventTime":"2023-04-14T11:04:23.3045+00:00","salt":2800},{"id":274,"eventTime":"2023-04-13T23:50:07.1112+00:00","salt":2900},{"id":273,"eventTime":"2023-04-13T11:04:51.9141+00:00","salt":2800},{"id":272,"eventTime":"2023-04-12T23:50:35.7298+00:00","salt":2900},{"id":271,"eventTime":"2023-04-11T23:50:30.4961+00:00","salt":2700},{"id":270,"eventTime":"2023-04-10T23:50:18.9217+00:00","salt":2600},{"id":269,"eventTime":"2023-04-10T18:49:27.0219+00:00","salt":2700},{"id":268,"eventTime":"2023-04-10T11:04:30.7721+00:00","salt":2800},{"id":267,"eventTime":"2023-04-09T23:50:14.6079+00:00","salt":2900},{"id":266,"eventTime":"2023-04-09T14:04:46.3411+00:00","salt":2600},{"id":265,"eventTime":"2023-04-08T11:04:12.4696+00:00","salt":2700},{"id":264,"eventTime":"2023-04-07T23:50:18.1241+00:00","salt":2800},{"id":263,"eventTime":"2023-04-07T14:04:04.6169+00:00","salt":2600},{"id":262,"eventTime":"2023-04-06T14:04:10.0638+00:00","salt":2700},{"id":261,"eventTime":"2023-04-05T23:50:17.9346+00:00","salt":2800},{"id":260,"eventTime":"2023-04-05T11:04:28.8574+00:00","salt":2700},{"id":259,"eventTime":"2023-04-04T23:50:12.6971+00:00","salt":2800},{"id":258,"eventTime":"2023-04-03T20:45:13.1465+00:00","salt":2600},{"id":257,"eventTime":"2023-04-03T20:33:32.6285+00:00","salt":2600},{"id":256,"eventTime":"2023-04-02T12:03:15.6089+00:00","salt":2700},{"id":255,"eventTime":"2023-04-02T00:49:35.398+00:00","salt":2800},{"id":254,"eventTime":"2023-04-01T09:03:29.5103+00:00","salt":2600},{"id":253,"eventTime":"2023-03-31T15:03:48.7058+00:00","salt":2500},{"id":252,"eventTime":"2023-03-31T09:04:04.931+00:00","salt":2600},{"id":251,"eventTime":"2023-03-30T12:03:33.5529+00:00","salt":2700},{"id":250,"eventTime":"2023-03-30T00:49:17.2278+00:00","salt":2800},{"id":249,"eventTime":"2023-03-29T21:02:51.8306+00:00","salt":2700},{"id":248,"eventTime":"2023-03-28T20:37:37.6649+00:00","salt":2700},{"id":247,"eventTime":"2023-03-28T19:27:48.4026+00:00","salt":2700},{"id":246,"eventTime":"2023-03-27T00:49:16.3311+00:00","salt":2900},{"id":245,"eventTime":"2023-03-26T13:59:28.8318+00:00","salt":2600},{"id":244,"eventTime":"2023-03-26T13:57:16.7923+00:00","salt":2600},{"id":243,"eventTime":"2023-03-25T16:30:44.2494+00:00","salt":2600},{"id":242,"eventTime":"2023-03-25T15:49:38.9069+00:00","salt":2600},{"id":241,"eventTime":"2023-03-25T14:23:18.0707+00:00","salt":2600},{"id":240,"eventTime":"2023-03-25T13:56:09.1894+00:00","salt":2600},{"id":239,"eventTime":"2023-03-22T12:03:36.4032+00:00","salt":2700},{"id":238,"eventTime":"2023-03-22T00:49:14.1777+00:00","salt":2800},{"id":237,"eventTime":"2023-03-21T09:04:01.1739+00:00","salt":2700},{"id":236,"eventTime":"2023-03-20T21:05:56.2539+00:00","salt":2600},{"id":235,"eventTime":"2023-03-20T17:29:20.1741+00:00","salt":2700},{"id":234,"eventTime":"2023-03-08T23:48:58.3192+00:00","salt":2900},{"id":233,"eventTime":"2023-03-08T14:03:14.8879+00:00","salt":2800},{"id":232,"eventTime":"2023-03-08T08:03:38.9281+00:00","salt":2900},{"id":231,"eventTime":"2023-03-07T21:20:05.3147+00:00","salt":2800},{"id":230,"eventTime":"2023-03-07T11:03:44.8576+00:00","salt":2800},{"id":229,"eventTime":"2023-03-06T23:48:58.1712+00:00","salt":2900},{"id":228,"eventTime":"2023-03-06T22:41:19.9431+00:00","salt":2800},{"id":227,"eventTime":"2023-02-22T23:48:50.3696+00:00","salt":3200},{"id":226,"eventTime":"2023-02-21T23:48:50.4884+00:00","salt":3100},{"id":225,"eventTime":"2023-02-21T11:03:37.2803+00:00","salt":3000},{"id":224,"eventTime":"2023-02-20T17:54:21.2884+00:00","salt":3100},{"id":223,"eventTime":"2023-02-07T23:48:52.2317+00:00","salt":3200},{"id":222,"eventTime":"2023-02-07T15:53:36.6961+00:00","salt":3000},{"id":221,"eventTime":"2023-02-06T23:48:41.8929+00:00","salt":3100},{"id":220,"eventTime":"2023-02-06T16:04:50.7168+00:00","salt":3000},{"id":219,"eventTime":"2023-02-05T23:48:35.5035+00:00","salt":3100},{"id":218,"eventTime":"2023-02-05T21:01:43.8752+00:00","salt":3000},{"id":217,"eventTime":"2023-02-05T08:03:06.042+00:00","salt":3100},{"id":216,"eventTime":"2023-02-04T18:02:18.9842+00:00","salt":3000},{"id":215,"eventTime":"2023-02-04T18:02:14.8763+00:00","salt":3100},{"id":214,"eventTime":"2023-01-27T19:50:30.4063+00:00","salt":3000},{"id":213,"eventTime":"2023-01-23T21:26:50.7756+00:00","salt":2900},{"id":212,"eventTime":"2023-01-22T22:42:29.4803+00:00","salt":2900}]
        """.data(using: .utf8)!
            
            data = try decoder.decode([SaltData].self, from: json)
        }
        catch {
            
        }
    }
    
    @ViewBuilder
    func ChartPopoverView() -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Salt Level")
                .font(.title3)
                .foregroundStyle(.gray)
            
            HStack(spacing: 4) {
                Text("\(Int(selectedData!.salt))")
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Text("PPM")
                    .font(.title3)
                    .textScale(.secondary)
                
            }
        }
        .padding()
        .background(Color.gray.opacity(0.3), in: .rect(cornerRadius: 10))
    }
}

#Preview {
    SaltLevelChartView()
    .environmentObject(NetworkManager())
}

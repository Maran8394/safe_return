import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe_return/blocs/enforcer/enforcer_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class EnforcerReports extends StatefulWidget {
  const EnforcerReports({super.key});

  @override
  State<EnforcerReports> createState() => _EnforcerReportsState();
}

class _EnforcerReportsState extends State<EnforcerReports> {
  EnforcerBloc? _enforcerBloc;

  @override
  void initState() {
    super.initState();
    _enforcerBloc = EnforcerBloc();
    _enforcerBloc!.add(GetReportsDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        leading: const BackButton(color: Colors.white),
        backgroundColor: Colors.blue,
        title: Text(
          "Reports",
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
          ),
          child: BlocBuilder<EnforcerBloc, EnforcerState>(
            bloc: _enforcerBloc,
            builder: (context, state) {
              if (state is GetEnforcerReportsDataInitState) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              } else if (state is GetEnforcerReportsDataFailedState) {
                return Center(
                  child: Text(state.errorMessage),
                );
              } else if (state is GetEnforcerReportsDataSuccessState) {
                final List<ChartData> chartData = [
                  ChartData(
                    'Solved',
                    state.reportsData.solved.toDouble(),
                  ),
                  ChartData(
                    'Unsolved',
                    state.reportsData.unSolved.toDouble(),
                  ),
                ];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: size.height * 0.4,
                      child: SfCircularChart(
                        legend: const Legend(
                          isVisible: true,
                          position: LegendPosition.bottom,
                        ),
                        series: <CircularSeries>[
                          PieSeries<ChartData, String>(
                            name: "Case Reports",
                            dataLabelSettings: const DataLabelSettings(
                              isVisible: true,
                              labelPosition: ChartDataLabelPosition.outside,
                              labelIntersectAction: LabelIntersectAction.shift,
                              connectorLineSettings: ConnectorLineSettings(
                                type: ConnectorType.curve,
                                length: '25%',
                              ),
                            ),
                            legendIconType: LegendIconType.circle,
                            dataSource: chartData,
                            pointColorMapper: (ChartData data, _) => data.color,
                            xValueMapper: (ChartData data, _) => data.x,
                            yValueMapper: (ChartData data, _) => data.y,
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
                    Row(
                      children: [
                        const Spacer(flex: 2),
                        Expanded(
                          flex: 2,
                          child: Text(
                            "Solved",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            state.reportsData.solved.toString(),
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.02),
                    Row(
                      children: [
                        const Spacer(flex: 2),
                        Expanded(
                          flex: 2,
                          child: Text(
                            "Unsolved",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            state.reportsData.unSolved.toString(),
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.02),
                    Row(
                      children: [
                        const Spacer(flex: 2),
                        Expanded(
                          flex: 2,
                          child: Text(
                            "Total",
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            state.reportsData.total.toString(),
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.02),
                  ],
                );
              } else {
                return const Center(
                  child: Text("Something is wrong!"),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y, [this.color]);
  final String x;
  final double y;
  final Color? color;
}

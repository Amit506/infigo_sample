import 'dart:math';

import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

const url2 =
    'https://firebasestorage.googleapis.com/v0/b/dominators-50608.appspot.com/o/test%2FAmit%20resume2.pdf?alt=media&token=08b50a75-7894-4d46-9b7e-52842f97709d';
const url1 =
    'https://firebasestorage.googleapis.com/v0/b/dominators-50608.appspot.com/o/test%2Fsample-the-seeker-resume.pdf?alt=media&token=43c7ee9b-0ff4-4a23-8999-5f89ae6e22be';

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  bool _isLoading = true;
  List<PDFDocument> document = [];
  final controller = PageController(initialPage: 2);

  @override
  void initState() {
    super.initState();
    loadDocument();
  }

  loadDocument() async {
    Future.wait([PDFDocument.fromURL(url2)]).then((value) {
      setState(() {
        document.addAll(value);
        document.addAll(value);
        document.addAll(value);

        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox.fromSize(
        size: size,
        child: SingleChildScrollView(
          child: Column(
            children: [
              DetailContainer(),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  color: Colors.white,
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: AssetImage(
                                  'assets/imgonline-com-ua-CompressToSize-ymhPwmYgzFEa_134.jpg'),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Amit Kumar',
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text('Marketing Resume',
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400))
                              ],
                            ),
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.blue[100],
                              child: Text('90',
                                  style: TextStyle(
                                      color: Colors.blue[800],
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800)),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        PdfView(
                            document: document,
                            loading: _isLoading,
                            callback: (index) {
                              // print(controller.page);
                            },
                            controller: controller),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            height: 30,
                            child: SmoothPageIndicator(
                              controller: controller, // PageController
                              count: 3,
                              textDirection: TextDirection.rtl,
                              effect: ExpandingDotsEffect(
                                  radius: 10,
                                  spacing: 3,
                                  expansionFactor: 2,
                                  dotWidth: 7,
                                  dotHeight: 7),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Resume Scores',
                            style: TextStyle(
                                color: Colors.blue[800],
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                            height: 300,
                            width: size.width,
                            child: BarChartSample2()),
                        SizedBox(height: 320, child: StepsWidget())
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DetailContainer extends StatelessWidget {
  const DetailContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: 100,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Colors.blue[800]!,
                Colors.blue[300]!,
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              tileMode: TileMode.clamp),
          borderRadius: BorderRadius.circular(12.0)),
      child: Row(children: [
        Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        Spacer(),
        Text(
          'Details',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        Spacer(),
      ]),
    );
  }
}

class PdfView extends StatelessWidget {
  final List<PDFDocument>? document;
  final bool loading;
  final PageController controller;
  final Function(int index) callback;
  const PdfView({
    Key? key,
    required this.document,
    required this.loading,
    required this.controller,
    required this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        clipBehavior: Clip.antiAlias,
        height: 450,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
        ),
        child: document != null
            ? Builder(
                builder: (context) {
                  final double height = MediaQuery.of(context).size.height;
                  return CarouselSlider(
                    options: CarouselOptions(
                        // onPageChanged: (index, p) {
                        //   callback(index);
                        //   // controller.jumpToPage(index);
                        // },
                        height: height,
                        viewportFraction: 1.0,
                        enlargeCenterPage: false,
                        enableInfiniteScroll: false
                        // autoPlay: false,
                        ),
                    items: document!
                        .map((item) => PDFViewer(
                              lazyLoad: false,
                              scrollDirection: Axis.vertical,
                              showNavigation: false,
                              showIndicator: false,
                              showPicker: false,
                              document: item,
                            ))
                        .toList(),
                  );
                },
              )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }
}

class BarChartSample2 extends StatefulWidget {
  const BarChartSample2({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => BarChartSample2State();
}

class BarChartSample2State extends State<BarChartSample2> {
  final Color leftBarColor = const Color(0xff53fdd7);
  // final Color rightBarColor = const Color(0xffff5182);
  final double width = 50;

  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;

  int touchedGroupIndex = -1;

  @override
  void initState() {
    super.initState();
    final barGroup1 = makeGroupData(0, 20, 12);
    final barGroup2 = makeGroupData(1, 50, 12);
    final barGroup3 = makeGroupData(2, 60, 5);

    final items = [
      barGroup1,
      barGroup2,
      barGroup3,
    ];

    rawBarGroups = items;

    showingBarGroups = rawBarGroups;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      color: Colors.white,
      child: BarChart(
        BarChartData(
          maxY: 100,
          barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
                tooltipBgColor: Colors.grey,
                getTooltipItem: (_a, _b, _c, _d) => null,
              ),
              touchCallback: (FlTouchEvent event, response) {
                if (response == null || response.spot == null) {
                  setState(() {
                    touchedGroupIndex = -1;
                    showingBarGroups = List.of(rawBarGroups);
                  });
                  return;
                }

                touchedGroupIndex = response.spot!.touchedBarGroupIndex;

                setState(() {
                  if (!event.isInterestedForInteractions) {
                    touchedGroupIndex = -1;
                    showingBarGroups = List.of(rawBarGroups);
                    return;
                  }
                  showingBarGroups = List.of(rawBarGroups);
                  if (touchedGroupIndex != -1) {
                    var sum = 0.0;
                    for (var rod
                        in showingBarGroups[touchedGroupIndex].barRods) {
                      sum += rod.y;
                    }
                    final avg = sum /
                        showingBarGroups[touchedGroupIndex].barRods.length;

                    showingBarGroups[touchedGroupIndex] =
                        showingBarGroups[touchedGroupIndex].copyWith(
                      barRods: showingBarGroups[touchedGroupIndex]
                          .barRods
                          .map((rod) {
                        return rod.copyWith(y: avg);
                      }).toList(),
                    );
                  }
                });
              }),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: SideTitles(showTitles: false),
            topTitles: SideTitles(showTitles: false),
            bottomTitles: SideTitles(
              showTitles: true,
              getTextStyles: (context, value) =>
                  const TextStyle(color: Color(0xff7589a2), fontSize: 12),
              margin: 20,
              getTitles: (double value) {
                switch (value.toInt()) {
                  case 0:
                    return 'Ist Resume';
                  case 1:
                    return '2nd Resume';
                  case 2:
                    return '3rd Resume';

                  default:
                    return '';
                }
              },
            ),
            leftTitles: SideTitles(
              showTitles: true,
              getTextStyles: (context, value) => const TextStyle(
                  color: Color(0xff7589a2),
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
              margin: 8,
              reservedSize: 28,
              interval: 1,
              getTitles: (value) {
                if (value == 0) {
                  return '0';
                } else if (value == 20) {
                  return '20';
                } else if (value == 40) {
                  return '40';
                } else if (value == 60) {
                  return '60';
                } else if (value == 80) {
                  return '80';
                } else if (value == 100) {
                  return '100';
                } else {
                  return '';
                }
              },
            ),
          ),
          borderData: FlBorderData(
            show: false,
          ),
          barGroups: showingBarGroups,
          gridData: FlGridData(show: false),
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(barsSpace: 4, x: x, barRods: [
      BarChartRodData(
        borderRadius: BorderRadius.circular(12),
        y: y1,
        colors: [Colors.blue[800]!, Colors.blue[200]!],
        width: width,
      ),
    ]);
  }
}

class StepsWidget extends StatefulWidget {
  StepsWidget({Key? key}) : super(key: key);

  static final _steps = [
    Step(
        state: StepState.indexed,
        isActive: true,
        title: const Text('Ist Resume'),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Learn to do it'),
            Text('Learn to do it'),
          ],
        )),
    Step(
        state: StepState.indexed,
        isActive: true,
        title: Text('2nd Resume'),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Learn This skill '),
            Text('Learn to do it'),
            Text('Learn This skill '),
          ],
        )),
    Step(
        state: StepState.indexed,
        isActive: true,
        title: Text('3rd Resume'),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Learn to do it'),
            Text('Learn to do it'),
          ],
        ))
  ];

  @override
  State<StepsWidget> createState() => _StepsWidgetState();
}

class _StepsWidgetState extends State<StepsWidget> {
  int step = 0;
  @override
  Widget build(BuildContext context) {
    return Stepper(
      physics: const NeverScrollableScrollPhysics(),
      steps: StepsWidget._steps,
      controlsBuilder: (context, {onStepCancel, onStepContinue}) {
        return const SizedBox();
      },
      currentStep: step,
      onStepTapped: (index) {
        setState(() {
          step = index;
        });
      },
    );
  }
}

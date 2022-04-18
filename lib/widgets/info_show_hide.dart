import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:flutter/material.dart';

class InfoShowOrHide extends StatefulWidget {
  final String title;
  final String imageUrl;
  final String data;
  final String dataParagraph;
  final List<dynamic> list;
  final List<double> sparkLineData;

  const InfoShowOrHide({
    Key? key,
    required this.title,
    this.data = "",
    this.list = const [],
    this.sparkLineData = const [],
    this.imageUrl = "",
    this.dataParagraph = "",
  }) : super(key: key);

  @override
  State<InfoShowOrHide> createState() => _InfoShowOrHideState();
}

class _InfoShowOrHideState extends State<InfoShowOrHide> {
  bool isDataVisibile = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.title.isNotEmpty)
          SizedBox(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: InkWell(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.title,
                            style: const TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: isDataVisibile
                              ? const Icon(
                                  Icons.arrow_drop_up_sharp,
                                  size: 40,
                                )
                              : const Icon(
                                  Icons.arrow_drop_down_sharp,
                                  size: 40,
                                ),
                        ),
                      )
                    ],
                  ),
                ),
                onTap: () => setState(() {
                  isDataVisibile = !isDataVisibile;
                }),
              ),
            ),
          ),
        //data with icon widget
        if (widget.data.isNotEmpty)
          Visibility(
            visible: isDataVisibile,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Row(
                children: [
                  if (widget.data == "null")
                    const SizedBox(
                      // width: MediaQuery.of(context).size.width,
                      // height: 40,
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          "Data not found",
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                  if (widget.data != "null")
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          widget.data,
                          textAlign: TextAlign.justify,
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                  if (widget.imageUrl.isNotEmpty)
                    Align(
                      alignment: Alignment.centerRight,
                      child: Image.network(
                        widget.imageUrl,
                        width: 30,
                        height: 30,
                      ),
                    ),
                ],
              ),
            ),
          ),
        //Data only
        if (widget.dataParagraph.isNotEmpty)
          Visibility(
            visible: isDataVisibile,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Stack(
                children: [
                  if (widget.dataParagraph == "null")
                    const SizedBox(
                      // width: MediaQuery.of(context).size.width,
                      // height: 40,
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          "Data not found",
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                  if (widget.dataParagraph != "null")
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          widget.dataParagraph,
                          textAlign: TextAlign.justify,
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        //list
        if (widget.list.isNotEmpty)
          Visibility(
            visible: isDataVisibile,
            child: SizedBox(
              height: 60,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                      itemCount: widget.list.length,
                      itemBuilder: (context, index) {
                        return Text(
                          widget.list[index],
                          style: const TextStyle(fontSize: 15),
                        );
                      }),
                ),
              ),
            ),
          ),

        //graph
        if (widget.sparkLineData.isNotEmpty)
          Visibility(
            visible: isDataVisibile,
            child: Row(children: [
              Expanded(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Center(
                    child: SizedBox(
                      // width: 400.0,
                      height: 200.0,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Sparkline(
                          useCubicSmoothing: true,
                          cubicSmoothingFactor: 0.1,
                          gridLinelabelPrefix: '\$',
                          enableGridLines: true,
                          // gridLineLabelPrecision: ,
                          // kLine: const ['max', 'min', 'first', 'last'],
                          // averageLine: true,
                          // averageLabel: false,
                          data: widget.sparkLineData,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ]),
          ),
      ],
    );
  }
}

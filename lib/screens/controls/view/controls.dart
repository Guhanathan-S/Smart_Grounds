import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_grounds/utils/network_connectivity/network_view.dart';
import '../../../utils/constants.dart';
import 'package:smart_grounds/utils/network_connectivity/internetError.dart';
import '../model/controls_model.dart';
import '../view_model/controls_view.dart';

class Controls extends StatefulWidget {
 const Controls({Key? key}) : super(key: key);

  @override
  _ControlsState createState() => _ControlsState();
}

class _ControlsState extends State<Controls> {
  List<bool> _expands = [];
  @override
  void dispose() {
    _expands.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    NetworkConnectivityViewModel networkConnectivity =
        context.watch<NetworkConnectivityViewModel>();
    ControlViewModel controlViewModel = context.watch<ControlViewModel>();
    return networkConnectivity.connectionStatus
        ? Container(
            margin: EdgeInsets.all(10),
            child: controlViewModel.loading
                ? Center(
                    child: CircularProgressIndicator(
                    color: primaryGreen,
                    strokeWidth: 4,
                  ))
                : ListView.separated(
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: 20,
                      );
                    },
                    itemCount: controlViewModel.totalArea,
                    itemBuilder: (context, index) {
                      _expands.clear();
                      _expands.addAll(List.generate(
                      controlViewModel.totalArea, (index) => false));
                      return ControlsCard(
                        index: index,
                        switchArea: controlViewModel.switchArea[index],
                        switchList: controlViewModel.switchesList[index],
                        expandData: _expands[index],
                      );
                    },
                  ))
        : InternetError();
  }
}

class ControlsCard extends StatefulWidget {
   ControlsCard(
      {required this.switchArea,
      required this.index,
      required this.switchList,
      required this.expandData});
  final String switchArea;
  final int index;
  final Switches switchList;
  late bool expandData;

  @override
  State<ControlsCard> createState() => _ControlsCardState();
}

class _ControlsCardState extends State<ControlsCard> {
  @override
  void didUpdateWidget(covariant ControlsCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(oldWidget.expandData != widget.expandData){
      widget.expandData = oldWidget.expandData;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ExpansionPanelList(
        dividerColor: primaryColor1,
        expansionCallback: (int index, bool expanded) {
          setState(() =>
            widget.expandData = !expanded);
        },
        children: [
          ExpansionPanel(
              backgroundColor: primaryGreen,
              headerBuilder: (context, isExpand) {
                return ListTile(
                  title: Text(
                    convertStringFormat(widget.switchArea),
                  ),
                  textColor: primaryColor1,
                  iconColor: primaryColor1,
                );
              },
              isExpanded: widget.expandData,
              body: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.switchList.switchId!.length,
                  itemBuilder: (context, index1) {
                    return SwitchListTile(
                        activeColor: whiteColor,
                        inactiveTrackColor: primaryColor3,
                        inactiveThumbColor: primaryColor3,
                        activeTrackColor: whiteColor,
                        title: Text(
                          convertStringFormat(
                              widget.switchList.switchId![index1]),
                          style: TextStyle(color: primaryColor1),
                        ),
                        value: widget.switchList.switchStates![index1] == 1
                            ? true
                            : false,
                        onChanged: (value) {
                          ControlViewModel().changeControls(
                              controls: 'controls/${widget.switchArea}',
                              switchs: widget.switchList.switchId![index1]
                                  .toString(),
                              state: value ? 1 : 0);
                        });
                  }))
        ],
      ),
    );
  }

  String convertStringFormat(String title) {
    StringBuffer titleData = StringBuffer();
    title.split("_").forEach((element) {
      titleData
        ..write(element[0].toUpperCase())
        ..write(element.substring(1))
        ..write(' ');
    });
    return titleData.toString();
  }
}

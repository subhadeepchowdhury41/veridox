import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../app_utils/app_constants.dart';

class DateTimePicker extends StatefulWidget {
  final Map<String, dynamic> widgetData;
  // final void Function(dynamic value) onChange;
  const DateTimePicker({
    Key? key,
    required this.widgetData,
    // required this.onChange,
  }) : super(key: key);

  @override
  State<DateTimePicker> createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  // Text
  DateTime? _date;
  DateTime _firstDate = DateTime.now();
  DateTime _lastDate = DateTime(2100);

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    try {
      setState(() {
        _date = DateFormat('dd/mm/yyyy').parse(widget.widgetData['value']);
        _firstDate =
            DateFormat('dd/mm/yyyy').parse(widget.widgetData['first-date']);
        _lastDate =
            DateFormat('dd/mm/yyyy').parse(widget.widgetData['last-date']);
      });
    } catch (e) {
      _date = DateTime.now();
    }
  }

  void _showDateTimePicker(FormFieldState formFieldState) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: _firstDate,
      lastDate: _lastDate,
    ).then((value) {
      if (value != null) {
        setState(() {
          _date = value;
        });
        formFieldState.didChange(_date);
        // String date = '${_date.day}/${_date.month}/${_date.year}';
        // widget.onChange(date);
      }
    });
  }

  String _getLabel() {
    String label = widget.widgetData['label'];

    if (widget.widgetData.containsKey('required') &&
        widget.widgetData['required'] == true) {
      label += '*';
    }
    return label;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      // height: 100,
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: containerElevationDecoration,
      child: FormField<DateTime>(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        initialValue: _date,
        validator: (date) {
          if (widget.widgetData.containsKey('required') && _date == null) {
            return 'Please select a date';
          }
          return null;
        },
        builder: (formState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _getLabel(),
                style: const TextStyle(
                  // fontWeight: FontWeight.bold,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Expanded(
                    flex: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        '${_date != null ? _date!.day : 'dd'}/${_date != null ? _date!.month : 'mm'}/${_date != null ? _date!.year : 'yyyy'}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: IconButton(
                        onPressed: () => setState(() {
                          _date = null;
                          formState.didChange(_date);
                        }),
                        icon: const Icon(
                          Icons.clear,
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: IconButton(
                        onPressed: () => _showDateTimePicker(formState),
                        icon: const Icon(
                          Icons.calendar_month,
                          size: 28,
                          color: CupertinoColors.activeBlue,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (formState.hasError)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: CupertinoColors.systemRed,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        formState.errorText!,
                        style: const TextStyle(
                          fontSize: 16,
                          color: CupertinoColors.systemRed,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

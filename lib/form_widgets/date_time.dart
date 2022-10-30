import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../app_providers/form_provider.dart';
import '../app_utils/app_constants.dart';

class DateTimePicker extends StatefulWidget {
  final Map<String, dynamic> widgetJson;
  final FormProvider provider;
  final String pageId;
  final String fieldId;
  const DateTimePicker({
    Key? key,
    required this.pageId,
    required this.fieldId,
    required this.provider,
    required this.widgetJson,
  }) : super(key: key);

  @override
  State<DateTimePicker> createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  DateTime? _date;
  DateTime _firstDate = DateTime.now();
  DateTime _lastDate = DateTime(2100);

  @override
  void initState() {
    _initializeValueFromData();
    super.initState();
  }

  void _initializeValueFromData() {
    String? date =
        widget.provider.getResult['${widget.pageId},${widget.fieldId}'];
    if (date != null) {
      DateTime initialDateFromDatabase = DateFormat("dd/mm/yyyy").parse(date);
      _date = initialDateFromDatabase;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    try {
      setState(() {
        _firstDate =
            DateFormat('dd/mm/yyyy').parse(widget.widgetJson['first-date']);
        _lastDate =
            DateFormat('dd/mm/yyyy').parse(widget.widgetJson['last-date']);
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
        widget.provider.updateData(
            pageId: widget.pageId,
            fieldId: widget.fieldId,
            value: '${_date!.day}/${_date!.month}/${_date!.year}');
        formFieldState.didChange(_date);
        // String date = '${_date.day}/${_date.month}/${_date.year}';
        // widget.onChange(date);
      }
    });
  }

  String _getLabel() {
    String label = widget.widgetJson['label'];

    if (widget.widgetJson.containsKey('required') &&
        widget.widgetJson['required'] == true) {
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
          if (widget.widgetJson.containsKey('required') &&
              widget.widgetJson['required'] == true &&
              _date == null) {
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
                        onPressed: () {
                          setState(() {
                            _date = null;
                          });

                          /// deleting date from _result
                          widget.provider
                              .deleteData('${widget.pageId},${widget.fieldId}');
                          formState.didChange(_date);
                        },
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

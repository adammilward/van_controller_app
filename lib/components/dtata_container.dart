import 'dart:convert';
import 'package:flutter/material.dart';

class DataContainer extends StatelessWidget {
  const DataContainer(this.payload, {
    this.onPayloadClear,
    super.key,
  });

  final Map<String, dynamic>? payload;
  final VoidCallback? onPayloadClear;

  String getPrettyJSONString(jsonObject) {
    var encoder = JsonEncoder.withIndent("     ");
    return encoder.convert(jsonObject);
  }

  @override
  Widget build(BuildContext context) {


    print("container rebuilt");
    return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Received Data',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  if (onPayloadClear != null)
                    IconButton(
                      onPressed: () {
                        // Clear received data
                        onPayloadClear?.call();
                      },
                      icon: const Icon(Icons.clear),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Text(
                      payload?.isEmpty ?? true
                          ? 'No data received'
                          : getPrettyJSONString(payload),
                      style: const TextStyle(fontFamily: 'monospace'),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
  }
}


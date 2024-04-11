import 'package:flutter/material.dart';

class Report extends StatelessWidget {
  const Report({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Summary:',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                  'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Details:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: [
                  CheckboxListTile(
                    title: Text('Item 1'),
                    subtitle: Text('Details about item 1'),
                    value: false,
                    onChanged: (value) {
                      // Handle checkbox state change
                    },
                  ),
                  CheckboxListTile(
                    title: Text('Item 2'),
                    subtitle: Text('Details about item 2'),
                    value: false,
                    onChanged: (value) {
                      // Handle checkbox state change
                    },
                  ),
                  // Add more CheckboxListTiles as needed
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

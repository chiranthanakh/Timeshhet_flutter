import 'package:flutter/material.dart';

class TimeSheetScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Navigation Header'),
            ),
            ListTile(
              title: Text('Menu Item 1'),
              onTap: () {},
            ),
            ListTile(
              title: Text('Menu Item 2'),
              onTap: () {},
            ),
          ],
        ),
      ),
      appBar: AppBar(
        toolbarHeight: 90.0,
        backgroundColor: Colors.white,
        title: Center(
          child: Image.asset(
            'assets/renew_logo.png',
            height: 60,
            fit: BoxFit.contain,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            icon: Image.asset('assets/hamberger_icon.png'),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        // actions: [
        //   IconButton(
        //     icon: Image.asset('assets/refresh_icon.png'),
        //     onPressed: () {},
        //   ),
        // ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(30),
          child: Column(
            children: [
              CircleAvatar(
                radius: 15,
                backgroundImage: AssetImage('assets/user_icon.png'),
              ),
              SizedBox(height: 5),
              Text(
                'Avinash',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Month/Year Section
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 8,
                    child: Text(
                      'Month/Year',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add, size: 24),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            // Week Navigation
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {},
                  ),
                  Text(
                    'Week Number',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            // Horizontal Scrollable Days Header and Table
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    child: Row(
                      children: List.generate(7, (index) {
                        return Container(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            'Day $index',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        );
                      }),
                    ),
                  ),
                  // Table Layout
                  Table(
                    columnWidths: {
                      0: FlexColumnWidth(),
                      1: FlexColumnWidth(),
                    },
                    children: [
                      TableRow(
                        children: [
                          Text('Column 1'),
                          Text('Column 2'),
                        ],
                      ),
                      // Repeat similar rows as needed
                    ],
                  ),
                ],
              ),
            ),
            // Total Hours Text
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Total Hours: ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            // Save & Draft and Submit Buttons
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Save & Draft'),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Submit'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
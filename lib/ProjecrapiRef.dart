import 'package:flutter/material.dart';

class ProjectListScreen extends StatefulWidget {
  @override
  _ProjectListScreenState createState() => _ProjectListScreenState();
}

class _ProjectListScreenState extends State<ProjectListScreen> {
  late Future<Map<String, dynamic>> _projectsFuture;

  @override
  void initState() {
    super.initState();
    // Call the API with mst_departments_id = "1"
   // _projectsFuture = getAllProjects("1");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Projects List')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _projectsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data?['data'].isEmpty == true) {
            return Center(child: Text('No projects found.'));
          }

          // Extract project data
          final projects = snapshot.data!['data'] as List<dynamic>;

          return ListView.builder(
            itemCount: projects.length,
            itemBuilder: (context, index) {
              final project = projects[index];
              return ListTile(
                title: Text(project['project_name']),
                subtitle: Text('Company Code: ${project['company_code']}'),
                trailing: Text('Profit Center: ${project['profit_center']}'),
              );
            },
          );
        },
      ),
    );
  }
}
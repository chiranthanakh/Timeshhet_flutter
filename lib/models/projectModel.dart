class Project {
  final String id;
  final String companyCode;
  final String projectName;
  final String profitCenter;

  Project({
    required this.id,
    required this.companyCode,
    required this.projectName,
    required this.profitCenter,
  });

  // Factory method to create a Project from JSON
  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['mst_projects_id'],
      companyCode: json['company_code'],
      projectName: json['project_name'],
      profitCenter: json['profit_center'],
    );
  }
}
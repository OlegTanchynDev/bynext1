class Issue {
  const Issue({
    this.id,
    this.category,
    this.categoryName,
    this.name,
    this.gradeEffect,
    this.type,
    this.issueEffectWf,
    this.issueEffectDc,
    this.issueEffectLs,
    this.issueEffectHd,
  });

  final int id;
  final int category;
  final String categoryName;
  final String name;
  final num gradeEffect;
  final int type;
  final bool issueEffectWf;
  final bool issueEffectDc;
  final bool issueEffectLs;
  final bool issueEffectHd;


  static final String _keyId = "id";
  static final String _keyCategory = "category";
  static final String _keyCategoryName = "category_name";
  static final String _keyName = "name";
  static final String _keyGradeEffect = "grade_effect";
  static final String _keyType = "type";
  static final String _keyIssueEffectWf = "issue_effect_wf";
  static final String _keyIssueEffectDc = "issue_effect_dc";
  static final String _keyIssueEffectLs = "issue_effect_ls";
  static final String _keyIssueEffectHd = "issue_effect_hd";


  Map<String, dynamic> toMap() =>
    <String, dynamic>{
      _keyId: id,
      _keyCategory: category,
      _keyCategoryName: categoryName,
      _keyName: name,
      _keyGradeEffect: gradeEffect,
      _keyType: type,
      _keyIssueEffectWf: issueEffectWf,
      _keyIssueEffectDc: issueEffectDc,
      _keyIssueEffectLs: issueEffectLs,
      _keyIssueEffectHd: issueEffectHd,
    };

  factory Issue.fromMap(Map<String, dynamic> map) =>
    Issue(
      id: map[_keyId] as int,
      category: map[_keyCategory] as int,
      categoryName: map[_keyCategoryName] as String,
      name: map[_keyName] as String,
      gradeEffect: map[_keyGradeEffect] as num,
      type: map[_keyType] as int,
      issueEffectWf: map[_keyIssueEffectWf] as bool,
      issueEffectDc: map[_keyIssueEffectDc] as bool,
      issueEffectLs: map[_keyIssueEffectLs] as bool,
      issueEffectHd: map[_keyIssueEffectHd] as bool,
    );
}
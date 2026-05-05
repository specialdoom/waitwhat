import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';

enum FeedbackCategory { bug, featureRequest, other }

extension FeedbackCategoryLabel on FeedbackCategory {
  String get label => switch (this) {
        FeedbackCategory.bug => 'Bug',
        FeedbackCategory.featureRequest => 'Feature Request',
        FeedbackCategory.other => 'Other',
      };

  String get githubLabel => switch (this) {
        FeedbackCategory.bug => 'bug',
        FeedbackCategory.featureRequest => 'enhancement',
        FeedbackCategory.other => 'feedback',
      };
}

class GithubService {
  static const _baseUrl = 'https://api.github.com';

  static bool get isConfigured =>
      kGithubToken.isNotEmpty &&
      kGithubOwner.isNotEmpty &&
      kGithubRepo.isNotEmpty;

  static Future<void> createIssue({
    required String title,
    required String body,
    required FeedbackCategory category,
    http.Client? client,
  }) async {
    if (!isConfigured) throw Exception('GitHub not configured');

    final c = client ?? http.Client();
    final response = await c.post(
      Uri.parse('$_baseUrl/repos/$kGithubOwner/$kGithubRepo/issues'),
      headers: {
        'Authorization': 'Bearer $kGithubToken',
        'Accept': 'application/vnd.github+json',
        'Content-Type': 'application/json',
        'X-GitHub-Api-Version': '2022-11-28',
      },
      body: jsonEncode({
        'title': '[${category.label}] $title',
        'body': body,
        'labels': ['feedback', category.githubLabel],
      }),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode != 201) {
      throw Exception('GitHub API error ${response.statusCode}: ${response.body}');
    }
  }
}

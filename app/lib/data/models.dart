import 'package:flutter/painting.dart';

enum ProjectStatus { inProgress, completed }

enum DetailSectionType { text, bullets, flowChips, image }

class TechItem {
  const TechItem(this.name, this.category, this.color, this.icon);

  final String name;
  final String category;
  final int color;

  /// Asset path under assets/devicons or assets/fontawesome.
  final String icon;
}

class DetailSection {
  const DetailSection(
    this.label,
    this.title, {
    this.body,
    this.items = const [],
    required this.type,
    this.image,
  });

  final String label;
  final String title;
  final String? body;
  final List<String> items;
  final DetailSectionType type;
  final String? image;
}

class Project {
  const Project({
    required this.slug,
    required this.title,
    required this.summary,
    required this.status,
    required this.period,
    required this.category,
    required this.featured,
    this.githubUrl,
    this.demoUrl,
    required this.thumbnail,
    required this.overview,
    required this.stack,
    required this.sections,
  });

  final String slug;
  final String title;
  final String summary;
  final ProjectStatus status;
  final String period;
  final String category;
  final bool featured;
  final String? githubUrl;
  final String? demoUrl;
  final String thumbnail;
  final String overview;
  final List<TechItem> stack;
  final List<DetailSection> sections;
}

class Award {
  const Award(this.title, this.event, this.date);

  final String title;
  final String event;
  final String date;
}

class LabelValue {
  const LabelValue(this.label, this.value);

  final String label;
  final String value;
}

class ToolkitGroup {
  const ToolkitGroup(this.label, this.color, this.items, this.width);

  final String label;
  final Color color;
  final List<TechItem> items;
  final double width;
}

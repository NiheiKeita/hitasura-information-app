import 'package:flutter/material.dart';

const _cBg = Color(0xFFFFFFFF);
const _cMain = Color(0xFF0284C7);
const _cGrayText = Color(0xFF64748B);

class InfoIntroPresentation extends StatelessWidget {
  const InfoIntroPresentation({
    super.key,
    required this.title,
    required this.sections,
  });

  final String title;
  final List<IntroSection> sections;

  @override
  Widget build(BuildContext context) {
    return IntroScaffold(
      title: title,
      sections: sections,
    );
  }
}

class IntroSection extends StatelessWidget {
  const IntroSection({super.key, required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _cBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: _cMain,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: const TextStyle(
              color: _cGrayText,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class IntroScaffold extends StatelessWidget {
  const IntroScaffold({
    super.key,
    required this.title,
    required this.sections,
  });

  final String title;
  final List<IntroSection> sections;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _cBg,
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            color: _cMain,
            fontWeight: FontWeight.w800,
          ),
        ),
        backgroundColor: _cBg,
        elevation: 0,
        surfaceTintColor: _cBg,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        itemCount: sections.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (_, index) => sections[index],
      ),
    );
  }
}

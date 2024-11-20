import 'package:flutter/material.dart';

class SectionWidget extends StatelessWidget {
  final Map<String, dynamic> section;

  const SectionWidget({super.key, required this.section});

  @override
  Widget build(BuildContext context) {
    final subsections =
        section['subsections'] as Map<String, dynamic>?; // Fetch subsections
    final content =
        section['content'] as List<dynamic>?; // Fetch section content

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display Section Name
            Text(
              section['name'] ?? 'Unknown Section',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Display Section Content (if available)
            if (content != null && content.isNotEmpty)
              ...content.map((line) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(line, style: const TextStyle(fontSize: 14)),
                  )),

            const SizedBox(height: 10),

            // Display Subsections (if available)
            if (subsections != null)
              ...subsections.entries.map((entry) {
                final subsection = entry.value as Map<String, dynamic>;
                final subsectionName =
                    subsection['name'] ?? 'Unknown Subsection';
                final subsectionContent =
                    subsection['content'] as List<dynamic>? ?? [];

                return Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Display Subsection Name
                      Text(
                        subsectionName,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      // Display Subsection Content
                      ...subsectionContent.map((line) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                            child: Text(line,
                                style: const TextStyle(fontSize: 14)),
                          )),
                    ],
                  ),
                );
              }).toList(),
          ],
        ),
      ),
    );
  }
}

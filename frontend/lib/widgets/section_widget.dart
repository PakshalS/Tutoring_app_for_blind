import 'package:flutter/material.dart';

class SectionWidget extends StatelessWidget {
  final Map<String, dynamic> section;

  const SectionWidget({super.key, required this.section});

  @override
  Widget build(BuildContext context) {
    final subsections = section['subsections'] as Map<String, dynamic>?;
    final content = section['content'] as List<dynamic>?;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: Card(
        elevation: 8.0, // Increased shadow for premium feel
        margin: const EdgeInsets.symmetric(vertical: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0), // Rounded edges
        ),
        color: Colors.yellow[700], // Bright yellow for contrast
        child: Padding(
          padding: const EdgeInsets.all(20.0), // Larger padding for clarity
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display Section Name
              Semantics(
                header: true,
                child: Text(
                  section['name'] ?? 'Unknown Section',
                  style: TextStyle(
                    fontSize: 28, // Larger text for accessibility
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // High contrast
                    letterSpacing: 1.2, // Premium typography
                  ),
                ),
              ),
              const SizedBox(height: 16), // Increased spacing
              // Display Section Content (if available)
              if (content != null && content.isNotEmpty)
                ...content.map((line) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Semantics(
                        child: Text(
                          line,
                          style: TextStyle(
                            fontSize: 22, // Larger text for accessibility
                            color: Colors.black87, // High contrast
                            height: 1.6, // Improved line spacing
                          ),
                        ),
                      ),
                    )),
              const SizedBox(height: 20), // Increased spacing
              // Display Subsections (if available)
              if (subsections != null)
                ...subsections.entries.map((entry) {
                  final subsection = entry.value as Map<String, dynamic>;
                  final subsectionName =
                      subsection['name'] ?? 'Unknown Subsection';
                  final subsectionContent =
                      subsection['content'] as List<dynamic>? ?? [];

                  return Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Display Subsection Name
                        Semantics(
                          header: true,
                          child: Text(
                            subsectionName,
                            style: TextStyle(
                              fontSize: 24, // Larger text for accessibility
                              fontWeight: FontWeight.w600,
                              color: Colors.black, // High contrast
                              letterSpacing: 1.0, // Premium typography
                            ),
                          ),
                        ),
                        const SizedBox(height: 12), // Increased spacing
                        // Display Subsection Content
                        ...subsectionContent.map((line) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Semantics(
                                child: Text(
                                  line,
                                  style: TextStyle(
                                    fontSize:
                                        20, // Larger text for accessibility
                                    color: Colors
                                        .black54, // Slightly muted for hierarchy
                                    height: 1.6, // Improved line spacing
                                  ),
                                ),
                              ),
                            )),
                      ],
                    ),
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }
}

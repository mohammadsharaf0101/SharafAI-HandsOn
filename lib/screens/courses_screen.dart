import 'package:flutter/material.dart';

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    // 1. DATA SOURCE: A list of maps containing course details.
    // In a real app, this data would come from an API or Database.
    final List<Map<String, String>> courses = [
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Our Courses'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          // 2. LOGOUT ACTION: Navigates back to the previous screen (Login).
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      // 3. LISTVIEW BUILDER: Efficiently creates a scrollable list.
      // It only renders the items currently visible on the screen.
      body: ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: courses.length, // Total number of items in the list.
        itemBuilder: (context, index) {
          // 4. UI COMPONENT (CARD): Defines the look of each individual course item.
          return Card(
            color: Colors.grey[900],
            margin: const EdgeInsets.only(bottom: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              // Leading Icon: Displays at the start of the row.
              leading: const CircleAvatar(
                backgroundColor: Colors.blue,
                child: Icon(Icons.book, color: Colors.white),
              ),
              // Title: Displays the course name.
              title: Text(
                courses[index]['title']!,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              // Subtitle: Displays the instructor and time.
              subtitle: Text(
                '${courses[index]['instructor']} • ${courses[index]['duration']}',
                style: const TextStyle(color: Colors.grey),
              ),
              // Trailing Icon: Displays at the end of the row (Action indicator).
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.blue, size: 18),
              onTap: () {
                // Future Step: Handle navigation to course details here.
                print("Clicked on: ${courses[index]['title']}");
              },
            ),
          );
        },
      ),
    );
  }
}
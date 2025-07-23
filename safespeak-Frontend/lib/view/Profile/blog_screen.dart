import 'package:flutter/material.dart';
import 'package:safespeak/models/blog_model.dart';
import 'package:safespeak/view/Profile/blog_detail_screen.dart';

final List<Blog> blogs = [
  Blog(
    title: '10 Ways to Protect Yourself from Cyberbullying',
    content: '''
Cyberbullying is the use of digital platforms to harass or intimidate others. It can affect a person's mental health, self-esteem, and confidence. Protecting yourself online requires awareness and proactive steps:

1. **Block and Report** – Never engage with bullies. Use the block and report features available on social platforms.
2. **Avoid Sharing Personal Details** – Do not share phone numbers, addresses, or sensitive information online.
3. **Keep Evidence** – Save screenshots or messages to use as proof if needed.
4. **Strong Privacy Settings** – Restrict who can see your posts or send you messages.
5. **Talk to Someone** – Inform parents, friends, or authorities if harassment persists.
6. **Use Anti-Cyberbullying Tools** – Apps like SafeSpeak can detect toxic messages and alert you.
7. **Don't Retaliate** – Responding to bullies often makes things worse.
8. **Secure Your Accounts** – Use strong passwords and enable two-factor authentication.
9. **Avoid Over-Sharing** – Think twice before posting personal images or updates.
10. **Seek Professional Help** – If cyberbullying affects your mental health, consult a counselor.

Remember, you are not alone. SafeSpeak aims to provide a safe digital environment for everyone.
    ''',
    imageUrl: 'assets/Images/19198142.jpg',
    date: DateTime(2025, 7, 23),
  ),
  Blog(
    title: 'Cyber Awareness: Essential Online Safety Tips',
    content: '''
With the growing presence of digital platforms, online safety is more crucial than ever. A single mistake can put your identity and data at risk. Here are essential tips to stay safe:

1. **Use Strong Passwords** – Avoid using birth dates or common words. Use a mix of uppercase, lowercase, numbers, and symbols.
2. **Enable 2FA (Two-Factor Authentication)** – Adds an extra layer of security to your accounts.
3. **Be Wary of Phishing Scams** – Do not click on suspicious links or attachments in emails or messages.
4. **Regularly Update Your Devices** – Outdated software can have security vulnerabilities.
5. **Don’t Share OTPs or Passwords** – Even with close friends or relatives.
6. **Monitor Your Online Presence** – Google yourself to see what information is public.
7. **Use Secure Networks** – Avoid using public Wi-Fi for transactions or sensitive activities.
8. **Back Up Your Data** – Store backups on secure cloud services or external devices.
9. **Use Antivirus & Anti-Malware Tools** – Keep them updated to detect harmful software.
10. **Educate Yourself** – Learn about the latest cyber threats and how to counter them.

Practicing these tips will keep you ahead of cybercriminals and help maintain your privacy.
    ''',
    imageUrl: 'assets/Images/10237987.jpg',
    date: DateTime(2025, 7, 20),
  ),
  Blog(
    title: 'How SafeSpeak Helps Combat Cyberbullying',
    content: '''
SafeSpeak is designed to protect users from harmful online content using AI and NLP technology. Here's how it works and how you can benefit from it:

**1. Real-Time Toxic Message Detection**
SafeSpeak scans incoming messages for harmful or toxic content and flags them instantly. It uses AI-driven classification models to detect hate speech, harassment, and bullying.

**2. Anonymous Reporting**
Users can report bullies anonymously, and SafeSpeak forwards these reports to authorities or community managers.

**3. Educational Awareness Blogs**
Apart from detecting harmful content, SafeSpeak includes blogs like this one to educate users about online safety and awareness.

**4. Community Support**
SafeSpeak promotes a positive online environment by encouraging kindness and responsible communication.

**5. Offline Mode**
Even when you’re offline, SafeSpeak can store past messages and allow you to review or report harmful content later.

By combining real-time detection, awareness, and community support, SafeSpeak is not just an app but a movement towards a safer internet.
    ''',
    imageUrl: 'assets/Images/safeSpeak_logo.png',
    date: DateTime(2025, 7, 18),
  ),
];

class BlogScreen extends StatefulWidget {
  const BlogScreen({Key? key}) : super(key: key);

  @override
  State<BlogScreen> createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredBlogs = blogs
        .where((blog) =>
            blog.title.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cyber Awareness Blog',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.2),
                  hintText: 'Search articles...',
                  hintStyle: const TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(Icons.search, color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),

            // Blog list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: filteredBlogs.length,
                itemBuilder: (context, index) {
                  final blog = filteredBlogs[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlogDetailScreen(blog: blog),
                        ),
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 8,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Row(
                          children: [
                            // Blog Image
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                              ),
                              child: Image.asset(
                                blog.imageUrl,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 10),
                            // Blog Text
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      blog.title,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      blog.content.length > 80
                                          ? '${blog.content.substring(0, 80)}...'
                                          : blog.content,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      'Published: ${blog.date.toLocal().toString().split(' ')[0]}',
                                      style: const TextStyle(
                                        color: Colors.white60,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

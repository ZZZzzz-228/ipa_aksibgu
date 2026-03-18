import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/centered_app_bar_title.dart';
class StudentContactsScreen extends StatelessWidget {
  const StudentContactsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const CenteredAppBarTitle(), // ✅ Новый компонент шапки
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: const Color(0xFFE3F2FD),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    'ЦЕНТР КАРЬЕРЫ',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Сибирский государственный университет науки и технологий имени академика М.Ф. Решетнёва, аэрокосмический колледж',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildContactItem(
                        Icons.phone,
                        '+7 (391) 264-06-59',
                        const Color(0xFF4A90E2),
                      ),
                      _buildContactItem(
                        Icons.phone,
                        '+7 (391) 264-57-35',
                        const Color(0xFF4A90E2),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildContactItem(
                        Icons.phone,
                        '+7 (391) 264-15-88',
                        const Color(0xFF4A90E2),
                      ),
                      _buildContactItem(
                        Icons.email,
                        'ak@sibsau.ru',
                        const Color(0xFF4A90E2),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildContactItem(
                        Icons.language,
                        'sibsau.ru',
                        const Color(0xFF4A90E2),
                      ),
                      _buildContactItem(
                        Icons.language,
                        'sibgu_ru',
                        const Color(0xFF4A90E2),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 32,
                            color: Colors.black87,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '08:00-17:00',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Icon(
                            Icons.people,
                            size: 32,
                            color: Colors.black87,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '500+ студентов',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Icon(
                            Icons.chat_bubble_outline,
                            size: 32,
                            color: Colors.black87,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Онлайн поддержка',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4A90E2), Color(0xFF64B5F6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    // ✅ Фото директора
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/contacts/director_photo.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Тимошев Павел Викторович',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Директор Аэрокосмического Колледжа',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF4A90E2),
                            ),
                          ),
                          const SizedBox(height: 16),
                          GestureDetector(
                            onTap: () async {
                              final uri = Uri.parse('mailto:ak@sibsau.ru');
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(uri, mode: LaunchMode.externalApplication);
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.email,
                                  size: 16,
                                  color: Color(0xFF4A90E2),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'ak@sibsau.ru',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF4A90E2),
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () async {
                              final uri = Uri.parse('tel:2919115');
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(uri, mode: LaunchMode.externalApplication);
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.phone,
                                  size: 16,
                                  color: Color(0xFF4A90E2),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  '2919115',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF4A90E2),
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Часы приёма: вторник, четверг с 14:00 до 16:00',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
  Widget _buildContactItem(IconData icon, String text, Color color) {
    return GestureDetector(
      onTap: () async {
        Uri? uri;
        if (icon == Icons.phone) {
          final cleanPhone = text.replaceAll(RegExp(r'[^\d+]'), '');
          uri = Uri.parse('tel:$cleanPhone');
        } else if (icon == Icons.email) {
          uri = Uri.parse('mailto:$text');
        } else if (icon == Icons.language) {
          final url = text.contains('://') ? text : 'https://$text';
          uri = Uri.parse(url);
        }
        if (uri != null && await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: color,
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
    );
  }
}

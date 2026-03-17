import 'package:flutter/material.dart';
import '../guest/guest_main_screen.dart';
import '../widgets/centered_app_bar_title.dart'; // ✅ Добавлен импорт

class StudentProfileScreen extends StatelessWidget {
  const StudentProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ✅ Новый AppBar
      appBar: AppBar(
        centerTitle: true,
        title: const CenteredAppBarTitle(),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Аватар и информация о студенте
            const CircleAvatar(
              radius: 50,
              backgroundColor: Color(0xFFE3F2FD),
              child: Icon(
                Icons.person,
                size: 50,
                color: Color(0xFF4A90E2),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Иванов Иван Иванович',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Студент группы ИСП 1-22',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 24),

            // Кнопки профиля
            _buildProfileButton(
              context,
              'Моё портфолио',
              Icons.folder_open,
                  () {},
            ),
            const SizedBox(height: 12),
            _buildProfileButton(
              context,
              'Создание резюме',
              Icons.description,
                  () {},
            ),
            const SizedBox(height: 12),
            _buildProfileButton(
              context,
              'Выйти',
              Icons.logout,
                  () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GuestMainScreen(),
                  ),
                );
              },
              isLogout: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileButton(
      BuildContext context,
      String title,
      IconData icon,
      VoidCallback onTap, {
        bool isLogout = false,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isLogout ? Colors.red : Colors.black87,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isLogout ? Colors.red : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

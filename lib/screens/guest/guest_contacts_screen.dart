import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/centered_app_bar_title.dart';
class GuestContactsScreen extends StatefulWidget {
  const GuestContactsScreen({super.key});
  @override
  State<GuestContactsScreen> createState() => _GuestContactsScreenState();
}
class _GuestContactsScreenState extends State<GuestContactsScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showMainTitle = false;
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }
  void _onScroll() {
    final shouldShow = _scrollController.offset > 40;
    if (shouldShow != _showMainTitle) setState(() => _showMainTitle = shouldShow);
  }
  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  pinned: true, floating: false, snap: false,
                  elevation: 0, scrolledUnderElevation: 0,
                  backgroundColor: Colors.transparent,
                  surfaceTintColor: Colors.transparent,
                  automaticallyImplyLeading: false,
                  toolbarHeight: 74,
                  flexibleSpace: _FrostedContactsHeader(showCenterTitle: _showMainTitle),
                ),
              ];
            },
            body: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              children: [
                // Основная информационная карточка
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.circular(12),
                  ),
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
                            'abiturient.sibsau.ru',
                            const Color(0xFF4A90E2),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Иконки с информацией
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: const [
                              Icon(Icons.access_time, size: 32, color: Colors.black87),
                              SizedBox(height: 8),
                              Text(
                                '08:00-17:00',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: const [
                              Icon(Icons.people, size: 32, color: Colors.black87),
                              SizedBox(height: 8),
                              Text(
                                '500+ студентов',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: const [
                              Icon(Icons.chat_bubble_outline, size: 32, color: Colors.black87),
                              SizedBox(height: 8),
                              Text(
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
                // Карточка директора
                _buildStaffCard(
                  name: 'Тимошев Павел Викторович',
                  position: 'Директор Аэрокосмического Колледжа',
                  email: 'ak@sibsau.ru',
                  phone: '2919115',
                  hours: 'Часы приёма: вторник, четверг с 14:00 до 16:00',
                  photo: 'assets/images/contacts/director_photo.png',
                  gradientColors: const [Color(0xFF4A90E2), Color(0xFF64B5F6)],
                ),
                const SizedBox(height: 16),
                // 11 дополнительных карточек сотрудников
                _buildStaffCard(
                  name: 'Шувалова М.А.',
                  position: 'Заместитель директора по Учебно-методической работе',
                  email: 'shuvalovav@sibsau.ru',
                  phone: '+7(391) 291-91-15',
                  hours: 'Часы приёма: понедельник, среда с 10:00 до 12:00',
                  photo: 'assets/images/contacts/staff_1.png',
                  gradientColors: const [Color(0xFF42A5F5), Color(0xFF90CAF9)],
                ),
                const SizedBox(height: 16),
                _buildStaffCard(
                  name: 'Чепенко С.А.',
                  position: 'Заместитель директора по Учебно-воспитательной работе',
                  email: 'students@sibsau.ru',
                  phone: '+7 (391) 264-15-88',
                  hours: 'Часы приёма: вторник, четверг с 10:00 до 12:00',
                  photo: 'assets/images/contacts/staff_2.png',
                  gradientColors: const [Color(0xFF66BB6A), Color(0xFFA5D6A7)],
                ),
                const SizedBox(height: 16),
                _buildStaffCard(
                  name: 'Позновский В.А.',
                  position: 'Заместитель директора по Учебно-производственной работе',
                  email: 'sidorova@sibsau.ru',
                  phone: '2641588',
                  hours: 'Часы приёма: понедельник, пятница с 14:00 до 16:00',
                  photo: 'assets/images/contacts/staff_3.png',
                  gradientColors: const [Color(0xFFAB47BC), Color(0xFFCE93D8)],
                ),
                const SizedBox(height: 16),
                _buildStaffCard(
                  name: 'Козырева С.В.',
                  position: 'Заместитель директора по внебюджетной деятельности',
                  email: 'kozyrevasv@sibsau.ru',
                  phone: '+7(391) 291-91-15',
                  hours: 'Часы приёма: среда с 10:00 до 12:00',
                  photo: 'assets/images/contacts/staff_4.png',
                  gradientColors: const [Color(0xFF29B6F6), Color(0xFF81D4FA)],
                ),
                const SizedBox(height: 16),
                _buildStaffCard(
                  name: 'Курдояк Е.Д.',
                  position: 'Заведующая отделением №1 Направление: «Технология машиностроения»',
                  email: 'students@sibsau.ru',
                  phone: '+7 (391) 264-15-88',
                  hours: 'Часы приёма: вторник с 14:00 до 16:00',
                  photo: 'assets/images/contacts/staff_5.png',
                  gradientColors: const [Color(0xFFEF5350), Color(0xFFEF9A9A)],
                ),
                const SizedBox(height: 16),
                _buildStaffCard(
                  name: 'Малиновская Е.А.',
                  position: 'Заведующая отделением №2 Направления: «Сварочное производство» «Контрольно-измерительные приборы и автоматика» «Эксплуатация летательных аппаратов»',
                  email: 'students@sibsau.ru',
                  phone: '+7 (391) 264-15-88',
                  hours: 'Часы приёма: четверг с 10:00 до 12:00',
                  photo: 'assets/images/contacts/staff_6.png',
                  gradientColors: const [Color(0xFFFFA726), Color(0xFFFFCC80)],
                ),
                const SizedBox(height: 16),
                _buildStaffCard(
                  name: 'Кольга Е.В.',
                  position: 'Заведующая отделением №5 Направление: «Безопасность автоматизированных систем» «Информационные системы и технологии»',
                  email: 'students@sibsau.ru',
                  phone: '+7 (391) 264-15-88',
                  hours: 'Часы приёма: понедельник с 14:00 до 16:00',
                  photo: 'assets/images/application_logo/icon42.png',
                  gradientColors: const [Color(0xFF5C6BC0), Color(0xFF9FA8DA)],
                ),
                const SizedBox(height: 16),
                _buildStaffCard(
                  name: 'Гурьянов А.С.',
                  position: 'Заведующий отделением №6 Направление:«Специальные машины и устройства» «Мобильная робототехника» «Автоматические системы управления»',
                  email: 'kuznetsov@sibsau.ru',
                  phone: '2640664',
                  hours: 'Часы приёма: ежедневно с 09:00 до 12:00',
                  photo: 'assets/images/application_logo/icon42.png',
                  gradientColors: const [Color(0xFF26A69A), Color(0xFF80CBC4)],
                ),
                const SizedBox(height: 16),
                _buildStaffCard(
                  name: 'Коткова Е.А.',
                  position: 'Заведующий отделением №7 Направление:«Безопасность автоматизированных систем» «Информационные системы и технологии»',
                  email: 'lebedeva@sibsau.ru',
                  phone: '+7 (391) 264-15-88',
                  hours: 'Часы приёма: ежедневно с 09:00 до 16:00',
                  photo: 'assets/images/application_logo/icon42.png',
                  gradientColors: const [Color(0xFFEC407A), Color(0xFFF48FB1)],
                ),
                const SizedBox(height: 16),
                _buildStaffCard(
                  name: 'Букалина Д.А.',
                  position: 'Заведующий отделением №8 Направление:«Сетевое администрирование» «Программирование и программное обеспечение»',
                  email: 'sokolov@sibsau.ru',
                  phone: '2640666',
                  hours: 'Часы приёма: среда, пятница с 10:00 до 14:00',
                  photo: 'assets/images/application_logo/icon42.png',
                  gradientColors: const [Color(0xFF7E57C2), Color(0xFFB39DDB)],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildStaffCard({
    required String name,
    required String position,
    required String email,
    required String phone,
    required String hours,
    required String photo,
    required List<Color> gradientColors,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const SizedBox(height: 40),
          // Фото сотрудника
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              image: DecorationImage(
                image: AssetImage(photo),
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
                Text(
                  name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  position,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: gradientColors[0],
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () async {
                    final uri = Uri.parse('mailto:$email');
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.email, size: 16, color: gradientColors[0]),
                      const SizedBox(width: 8),
                      Text(
                        email,
                        style: TextStyle(
                          fontSize: 13,
                          color: gradientColors[0],
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () async {
                    final cleanPhone = phone.replaceAll(RegExp(r'[^\d+]'), '');
                    final uri = Uri.parse('tel:$cleanPhone');
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.phone, size: 16, color: gradientColors[0]),
                      const SizedBox(width: 8),
                      Text(
                        phone,
                        style: TextStyle(
                          fontSize: 13,
                          color: gradientColors[0],
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  hours,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
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
// ─────────────────────────────────────────────────────────────────────────────
// Frosted header для страницы Контакты:
// при скролле иконка и «Центр карьеры» исчезают, появляется «Контакты»
// ─────────────────────────────────────────────────────────────────────────────
class _FrostedContactsHeader extends StatelessWidget {
  final bool showCenterTitle;
  const _FrostedContactsHeader({required this.showCenterTitle});
  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Матовый фон — появляется плавно
          AnimatedOpacity(
            duration: const Duration(milliseconds: 220),
            opacity: showCenterTitle ? 1 : 0,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
              child: Container(color: Colors.white.withOpacity(0.72)),
            ),
          ),
          // «Центр карьеры» — исчезает при скролле
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 220),
                  opacity: showCenterTitle ? 0 : 1,
                  child: const CenteredAppBarTitle(),
                ),
              ),
            ),
          ),
          // «Контакты» — плавно появляется по центру при скролле
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.center,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 220),
                  opacity: showCenterTitle ? 1 : 0,
                  child: AnimatedSlide(
                    duration: const Duration(milliseconds: 220),
                    offset: showCenterTitle ? Offset.zero : const Offset(0, -0.15),
                    child: const Text('Контакты', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black87)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

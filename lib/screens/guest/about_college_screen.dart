import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/centered_app_bar_title.dart';
import 'career_guidance_screen.dart';
import 'document_submission_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Избранные специальности ("звёздочка")
// ─────────────────────────────────────────────────────────────────────────────

class FavoriteSpecialtyStore {
  FavoriteSpecialtyStore._();
  static final FavoriteSpecialtyStore instance = FavoriteSpecialtyStore._();
  final ValueNotifier<Set<String>> favorites = ValueNotifier(<String>{});
  bool isFavorite(String id) => favorites.value.contains(id);
  void toggle(String id) {
    final next = Set<String>.from(favorites.value);
    if (next.contains(id)) { next.remove(id); } else { next.add(id); }
    favorites.value = next;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Модель специальности (добавлены поля: квалификация, карьера, навыки, зарплата)
// ─────────────────────────────────────────────────────────────────────────────

class Specialty {
  final String id;
  final String title;
  final String shortTitle;
  final String code;
  final String description;
  final String duration;
  final String form;
  final IconData icon;
  final Color color;
  final String qualification;
  final String career;
  final String skills;
  final String salary;
  const Specialty({
    required this.id, required this.title, required this.shortTitle,
    required this.code, required this.description, required this.duration,
    required this.form, required this.icon, required this.color,
    required this.qualification, required this.career, required this.skills,
    required this.salary,
  });
}

const List<Specialty> specialties = [
  Specialty(
    id: 'Сетевое и системное администрирование', title: 'Сетевое и системное администрирование', shortTitle: 'Сетевое администрирование', code: '09.02.06',
    description: 'Специальность готовит специалистов по установке, настройке и обслуживанию сетевого оборудования, серверов и операционных систем. Выпускники работают системными администраторами, сетевыми инженерами и IT-специалистами.',
    duration: '3 года 10 месяцев', form: 'Очная / Заочная', icon: Icons.lan, color: Color(0xFF1565C0),
    qualification: 'Сетевой и системный администратор',
    career: 'Системный администратор, сетевой инженер, DevOps-инженер, специалист технической поддержки',
    skills: 'Linux/Windows Server, настройка сетей, виртуализация, мониторинг серверов',
    salary: 'от 45 000 ₽',
  ),
  Specialty(
    id: 'Информационные системы и программирование', title: 'Информационные системы и программирование', shortTitle: 'ИС и программирование', code: '09.02.07',
    description: 'Обучение разработке программного обеспечения, созданию веб-приложений и информационных систем. Специальность охватывает языки программирования, базы данных, алгоритмы и проектирование ПО.',
    duration: '3 года 10 месяцев', form: 'Очная', icon: Icons.code, color: Color(0xFF0288D1),
    qualification: 'Программист / Разработчик',
    career: 'Frontend/Backend-разработчик, мобильный разработчик, тестировщик ПО, аналитик',
    skills: 'Python, Java, C#, SQL, HTML/CSS/JS, Git, алгоритмы и структуры данных',
    salary: 'от 60 000 ₽',
  ),
  Specialty(
    id: 'Обеспечение информационной безопасности телекоммуникационных систем', title: 'Обеспечение информационной безопасности телекоммуникационных систем', shortTitle: 'ИБ телекоммуникаций', code: '10.02.03',
    description: 'Специальность по защите информации в телекоммуникационных системах и сетях. Включает криптографию, защиту каналов связи и противодействие сетевым атакам.',
    duration: '2 года 10 месяцев', form: 'Очная', icon: Icons.security, color: Color(0xFF00695C),
    qualification: 'Техник по защите информации',
    career: 'Специалист по ИБ, пентестер, аналитик SOC, администратор средств защиты',
    skills: 'Криптография, сетевая безопасность, анализ угроз, настройка МСЭ и IDS/IPS',
    salary: 'от 55 000 ₽',
  ),
  Specialty(
    id: 'Обеспечение информационной безопасности автоматизированных систем', title: 'Обеспечение информационной безопасности автоматизированных систем', shortTitle: 'ИБ автоматизированных систем', code: '10.02.04',
    description: 'Подготовка специалистов по защите автоматизированных информационных систем. Студенты изучают методы анализа уязвимостей, управление доступом и аудит безопасности.',
    duration: '2 года 10 месяцев', form: 'Очная', icon: Icons.shield, color: Color(0xFF2E7D32),
    qualification: 'Техник по защите информации',
    career: 'Аудитор информационной безопасности, специалист по защите АСУ ТП, инженер ИБ',
    skills: 'Аудит безопасности, управление доступом, SIEM-системы, анализ уязвимостей',
    salary: 'от 55 000 ₽',
  ),
  Specialty(
    id: 'Техническая эксплуатация и обслуживание электрического и электромеханического оборудования (по отраслям)', title: 'Техническая эксплуатация и обслуживание электрического и электромеханического оборудования (по отраслям)', shortTitle: 'Электрооборудование', code: '13.02.11',
    description: 'Специальность по технической эксплуатации и обслуживанию электрического и электромеханического оборудования различных отраслей промышленности.',
    duration: '3 года 10 месяцев', form: 'Очная / Заочная', icon: Icons.electrical_services, color: Color(0xFFF57F17),
    qualification: 'Техник-электромеханик',
    career: 'Электромеханик, наладчик электрооборудования, энергетик предприятия',
    skills: 'Электрические схемы, наладка оборудования, ремонт электродвигателей, ПУЭ',
    salary: 'от 40 000 ₽',
  ),
  Specialty(
    id: 'Специальные машины и устройства', title: 'Специальные машины и устройства', shortTitle: 'Спецмашины и устройства', code: '17.02.12',
    description: 'Обучение проектированию, изготовлению и обслуживанию специальных машин и механизмов для промышленности.',
    duration: '3 года 10 месяцев', form: 'Очная', icon: Icons.precision_manufacturing, color: Color(0xFF6A1B9A),
    qualification: 'Техник-механик',
    career: 'Инженер-конструктор, техник по спецмашинам, мастер производственного участка',
    skills: 'Черчение и САПР, обработка металлов, сборка механизмов, контроль качества',
    salary: 'от 42 000 ₽',
  ),
  Specialty(
    id: 'Технология машиностроения', title: 'Технология машиностроения', shortTitle: 'Технология машиностроения', code: '15.02.08',
    description: 'Подготовка техников-технологов для машиностроительного производства. Охватывает металлообработку, станочное оборудование и технологические процессы.',
    duration: '3 года 10 месяцев', form: 'Очная / Заочная', icon: Icons.settings, color: Color(0xFF4E342E),
    qualification: 'Техник-технолог',
    career: 'Технолог машиностроительного производства, оператор ЧПУ, мастер цеха',
    skills: 'Программирование ЧПУ, технологические процессы, метрология, чтение чертежей',
    salary: 'от 45 000 ₽',
  ),
  Specialty(
    id: 'Мехатроника и мобильная робототехника (по отраслям)', title: 'Мехатроника и мобильная робототехника (по отраслям)', shortTitle: 'Мехатроника и робототехника', code: '15.02.16',
    description: 'Современная специальность на стыке механики, электроники и программирования. Студенты создают роботизированные системы и мобильные роботы для различных отраслей.',
    duration: '3 года 10 месяцев', form: 'Очная', icon: Icons.smart_toy, color: Color(0xFF0277BD),
    qualification: 'Техник-мехатроник',
    career: 'Инженер-робототехник, программист роботов, наладчик автоматизированных линий',
    skills: 'Arduino/Raspberry Pi, программирование контроллеров, 3D-моделирование, сенсоры',
    salary: 'от 50 000 ₽',
  ),
  Specialty(
    id: 'Сооружение и эксплуатация газонефтепроводов и газонефтехранилищ (прикладная геология, горное дело, нефтегазовое дело и геодезия)', title: 'Сооружение и эксплуатация газонефтепроводов и газонефтехранилищ (прикладная геология, горное дело, нефтегазовое дело и геодезия)', shortTitle: 'Газонефтепроводы', code: '21.02.03',
    description: 'Специальность по сооружению и эксплуатации трубопроводного транспорта нефти и газа. Подготовка специалистов для нефтегазовой отрасли.',
    duration: '3 года 10 месяцев', form: 'Очная / Заочная', icon: Icons.oil_barrel, color: Color(0xFF558B2F),
    qualification: 'Техник по эксплуатации трубопроводов',
    career: 'Оператор нефтеперекачивающей станции, техник-эксплуатационник, инженер ГНП',
    skills: 'Трубопроводный транспорт, диагностика, сварочные работы, экология',
    salary: 'от 55 000 ₽',
  ),
  Specialty(
    id: 'Сварочное производство', title: 'Сварочное производство', shortTitle: 'Сварочное производство', code: '22.02.06',
    description: 'Подготовка специалистов в области технологии сварочного производства. Обучение современным методам сварки и контроля качества сварных соединений.',
    duration: '3 года 10 месяцев', form: 'Очная', icon: Icons.local_fire_department, color: Color(0xFFBF360C),
    qualification: 'Техник-сварщик',
    career: 'Сварщик, инженер-технолог сварочного производства, контролёр качества',
    skills: 'MIG/MAG, TIG, ручная дуговая сварка, дефектоскопия, чтение чертежей',
    salary: 'от 50 000 ₽',
  ),
  Specialty(
    id: 'Техническое обслуживание авиационных двигателей', title: 'Техническое обслуживание авиационных двигателей', shortTitle: 'Авиационные двигатели', code: '25.02.04',
    description: 'Специальность по техническому обслуживанию и ремонту авиационных двигателей. Выпускники работают на авиационных предприятиях и в авиакомпаниях.',
    duration: '3 года 10 месяцев', form: 'Очная', icon: Icons.flight, color: Color(0xFF1A237E),
    qualification: 'Техник по авиационным двигателям',
    career: 'Авиатехник, инженер по ТО двигателей, специалист авиаремонтного завода',
    skills: 'Газотурбинные двигатели, диагностика, авиационные материалы, регламент ТО',
    salary: 'от 55 000 ₽',
  ),
  Specialty(
    id: 'Контроль работы измерительных приборов', title: 'Контроль работы измерительных приборов', shortTitle: 'Измерительные приборы', code: '12.02.11',
    description: 'Обучение методам контроля, настройки и поверки измерительного оборудования. Специалисты востребованы в промышленности и лабораториях.',
    duration: '2 года 10 месяцев', form: 'Очная', icon: Icons.speed, color: Color(0xFF37474F),
    qualification: 'Техник-метролог',
    career: 'Метролог, контролёр ОТК, калибровщик, инженер по качеству',
    skills: 'Метрология, поверка приборов, стандартизация, работа с эталонами',
    salary: 'от 40 000 ₽',
  ),
  Specialty(
    id: 'Электро‑ и теплоэнергетика', title: 'Электро‑ и теплоэнергетика', shortTitle: 'Электро‑ и теплоэнергетика', code: '13.02.02',
    description: 'Подготовка специалистов для энергетической отрасли. Охватывает электрические сети, тепловые установки и системы энергоснабжения.',
    duration: '3 года 10 месяцев', form: 'Очная / Заочная', icon: Icons.bolt, color: Color(0xFFE65100),
    qualification: 'Техник-энергетик',
    career: 'Электромонтёр, энергетик, техник по обслуживанию ТЭЦ, диспетчер энергосистем',
    skills: 'Электрические сети, тепловые установки, релейная защита, энергоаудит',
    salary: 'от 45 000 ₽',
  ),
  Specialty(
    id: 'Аэронавигация и эксплуатация авиационной и ракетно‑космической техники', title: 'Аэронавигация и эксплуатация авиационной и ракетно‑космической техники', shortTitle: 'Аэронавигация', code: '25.02.01',
    description: 'Специальность по эксплуатации авиационной и ракетно-космической техники. Подготовка специалистов для авиационно-космической отрасли.',
    duration: '3 года 10 месяцев', form: 'Очная', icon: Icons.rocket_launch, color: Color(0xFF283593),
    qualification: 'Техник по авиационной и РК технике',
    career: 'Техник аэронавигации, инженер РКТ, специалист космодрома, авиадиспетчер',
    skills: 'Аэродинамика, навигационные системы, радиоэлектроника, ракетные двигатели',
    salary: 'от 55 000 ₽',
  ),
  Specialty(
    id: 'Экономика и бухгалтерский учет', title: 'Экономика и бухгалтерский учет', shortTitle: 'Экономика и бухучёт', code: '38.02.01',
    description: 'Специальность по экономике, финансам и бухгалтерскому учёту. Выпускники работают бухгалтерами, экономистами и финансовыми аналитиками.',
    duration: '2 года 10 месяцев', form: 'Очная / Заочная', icon: Icons.account_balance_wallet, color: Color(0xFF00796B),
    qualification: 'Бухгалтер / Экономист',
    career: 'Бухгалтер, экономист, аудитор, финансовый аналитик, налоговый консультант',
    skills: '1С:Бухгалтерия, налогообложение, финансовый анализ, Excel, отчётность',
    salary: 'от 35 000 ₽',
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
// Обучение (добавлены поля: для кого, что получите, формат)
// ─────────────────────────────────────────────────────────────────────────────

enum EducationFilter { additional, courses }
enum EducationType { additional, courses }

class EducationProgram {
  final EducationType type;
  final String title;
  final String description;
  final String duration;
  final String details;
  final IconData icon;
  final Color color;
  final String targetAudience;
  final String outcome;
  final String format;
  const EducationProgram({required this.type, required this.title, required this.description, required this.duration, required this.details, required this.icon, required this.color, required this.targetAudience, required this.outcome, required this.format});
}

const List<EducationProgram> educationPrograms = [
  EducationProgram(type: EducationType.additional, title: 'Веб-разработка (Full Stack)', description: 'HTML, CSS, JavaScript, React, Node.js — от основ до практики.', duration: '6 месяцев', details: 'Курс охватывает полный стек веб-разработки: вёрстка, стилизация, JavaScript, фреймворки React и Node.js. После завершения курса вы сможете создавать современные веб-приложения и работать как фронтенд, так и бэкенд разработчиком.', icon: Icons.web, color: Color(0xFF1565C0),
    targetAudience: 'Для начинающих и тех, кто хочет сменить профессию на IT',
    outcome: 'Сертификат о доп. образовании, портфолио из 3+ проектов',
    format: 'Очно, 3 раза в неделю по 2 часа',
  ),
  EducationProgram(type: EducationType.additional, title: '1С: Бухгалтерия', description: 'Практический курс по работе с 1С:Бухгалтерия 8.3.', duration: '3 месяца', details: 'Освоите работу в программе 1С:Бухгалтерия 8.3: ввод первичных документов, учёт расчётов с контрагентами, формирование отчётности. Курс предназначен для начинающих бухгалтеров и специалистов по учёту.', icon: Icons.calculate, color: Color(0xFF00695C),
    targetAudience: 'Для начинающих бухгалтеров и экономистов',
    outcome: 'Сертификат 1С:Профессионал, навыки ведения учёта',
    format: 'Очно, 2 раза в неделю по 3 часа',
  ),
  EducationProgram(type: EducationType.additional, title: 'AutoCAD для инженеров', description: 'Черчение и проектирование: 2D/3D основы.', duration: '4 месяца', details: 'Научитесь создавать технические чертежи и трёхмерные модели в AutoCAD. Курс включает 2D-черчение, 3D-моделирование, оформление чертежей по ГОСТ.', icon: Icons.design_services, color: Color(0xFF6A1B9A),
    targetAudience: 'Для студентов технических специальностей и инженеров',
    outcome: 'Удостоверение, навыки работы с AutoCAD 2D/3D',
    format: 'Очно, 2 раза в неделю по 2,5 часа',
  ),
  EducationProgram(type: EducationType.additional, title: 'Основы кибербезопасности', description: 'Уязвимости, защита инфраструктуры, базовые практики.', duration: '5 месяцев', details: 'Курс знакомит с основными угрозами информационной безопасности, методами защиты сетей и систем, основами криптографии. Вы научитесь выявлять уязвимости и применять инструменты защиты информации.', icon: Icons.lock, color: Color(0xFF2E7D32),
    targetAudience: 'Для студентов IT-направлений и всех интересующихся ИБ',
    outcome: 'Сертификат, базовые навыки пентеста и защиты сетей',
    format: 'Очно, 2 раза в неделю по 2 часа + лабораторные',
  ),
  EducationProgram(type: EducationType.courses, title: 'Математика для поступающих', description: 'Алгебра, геометрия, типовые задачи — интенсив.', duration: '2 месяца', details: 'Интенсивная подготовка к поступлению: алгебра, геометрия, тригонометрия, типовые задачи вступительных испытаний. Занятия в малых группах, разбор типичных ошибок.', icon: Icons.functions, color: Color(0xFFF57F17),
    targetAudience: 'Для школьников 9–11 классов, поступающих в колледж',
    outcome: 'Уверенное решение задач вступительных экзаменов',
    format: 'Очно, 3 раза в неделю, группы до 12 человек',
  ),
  EducationProgram(type: EducationType.courses, title: 'Русский язык и изложение', description: 'Орфография, пунктуация, сочинения и изложение.', duration: '2 месяца', details: 'Подготовка по русскому языку: повторение орфографии и пунктуации, практика написания изложений и сочинений. Разбор типовых ошибок и заданий вступительных испытаний.', icon: Icons.menu_book, color: Color(0xFFBF360C),
    targetAudience: 'Для школьников, готовящихся к поступлению',
    outcome: 'Грамотность, уверенное написание изложений и сочинений',
    format: 'Очно, 3 раза в неделю, группы до 10 человек',
  ),
  EducationProgram(type: EducationType.courses, title: 'Информатика — базовый курс', description: 'Алгоритмы, основы программирования, практика.', duration: '1,5 месяца', details: 'Базовая подготовка по информатике: алгоритмы и основы программирования, работа с офисными программами, устройство компьютера.', icon: Icons.computer, color: Color(0xFF0277BD),
    targetAudience: 'Для школьников без опыта в программировании',
    outcome: 'Основы алгоритмизации, уверенная работа с ПК',
    format: 'Очно, 2 раза в неделю с практикой на компьютерах',
  ),
  EducationProgram(type: EducationType.courses, title: 'Физика для технических специальностей', description: 'Механика, электричество, термодинамика — подготовка.', duration: '2 месяца', details: 'Подготовительный курс по физике: механика, молекулярная физика, электричество и магнетизм, оптика. Разбор задач вступительных испытаний и практические лабораторные работы.', icon: Icons.science, color: Color(0xFF37474F),
    targetAudience: 'Для школьников, поступающих на технические специальности',
    outcome: 'Уверенное решение задач по физике, понимание основ',
    format: 'Очно, 2 раза в неделю + лабораторные работы',
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
// Мероприятия (истории)
// ─────────────────────────────────────────────────────────────────────────────

class StoryData {
  final String title;
  final String content;
  final Color color;
  final String imagePath;
  StoryData({required this.title, required this.content, required this.color, required this.imagePath});
}

final List<StoryData> applicantStories = [
  StoryData(title: 'День открытых дверей', content: 'Экскурсии, презентации специальностей, ответы на вопросы.', color: Colors.blue, imagePath: 'assets/images/story1.jpg'),
  StoryData(title: 'Олимпиада', content: 'Олимпиада для школьников 8–11 классов. Призы и бонусы.', color: Colors.green, imagePath: 'assets/images/story2.jpg'),
  StoryData(title: 'Мастер-класс', content: 'Практика по направлениям: IT, робототехника, инженерия.', color: Colors.orange, imagePath: 'assets/images/story3.jpg'),
  StoryData(title: 'Встреча с работодателями', content: 'Партнёры расскажут про практику, стажировки и вакансии.', color: Colors.purple, imagePath: 'assets/images/story4.jpg'),
  StoryData(title: 'Экскурсия в лаборатории', content: 'Покажем оборудование и учебные аудитории.', color: Colors.red, imagePath: 'assets/images/story5.jpg'),
];

// ─────────────────────────────────────────────────────────────────────────────
// Партнёры
// ─────────────────────────────────────────────────────────────────────────────

class Partner {
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final String url;
  const Partner({required this.name, required this.description, required this.icon, required this.color, required this.url});
}

const List<Partner> partners = [
  Partner(name: 'ОКБ Зенит', description: 'машиностроительное предприятие', icon: Icons.satellite_alt, color: Color(0xFF1A237E), url: 'https://www.iss-reshetnev.ru'),
  Partner(name: 'КрасМаш', description: 'Красноярский машиностроительный завод', icon: Icons.precision_manufacturing, color: Color(0xFF4E342E), url: 'http://www.krasm.com'),
  Partner(name: 'РЕШЕТНЁВ', description: 'бывш. ИСС им. академика М.Ф.Решетнёва', icon: Icons.bolt, color: Color(0xFFE65100), url: 'https://sibgenco.ru'),
  Partner(name: 'НПП «Радиосвязь»', description: ' ведущее высокотехнологичное предприятие', icon: Icons.flight, color: Color(0xFF0277BD), url: 'https://www.aeroflot.ru'),
];

// ─────────────────────────────────────────────────────────────────────────────
// Экран «Абитуриенту»
// ─────────────────────────────────────────────────────────────────────────────

class AboutCollegeScreen extends StatefulWidget {
  const AboutCollegeScreen({super.key});
  @override
  State<AboutCollegeScreen> createState() => _AboutCollegeScreenState();
}

class _AboutCollegeScreenState extends State<AboutCollegeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showMainTitle = false;
  final Set<int> _viewedStories = {};
  final PageController _specialtyController = PageController(viewportFraction: 0.92);
  int _currentSpecialtyPage = 0;
  EducationFilter _educationFilter = EducationFilter.additional;
  final PageController _educationController = PageController(viewportFraction: 0.92);
  int _currentEducationPage = 0;

  List<EducationProgram> get _filteredEducationPrograms {
    final type = _educationFilter == EducationFilter.additional ? EducationType.additional : EducationType.courses;
    return educationPrograms.where((p) => p.type == type).toList();
  }

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
    _specialtyController.dispose();
    _educationController.dispose();
    super.dispose();
  }

  bool _isViewed(int index) => _viewedStories.contains(index);
  void _markAsViewed(int index) => setState(() => _viewedStories.add(index));

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
                  flexibleSpace: _FrostedHeader(showCenterTitle: _showMainTitle),
                ),
              ];
            },
            body: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              children: [
                // ── 1) ИСТОРИИ ────────────────────────────────────────────────
                SizedBox(
                  height: 180,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: applicantStories.length,
                    itemBuilder: (context, index) {
                      return _buildStoryItem(context, index, applicantStories[index]);
                    },
                  ),
                ),

                const SizedBox(height: 18),

                // ── 2) КНОПКИ ─────────────────────────────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CareerGuidanceScreen())),
                        child: Container(
                          height: 100, padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(12)),
                          child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                            Icon(Icons.explore, size: 32, color: Color(0xFF4A90E2)),
                            SizedBox(height: 8),
                            Text('Профориентация', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                          ]),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CollegeInfoScreen())),
                        child: Container(
                          height: 100, padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(12)),
                          child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                            Icon(Icons.school, size: 32, color: Color(0xFF4A90E2)),
                            SizedBox(height: 8),
                            Text('О колледже', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                          ]),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // ── 3) СПЕЦИАЛЬНОСТИ ──────────────────────────────────────────
                const Text('Специальности', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),

                ValueListenableBuilder<Set<String>>(
                  valueListenable: FavoriteSpecialtyStore.instance.favorites,
                  builder: (context, favorites, _) {
                    return Column(
                      children: [
                        SizedBox(
                          height: 200,
                          child: PageView.builder(
                            controller: _specialtyController,
                            padEnds: false,
                            pageSnapping: true,
                            itemCount: specialties.length,
                            onPageChanged: (i) => setState(() => _currentSpecialtyPage = i),
                            itemBuilder: (context, index) {
                              final spec = specialties[index];
                              return _SpecialtyCard(
                                specialty: spec,
                                isFavorite: favorites.contains(spec.id),
                                onToggleFavorite: () => FavoriteSpecialtyStore.instance.toggle(spec.id),
                                onOpen: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SpecialtyDetailScreen(specialty: spec))),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(specialties.length, (i) {
                            final active = i == _currentSpecialtyPage;
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              width: active ? 18 : 6, height: 6,
                              decoration: BoxDecoration(color: active ? const Color(0xFF4A90E2) : Colors.grey[300], borderRadius: BorderRadius.circular(3)),
                            );
                          }),
                        ),
                        // Кнопка «Подать документы» — появляется когда есть избранные
                        if (favorites.isNotEmpty) ...[
                          const SizedBox(height: 14),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () => Navigator.push(context, MaterialPageRoute(
                                builder: (_) => DocumentSubmissionScreen(initialSpecialties: favorites.toList()),
                              )),
                              icon: const Icon(Icons.description_outlined),
                              label: Text('Подать документы (${favorites.length})', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4A90E2), foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                elevation: 0,
                              ),
                            ),
                          ),
                        ],
                      ],
                    );
                  },
                ),

                const SizedBox(height: 28),

                // ── 4) ОБУЧЕНИЕ ───────────────────────────────────────────────
                const Text('Обучение', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),

                Row(
                  children: [
                    ChoiceChip(
                      label: const Text('Доп. образование'),
                      selected: _educationFilter == EducationFilter.additional,
                      onSelected: (v) { if (!v) return; setState(() { _educationFilter = EducationFilter.additional; _currentEducationPage = 0; }); _educationController.jumpToPage(0); },
                      selectedColor: const Color(0xFF4A90E2).withOpacity(0.15),
                      labelStyle: TextStyle(color: _educationFilter == EducationFilter.additional ? const Color(0xFF4A90E2) : Colors.black87, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 10),
                    ChoiceChip(
                      label: const Text('Курсы'),
                      selected: _educationFilter == EducationFilter.courses,
                      onSelected: (v) { if (!v) return; setState(() { _educationFilter = EducationFilter.courses; _currentEducationPage = 0; }); _educationController.jumpToPage(0); },
                      selectedColor: const Color(0xFF4A90E2).withOpacity(0.15),
                      labelStyle: TextStyle(color: _educationFilter == EducationFilter.courses ? const Color(0xFF4A90E2) : Colors.black87, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Builder(builder: (context) {
                  final list = _filteredEducationPrograms;
                  return Column(children: [
                    SizedBox(
                      height: 200,
                      child: PageView.builder(
                        controller: _educationController,
                        padEnds: false,
                        pageSnapping: true,
                        itemCount: list.length,
                        onPageChanged: (i) => setState(() => _currentEducationPage = i),
                        itemBuilder: (context, index) => _EducationCard(program: list[index]),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(list.length, (i) {
                        final active = i == _currentEducationPage;
                        return AnimatedContainer(duration: const Duration(milliseconds: 250), margin: const EdgeInsets.symmetric(horizontal: 3), width: active ? 18 : 6, height: 6, decoration: BoxDecoration(color: active ? const Color(0xFF4A90E2) : Colors.grey[300], borderRadius: BorderRadius.circular(3)));
                      }),
                    ),
                  ]);
                }),

                const SizedBox(height: 28),

                // ── 5) ПАРТНЁРЫ ───────────────────────────────────────────────
                const Text('Партнёры', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.4),
                  itemCount: partners.length,
                  itemBuilder: (context, i) => _buildPartnerCard(partners[i]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoryItem(BuildContext context, int index, StoryData story) {
    final bool isViewed = _isViewed(index);
    return GestureDetector(
      onTap: () async {
        await Navigator.push(context, MaterialPageRoute(builder: (_) => StoryViewerScreen(initialIndex: index, stories: applicantStories)));
        _markAsViewed(index);
      },
      child: Container(
        width: 120, margin: const EdgeInsets.only(right: 12),
        child: Container(
          width: 120, height: 150,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: isViewed ? Colors.grey : story.color, width: 3)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(9),
            child: Stack(children: [
              Image.asset(story.imagePath, width: double.infinity, height: double.infinity, fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey[300], child: const Center(child: Icon(Icons.image, size: 40, color: Colors.grey)))),
              Align(alignment: Alignment.bottomCenter, child: Container(height: 60, decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withOpacity(0.7)])))),
              Align(alignment: Alignment.bottomLeft, child: Padding(padding: const EdgeInsets.all(8.0), child: Text(story.title, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)))),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _buildPartnerCard(Partner p) {
    return GestureDetector(
      onTap: () async {
        final uri = Uri.parse(p.url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.08), blurRadius: 6, offset: const Offset(0, 2))]),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(width: 44, height: 44, decoration: BoxDecoration(color: p.color.withOpacity(0.12), borderRadius: BorderRadius.circular(12)), child: Icon(p.icon, color: p.color, size: 22)),
          const SizedBox(height: 8),
          Text(p.name, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, height: 1.3)),
          const SizedBox(height: 4),
          Text(p.description, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 10, color: Colors.grey[600], height: 1.3)),
        ]),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Frosted header: при скролле иконка и «Центр карьеры» полностью исчезают,
// «Главная» плавно появляется по центру.
// ─────────────────────────────────────────────────────────────────────────────

class _FrostedHeader extends StatelessWidget {
  final bool showCenterTitle;
  const _FrostedHeader({required this.showCenterTitle});

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

          // «Главная» — плавно появляется по центру при скролле
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
                    child: const Text('Главная', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black87)),
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

// ─────────────────────────────────────────────────────────────────────────────
// Карточка специальности (добавлена форма обучения в нижнюю строку)
// ─────────────────────────────────────────────────────────────────────────────

class _SpecialtyCard extends StatelessWidget {
  final Specialty specialty;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;
  final VoidCallback onOpen;
  const _SpecialtyCard({required this.specialty, required this.isFavorite, required this.onToggleFavorite, required this.onOpen});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onOpen,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Stack(children: [
          Container(
            decoration: BoxDecoration(color: specialty.color, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: specialty.color.withOpacity(0.35), blurRadius: 10, offset: const Offset(0, 4))]),
            child: Padding(
              // Правый отступ увеличен, чтобы код НЕ заходил под звёздочку
              padding: const EdgeInsets.fromLTRB(18, 18, 60, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(10)), child: Icon(specialty.icon, color: Colors.white, size: 26)),
                    const SizedBox(width: 10),
                    Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(8)), child: Text(specialty.code, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600))),
                  ]),
                  const Spacer(),
                  Text(specialty.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, height: 1.3)),
                  const SizedBox(height: 8),
                  Row(children: [
                    const Icon(Icons.schedule, color: Colors.white70, size: 13),
                    const SizedBox(width: 4),
                    Text(specialty.duration, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                    const SizedBox(width: 10),
                    const Icon(Icons.school, color: Colors.white70, size: 13),
                    const SizedBox(width: 4),
                    Expanded(child: Text(specialty.form, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white70, fontSize: 12))),
                  ]),
                ],
              ),
            ),
          ),
          Positioned(
            top: 10, right: 10,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onToggleFavorite, borderRadius: BorderRadius.circular(999),
                child: Container(
                  width: 38, height: 38,
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.18), shape: BoxShape.circle, border: Border.all(color: Colors.white.withOpacity(0.35))),
                  child: Icon(isFavorite ? Icons.star : Icons.star_border, color: isFavorite ? const Color(0xFFFFD54F) : Colors.white, size: 22),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Карточка обучения (добавлена целевая аудитория в нижнюю строку)
// ─────────────────────────────────────────────────────────────────────────────

class _EducationCard extends StatelessWidget {
  final EducationProgram program;
  const _EducationCard({required this.program});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => EducationDetailScreen(program: program))),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.08), blurRadius: 6, offset: const Offset(0, 2))]),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(width: 52, height: 52, decoration: BoxDecoration(color: program.color.withOpacity(0.12), borderRadius: BorderRadius.circular(14)), child: Icon(program.icon, color: program.color, size: 26)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(program.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, height: 1.3)),
              const SizedBox(height: 4),
              Text(program.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, color: Colors.grey[600], height: 1.4)),
              const SizedBox(height: 4),
              Text(program.targetAudience, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11, color: program.color.withOpacity(0.8), fontStyle: FontStyle.italic)),
              const Spacer(),
              Row(children: [
                Icon(Icons.timer_outlined, size: 14, color: program.color),
                const SizedBox(width: 4),
                Text(program.duration, style: TextStyle(fontSize: 12, color: program.color, fontWeight: FontWeight.w700)),
                const Spacer(),
                Text('Подробнее →', style: TextStyle(fontSize: 11, color: program.color, fontWeight: FontWeight.w600)),
              ]),
            ])),
          ]),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Экран деталей программы обучения (добавлены секции: Для кого, Что вы получите, Формат)
// ─────────────────────────────────────────────────────────────────────────────

class EducationDetailScreen extends StatelessWidget {
  final EducationProgram program;
  const EducationDetailScreen({super.key, required this.program});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)), title: Text(program.title), backgroundColor: program.color, foregroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(child: Container(width: 80, height: 80, decoration: BoxDecoration(color: program.color.withOpacity(0.12), borderRadius: BorderRadius.circular(20)), child: Icon(program.icon, color: program.color, size: 44))),
          const SizedBox(height: 20),
          Text(program.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, height: 1.3)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(color: program.color.withOpacity(0.10), borderRadius: BorderRadius.circular(10)),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.timer_outlined, size: 18, color: program.color),
              const SizedBox(width: 6),
              Text('Срок обучения: ${program.duration}', style: TextStyle(fontSize: 14, color: program.color, fontWeight: FontWeight.w700)),
            ]),
          ),
          const SizedBox(height: 20),
          const Text('О программе', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text(program.details, style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.6)),
          const SizedBox(height: 20),

          // Для кого
          _buildDetailSection(Icons.people_outline, 'Для кого', program.targetAudience, program.color),
          const SizedBox(height: 12),
          // Что вы получите
          _buildDetailSection(Icons.emoji_events_outlined, 'Что вы получите', program.outcome, program.color),
          const SizedBox(height: 12),
          // Формат занятий
          _buildDetailSection(Icons.calendar_today_outlined, 'Формат занятий', program.format, program.color),

          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                showDialog(context: context, builder: (_) => AlertDialog(
                  title: const Text('Запись на курс'),
                  content: Text('Вы хотите записаться на курс:\n«${program.title}»?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('Отмена')),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Заявка на курс «${program.title}» отправлена!'), backgroundColor: program.color, duration: const Duration(seconds: 3)));
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: program.color, foregroundColor: Colors.white),
                      child: const Text('Записаться'),
                    ),
                  ],
                ));
              },
              style: ElevatedButton.styleFrom(backgroundColor: program.color, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), elevation: 0),
              child: const Text('Записаться', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildDetailSection(IconData icon, String title, String text, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: color)),
            const SizedBox(height: 4),
            Text(text, style: const TextStyle(fontSize: 13, color: Colors.black87, height: 1.4)),
          ])),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Экран деталей специальности (добавлены: квалификация, карьера, навыки, зарплата)
// ─────────────────────────────────────────────────────────────────────────────

class SpecialtyDetailScreen extends StatelessWidget {
  final Specialty specialty;
  const SpecialtyDetailScreen({super.key, required this.specialty});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverAppBar(
          expandedHeight: 200, pinned: true, backgroundColor: specialty.color,
          leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
          flexibleSpace: FlexibleSpaceBar(background: Container(
            decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [specialty.color, specialty.color.withOpacity(0.72)])),
            child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const SizedBox(height: 40),
              Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(16)), child: Icon(specialty.icon, color: Colors.white, size: 48)),
            ])),
          )),
        ),
        SliverToBoxAdapter(child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: specialty.color.withOpacity(0.12), borderRadius: BorderRadius.circular(8)), child: Text(specialty.code, style: TextStyle(color: specialty.color, fontSize: 13, fontWeight: FontWeight.w700))),
            const SizedBox(height: 10),
            Text(specialty.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, height: 1.3)),
            const SizedBox(height: 16),

            // Квалификация
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(color: specialty.color.withOpacity(0.08), borderRadius: BorderRadius.circular(10)),
              child: Row(children: [
                Icon(Icons.workspace_premium, color: specialty.color, size: 20),
                const SizedBox(width: 8),
                Expanded(child: Text('Квалификация: ${specialty.qualification}', style: TextStyle(fontSize: 13, color: specialty.color, fontWeight: FontWeight.w600))),
              ]),
            ),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
              child: Row(children: [
                Expanded(child: _buildInfoChip(Icons.schedule, 'Срок обучения', specialty.duration, specialty.color)),
                Container(width: 1, height: 48, color: Colors.grey.shade300),
                Expanded(child: _buildInfoChip(Icons.school, 'Форма', specialty.form, specialty.color)),
              ]),
            ),
            const SizedBox(height: 20),
            const Text('О специальности', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(specialty.description, style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.6)),

            const SizedBox(height: 20),

            // Кем работать
            _buildSpecialtyInfoBlock(Icons.work_outline, 'Кем работать', specialty.career, specialty.color),
            const SizedBox(height: 12),

            // Ключевые навыки
            _buildSpecialtyInfoBlock(Icons.build_outlined, 'Ключевые навыки', specialty.skills, specialty.color),
            const SizedBox(height: 12),

            // Зарплата
            _buildSpecialtyInfoBlock(Icons.payments_outlined, 'Зарплата выпускников', specialty.salary, specialty.color),

            const SizedBox(height: 28),
            ValueListenableBuilder<Set<String>>(
              valueListenable: FavoriteSpecialtyStore.instance.favorites,
              builder: (context, favorites, _) {
                final isFav = favorites.contains(specialty.id);
                return Row(children: [
                  Container(
                    width: 54, height: 54,
                    decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.grey.shade200)),
                    child: IconButton(onPressed: () => FavoriteSpecialtyStore.instance.toggle(specialty.id), icon: Icon(isFav ? Icons.star : Icons.star_border, color: isFav ? const Color(0xFFFFD54F) : Colors.grey[600]), tooltip: 'Хочу эту специальность'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: ElevatedButton.icon(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DocumentSubmissionScreen(initialSpecialties: [specialty.id]))),
                    icon: const Icon(Icons.description_outlined),
                    label: const Text('Подать документы', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                    style: ElevatedButton.styleFrom(backgroundColor: specialty.color, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), elevation: 0),
                  )),
                ]);
              },
            ),
          ]),
        )),
      ]),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, String value, Color color) {
    return Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: Column(children: [
      Icon(icon, color: color, size: 22), const SizedBox(height: 4),
      Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])), const SizedBox(height: 2),
      Text(value, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
    ]));
  }

  Widget _buildSpecialtyInfoBlock(IconData icon, String title, String text, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: color)),
            const SizedBox(height: 4),
            Text(text, style: const TextStyle(fontSize: 13, color: Colors.black87, height: 1.4)),
          ])),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Просмотрщик историй — с кнопкой «Подробнее» внизу
// ─────────────────────────────────────────────────────────────────────────────

class StoryViewerScreen extends StatefulWidget {
  final int initialIndex;
  final List<StoryData> stories;
  const StoryViewerScreen({super.key, required this.initialIndex, required this.stories});
  @override
  State<StoryViewerScreen> createState() => _StoryViewerScreenState();
}

class _StoryViewerScreenState extends State<StoryViewerScreen> {
  late int _currentIndex;
  late PageController _pageController;
  Timer? _timer;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
    _startTimer();
  }

  @override
  void dispose() { _timer?.cancel(); _pageController.dispose(); super.dispose(); }

  void _startTimer() {
    _timer?.cancel(); _progress = 0.0;
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        _progress += 0.05 / 5;
        if (_progress >= 1.0) { _progress = 0.0; _nextStory(); }
      });
    });
  }

  void _nextStory() {
    if (_currentIndex < widget.stories.length - 1) {
      setState(() { _currentIndex++; _pageController.animateToPage(_currentIndex, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut); });
      _startTimer();
    } else { Navigator.pop(context); }
  }

  void _previousStory() {
    if (_currentIndex > 0) {
      setState(() { _currentIndex--; _pageController.animateToPage(_currentIndex, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut); });
      _startTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapUp: (details) {
          final screenWidth = MediaQuery.of(context).size.width;
          final screenHeight = MediaQuery.of(context).size.height;
          // Нижние 25% экрана — зона кнопки «Подробнее», не переключаем
          if (details.globalPosition.dy > screenHeight * 0.75) return;
          if (details.globalPosition.dx < screenWidth / 2) { _previousStory(); } else { _nextStory(); }
        },
        child: Stack(children: [
          PageView.builder(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.stories.length,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemBuilder: (context, index) => _buildStoryContent(widget.stories[index]),
          ),
          SafeArea(child: Column(children: [
            // Одна полоска прогресса на текущую историю (1 фото = 1 сегмент)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Container(
                height: 3,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: _progress,
                    child: Container(
                      height: 3,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Align(alignment: Alignment.centerRight, child: Padding(padding: const EdgeInsets.only(right: 8), child: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close, color: Colors.white)))),
          ])),
          // Кнопка «Подробнее» внизу — прозрачно-матовая
          Positioned(
            bottom: 40, left: 16, right: 16,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Material(
                  color: Colors.white.withOpacity(0.2),
                  child: InkWell(
                    onTap: () {
                      _timer?.cancel();
                      final story = widget.stories[_currentIndex];
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                        builder: (_) => ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                            child: Container(
                              color: Colors.black.withOpacity(0.45),
                              padding: const EdgeInsets.all(24),
                              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text(story.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                                const SizedBox(height: 12),
                                Text(story.content, style: const TextStyle(fontSize: 15, color: Colors.white, height: 1.5)),
                                const SizedBox(height: 20),
                                SizedBox(width: double.infinity, child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                    child: ElevatedButton(
                                      onPressed: () => Navigator.pop(context),
                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.white.withOpacity(0.2), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0),
                                      child: const Text('Закрыть'),
                                    ),
                                  ),
                                )),
                              ]),
                            ),
                          ),
                        ),
                      ).then((_) => _startTimer());
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Center(
                        child: Text('Подробнее', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildStoryContent(StoryData story) {
    return Stack(fit: StackFit.expand, children: [
      Image.asset(story.imagePath, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => Container(color: Colors.black)),
      Container(color: Colors.black.withOpacity(0.15)),
    ]);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Экран «О колледже» — обогащённая версия
// ─────────────────────────────────────────────────────────────────────────────

class CollegeInfoScreen extends StatelessWidget {
  const CollegeInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)), centerTitle: true, title: const Text('О колледже')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Фото колледжа
          Container(
            width: double.infinity, height: 180,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.grey[300]),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset('assets/images/college_building.jpg', fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.image, size: 64, color: Colors.grey)),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // ── Наша миссия ──
          const Text('Наша миссия', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text(
            'Подготовка высококвалифицированных специалистов, готовых к успешной профессиональной деятельности в современных условиях. '
                'Мы стремимся воспитать не только профессионалов, но и ответственных граждан, способных внести значимый вклад в развитие общества и технологий.',
            style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.6),
          ),
          const SizedBox(height: 20),

          // ── О нас ──
          const Text('О нас', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text(
            'Аэрокосмический колледж СибГУ им. академика М.Ф. Решетнёва — одно из ведущих учебных заведений среднего профессионального образования в Красноярском крае. '
                'Колледж является структурным подразделением Сибирского государственного университета науки и технологий и имеет богатую историю подготовки специалистов для авиационно-космической, машиностроительной и IT-отраслей.\n\n'
                'На протяжении десятилетий наш колледж выпускает квалифицированных техников, программистов, инженеров и экономистов, которые успешно трудоустраиваются на ведущих предприятиях региона и страны. '
                'Тесное сотрудничество с промышленными партнёрами — ОКБ «Зенит», КрасМаш, АО «РЕШЕТНЁВ» — обеспечивает студентам возможность проходить производственную практику на реальном оборудовании.',
            style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.6),
          ),
          const SizedBox(height: 24),

          // ── Колледж в цифрах ──
          const Text('Колледж в цифрах', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: _StatCard(icon: Icons.people, value: '2 500+', label: 'Студентов', color: Color(0xFF4A90E2))),
            const SizedBox(width: 10),
            Expanded(child: _StatCard(icon: Icons.auto_stories, value: '15', label: 'Специальностей', color: Color(0xFF66BB6A))),
          ]),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(child: _StatCard(icon: Icons.emoji_events, value: '60+', label: 'Лет истории', color: Color(0xFFFFA726))),
            const SizedBox(width: 10),
            Expanded(child: _StatCard(icon: Icons.business, value: '4', label: 'Партнёра', color: Color(0xFFAB47BC))),
          ]),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(child: _StatCard(icon: Icons.school, value: '95%', label: 'Трудоустройство', color: Color(0xFF26A69A))),
            const SizedBox(width: 10),
            Expanded(child: _StatCard(icon: Icons.groups, value: '150+', label: 'Преподавателей', color: Color(0xFFEF5350))),
          ]),
          const SizedBox(height: 24),

          // ── Почему выбирают нас ──
          const Text('Почему выбирают нас', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _AdvantageItem(icon: Icons.rocket_launch, title: 'Аэрокосмическое наследие', text: 'Уникальные специальности, связанные с авиацией и ракетно-космической техникой, которые есть далеко не в каждом колледже.', color: Color(0xFF283593)),
          const SizedBox(height: 10),
          _AdvantageItem(icon: Icons.computer, title: 'Современные IT-направления', text: 'Программирование, кибербезопасность, системное администрирование — востребованные специальности с высоким спросом на рынке труда.', color: Color(0xFF0288D1)),
          const SizedBox(height: 10),
          _AdvantageItem(icon: Icons.handshake, title: 'Связь с индустрией', text: 'Производственная практика на реальных предприятиях. Наши партнёры — КрасМаш, РЕШЕТНЁВ, ОКБ «Зенит» — берут выпускников на работу.', color: Color(0xFF2E7D32)),
          const SizedBox(height: 10),
          _AdvantageItem(icon: Icons.trending_up, title: 'Карьерный рост', text: 'Центр карьеры помогает с трудоустройством, стажировками и развитием профессиональных навыков ещё во время обучения.', color: Color(0xFFE65100)),
          const SizedBox(height: 24),

          // ── Наши достижения ──
          const Text('Наши достижения', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _AchievementCard(icon: Icons.military_tech, title: 'Победители WorldSkills Russia', text: 'Студенты колледжа регулярно занимают призовые места в региональных и национальных чемпионатах WorldSkills по компетенциям «Сетевое администрирование», «Мехатроника» и «Сварочные технологии».', color: Color(0xFFFFA726)),
          const SizedBox(height: 10),
          _AchievementCard(icon: Icons.workspace_premium, title: 'Аккредитация и лицензии', text: 'Все образовательные программы прошли государственную аккредитацию. Выпускники получают дипломы государственного образца, признаваемые по всей России.', color: Color(0xFF4A90E2)),
          const SizedBox(height: 10),
          _AchievementCard(icon: Icons.science, title: 'Научно-техническое творчество', text: 'Ежегодно студенты участвуют в научных конференциях и инженерных конкурсах, представляя проекты по робототехнике, программированию и 3D-моделированию.', color: Color(0xFF66BB6A)),
          const SizedBox(height: 10),
          _AchievementCard(icon: Icons.diversity_3, title: 'Активная студенческая жизнь', text: 'Более 10 кружков и секций: от спортивных команд до IT-клуба и инженерного общества. Регулярные фестивали, соревнования и волонтёрские проекты.', color: Color(0xFFAB47BC)),
          const SizedBox(height: 24),

          // ── Инфраструктура ──
          const Text('Инфраструктура', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          const Text(
            'Колледж располагает современными учебными корпусами, оснащёнными лабораториями и мастерскими:\n'
                '• Компьютерные классы с лицензионным ПО\n'
                '• Лаборатории робототехники и мехатроники\n'
                '• Сварочные мастерские с современным оборудованием\n'
                '• Лаборатории электротехники и измерительных приборов\n'
                '• Авиационный ангар для практических занятий\n'
                '• Библиотека с электронными ресурсами\n'
                '• Спортивный зал и площадки',
            style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.6),
          ),
          const SizedBox(height: 32),
        ]),
      ),
    );
  }
}

// ── Карточка статистики ──
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  const _StatCard({required this.icon, required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[700]), textAlign: TextAlign.center),
      ]),
    );
  }
}

// ── Карточка преимущества ──
class _AdvantageItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;
  final Color color;
  const _AdvantageItem({required this.icon, required this.title, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.06), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: 44, height: 44,
          decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(text, style: TextStyle(fontSize: 13, color: Colors.grey[700], height: 1.4)),
        ])),
      ]),
    );
  }
}

// ── Карточка достижения ──
class _AchievementCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;
  final Color color;
  const _AchievementCard({required this.icon, required this.title, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [color.withOpacity(0.08), color.withOpacity(0.03)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: 44, height: 44,
          decoration: BoxDecoration(color: color.withOpacity(0.15), shape: BoxShape.circle),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(text, style: const TextStyle(fontSize: 13, color: Colors.black87, height: 1.4)),
        ])),
      ]),
    );
  }
}

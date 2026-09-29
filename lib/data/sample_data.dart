import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'models.dart';

/// All sample (fictional) data used by the prototype.
/// No database or API is needed – everything lives here.
class SampleData {
  SampleData._();

  static const String appName = 'Quadrangle';
  static const String university = 'Kingsbridge University';
  static const String dashboardTitle = 'Student Dashboard';

  static const Student student = Student(
    fullName: 'Aarav Menon',
    preferredName: 'Aarav',
    studentId: 'KBU-23-04817',
    programme: 'BSc (Hons) Computer Science',
    faculty: 'Faculty of Computing & Informatics',
    yearLabel: 'Year 3',
    semester: 'Semester 5',
    email: 'aarav.menon@student.kingsbridge.edu',
    phone: '+1 (555) 014-2291',
    advisor: 'Dr. Eleanor Hughes',
    intake: 'September 2023',
    hostel: 'Wren College, Room 3-14',
  );

  // ---------- Academic snapshot ----------
  static const double cgpa = 3.68;
  static const int creditsEarned = 96;
  static const int creditsRequired = 120;
  static const String nextAdvisorMeeting = 'Fri, 2 Oct · 3:00 PM';

  // ---------- Campus services (quick access) ----------
  static const List<CampusService> services = [
    CampusService(
      id: 'timetable',
      title: 'Timetable',
      subtitle: 'Classes & rooms',
      icon: Icons.calendar_month_rounded,
      color: Color(0xFF24507F),
      tint: Color(0xFFE3ECF7),
      badge: 'Today',
    ),
    CampusService(
      id: 'results',
      title: 'Results',
      subtitle: 'Grades & GPA',
      icon: Icons.workspace_premium_rounded,
      color: Color(0xFF1F6F6B),
      tint: Color(0xFFE1F0EE),
      badge: 'New',
    ),
    CampusService(
      id: 'attendance',
      title: 'Attendance',
      subtitle: 'Per-course record',
      icon: Icons.fact_check_rounded,
      color: Color(0xFF2E6B45),
      tint: Color(0xFFE3F1E7),
    ),
    CampusService(
      id: 'fees',
      title: 'Fees',
      subtitle: 'Invoices & payments',
      icon: Icons.account_balance_wallet_rounded,
      color: Color(0xFF8E2231),
      tint: Color(0xFFF8E3E5),
      badge: 'Due soon',
    ),
    CampusService(
      id: 'library',
      title: 'Library',
      subtitle: 'Loans & study rooms',
      icon: Icons.local_library_rounded,
      color: Color(0xFF5B3A73),
      tint: Color(0xFFEFE7F4),
      badge: '3 loans',
    ),
    CampusService(
      id: 'shuttle',
      title: 'Shuttle',
      subtitle: 'Live bus routes',
      icon: Icons.directions_bus_rounded,
      color: Color(0xFF8A5A1E),
      tint: Color(0xFFF6EBDD),
      badge: 'Live',
    ),
    CampusService(
      id: 'clubs',
      title: 'Clubs',
      subtitle: 'Societies & activities',
      icon: Icons.groups_rounded,
      color: Color(0xFFA0432E),
      tint: Color(0xFFF8E6E0),
    ),
    CampusService(
      id: 'helpdesk',
      title: 'Helpdesk',
      subtitle: 'Support & FAQs',
      icon: Icons.support_agent_rounded,
      color: Color(0xFF37516B),
      tint: Color(0xFFE5ECF2),
    ),
  ];

  // ---------- Announcements ----------
  static const List<Announcement> announcements = [
    Announcement(
      id: 'reg-s6',
      title: 'Semester 6 course registration closes',
      message: 'Register your Semester 6 courses on the portal before Friday, 9 Oct, 5:00 PM.',
      details:
          'Course registration for Semester 6 (January 2027 intake) is now open. '
          'Please meet your academic advisor if you plan to take more than 20 credit hours, '
          'retake a course, or change your elective stream.\n\n'
          'Late registration will incur a fee of \$50 and is subject to seat availability. '
          'Students with outstanding fees must settle them before registration is approved.',
      postedOn: 'Posted 29 Sep 2026 · Registry Office',
      deadline: 'Fri, 9 Oct 2026 · 5:00 PM',
      badge: 'Due soon',
      category: AlertCategory.academic,
      icon: Icons.edit_calendar_rounded,
      relatedServiceId: 'timetable',
      relatedActionLabel: 'Plan in Timetable',
      pinned: true,
    ),
    Announcement(
      id: 'fee-s6',
      title: 'Tuition fee instalment due',
      message: 'Your Semester 6 tuition of \$2,450.00 is due on 16 Oct 2026.',
      details:
          'Payments can be made through the Fees section of this app, by bank transfer, '
          'or at the Bursary counter (Admin Block, Level 1) from 9:00 AM to 4:30 PM.\n\n'
          'Students on scholarship should upload their sponsor letter before the due date.',
      postedOn: 'Posted 27 Sep 2026 · Bursary',
      deadline: 'Fri, 16 Oct 2026',
      badge: 'Action',
      category: AlertCategory.finance,
      icon: Icons.receipt_long_rounded,
      relatedServiceId: 'fees',
      relatedActionLabel: 'Pay in Fees',
    ),
    Announcement(
      id: 'lib-247',
      title: 'Library open 24/7 during exam weeks',
      message:
          'The Main Library stays open around the clock from 19 Oct to 6 Nov.',
      details:
          'Level 2 quiet zones and all group study rooms will be available 24 hours a day. '
          'A valid student card is required for entry after 10:00 PM. '
          'Free coffee will be served at the ground floor lounge from midnight to 2:00 AM.',
      postedOn: 'Posted 26 Sep 2026 · Library Services',
      deadline: 'Starts Mon, 19 Oct 2026',
      badge: 'New',
      category: AlertCategory.facilities,
      icon: Icons.local_library_rounded,
      relatedServiceId: 'library',
      relatedActionLabel: 'Open Library',
    ),
    Announcement(
      id: 'shuttle-b',
      title: 'Route B diverted via East Ring Road',
      message: 'Shuttle Route B will skip North Gate from 5–12 Oct due to roadworks.',
      details:
          'A temporary stop will be placed outside the Sports Complex. '
          'Please allow an extra 10 minutes for journeys to the Science Park. '
          'Live bus positions are available in the Shuttle section.',
      postedOn: 'Posted 28 Sep 2026 · Campus Transport',
      deadline: 'Mon, 5 Oct – Mon, 12 Oct',
      badge: 'Notice',
      category: AlertCategory.transport,
      icon: Icons.alt_route_rounded,
      relatedServiceId: 'shuttle',
      relatedActionLabel: 'Open Shuttle',
    ),
    Announcement(
      id: 'deans-list',
      title: "Dean's List Scholarship briefing",
      message: 'Briefing on Wed, 7 Oct at 2:00 PM in Lecture Theatre 2.',
      details:
          "Students with a CGPA of 3.60 and above are invited to learn about the Dean's List "
          'Scholarship, which covers up to 50% of tuition fees for the next academic year. '
          'Bring a copy of your latest transcript.',
      postedOn: 'Posted 25 Sep 2026 · Faculty of Computing',
      deadline: 'Wed, 7 Oct 2026 · 2:00 PM',
      badge: 'New',
      category: AlertCategory.academic,
      icon: Icons.school_rounded,
      relatedServiceId: 'results',
      relatedActionLabel: 'View Results',
    ),
    Announcement(
      id: 'wifi-c',
      title: 'Wi-Fi maintenance in Block C',
      message: 'Wireless access in Block C will be unavailable on Sat, 3 Oct, 11 PM – 3 AM.',
      details:
          'IT Services is upgrading access points in Block C. Wired ports in the computer labs '
          'will remain available. Report any issues after the upgrade via the Helpdesk.',
      postedOn: 'Posted 24 Sep 2026 · IT Services',
      deadline: 'Sat, 3 Oct 2026 · 11:00 PM',
      badge: 'Info',
      category: AlertCategory.facilities,
      icon: Icons.wifi_off_rounded,
      relatedServiceId: 'helpdesk',
      relatedActionLabel: 'Contact Helpdesk',
    ),
  ];

  // ---------- Student life ----------
  static const List<CampusEvent> events = [
    CampusEvent(
      id: 'career-fair',
      title: 'Career Discovery Fair',
      day: '14',
      month: 'OCT',
      weekday: 'Wednesday',
      time: '10:00 AM – 4:00 PM',
      venue: 'Great Hall',
      organiser: 'Career Services Centre',
      description:
          'Meet recruiters from 40+ companies, get your CV reviewed, and attend short talks on '
          'internships in software, finance, and consulting. Formal attire recommended.',
      category: 'Careers',
      seatsLeft: 42,
      icon: Icons.work_outline_rounded,
      color: AppColors.navy,
    ),
    CampusEvent(
      id: 'chess-open',
      title: 'Inter-Faculty Chess Open',
      day: '17',
      month: 'OCT',
      weekday: 'Saturday',
      time: '9:30 AM – 5:00 PM',
      venue: 'Old Library Reading Room',
      organiser: 'Kingsbridge Chess Club',
      description:
          'A seven-round Swiss tournament open to all skill levels. Trophies for the top three '
          'players and the best-performing faculty team. Boards and clocks are provided.',
      category: 'Club',
      seatsLeft: 16,
      icon: Icons.castle_rounded,
      color: Color(0xFF8A5A1E),
    ),
    CampusEvent(
      id: 'flutter-night',
      title: 'Flutter Build Night',
      day: '21',
      month: 'OCT',
      weekday: 'Wednesday',
      time: '6:00 PM – 9:00 PM',
      venue: 'Innovation Lab 2',
      organiser: 'Coding Club',
      description:
          'Build a small mobile app in three hours with mentors from the Coding Club. '
          'Bring your laptop with Flutter installed. Pizza will be served.',
      category: 'Workshop',
      seatsLeft: 8,
      icon: Icons.code_rounded,
      color: Color(0xFF1F6F6B),
    ),
    CampusEvent(
      id: 'charity-run',
      title: 'Autumn Charity Run 5K',
      day: '24',
      month: 'OCT',
      weekday: 'Saturday',
      time: '7:00 AM – 10:00 AM',
      venue: 'Main Quad',
      organiser: 'Student Union',
      description:
          'Run, jog, or walk a 5 km loop around campus. All proceeds go to the Kingsbridge '
          'Community Food Bank. Registration includes a T-shirt and finisher medal.',
      category: 'Sports',
      seatsLeft: 120,
      icon: Icons.directions_run_rounded,
      color: Color(0xFF8E2231),
    ),
  ];

  // ---------- Timetable (Mon–Fri) ----------
  static const List<String> weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'];

  static const Map<String, List<ClassSession>> timetable = {
    'Mon': [
      ClassSession(
        start: '09:00',
        end: '10:30',
        code: 'CS3101',
        title: 'Software Engineering',
        room: 'Lecture Theatre 2',
        lecturer: 'Dr. Eleanor Hughes',
        type: 'Lecture',
      ),
      ClassSession(
        start: '11:00',
        end: '13:00',
        code: 'CS3207',
        title: 'Mobile App Development',
        room: 'Lab 3B',
        lecturer: 'Mr. Daniel Okafor',
        type: 'Lab',
      ),
      ClassSession(
        start: '14:00',
        end: '15:00',
        code: 'HU2101',
        title: 'Professional Ethics',
        room: 'Room C-204',
        lecturer: 'Ms. Priya Raman',
        type: 'Tutorial',
      ),
    ],
    'Tue': [
      ClassSession(
        start: '08:30',
        end: '10:00',
        code: 'CS3104',
        title: 'Operating Systems',
        room: 'Lecture Theatre 1',
        lecturer: 'Prof. Martin Keller',
        type: 'Lecture',
      ),
      ClassSession(
        start: '10:30',
        end: '12:00',
        code: 'MA2203',
        title: 'Discrete Mathematics',
        room: 'Room B-110',
        lecturer: 'Dr. Sofia Alvarez',
        type: 'Lecture',
      ),
      ClassSession(
        start: '15:00',
        end: '17:00',
        code: 'CS3112',
        title: 'Database Systems',
        room: 'Lab 2A',
        lecturer: 'Dr. Hana Yusuf',
        type: 'Lab',
      ),
    ],
    'Wed': [
      ClassSession(
        start: '09:00',
        end: '10:30',
        code: 'CS3112',
        title: 'Database Systems',
        room: 'Lecture Theatre 3',
        lecturer: 'Dr. Hana Yusuf',
        type: 'Lecture',
      ),
      ClassSession(
        start: '11:00',
        end: '12:00',
        code: 'CS3101',
        title: 'Software Engineering',
        room: 'Room C-118',
        lecturer: 'Dr. Eleanor Hughes',
        type: 'Tutorial',
      ),
    ],
    'Thu': [
      ClassSession(
        start: '08:30',
        end: '10:00',
        code: 'CS3104',
        title: 'Operating Systems',
        room: 'Lab 1C',
        lecturer: 'Prof. Martin Keller',
        type: 'Lab',
      ),
      ClassSession(
        start: '11:00',
        end: '12:30',
        code: 'CS3207',
        title: 'Mobile App Development',
        room: 'Lecture Theatre 2',
        lecturer: 'Mr. Daniel Okafor',
        type: 'Lecture',
      ),
      ClassSession(
        start: '14:00',
        end: '15:30',
        code: 'MA2203',
        title: 'Discrete Mathematics',
        room: 'Room B-112',
        lecturer: 'Dr. Sofia Alvarez',
        type: 'Tutorial',
      ),
    ],
    'Fri': [
      ClassSession(
        start: '10:00',
        end: '11:30',
        code: 'CS3101',
        title: 'Software Engineering',
        room: 'Project Studio 4',
        lecturer: 'Dr. Eleanor Hughes',
        type: 'Studio',
      ),
      ClassSession(
        start: '14:30',
        end: '15:30',
        code: 'HU2101',
        title: 'Professional Ethics',
        room: 'Room C-204',
        lecturer: 'Ms. Priya Raman',
        type: 'Lecture',
      ),
    ],
  };

  // ---------- Results ----------
  static const Map<String, List<CourseResult>> results = {
    'Semester 4': [
      CourseResult('CS2201', 'Data Structures & Algorithms', 4, 'A', 4.00),
      CourseResult('CS2204', 'Computer Networks', 3, 'A-', 3.67),
      CourseResult('CS2208', 'Object-Oriented Design', 3, 'B+', 3.33),
      CourseResult('MA2102', 'Linear Algebra', 3, 'A-', 3.67),
      CourseResult('CS2210', 'Web Technologies', 3, 'A', 4.00),
      CourseResult('HU1203', 'Academic Writing', 2, 'B+', 3.33),
    ],
    'Semester 3': [
      CourseResult('CS2101', 'Programming II', 4, 'A-', 3.67),
      CourseResult('CS2105', 'Computer Architecture', 3, 'B+', 3.33),
      CourseResult('MA1204', 'Probability & Statistics', 3, 'B', 3.00),
      CourseResult('CS2107', 'Digital Logic', 3, 'A-', 3.67),
      CourseResult('GE1102', 'Entrepreneurship', 2, 'A', 4.00),
    ],
  };

  // ---------- Attendance ----------
  static const List<AttendanceRecord> attendance = [
    AttendanceRecord('CS3101', 'Software Engineering', 27, 28),
    AttendanceRecord('CS3104', 'Operating Systems', 25, 28),
    AttendanceRecord('CS3207', 'Mobile App Development', 26, 28),
    AttendanceRecord('CS3112', 'Database Systems', 24, 26),
    AttendanceRecord('MA2203', 'Discrete Mathematics', 20, 26),
    AttendanceRecord('HU2101', 'Professional Ethics', 14, 14),
  ];

  static double get overallAttendance {
    final attended = attendance.fold<int>(0, (sum, r) => sum + r.attended);
    final total = attendance.fold<int>(0, (sum, r) => sum + r.total);
    return attended / total;
  }

  // ---------- Fees (mutable, copied into AppState) ----------
  static List<Invoice> invoices() => [
    Invoice(
      id: 'INV-2026-0874',
      title: 'Hostel Fee – October',
      amount: 320.00,
      dueDate: '5 Oct 2026',
    ),
    Invoice(
      id: 'INV-2026-0802',
      title: 'Library Late Fine',
      amount: 4.50,
      dueDate: '10 Oct 2026',
    ),
    Invoice(
      id: 'INV-2026-0931',
      title: 'Tuition Fee – Semester 6',
      amount: 2450.00,
      dueDate: '16 Oct 2026',
    ),
    Invoice(
      id: 'INV-2026-0610',
      title: 'Tuition Fee – Semester 5',
      amount: 2450.00,
      dueDate: '15 May 2026',
      paid: true,
    ),
  ];

  // ---------- Library (mutable, copied into AppState) ----------
  static List<BorrowedBook> books() => [
    BorrowedBook(
      id: 'b1',
      title: 'Clean Code',
      author: 'Robert C. Martin',
      dueDate: DateTime(2026, 10, 3),
    ),
    BorrowedBook(
      id: 'b2',
      title: 'Operating System Concepts',
      author: 'Silberschatz, Galvin & Gagne',
      dueDate: DateTime(2026, 10, 8),
      renewals: 1,
    ),
    BorrowedBook(
      id: 'b3',
      title: 'Designing Data-Intensive Applications',
      author: 'Martin Kleppmann',
      dueDate: DateTime(2026, 10, 12),
    ),
  ];

  static const List<String> studyRooms = [
    'Room G1 · 4 seats',
    'Room G2 · 6 seats',
    'Room L2-A · 8 seats',
    'Silent Pod 3 · 1 seat',
  ];

  static const List<String> studySlots = [
    '9:00 AM',
    '11:00 AM',
    '1:00 PM',
    '3:00 PM',
    '5:00 PM',
    '7:00 PM',
  ];

  // ---------- Shuttle ----------
  static const List<ShuttleRoute> shuttleRoutes = [
    ShuttleRoute(
      id: 'A',
      name: 'Route A · Hostel Loop',
      from: 'Main Gate',
      to: 'Residential Colleges',
      frequency: 'Every 10 min',
      status: 'On time',
      color: Color(0xFF24507F),
      stops: [
        'Main Gate',
        'Main Library',
        'Great Hall',
        'Sports Complex',
        'Residential Colleges',
      ],
    ),
    ShuttleRoute(
      id: 'B',
      name: 'Route B · Science Park',
      from: 'Sports Complex',
      to: 'Science Park',
      frequency: 'Every 20 min',
      status: 'Diverted',
      color: Color(0xFF8A5A1E),
      stops: [
        'Sports Complex (temp.)',
        'East Ring Road',
        'Engineering Block',
        'Science Park',
      ],
    ),
    ShuttleRoute(
      id: 'C',
      name: 'Route C · City Link',
      from: 'Campus Central',
      to: 'City Station',
      frequency: 'Every 30 min',
      status: 'Delayed',
      color: Color(0xFF8E2231),
      stops: [
        'Campus Central',
        'Medical Centre',
        'Riverside Mall',
        'City Station',
      ],
    ),
    ShuttleRoute(
      id: 'N',
      name: 'Night Shuttle',
      from: 'Main Library',
      to: 'Residential Colleges',
      frequency: '9 PM – 1 AM · every 15 min',
      status: 'On time',
      color: Color(0xFF2E6B45),
      stops: ['Main Library', 'Student Centre', 'Residential Colleges'],
    ),
  ];

  // ---------- Clubs ----------
  static const List<Club> clubs = [
    Club(
      id: 'coding',
      name: 'Coding Club',
      category: 'Technology',
      members: 120,
      meets: 'Fridays · 4:00 PM · Lab 3B',
      description:
          'Weekly coding challenges, hackathon prep, and build nights.',
      icon: Icons.terminal_rounded,
      color: Color(0xFF1F6F6B),
    ),
    Club(
      id: 'debate',
      name: 'Debate Society',
      category: 'Academic',
      members: 86,
      meets: 'Thursdays · 6:00 PM · Room A-301',
      description: 'British Parliamentary debate training and inter-varsity tournaments.',
      icon: Icons.record_voice_over_rounded,
      color: Color(0xFF8E2231),
    ),
    Club(
      id: 'robotics',
      name: 'Robotics Club',
      category: 'Technology',
      members: 64,
      meets: 'Wednesdays · 5:00 PM · Innovation Lab 1',
      description: 'Design, build, and race autonomous robots.',
      icon: Icons.precision_manufacturing_rounded,
      color: Color(0xFF24507F),
    ),
    Club(
      id: 'photo',
      name: 'Photography Guild',
      category: 'Arts',
      members: 52,
      meets: 'Saturdays · 8:00 AM · Main Quad',
      description: 'Photo walks, editing workshops, and an annual exhibition.',
      icon: Icons.photo_camera_rounded,
      color: Color(0xFF5B3A73),
    ),
    Club(
      id: 'chess',
      name: 'Chess Club',
      category: 'Recreation',
      members: 38,
      meets: 'Tuesdays · 7:00 PM · Old Library',
      description: 'Casual games, coaching sessions, and rated tournaments.',
      icon: Icons.castle_rounded,
      color: Color(0xFF8A5A1E),
    ),
    Club(
      id: 'drama',
      name: 'Drama Society',
      category: 'Arts',
      members: 45,
      meets: 'Mondays · 6:30 PM · Heritage Theatre',
      description:
          'Two main-stage productions every year. No experience needed.',
      icon: Icons.theater_comedy_rounded,
      color: Color(0xFFA0432E),
    ),
  ];

  // ---------- Helpdesk ----------
  static const List<String> ticketCategories = [
    'IT Services',
    'Registry',
    'Bursary',
    'Hostel',
    'Library',
    'Counselling',
  ];

  static List<HelpTicket> tickets() => const [
    HelpTicket(
      id: 'HD-10482',
      category: 'IT Services',
      subject: 'Cannot connect to campus Wi-Fi in Block C',
      status: 'In progress',
      date: '27 Sep 2026',
    ),
    HelpTicket(
      id: 'HD-10311',
      category: 'Registry',
      subject: 'Request for enrolment confirmation letter',
      status: 'Resolved',
      date: '18 Sep 2026',
    ),
  ];

  static const List<MapEntry<String, String>> faqs = [
    MapEntry(
      'How do I reset my student portal password?',
      'Use "Forgot password" on the portal login page. A reset link is sent to your student email and expires in 30 minutes.',
    ),
    MapEntry(
      'Where can I collect a replacement student card?',
      'Visit the Registry counter (Admin Block, Level 1). A replacement costs \$15 and is ready within 2 working days.',
    ),
    MapEntry(
      'How many books can I borrow?',
      'Undergraduates may borrow up to 8 books for 14 days each, with up to 2 renewals per book.',
    ),
    MapEntry(
      'Is counselling confidential?',
      'Yes. Sessions with Student Wellbeing are confidential and free for all enrolled students.',
    ),
  ];
}

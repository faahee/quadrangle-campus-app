import 'package:flutter/material.dart';

import '../models/campus_content.dart';

/// Demonstration data for the lab pages (fictional campus content).
class CampusContentData {
  CampusContentData._();

  static const List<Announcement> announcements = [
    Announcement(
      id: 'ann-registration',
      title: 'Semester 6 course registration opens',
      category: 'Academic',
      date: '2 Nov 2026',
      preview: 'Choose your Semester 6 courses on the portal before 13 Nov.',
      detail:
          'Course registration for Semester 6 is now open on the student portal. '
          'Meet your academic advisor before registering for more than 20 credit '
          'hours or retaking a course. Registration closes on Friday, 13 November '
          'at 5:00 PM; late registration carries a \$50 fee.',
    ),
    Announcement(
      id: 'ann-library-hours',
      title: 'Library extends opening hours for exams',
      category: 'Facilities',
      date: '30 Oct 2026',
      preview: 'The Main Library stays open 24/7 from 23 Nov to 11 Dec.',
      detail:
          'To support exam preparation, the Main Library will open around the clock '
          'from 23 November to 11 December. Level 2 quiet zones and all group study '
          'rooms remain bookable. A valid student card is needed after 10:00 PM.',
    ),
    Announcement(
      id: 'ann-career-fair',
      title: 'Career Discovery Fair – 40+ employers',
      category: 'Careers',
      date: '28 Oct 2026',
      preview: 'Meet recruiters and get your CV reviewed in the Great Hall.',
      detail:
          'The Career Discovery Fair takes place on Wednesday, 18 November from '
          '10:00 AM to 4:00 PM in the Great Hall. More than 40 employers from '
          'software, finance and engineering will attend. Free CV reviews run all '
          'day at the Career Services stand.',
    ),
    Announcement(
      id: 'ann-shuttle',
      title: 'Shuttle Route B diverted for roadworks',
      category: 'Transport',
      date: '27 Oct 2026',
      preview: 'Route B skips North Gate from 9 to 16 November.',
      detail:
          'Because of roadworks on North Gate Road, Shuttle Route B will use the '
          'East Ring Road between 9 and 16 November. A temporary stop is placed '
          'outside the Sports Complex. Allow an extra 10 minutes for journeys to '
          'the Science Park.',
    ),
    Announcement(
      id: 'ann-wellbeing',
      title: 'Wellbeing week: free counselling drop-ins',
      category: 'Wellbeing',
      date: '26 Oct 2026',
      preview: 'Drop-in sessions every afternoon at the Student Centre.',
      detail:
          'Student Wellbeing is running a wellbeing week from 2 to 6 November. '
          'Counsellors are available for confidential drop-in chats every day from '
          '2:00 PM to 5:00 PM in Student Centre Room 4, alongside yoga and '
          'mindfulness sessions on the lawn.',
    ),
    Announcement(
      id: 'ann-wifi',
      title: 'Wi-Fi upgrade in Block C',
      category: 'IT Services',
      date: '24 Oct 2026',
      preview: 'Wireless access paused on Sat 7 Nov, 11 PM – 3 AM.',
      detail:
          'IT Services is upgrading wireless access points across Block C. Wi-Fi '
          'will be unavailable on Saturday, 7 November from 11:00 PM to 3:00 AM. '
          'Wired ports in the computer labs remain available during the work.',
    ),
    Announcement(
      id: 'ann-sports-trials',
      title: 'Inter-faculty football trials',
      category: 'Sports',
      date: '22 Oct 2026',
      preview: 'Trials on the north pitch, Saturday 14 Nov at 9:00 AM.',
      detail:
          'Faculty football teams are selecting players for the spring league. '
          'Trials are open to all students on Saturday, 14 November at 9:00 AM on '
          'the north pitch. Bring boots, water and your student card; bibs are '
          'provided.',
    ),
    Announcement(
      id: 'ann-hostel',
      title: 'Hostel room inspections next week',
      category: 'Accommodation',
      date: '20 Oct 2026',
      preview: 'Routine safety checks in all residential colleges.',
      detail:
          'Accommodation Services will carry out routine fire-safety inspections in '
          'every residential college from 9 to 13 November between 10:00 AM and '
          '4:00 PM. You do not need to be present. Please keep corridors and fire '
          'doors clear.',
    ),
  ];

  static const List<CampusService> services = [
    CampusService(
      id: 'svc-library',
      label: 'Library',
      icon: Icons.local_library_rounded,
      color: Color(0xFF1B2632),
      description: 'Borrow and renew books, and book group study rooms.',
      destination: ServiceDestination.feature,
      featureId: 'library',
    ),
    CampusService(
      id: 'svc-counselling',
      label: 'Counselling',
      icon: Icons.self_improvement_rounded,
      color: Color(0xFF4F7A5C),
      description:
          'Free, confidential support from qualified counsellors for stress, '
          'anxiety, homesickness or anything else on your mind.',
      destination: ServiceDestination.info,
      location: 'Student Centre, Room 4',
      hours: 'Mon–Fri · 9:00 AM – 5:00 PM',
    ),
    CampusService(
      id: 'svc-accommodation',
      label: 'Accommodation',
      icon: Icons.apartment_rounded,
      color: Color(0xFF8A7F6B),
      description:
          'Room allocations, hostel fees, maintenance requests and moving-in '
          'support for all residential colleges.',
      destination: ServiceDestination.info,
      location: 'Residential Office, Wren College',
      hours: 'Mon–Fri · 8:30 AM – 4:30 PM',
    ),
    CampusService(
      id: 'svc-careers',
      label: 'Career Services',
      icon: Icons.work_outline_rounded,
      color: Color(0xFFC9742E),
      description:
          'CV reviews, mock interviews, internship listings and the annual '
          'Career Discovery Fair.',
      destination: ServiceDestination.info,
      location: 'Admin Block, Level 2',
      hours: 'Mon–Fri · 9:00 AM – 5:00 PM',
    ),
    CampusService(
      id: 'svc-sports',
      label: 'Sports',
      icon: Icons.sports_soccer_rounded,
      color: Color(0xFFA35139),
      description:
          'Gym membership, court bookings, team trials and fitness classes at '
          'the Sports Complex.',
      destination: ServiceDestination.info,
      location: 'Sports Complex',
      hours: 'Daily · 6:00 AM – 10:00 PM',
    ),
    CampusService(
      id: 'svc-it',
      label: 'IT Helpdesk',
      icon: Icons.support_agent_rounded,
      color: Color(0xFF2C3B4D),
      description: 'Raise an IT support request and track its progress.',
      destination: ServiceDestination.feature,
      featureId: 'requests',
    ),
  ];
}

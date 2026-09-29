import 'package:flutter/material.dart';

class Student {
  final String fullName;
  final String preferredName;
  final String studentId;
  final String programme;
  final String faculty;
  final String yearLabel;
  final String semester;
  final String email;
  final String phone;
  final String advisor;
  final String intake;
  final String hostel;

  const Student({
    required this.fullName,
    required this.preferredName,
    required this.studentId,
    required this.programme,
    required this.faculty,
    required this.yearLabel,
    required this.semester,
    required this.email,
    required this.phone,
    required this.advisor,
    required this.intake,
    required this.hostel,
  });

  String get initials {
    final parts = fullName.split(' ');
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }
}

class CampusService {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Color tint;
  final String? badge;

  const CampusService({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.tint,
    this.badge,
  });
}

enum AlertCategory { academic, finance, facilities, transport }

class Announcement {
  final String id;
  final String title;
  final String message;
  final String details;
  final String postedOn;
  final String deadline;
  final String badge;
  final AlertCategory category;
  final IconData icon;
  final bool pinned;
  final String relatedServiceId;
  final String relatedActionLabel;

  const Announcement({
    required this.id,
    required this.title,
    required this.message,
    required this.details,
    required this.postedOn,
    required this.deadline,
    required this.badge,
    required this.category,
    required this.icon,
    required this.relatedServiceId,
    required this.relatedActionLabel,
    this.pinned = false,
  });
}

class CampusEvent {
  final String id;
  final String title;
  final String day;
  final String month;
  final String weekday;
  final String time;
  final String venue;
  final String organiser;
  final String description;
  final String category;
  final int seatsLeft;
  final IconData icon;
  final Color color;

  const CampusEvent({
    required this.id,
    required this.title,
    required this.day,
    required this.month,
    required this.weekday,
    required this.time,
    required this.venue,
    required this.organiser,
    required this.description,
    required this.category,
    required this.seatsLeft,
    required this.icon,
    required this.color,
  });
}

class ClassSession {
  final String start;
  final String end;
  final String code;
  final String title;
  final String room;
  final String lecturer;
  final String type;

  const ClassSession({
    required this.start,
    required this.end,
    required this.code,
    required this.title,
    required this.room,
    required this.lecturer,
    required this.type,
  });
}

class CourseResult {
  final String code;
  final String title;
  final int credits;
  final String grade;
  final double points;

  const CourseResult(
    this.code,
    this.title,
    this.credits,
    this.grade,
    this.points,
  );
}

class AttendanceRecord {
  final String code;
  final String title;
  final int attended;
  final int total;

  const AttendanceRecord(this.code, this.title, this.attended, this.total);

  double get ratio => attended / total;
}

class Invoice {
  final String id;
  final String title;
  final double amount;
  final String dueDate;
  bool paid;

  Invoice({
    required this.id,
    required this.title,
    required this.amount,
    required this.dueDate,
    this.paid = false,
  });
}

class BorrowedBook {
  final String id;
  final String title;
  final String author;
  DateTime dueDate;
  int renewals;

  BorrowedBook({
    required this.id,
    required this.title,
    required this.author,
    required this.dueDate,
    this.renewals = 0,
  });
}

class ShuttleRoute {
  final String id;
  final String name;
  final String from;
  final String to;
  final String frequency;
  final String status;
  final Color color;
  final List<String> stops;

  const ShuttleRoute({
    required this.id,
    required this.name,
    required this.from,
    required this.to,
    required this.frequency,
    required this.status,
    required this.color,
    required this.stops,
  });
}

class Club {
  final String id;
  final String name;
  final String category;
  final int members;
  final String meets;
  final String description;
  final IconData icon;
  final Color color;

  const Club({
    required this.id,
    required this.name,
    required this.category,
    required this.members,
    required this.meets,
    required this.description,
    required this.icon,
    required this.color,
  });
}

class HelpTicket {
  final String id;
  final String category;
  final String subject;
  final String status;
  final String date;

  const HelpTicket({
    required this.id,
    required this.category,
    required this.subject,
    required this.status,
    required this.date,
  });
}

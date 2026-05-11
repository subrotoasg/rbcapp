class AppConfig {
  AppConfig._();

  static const String appName = 'রূপসী বাংলা ক্লাব';
  static const String shortAppName = 'RBC';
  static const String packageName = 'com.rbc15.rbc';
  static const String backendUrl = 'https://rbc-server.vercel.app';
  static const String websiteUrl = 'https://rbcweb.vercel.app';
  static const String facebookGroup = 'https://www.facebook.com/groups/rbc2015';
  static const String mobileNumber = '0963 9154759';
  static const String email = 'info@rbcweb.site';
  static const String youtubeUrl = 'https://www.youtube.com/@INDIANCULTUREKIRTAN';
  static const String bangladeshSportsUrl = 'https://www.google.com/search?q=Bangladesh+cricket+live+score';
  static const String googleMeetUrl = 'https://meet.google.com/';
  static const String googleCalendarUrl = 'https://calendar.google.com/calendar/u/0/r';

  static const String googleClientId = '919632471361-smrg1n1doaomgnfegj8nij0qnirml5si.apps.googleusercontent.com';
  static const String googleServerClientId = '919632471361-smrg1n1doaomgnfegj8nij0qnirml5si.apps.googleusercontent.com';

  static const String imgbbApiKey = 'f29b697f5f096645c6847c9c54f25070';

  static const int sessionYears = 5;
  static Duration get sessionDuration => const Duration(days: 365 * sessionYears);
}

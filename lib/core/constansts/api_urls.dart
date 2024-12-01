class ApiUrls {
  static const baseUrl = 'http://192.168.56.1:8000/api/';
  static const login = '${baseUrl}login';
  static const studentHome = '${baseUrl}student/home';
  static const studentGuidance = '${baseUrl}student/guidance';
  static const studentLogBook = '${baseUrl}student/logBook';
  static const studentProfile = '${baseUrl}student/profile';
  static const notification = '${baseUrl}student/notification';
  static const notificationMarkAsRead = '${baseUrl}notification/markAsRead';


  static const lecturerHome = '${baseUrl}lecturer/home';
  static const detailStudent = '${baseUrl}lecturer/detailStudent';
  static const updateLogBookNote = '${baseUrl}lecturer/logBook';
  static const finishedStudent = '${baseUrl}lecturer/finishedStudent';
  static const updateStatusGuidance = '${baseUrl}lecturer/guidance';
  static const updateStatusProfile = '${baseUrl}lecturer/profile';
  static const getAssessments = '${baseUrl}lecturer/assessments';
  static const submitScores = '${baseUrl}lecturer/addAssessment';
  static const updateFinishedStudent = '${baseUrl}lecturer/finishedStudent';
  static const addNotification  = '${baseUrl}lecturer/notifications';

  static const updatePhotoProfile = '${baseUrl}updateProfile';
  static const resetPassword = '${baseUrl}resetPassword';
}

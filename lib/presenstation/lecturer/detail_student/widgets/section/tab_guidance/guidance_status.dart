// ignore_for_file: constant_identifier_names

enum LecturerGuidanceStatus { 
  approved, 
  rejected, 
  inProgress, 
  updated 
}

class GuidanceStatusHelper {
  static LecturerGuidanceStatus mapStringToStatus(String status) {
    switch (status) {
      case 'approved':
        return LecturerGuidanceStatus.approved;
      case 'in-progress':
        return LecturerGuidanceStatus.inProgress;
      case 'rejected':
        return LecturerGuidanceStatus.rejected;
      default:
        return LecturerGuidanceStatus.updated;
    }
  }

  static String getStatusTitle(LecturerGuidanceStatus status) {
    return status == LecturerGuidanceStatus.approved ? 'menyetujui' : 'merevisi';
  }

  static String getNotificationTitle(LecturerGuidanceStatus status) {
    return status == LecturerGuidanceStatus.approved 
      ? 'Bimbingan Anda Disetujui' 
      : 'Bimbingan Anda Perlu Direvisi';
  }

  static String getNotificationCategory(LecturerGuidanceStatus status) {
    return status == LecturerGuidanceStatus.approved ? 'guidance' : 'revision';
  }
}
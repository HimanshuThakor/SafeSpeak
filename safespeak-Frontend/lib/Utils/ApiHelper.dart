class ApiHelper {
  static const String baseUrl =
      'https://safespeak.onrender.com/api/'; //'https://livewellapi.life-connect.in/api/';
  static const socketUrl = "https://safespeak.onrender.com";
  static const String loginUrl = 'auth/login';
  static const String registerUrl = 'auth/register';
  static const String getDashboardData = 'admin/dashboard';
  static const String userProfile = 'user/profile';
  static const String getEvents = 'event/get-all-events';
  static const String createEvent = 'admin/events';
  static const String deleteEvent = 'admin/delete-events';
  static const String getUsersDetails = 'admin/usersDetails';
  static const String createCategory = 'admin/categories';
  static const String getAllCategories = 'admin/categories';
  static const String deleteCategory = 'admin/categories-delete';
  static const String updateCategory = 'admin/categories-update';
  static const String getScanners = 'admin/scanners';
  static const String createScanner = 'admin/create-scanner';
  static const String updateScanner = 'admin/edit-scanner';
  static const String deleteScanner = 'admin/delete-scanner';
  static const String assignEventToScanner = 'admin/assign-scanner';
  static const String getEventsForUser = 'user/events';
  static const String bookEvent = 'user/tickets/book';
  static const String fetchAssignedEvents = 'scanner/events';
  static const String checkTicketIsValid = 'scanner/scan';
  static const String createPaymentOrder = 'payment/create-order';
  static const String checkMessage = 'toxicity/check';
  static const String addFamilyMember = 'users/add-emergency-contacts';
  static const String updateFamilyMember = 'users/update-emergency-contacts';
  static const String getFamilyMembers = 'users/get-emergency-contacts';
  static const String removeFamilyMember = 'users/delete-emergency-contacts';
}

class AppUrls {
  AppUrls._();


  //static const String _baseUrl = 'http://10.0.20.64:5008/api/v1';
   //static const String _baseUrl = 'http://10.0.20.12:5008/api/v1';
   static const String _baseUrl = 'http://147.93.41.241:7008/api/v1';




   // Authentication Part
   static const String register = '$_baseUrl/user/create';
   static const String verifyOTp = '$_baseUrl/auth/verify-otp';
   static const String forgotVerifyOtp= '$_baseUrl/auth/forget-otp-verify';
   static const String verifySignUpOTp = '$_baseUrl/auth/verify-otp';
   static const String resendEmail= '$_baseUrl/auth/resend-otp';
   static const String login = '$_baseUrl/auth/login';
   static const String forgotEmail = '$_baseUrl/auth/forget-password';
   static const String resetPassword = '$_baseUrl/auth/reset-password';
   static const String changePassword = '$_baseUrl/user/change-password';

   // Profile
   static const String getMe = '$_baseUrl/user/me';
   static  getSingleUser(String userId) =>'$_baseUrl/user/single/$userId';


   // Recommended User
    static getRecommendedUser({required String lat,required String long}) => '$_baseUrl/user/recommend?myLat=$lat&myLong=$long';

    // Add Favourite
    static  addFavourite(String engineerId) => '$_baseUrl/favorite/add/$engineerId';
    static  removeFavourite(String engineerId) => '$_baseUrl/favorite/remove/$engineerId';
  static const String getAllFavourite = '$_baseUrl/favorite/all';


   //
  static const String requestService = '$_baseUrl/service/create-service';
  static const String getUserService = '$_baseUrl/service/user-service?status=pending';
  static const String getProgressingService = '$_baseUrl/service/user-service?status=progressing';
  static const String getEngineerNearService = '$_baseUrl/service/my-near-service';
  static const String sendOffer = '$_baseUrl/service/offer';
  static  getSingleServiceDetails(String serviceId) => '$_baseUrl/service/single-service/$serviceId';
  static  getOfferList(String serviceId) => '$_baseUrl/service/offer-list/$serviceId';
  static  acceptOffer(String offerId) => '$_baseUrl/service/accept-offer/$offerId';
  static  declineOffer(String offerId) => '$_baseUrl/service/decline-offer/$offerId';


  // Payment
  static const String confirmPayment= '$_baseUrl/payment/create';








}

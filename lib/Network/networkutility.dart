class NetworkUtility {
  static String baseurl = "https://staginglink.org/twice/";
  static String insert_call_record_api = baseurl + "insert_call_record_api";
  static String register_new_user_api = baseurl + "register_new_user_api";
  static String add_new_contact_api = baseurl + "add_new_contact_api";
  static String add_call_schedule_api = baseurl + "add_call_schedule_api";
  static String get_month_wise_call_schedule_api =
      baseurl + "get_month_wise_call_schedule_api";
  static String get_date_wise_call_schedule_api =
      baseurl + "get_date_wise_call_schedule_api";
  static String get_call_all_summary_api = baseurl + "get_call_all_summary_api";
  static String get_mobile_number_verify_api =
      baseurl + "get_mobile_number_verify_api";
  static String get_all_user_list_api = baseurl + "get_all_user_list_api";
  static String get_user_call_logs_api = baseurl + "get_user_call_logs_api";

  static int register_new_user = 1;
  static int insert_call_record = 2;
  static int add_new_contact = 3;
  static int add_call_schedule = 4;
  static int get_month_wise_call_schedule = 5;
  static int get_date_wise_call_schedule = 6;
  static int get_call_all_summary = 7;
  static int get_mobile_number_verify = 8;
  static int get_all_user_list = 9;
  static int get_user_call_logs = 10;
}

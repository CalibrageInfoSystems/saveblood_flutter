library APIConstants;

const String SUCCESS_MESSAGE=" You will be contacted by us very soon.";

//var baseUrl = "http://183.82.111.111/SaveBloodAPI/";           // Live
var baseUrl = "http://183.82.111.111/SaveBloodAPILatest/";      // Test

var loginComponentUrl="api/Account/Login";

var recoverPasswordComponentUrl="api/Account/public/recoverpassword";

var signUpComponentUrl="api/Account/public/users";

var getProfileComponentUrl="api/Account/users/userinfoById?userId=";

var getUserInfoByIdComponentUrl="api/Account/users/userinfoById";

var getbloodgroupsUrl = "api/BloodInventory/BloodTypes";

var getClassTypeComponentUrl="/api/Master/ClassType";

var getTypeCdDmtByClassTypeIdComponentUrl="api/Master/TypeCdDmtByClassTypeId";

var getCountryComponentUrl="api/Country";

var getStatesByCountryComponentUrl="api/State/GetStatesByCountry/1";

var getDistrictsByStateComponentUrl="api/District/GetDistrictsByState";

var getMandalsByDistrictComponentUrl="api/Mandal/GetMandalsByDistrict";

var getVillagesByMandalComponentUrl="api/Village/GetVillagesByMandal";

var updateProfileComponentUrl="api/Account/UserInfo";

var getAllNotificationsUrl="api/Notification/AllNotifications";

var doAcceptNotificationComponentUrl="api/Notification/AcceptOrRejectNotificationForMobile";

var doRejectNotificationComponentUrl="api/Notification/AcceptOrRejectNotificationForMobile";

var updateGeoLocationComponentUrl="api/GeoLocation";

var updateDeviceTokenComponentUrl = "api/UserInfo";

var shareInfo = "check out my website https://saveblood.com";
import 'package:flutter/material.dart';

String deviceToken = '';

const greenColor = '#008000';
const redColor = '#FF0000';

// 3 bar bounce 590
// vidhya dhar branch

// FireBase table's name
const kFireBaseConnect = '__';
const tblUserDetails = 'userDetails';
const tblFitnessGoal = 'fitness_Goal';
const tblActiveDailyLife = 'active_Daily_Life';
const tblTermsPrivacyAppVersion = 'terms_Privacy_AppVersion';
const tblFeedback = 'feedback';
const tblPaymentCards = 'paymentCards';
const tblTracks = 'tracks';
const tblGoals = 'goals';
const tblExercises = 'exercises';
const tblQuotes = 'quotes';
const tblFoodDetails = 'food_Details';
const tblAdmin = 'admin';


// FireStorage image folder name
const kUserProfilePicture = 'userProfilePicture/';
const kGoalPhoto = 'goalPhoto/';
const kWeeklyGoalPhoto = 'weeklyGoalPhoto/';
// FireBase parameter
const kUserID = 'userID';
const kEmail = 'email';
const kDeviceToken = 'deviceToken';
const kDeviceType = 'deviceType';
const kPassword = 'password';

const kFirstName = 'first_name';
const kLastName = 'last_name';
const kLocation = 'location';
const kDateOfBirth = 'date_of_birth';
const kGender = 'gender';
const kProfilePicture = 'profile_Picture';
const kFitnessGoal = 'fitness_Goal';
const kActiveDailyLife = 'active_Daily_Life';

const kID = 'id';
const kName = 'name';
const kDocID = 'docID';
const kSocialType = 'socialType';
const kQuotes = 'quotes';
const kTitle = 'title';
const kSubtitle = 'subtitle';

var kIsAdmin = false;
const kTerms = 'terms';
const kPrivacyPolicy = 'privacyPolicy';
const kAppVersion = 'appVersion';

const kFeedbackTitle = 'feedback_Title';
const kFeedbackDescription = 'feedback_Description';

const kCardName = 'cardName';
const kCardNumber = 'cardNumber';
const kExpiryDate = 'expiryDate';
const kCVV = 'cvv';
const kVisa = 'visa';
const kCreatedTime = 'createdTime';

const kSteps = 'steps';
const kWater = 'water';
const kExerciseTime = 'exerciseTime';
const kAchieveGoal = 'achieveGoal';

const kGoalsPicture = 'goalsPicture';
const kGoalsDescription = 'goalsDescription';
const kDailyGoalsCheckIn = 'dailyGoalsCheckIn';
const kWeeklyGoalsTracker = 'weeklyGoalsTracker';

const kWhatAreYou_GreateFul_For_Today = 'whatAreYou_GreateFul_For_Today';
const kWhatIsYour_Health_Fitness_Goal = 'whatIsYour_Health_Fitness_Goal';
const kWhatIsYour_Work_Personal_Life_Goals = 'whatIsYour_Work_Personal_Life_Goals';
const kDidYouAchieveYour_Health_FitnessGoal = 'didYouAchieveYour_Health_FitnessGoal';
const kDidYouAchieveYour_Work_PersonalGoal = 'didYouAchieveYour_Work_PersonalGoal';
const kWhatCouldIDoBetter_Tomorrow = 'whatCouldIDoBetter_Tomorrow';

const kWeight = 'weight';
const kWaist = 'waist';
const kHips = 'hips';
const kChest = 'chest';
const kThigh = 'thigh';
const kUploadProgressImage = 'uploadProgressImage';
const kDidYouAchieveYour_Health_Fitness_Goal_this_Week = 'didYouAchieveYour_Health_Fitness_Goal_this_Week';
const kDidYouAchieveYour_Work_Personal_Life_Goal_this_Week = 'didYouAchieveYour_Work_Personal_Life_Goal_this_Week';
const kWhatIsYour_Health_Fitness_Goal_Next_Week = 'whatIsYour_Health_Fitness_Goal_Next_Week';
const kWhatIsYour_Work_Personal_Life_Goal_Next_Week = 'whatIsYour_Work_Personal_Life_Goal_Next_Week';
const kDidYouAchieveYour_Health_FitnessGoal_Next_Week = 'didYouAchieveYour_Health_FitnessGoal_Next_Week';
const kDidYouAchieveYour_Work_PersonalGoal_Next_Week = 'didYouAchieveYour_Work_PersonalGoal_Next_Week';



const kUpper_body = 'upper_body';
const kCore_cardio = 'core_cardio';
const kFull_body = 'full_body';
const kLower_body = 'lower_body';


const kBreakfast = 'breakfast';
const kLunch = 'lunch';
const kDinner = 'dinner';
const kSnacks = 'snacks';

const kFood = 'food';
const kFoodTime = 'foodTime';
const kCalories = 'calories';
const kAny_Other_Notes_About_How_You_Felf_During_Or_After_Eating = 'any_Other_Notes_About_How_You_Felf_During_Or_After_Eating';

const kHow_Was_Your_Energy_After_Breakfast = 'how_Was_Your_Energy_After_Breakfast';
const kHow_Did_You_Feel_After_Breakfast = 'how_Did_You_Feel_After_Breakfast';

const kHow_Did_You_Feel_After_Lunch = 'how_Did_You_Feel_After_Lunch';
const kHow_Was_Your_Energy_After_Lunch = 'how_Was_Your_Energy_After_Lunch';

const kHow_Did_You_Feel_After_Dinner = 'how_Did_You_Feel_After_Dinner';
const kHow_Was_Your_Energy_After_Dinner = 'how_Was_Your_Energy_After_Dinner';

const kForWhatReasonDidYouHaveThisSnack = 'for_What_Reason_Did_You_Have_This_Snack';
const kWhatThisSnackNutritous = 'what_This_Snack_Nutritous';
const kOtherReason = 'otherReason';
const kWhatBetterOptionCouldYouHaveChosen = 'what_Better_Option_Could_You_Have_Chosen';

const kLive = 'liveLink';
const kLink = 'link';
const kLiveOn = 'liveOn';
const kThumbnail = 'thumbnail';
const kWorkoutOfTheDay = 'workoutOfTheDay';

const kAdminNumber = 'adminNumber';



class AppConstant {
  static const kKollektif = 'kollektif';
  static const kPoppins = 'Poppins';

  static const fontRegular = 'kollektif';
  static const fontBold = 'kollektif_bold';
  static const fontMedium = 'Poppins_medium';
  static const colorPrimary = Color(0xff004A23);
  static const colorPrimaryDark = Color(0xff00574B);
  static const colorAccent = Color(0xff008577);
  static const color_blue_dark = Color(0xff232F45);

  static const dollar = '\$';
  static const colorwhite = Color(0xffFFFFFF);

  static const session = "session";
  static const user = "UserData";
  static const id = "id";
  static const name = "name";
  static const email = "email";
  static const accessToken = "accessToken";
  static const image = "image";
  static const lang = "lang";
  static const APP_ID = '25b2215187564c728908f0410fbdd229';
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

BoxDecoration kButtonThemeGradientColor() {
  return BoxDecoration(
      color: Colors.red,
      borderRadius: BorderRadius.circular(16),
      gradient: LinearGradient(
        colors: [HexColor('2E4877'), HexColor('29364E')],
        begin: FractionalOffset.topCenter,
        end: FractionalOffset.bottomCenter,
      ));
}

BoxDecoration kGoalButtonThemeGradientColor() {
  return BoxDecoration(
      color: Colors.red,
      borderRadius: BorderRadius.circular(16),
      gradient: LinearGradient(
        colors: [HexColor('54C9AF'), HexColor('1CA386')],
        begin: FractionalOffset.topCenter,
        end: FractionalOffset.bottomCenter,
      ));
}

BoxDecoration kFitnessThemeGradientColor() {
  return BoxDecoration(
      color: Colors.red,
      borderRadius: BorderRadius.circular(16),
      gradient: LinearGradient(
        colors: [HexColor('54C9AF'), HexColor('1CA386')],
        begin: FractionalOffset.topCenter,
        end: FractionalOffset.bottomCenter,
      ));
}

PreferredSize setAppBar() {
  return PreferredSize(
      preferredSize: Size.fromHeight(0),
      child: AppBar(
        // Here we create one to set status bar color
        backgroundColor: Colors.white,
        elevation: 0,
        brightness: Brightness
            .light, // Set any color of status bar you want; or it defaults to your theme's primary color
      ));
}

void showLoading(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
                color: AppConstant.colorPrimaryDark,
                borderRadius: BorderRadius.circular(6)),
            height: 80,
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Row(
              children: [
                CircularProgressIndicator(
                  backgroundColor: AppConstant.colorAccent,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
                SizedBox(width: 20),
                Text(
                  'Loading...',
                  style: TextStyle(
                      color: Colors.white,
                      // fontFamily:kFontRaleway,
                      fontSize: 18,
                      fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ));
    },
  );
}

void dismissLoading(BuildContext context) {
  Navigator.pop(context);
}


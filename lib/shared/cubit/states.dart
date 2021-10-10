
abstract class AppStates {}

class AppInitialState extends AppStates{}

class AppCreateDBState extends AppStates{}

class AppInsertIntoDBState extends AppStates{}

class AppUpdateDBState extends AppStates{}

class AppDeleteFromDBState extends AppStates{}

class AppGetFromDBState extends AppStates{}

class AppChangeBottomNavState extends AppStates{}

class AppChangeBottomSheetState extends AppStates{}

class AppChangeIndex extends AppStates{}

class AppLoadingCircleState extends AppStates{}
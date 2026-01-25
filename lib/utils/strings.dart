/// App-wide string constants
/// Centralizes all user-facing text for easy localization and maintenance
class AppStrings {
  // App
  static const String appName = 'AutoMobile';
  
  // Auth
  static const String welcome = 'Welcome';
  static const String welcomeBack = 'Welcome Back';
  static const String signInToContinue = 'Sign in to continue your journey';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String enterEmail = 'Enter your email';
  static const String enterPassword = 'Enter your password';
  static const String forgotPassword = 'Forgot Password?';
  static const String signIn = 'Sign In';
  static const String signUp = 'Sign Up';
  static const String orContinueWith = 'or continue with';
  static const String google = 'Google';
  static const String facebook = 'Facebook';
  static const String apple = 'Apple';
  
  // Validation
  static const String emailRequired = 'Please enter both email and password';
  static const String emailInvalid = 'Please enter a valid email address';
  static const String passwordWeak = 'Password should be at least 6 characters';
  
  // Home
  static const String findYourDreamCar = 'Find Your Dream Car';
  static const String searchCars = 'Search cars...';
  static const String featuredCars = 'Featured Cars';
  static const String allCars = 'All Cars';
  static const String viewAll = 'View All';
  
  // Categories
  static const String luxury = 'Luxury';
  static const String sports = 'Sports';
  static const String suv = 'SUV';
  static const String electric = 'Electric';
  static const String hatchback = 'Hatchback';
  static const String sedan = 'Sedan';
  
  // Car Details
  static const String specifications = 'Specifications';
  static const String features = 'Features';
  static const String overview = 'Overview';
  static const String topSpeed = 'Top Speed';
  static const String acceleration = 'Acceleration';
  static const String horsepower = 'Horsepower';
  static const String transmission = 'Transmission';
  static const String seats = 'Seats';
  static const String fuelType = 'Fuel Type';
  static const String bodyType = 'Body Type';
  static const String visitWebsite = 'Visit Official Website';
  static const String addToFavorites = 'Add to Favorites';
  static const String removeFromFavorites = 'Remove from Favorites';
  static const String compareCar = 'Compare';
  
  // Search & Filters
  static const String filters = 'Filters';
  static const String sortBy = 'Sort By';
  static const String priceRange = 'Price Range';
  static const String category = 'Category';
  static const String resetFilters = 'Reset Filters';
  static const String clearFilters = 'Clear Filters';
  static const String applyFilters = 'Apply Filters';
  static String carsFound(int count) => '$count cars found';
  static const String noResults = 'No cars match your filters';
  
  // Sort Options
  static const String priceLowToHigh = 'Price: Low to High';
  static const String priceHighToLow = 'Price: High to Low';
  static const String ratingHighToLow = 'Rating: High to Low';
  static const String nameAZ = 'Name: A-Z';
  
  // Favorites
  static const String favorites = 'Favorites';
  static const String myFavorites = 'My Favorites';
  static const String noFavorites = 'No favorites yet';
  static const String startAddingFavorites = 'Start adding your dream cars to see them here';
  
  // Recently Viewed
  static const String recentlyViewed = 'Recently Viewed';
  static const String noHistory = 'No viewing history';
  static const String browseToSeeHistory = 'Browse cars to build your history';
  
  // Compare
  static const String compare = 'Compare';
  static const String compareCars = 'Compare Cars';
  static const String selectCarsToCompare = 'Select cars to compare specs';
  static const String clearComparison = 'Clear Comparison';
  static const String addCarToCompare = 'Add Car';
  static String compareCount(int current, int max) => '$current/$max cars selected';
  static const String confirmClearComparison = 'Are you sure you want to clear the comparison?';
  
  // EMI Calculator
  static const String emiCalculator = 'EMI Calculator';
  static const String loanAmount = 'Loan Amount';
  static const String interestRate = 'Interest Rate (p.a.)';
  static const String loanTenure = 'Loan Tenure';
  static const String monthlyEMI = 'Monthly EMI';
  static const String perMonth = 'per month';
  static const String principal = 'Principal';
  static const String interest = 'Interest';
  static const String total = 'Total';
  static const String loanBreakdown = 'Loan Breakdown';
  static const String principalAmount = 'Principal Amount';
  static const String totalInterest = 'Total Interest';
  static const String totalPayable = 'Total Payable';
  
  // Profile
  static const String profile = 'Profile';
  static const String myProfile = 'My Profile';
  static const String settings = 'Settings';
  static const String signOut = 'Sign Out';
  static const String confirmSignOut = 'Are you sure you want to sign out?';
  
  // Common
  static const String loading = 'Loading...';
  static const String error = 'Error';
  static const String retry = 'Retry';
  static const String cancel = 'Cancel';
  static const String confirm = 'Confirm';
  static const String okay = 'Okay';
  static const String yes = 'Yes';
  static const String no = 'No';
  static const String save = 'Save';
  static const String delete = 'Delete';
  static const String remove = 'Remove';
  static const String edit = 'Edit';
  static const String done = 'Done';
  static const String back = 'Back';
  static const String next = 'Next';
  static const String skip = 'Skip';
  static const String getStarted = 'Get Started';
  
  // Error Messages
  static const String somethingWentWrong = 'Something went wrong';
  static const String pleaseTryAgain = 'Please try again';
  static const String noInternetConnection = 'No internet connection';
  static const String checkYourConnection = 'Please check your connection and try again';
  static const String failedToLoadData = 'Failed to load data';
  static const String failedToLoadCars = 'Failed to load cars';
  
  // Success Messages
  static const String addedToFavorites = 'Added to favorites';
  static const String removedFromFavorites = 'Removed from favorites';
  static const String addedToComparison = 'Added to comparison';
  static const String removedFromComparison = 'Removed from comparison';
}

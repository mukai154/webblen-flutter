class FormValidators {

  String validateEmail(String email) {
    String error = "";
    if (!email.contains('@')) {
      error = "Invalid Email";
    }
    return error;
  }

  String validatePassword(String password, String confirmPassword) {
    String error = "";
    if (password.length < 8) {
      error = 'Password Must be at least 8 Characters Long';
    } else if (password.trim() == "")  {
      error = 'Password Must be at least 8 Characters Long';
    } else if (password != confirmPassword) {
      error = 'Passwords Must Match';
    }
    return error;
  }

}
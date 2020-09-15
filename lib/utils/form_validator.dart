class FormValidator {
  static FormValidator _instance;
 
  factory FormValidator() => _instance ??= new FormValidator._();
 
  FormValidator._();
 
  String validatePassword(String value) {
    String patttern = r'(^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{6,}$)';
    //RegExp regExp = new RegExp(patttern);
    if (value.isEmpty) {
      return "Password is Required";
    } else if (value.length < 8) {
      return "La contrasela debe ser mayor a 7 dígitos";
    } else if (value.length < 8) {
      return "La contraseña debe ser menor a 25 dígitos";
    }/* else if (!regExp.hasMatch(value)) {
      return "Password at least one uppercase letter, one lowercase letter and one number";
    } */
    return null;
  }
 
  String validateEmail(String value) {
    String pattern =
        //r'/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,4})+$/';
        //^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$;
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regExp = new RegExp(pattern);
    if (value.isEmpty) {
      return "Email is Required";
    }else if (!regExp.hasMatch(value)) {
      return "Invalid Email";
    } else {
      return null;
    }
  }
}
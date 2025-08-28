package in.enp.sms.validator;

import in.enp.sms.entities.User;
import in.enp.sms.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;
import org.springframework.validation.Validator;

import java.util.regex.Pattern;


@Component
public class UserValidator implements Validator {
    private static final String PASSWORD_PATTERN = "^(?=.*[0-9])(?=.*[!@#$%^&*(),.?\":{}|<>]).{8,}$";

    @Override
    public boolean supports(Class<?> aClass) {
        return User.class.equals(aClass);
    }

    @Override
    public void validate(Object o, Errors errors) {
        User user = (User) o;

        // Check if passwords match
        if (!user.getPassword().equals(user.getPasswordConfirm())) {
            errors.rejectValue("passwordConfirm", "Match.user.passwordConfirm", "Passwords do not match");
        }

        // Check password strength
        if (!Pattern.matches(PASSWORD_PATTERN, user.getPassword())) {
            errors.rejectValue("password", "Weak.user.password", "Password must be at least 8 characters long and contain a number and special character.");
        }

        // You can add more validations here (e.g., username uniqueness)
    }
}

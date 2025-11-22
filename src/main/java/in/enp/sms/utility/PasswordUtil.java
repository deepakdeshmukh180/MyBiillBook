package in.enp.sms.utility;

import java.security.SecureRandom;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class PasswordUtil {

    private static final String UPPER = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    private static final String LOWER = "abcdefghijklmnopqrstuvwxyz";
    private static final String DIGITS = "0123456789";
    private static final String SPECIALS = "!@#$%";

    private static final SecureRandom random = new SecureRandom();

    public static String generateSecurePassword() {
        String allChars = UPPER + LOWER + DIGITS + SPECIALS;

        List<Character> passwordChars = new ArrayList<>();

        // Ensure at least one digit and one special character
        passwordChars.add(DIGITS.charAt(random.nextInt(DIGITS.length())));
        passwordChars.add(SPECIALS.charAt(random.nextInt(SPECIALS.length())));

        // Fill the remaining 6 characters
        for (int i = 0; i < 6; i++) {
            passwordChars.add(allChars.charAt(random.nextInt(allChars.length())));
        }

        // Shuffle to randomize character positions
        Collections.shuffle(passwordChars, random);

        // Convert list to string
        StringBuilder password = new StringBuilder();
        for (char c : passwordChars) {
            password.append(c);
        }

        return password.toString();
    }
}

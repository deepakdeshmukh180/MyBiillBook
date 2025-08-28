package in.enp.sms.utility;

public class AmountInWordUtility {

    private static final String[] units = {
            "", "One", "Two", "Three", "Four", "Five",
            "Six", "Seven", "Eight", "Nine", "Ten",
            "Eleven", "Twelve", "Thirteen", "Fourteen",
            "Fifteen", "Sixteen", "Seventeen", "Eighteen",
            "Nineteen"
    };

    private static final String[] tens = {
            "", "", "Twenty", "Thirty", "Forty", "Fifty",
            "Sixty", "Seventy", "Eighty", "Ninety"
    };

    public static String convertToWords(double amount) {
        if (amount == 0) {
            return "Zero Rupees";
        }

        long rupees = (long) amount; // Only integer part considered

        return convertNumber(rupees).trim() + " Rupees";
    }

    private static String convertNumber(long num) {
        if (num == 0) {
            return "";
        }

        if (num < 20) {
            return units[(int) num];
        } else if (num < 100) {
            return tens[(int) num / 10] + (num % 10 != 0 ? " " + units[(int) num % 10] : "");
        } else if (num < 1000) {
            return units[(int) num / 100] + " Hundred" + (num % 100 != 0 ? " " + convertNumber(num % 100) : "");
        } else if (num < 100000) {
            return convertNumber(num / 1000) + " Thousand" + (num % 1000 != 0 ? " " + convertNumber(num % 1000) : "");
        } else if (num < 10000000) {
            return convertNumber(num / 100000) + " Lakh" + (num % 100000 != 0 ? " " + convertNumber(num % 100000) : "");
        } else {
            return convertNumber(num / 10000000) + " Crore" + (num % 10000000 != 0 ? " " + convertNumber(num % 10000000) : "");
        }
    }

    // Example usage

}

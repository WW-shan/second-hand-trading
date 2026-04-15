package com.second.hand.trading.server.enums;

/**
 * Standard API error messages.
 */
public enum ErrorMsg {

    ACCOUNT_EXIT("User already exists"),
    ACCOUNT_Ban("Account has been blocked"),
    ACCOUNT_NOT_EXIT("User does not exist"),
    PASSWORD_IS_NOT_SAME("Passwords do not match"),
    PASSWORD_RESET_ERROR("Failed to reset password"),
    EMAIL_SEND_ERROR("Failed to send email, please retry"),
    PARAM_ERROR("Invalid parameters"),
    SYSTEM_ERROR("System error"),
    REGISTER_ERROR("Registration failed"),
    FILE_TYPE_ERROR("Invalid file type. Please choose .jpg or .png"),
    FILE_UPLOAD_ERROR("File upload failed"),
    FILE_NOT_EXIT("File does not exist"),
    FILE_DOWNLOAD_ERROR("File download error"),
    FILE_SIZE_ERROR("File is too large"),
    OPERAT_FREQUENCY("Too many operations, please retry later"),
    MISSING_PARAMETER("Missing parameter"),
    COOKIE_ERROR("Please sign in again"),
    EMAIL_LOGIN_ERROR("Sign-in failed. Incorrect account or password"),
    JSON_READ_ERROR("JSON parsing error"),
    FORM_NUMBER_ERROR("Invalid form id"),
    REPEAT_COMMIT_ERROR("Please do not submit repeatedly"),
    COMMIT_FAIL_ERROR("Submit failed"),
    FAVORITE_EXIT("Favorite already exists");

    private final String msg;

    ErrorMsg(String msg) {
        this.msg = msg;
    }

    public String getMsg() {
        return msg;
    }
}

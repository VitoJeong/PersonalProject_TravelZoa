package email;

import javax.mail.Authenticator;
import javax.mail.PasswordAuthentication;

public class SMTPAuthenticatior extends Authenticator{  
    @Override
    protected PasswordAuthentication getPasswordAuthentication() {
        return new PasswordAuthentication("vitojeong@naver.com","vito123!@");
    }
}


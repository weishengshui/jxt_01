package jxt.elt.common;

import javax.mail.Authenticator;
import javax.mail.PasswordAuthentication;

/**
 * Email发送帐号密码验证类
 */

public class CheckSendEmail extends Authenticator{
  private String m_username = null;
  private String m_userpass = null;
  public void setUsername(String username)
  {
      m_username = username;
  }
  public void setUserpass(String userpass)
  {
      m_userpass = userpass;
  }
  public CheckSendEmail(String username, String userpass)
  {
      super();
      setUsername(username);
      setUserpass(userpass);
  }
  public PasswordAuthentication getPasswordAuthentication()
  {
      return new PasswordAuthentication(m_username,m_userpass);
  }
}

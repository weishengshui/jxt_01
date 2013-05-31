package com.ssh.base;

import com.opensymphony.xwork2.ActionSupport;
import com.ssh.entity.TblQy;
import java.util.Map;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.struts2.ServletActionContext;
import org.apache.struts2.interceptor.ServletRequestAware;
import org.apache.struts2.interceptor.ServletResponseAware;
import org.apache.struts2.interceptor.SessionAware;
import org.apache.struts2.util.ServletContextAware;

public abstract class BaseAction extends ActionSupport
  implements ServletContextAware, ServletResponseAware, ServletRequestAware, SessionAware
{
  private static final long serialVersionUID = -5094026918456713617L;
  private static String ipAddress = null;
  protected ServletContext servletContext;
  protected HttpServletRequest httpServletRequest;
  protected HttpServletResponse httpServletResponse;
  protected HttpSession httpSession;
  protected Map<String, Object> session;

  public void setServletContext(ServletContext context)
  {
    this.servletContext = context;
  }

  public void setServletResponse(HttpServletResponse response) {
    this.httpServletResponse = response;
  }

  public void setServletRequest(HttpServletRequest request) {
    this.httpServletRequest = request;
    this.httpSession = request.getSession();
  }

  public void setSession(Map<String, Object> session) {
    this.session = session;
  }

  public static String getipAddress() {
    if (ipAddress == null) {
      HttpServletRequest request = ServletActionContext.getRequest();

      ipAddress = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort();
    }

    return ipAddress;
  }

  public static String getRealPath() {
    return ServletActionContext.getServletContext().getRealPath("/");
  }

  public static String getBasePath() {
    HttpServletRequest request = ServletActionContext.getRequest();
    return getipAddress() + request.getContextPath() + "/";
  }

  public boolean isTrialAccount()
  {
    boolean ret = false;
    if (this.session != null) {
      TblQy qy = (TblQy)this.session.get("userQy");
      if ((qy != null) && (qy.getZt().intValue() == 1)) {
        ret = true;
      }
    }
    return ret;
  }
}
package jxt.elt.common;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.HashMap;
import java.util.Map;
import org.apache.velocity.Template;
import org.apache.velocity.app.VelocityEngine;
import org.apache.velocity.runtime.resource.loader.StringResourceLoader;
import org.apache.velocity.runtime.resource.util.StringResourceRepository;

public class EmailTemplate
{
  public static VelocityEngine ve;
  public static final Map<String, Map<String, String>> PARAMETER_MAP = new HashMap();
  public static final String templeteFoot = "\n</body>\n</html>";

  public static synchronized Template getTemplate(String name)
    throws Exception
  {
    if (null == ve) {
      init();
    }

    return ve.getTemplate(name, "UTF-8");
  }

  public static synchronized void init() throws Exception {
    Connection conn = DbPool.getInstance().getConnection();
    Statement stmt = null;
    ResultSet rs = null;
    try {
      stmt = conn.createStatement();
      rs = stmt.executeQuery("SELECT nid, mc, head, nr, zwmc FROM tbl_yjmb");
      String mc = "";
      String nr = "";
      String head = "";

      ve = new VelocityEngine();
      ve.setProperty("resource.loader", "string");
      ve.setProperty("string.resource.loader.class", "org.apache.velocity.runtime.resource.loader.StringResourceLoader");

      ve.init();

      StringResourceRepository repo = StringResourceLoader.getRepository();

      while (rs.next()) {
        mc = rs.getString("mc");
        nr = rs.getString("nr");
        head = rs.getString("head");
        repo.putStringResource(mc, head + nr + "\n</body>\n</html>");
      }
      rs.close();

      if (null != stmt) {
        stmt.close();
      }
      if (null != conn)
        conn.close();
    }
    catch (SQLException e)
    {
      e.printStackTrace();

      if (null != stmt) {
        stmt.close();
      }
      if (null != conn)
        conn.close();
    }
    catch (Exception e)
    {
      e.printStackTrace();

      if (null != stmt) {
        stmt.close();
      }
      if (null != conn)
        conn.close();
    }
    finally
    {
      if (null != stmt) {
        stmt.close();
      }
      if (null != conn)
        conn.close();
    }
  }

  static
  {
    String name = "用户姓名";
    String nameP = "$name";
    String loginAccount = "登陆帐号";
    String loginAccountP = "$loginAccount";
    String loginPassword = "登陆密码";
    String loginPasswordP = "$loginPassword";
    String company = "公司名称";
    String companyP = "$company";
    String assignedDate = "发放日期";
    String assignedDateP = "$assignedDate";
    String catagoryName = "发放名目";
    String catagoryNameP = "$catagoryName";
    String quantity = "数量";
    String quantityP = "$quantity";
    String account = "帐号名称";
    String accountP = "$account";
    String password = "追加密码";
    String passwordP = "$password";
    String assignPassword = "试用企业发放积分密码";
    String assignPasswordP = "$assignPassword";

    String forgetpwd = "forgetpwd.vm";
    String jfassign = "jfassign.vm";
    String jfqassign = "jfqassign.vm";
    String jfqhrexpirenotify = "jfqhrexpirenotify.vm";
    String jfqreceive = "jfqreceive.vm";
    String jfqstaffexpirenotify = "jfqstaffexpirenotify.vm";
    String jfreceive = "jfreceive.vm";
    String managerappendpwd = "managerappendpwd.vm";
    String managerinitassignpwd = "managerinitassignpwd.vm";
    String managerinitpwd = "managerinitpwd.vm";
    String qymanageraccount = "qymanageraccount.vm";
    String staffregisterpwd = "staffregisterpwd.vm";
    String testaccountgenerated = "testaccountgenerated.vm";
    String testresetpwd = "testresetpwd.vm";

    Map parameters = new HashMap();
    parameters.put(nameP, name);
    parameters.put(loginAccountP, loginAccount);
    parameters.put(loginPasswordP, loginPassword);
    PARAMETER_MAP.put(forgetpwd, parameters);

    PARAMETER_MAP.put(qymanageraccount, parameters);

    PARAMETER_MAP.put(staffregisterpwd, parameters);

    PARAMETER_MAP.put(testaccountgenerated, parameters);

    PARAMETER_MAP.put(testresetpwd, parameters);

    parameters = new HashMap();
    parameters.put(nameP, name);
    parameters.put(companyP, company);
    parameters.put(assignedDateP, assignedDate);
    parameters.put(catagoryNameP, catagoryName);
    parameters.put(quantityP, quantity);
    parameters.put(accountP, account);
    PARAMETER_MAP.put(jfassign, parameters);

    PARAMETER_MAP.put(jfqassign, parameters);

    parameters = new HashMap();
    parameters.put("#foreach($item in $expiryList) ... #end", "遍历所有过期的条目,请在省略处编辑样式,可参照原格式修改");
    parameters.put("$item.name", "即将过期的福利券名称,必须在#foreach与#end之间使用");
    parameters.put("$fmt.format($item.expireDate)", "福利券过期时间,必须在#foreach与#end之间使用");
    parameters.put("$item.quantity", "过期福利券数量,必须在#foreach与#end之间使用");
    PARAMETER_MAP.put(jfqhrexpirenotify, parameters);

    PARAMETER_MAP.put(jfqstaffexpirenotify, parameters);

    parameters = new HashMap();
    parameters.put(nameP, name);
    parameters.put(companyP, company);
    parameters.put(assignedDateP, assignedDate);
    parameters.put(catagoryNameP, catagoryName);
    parameters.put(quantityP, quantity);
    PARAMETER_MAP.put(jfqreceive, parameters);

    PARAMETER_MAP.put(jfreceive, parameters);

    parameters = new HashMap();
    parameters.put(passwordP, password);
    PARAMETER_MAP.put(managerappendpwd, parameters);

    parameters = new HashMap();
    parameters.put(assignPasswordP, assignPassword);
    PARAMETER_MAP.put(managerinitassignpwd, parameters);

    parameters = new HashMap();
    parameters.put(loginAccountP, loginAccount);
    parameters.put(loginPasswordP, loginPassword);
    PARAMETER_MAP.put(managerinitpwd, parameters);
  }
}
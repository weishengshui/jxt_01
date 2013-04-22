package jxt.elt.common;

import javax.mail.Transport;
import javax.mail.internet.InternetAddress;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Date;
import javax.mail.Message.RecipientType;
import javax.mail.internet.MimeMessage;
import javax.mail.Message;
import javax.mail.Session;
import java.util.Properties;
import java.util.concurrent.ExecutionException;

import javax.mail.internet.MimeBodyPart;
import javax.mail.Multipart;
import javax.mail.internet.MimeMultipart;
import javax.activation.*;








public class SendEmailBean
{
	String szsmtp="";
	String szusername="";
	String szpassword="";
	String szfrom="";
	
	public SendEmailBean()
	{
		Connection conn=DbPool.getInstance().getConnection();
		try
		{
			Statement stmt=conn.createStatement();
			ResultSet rs=null;
			String strsql="select pvalue from tbl_config where pname='sendemailsmtp'";
			rs=stmt.executeQuery(strsql);
			if (rs.next())
			{
				szsmtp=rs.getString("pvalue");
			}
			rs.close();
			
			strsql="select pvalue from tbl_config where pname='sendemail'";
			rs=stmt.executeQuery(strsql);
			if (rs.next())
			{
				szusername=rs.getString("pvalue");
				szfrom=szusername;
			}
			rs.close();
			
			strsql="select pvalue from tbl_config where pname='sendemailpwd'";
			rs=stmt.executeQuery(strsql);
			if (rs.next())
			{
				szpassword=rs.getString("pvalue");				
			}
			rs.close();
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		finally{
			try{
			if (!conn.isClosed())
				conn.close();
			}
			catch(SQLException se)
			{
				se.printStackTrace();
			}
		}
	}
	
	/**
	 * Email发送方法
	 * 
	 * @param toemails
	 *            需要一个字符串参数，用来设置收件人地址，如果收件人为多个，则用","隔开
	 * @param content
	 *            邮件内容
	 * @param subject
	 *            邮件主题	
	 * @return 邮件成功发送则返回true,否则返回false
	 */
	public boolean sendSimpleEmail(String toemails, String content,String subject)
	{
		boolean result = false;
		try
		{
			
			
			//System.out.println(szusername);
			//System.out.println(szpassword);
			//System.out.println(szsmtp);
			//System.out.println(szusername);
			
			// 创建属性对象
			Properties props = new Properties();
			// 设置邮件传输协议为：smtp			
			props.put("mail.transpost.protocol", "smtp");
			// 设置邮件服务器地址
			props.put("mail.smtp.host",szsmtp);
			// 设置邮件验证为真
			props.put("mail.smtp.auth", "true");
			// 设置邮件服务器端口
			props.put("mail.smtp.port", "25");

			// 调用验证类进行验证

			CheckSendEmail auth = new CheckSendEmail(szusername, szpassword);
			
			// 创建session对象
			Session sendMailSession;
			sendMailSession = Session.getInstance(props, auth);
			// 设置输出调试信息
			//sendMailSession.setDebug(true);

			// logger.info("开始创建消息对象");
			// 创建信息对象
			Message newMessage = new MimeMessage(sendMailSession);

			// 输入发送信息
			// 设置发信人地址
			// logger.info("设置发信人地址");
			newMessage.setFrom(new InternetAddress(szfrom));

			// 设置收信人地址，只支持单用户发送
			// newMessage.setRecipient(Message.RecipientType.TO,new
			// InternetAddress("lip0091981@163.com"));

			// 设置收信人地址，可以支持多用户发送
			// logger.info("设置收信人地址");
			newMessage.setRecipients(Message.RecipientType.TO, InternetAddress
					.parse(toemails));
			// 附件
			// ==============================================================================
			// msgText是信件的正文，共有两行
			// String msgText = content;

			// msgAttachment是一段字符串作为附件内容
			// String msgAttachment = "This is an attachment string!";

			// MimeBodyPart mbp1 = new MimeBodyPart();

			// mbp1.setText(msgText); //把前面定义的msgText中的文字设定为邮件正文的内容

			// 创建附件部分
			// MimeBodyPart mbp2 = new MimeBodyPart();

			// 使用setText(text, charset)来加入附件
			// mbp2.setText(msgAttachment, "gb2312");

			// 创建Multipart
			// Multipart mp = new MimeMultipart();

			// mp.addBodyPart(mbp1);
			// mp.addBodyPart(mbp2);

			// 添加 Multipart到Message中
			// newMessage.setContent(mp);
			// ==============================================================================
			// 设置信件文本格式（当设置了附件，这里就不能有）
			// logger.info("设置格式");
			newMessage.setContent("SendMail", "text/html");
			
			// 设置信件主题
			// logger.info("设置主题");
			newMessage.setSubject(subject);

			// 设置信件发送日期
			// logger.info("设置发送日期");
			newMessage.setSentDate(new Date());

			// 设置信件正文（当设置了附件，这里就不能有）			
			newMessage.setText(content);
			
			// logger.info("设置完消息");
			// 创建对象
			Transport transport;
			transport = sendMailSession.getTransport("smtp");
			// logger.info("将要发送");

			// 发送
			result = true;
			
			transport.send(newMessage);// 此处总是抛出异常，让人很是郁闷，但是邮件却发送成功！
			// logger.info("恭喜你！您的邮件已经成功发送！");
		}
		catch (Exception ex)
		{
			//ex.printStackTrace();
		}
		return result;
	}
	
	
	public boolean sendHtmlEmail(String toemails, String content,String subject)
	{
		boolean result = false;
		try
		{
			
			
			// 创建属性对象

			Properties props = new Properties();
			// 设置邮件传输协议为：smtp			
			props.put("mail.transpost.protocol", "smtp");
			// 设置邮件服务器地址
			props.put("mail.smtp.host",szsmtp);
			// 设置邮件验证为真
			props.put("mail.smtp.auth", "true");
			// 设置邮件服务器端口

			props.put("mail.smtp.port", "25");

			// 调用验证类进行验证


			CheckSendEmail auth = new CheckSendEmail(szusername, szpassword);
			
			// 创建session对象
			Session sendMailSession;
			sendMailSession = Session.getInstance(props, auth);
			// 设置输出调试信息
			//sendMailSession.setDebug(true);

			// logger.info("开始创建消息对象");
			// 创建信息对象
			Message newMessage = new MimeMessage(sendMailSession);

			// 输入发送信息

			// 设置发信人地址
			// logger.info("设置发信人地址");
			newMessage.setFrom(new InternetAddress(szfrom));

			// 设置收信人地址，只支持单用户发送

			// newMessage.setRecipient(Message.RecipientType.TO,new
			// InternetAddress("lip0091981@163.com"));

			// 设置收信人地址，可以支持多用户发送

			// logger.info("设置收信人地址");
			newMessage.setRecipients(Message.RecipientType.TO, InternetAddress
					.parse(toemails));
			// 附件
			// ==============================================================================
			// msgText是信件的正文，共有两行

			// String msgText = content;

			// msgAttachment是一段字符串作为附件内容
			// String msgAttachment = "This is an attachment string!";

			// MimeBodyPart mbp1 = new MimeBodyPart();

			// mbp1.setText(msgText); //把前面定义的msgText中的文字设定为邮件正文的内容

			// 创建附件部分
			// MimeBodyPart mbp2 = new MimeBodyPart();

			// 使用setText(text, charset)来加入附件

			// mbp2.setText(msgAttachment, "gb2312");

			// 创建Multipart
			// Multipart mp = new MimeMultipart();

			// mp.addBodyPart(mbp1);
			// mp.addBodyPart(mbp2);

			// 添加 Multipart到Message中

			// newMessage.setContent(mp);
			// ==============================================================================
			// 设置信件文本格式（当设置了附件，这里就不能有）

			// logger.info("设置格式");
			newMessage.setContent(content, "text/html;charset=utf-8");
			
			// 设置信件主题
			// logger.info("设置主题");
			newMessage.setSubject(subject);

			// 设置信件发送日期

			// logger.info("设置发送日期");
			newMessage.setSentDate(new Date());

			// 设置信件正文（当设置了附件，这里就不能有）
			//newMessage.setDataHandler(new DataHandler(new StringDataSource(content,"text/html")));
			//newMessage.setText(content);
			
			// logger.info("设置完消息");
			// 创建对象
			Transport transport;
			transport = sendMailSession.getTransport("smtp");
			// logger.info("将要发送");

			// 发送

			result = true;
			
			transport.send(newMessage);// 此处总是抛出异常，让人很是郁闷，但是邮件却发送成功！
			// logger.info("恭喜你！您的邮件已经成功发送！");
		}
		catch (Exception ex)
		{
			//ex.printStackTrace();
		}
		return result;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}

package com.ssh.action;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.security.NoSuchAlgorithmException;

import javax.annotation.Resource;

import net.coobird.thumbnailator.Thumbnails;

import org.apache.log4j.Logger;
import org.apache.struts2.convention.annotation.InterceptorRef;
import org.apache.struts2.convention.annotation.InterceptorRefs;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.Results;
import org.springframework.stereotype.Controller;

import com.ssh.util.FileUtil;
import com.ssh.util.SecurityUtil;
import com.ssh.base.BaseAction;
import com.ssh.entity.TblQyyg;
import com.ssh.service.QyygService;

@Controller
@Results( { @Result(name = "success", location = "/jsp/user/modify.jsp"),
	@Result(name = "pwd", location = "/jsp/user/password.jsp")})
@InterceptorRefs( { @InterceptorRef("fileUpload"),
	@InterceptorRef("mydefault") })
public class UserAction extends BaseAction {
	
	private static final long serialVersionUID = 3528235643171266138L;
	private static Logger logger = Logger
			.getLogger(UserAction.class.getName());
	@Resource
	private QyygService qyyg;
	private int rs;
	private TblQyyg user;
    private String uploadFileName;
    private String password;
    private String oldpassword;
    private File upload;

	public void setUpload(File upload) {
		this.upload = upload;
	}

	public File getUpload() {
		return (this.upload);
	}

	public void setUploadFileName(String uploadFileName) {
		this.uploadFileName = uploadFileName;
	}

	public String getUploadFileName() {
		return uploadFileName;
	}
	public void setPassword(String password) {
		this.password = password;
	}

	public String getPassword() {
		return password;
	}

	public void setOldpassword(String oldpassword) {
		this.oldpassword = oldpassword;
	}

	public String getOldpassword() {
		return oldpassword;
	}

	public void setRs(int rs) {
		this.rs = rs;
	}

	public int getRs() {
		return rs;
	}

	public void setUser(TblQyyg user) {
		this.user = user;
	}

	public TblQyyg getUser() {
		return user;
	}

	public String list() {
		TblQyyg tyq = (TblQyyg) session.get("user");
		if(tyq!=null){
			TblQyyg user = qyyg.findById(tyq.getNid());
			setUser(user);
		}		
		return SUCCESS;
	}

	public String pwd() {
		TblQyyg tyq = (TblQyyg) session.get("user");
		if(tyq!=null){
			TblQyyg user = qyyg.findById(tyq.getNid());
			setUser(user);
		}
		return "pwd";
	}

	public String chgpwd() {
		TblQyyg tyg = qyyg.findById(user.getNid());
		String md5pwd = "";
		String oldmd5pwd = "";
		try {
			oldmd5pwd = SecurityUtil.md5(oldpassword);
			md5pwd = SecurityUtil.md5(password);
		} catch (NoSuchAlgorithmException e) {
			logger.error("UserAction--chgpwd:", e);
		}
		if(!tyg.getDlmm().equals(oldmd5pwd)){
			setRs(1);
		}
		else{
			tyg.setDlmm(md5pwd);
			qyyg.save(tyg);
			setRs(2);			
		}
		return pwd();
	}
	
	public String modify() throws IOException{
		String userid = user.getNid().toString();
		FileUtil fu = new FileUtil();
		String rootFloder = getRealPath() + "photo";
		File dirphoto = new File(rootFloder);
		if (!dirphoto.exists()) {
			dirphoto.mkdir();
		}
		String userFloder = dirphoto+"/"+userid;
		File dir = new File(userFloder);
		if (!dir.exists()) {
		    dir.mkdir();
		}
		if (getUpload() != null) {
			this.filecopy(userFloder + "/temp.jpg", this.getUpload());
			Thumbnails.of(new File(userFloder + "/temp.jpg")).size(116, 116)
					.toFile(new File(userFloder + "/normal.jpg"));
			Thumbnails.of(new File(userFloder + "/temp.jpg")).size(67, 67)
			.toFile(new File(userFloder + "/little.jpg"));
		    fu.delFile(userFloder, "temp.jpg");
		}
		TblQyyg tyg = qyyg.findById(user.getNid());
		tyg.setXb(user.getXb());
		tyg.setCsrj(user.getCsrj());
		tyg.setNc(user.getNc());
		tyg.setLxdh(user.getLxdh());
		qyyg.save(tyg);
		setRs(2);
		return list();
	}

	public void filecopy(String outpath, File infile) throws IOException {
		FileOutputStream fos = new FileOutputStream(outpath);
		FileInputStream fis = new FileInputStream(infile);
		byte[] buffer = new byte[1024];
		int len = 0;
		while ((len = fis.read(buffer)) > 0) {
			fos.write(buffer, 0, len);
		}
		fis.close();
		fos.close();
	}
}

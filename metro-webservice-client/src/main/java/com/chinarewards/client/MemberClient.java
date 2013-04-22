package com.chinarewards.client;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.ws.rs.core.MultivaluedMap;

import com.chinarewards.metro.models.ExternalMember;
import com.chinarewards.metro.models.ExternalMemberActivate;
import com.chinarewards.metro.models.ExternalMemberLogin;
import com.chinarewards.metro.models.ExternalMemberReg;
import com.chinarewards.metro.models.Member;
import com.chinarewards.metro.models.common.DES3;
import com.chinarewards.metro.models.request.MemberModifyReq;
import com.chinarewards.metro.models.request.MemberPasswordModifyReq;
import com.chinarewards.metro.models.response.MemberModifyRes;
import com.chinarewards.metro.models.response.MemberPasswordModifyRes;
import com.sun.jersey.api.client.GenericType;
import com.sun.jersey.api.client.UniformInterfaceException;
import com.sun.jersey.api.client.WebResource;
import com.sun.jersey.core.util.MultivaluedMapImpl;

public class MemberClient extends AbstractClient {

	private String url;

	public MemberClient(String url) {
		this.url = url;
	}

	public static void main(String[] args) throws Exception{

		// List<Member> members = new MemberClient(
		// "http://192.168.4.97:8080/metro/ws").getMembers("P1");
		// for (Member m : members) {
		// System.out.println("name:" + m.getUserName() + " age:" + m.getAge()
		// + " address:" + m.getAddress());
		// }

//		MemberModifyReq req = new MemberModifyReq();// 模拟修改会员基本信息的请求
//		req.setId(1);
//		req.setAlivePhoneNumber("13189755310");
//		req.setPhone("13189755314");
//		req.setMemberStatus(1);
//		req.setMail("657620636@qq.com");
//		MemberModifyRes res = new MemberClient(
//				"http://192.168.4.236:8000/metro/ws").modifyMember(req);
//		System.out.println("MemberModify updateStatus is " + res.getUpdateStatus());
//		System.out.println("MemberModify failureReasons is " + res.getFailureReasons());

		
		MemberPasswordModifyReq req2 = new MemberPasswordModifyReq();//模拟修改会员密码的请求
		req2.setId(1);
		//设定密码，并用3DES加密
		
//		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmss");
//		String updateTime = dateFormat.format(new Date());
//		
//		String oldPassword = DES3.encryptStrMode(DES3.getKeyBytes(updateTime), "12345@#$%^&*()6lll");
//		String newPassword = DES3.encryptStrMode(DES3.getKeyBytes(updateTime), "123456");
//		req2.setUpdateTime(updateTime);
//		System.out.println("updateTime is "+req2.getUpdateTime());
//		req2.setOldPassword(oldPassword);
//		req2.setNewPassword(newPassword);
//		MemberPasswordModifyRes res2 = new MemberClient("http://192.168.4.236:8000/metro/ws").modifyMemberPassword(req2);
//		System.out.println("MemberPasswordModify updateStatus is " + res2.getUpdateStatus());
//		System.out.println("MemberPasswordModify updateDesc is " + res2.getUpdateDesc());
		
//		List<ExternalMember> list = new MemberClient("http://localhost:8081/metro/ws").offExternalMember("SYNC", "2012-01-01", "13456789765");
//		for(ExternalMember m : list){
//			System.out.print("  会员ID：" + m.getMemberId());
//			System.out.print("  邮箱：" + m.getEmail());
//			System.out.print("  手机号码：" + m.getPhone());
//			System.out.print("  注册日期：" + m.getCreateTime());
//			System.out.print("  是否激活：" + m.getIsActive());	//1:已激活   2:未激活
//			System.out.print("  激活手机号：" + m.getActivePhone());
//			System.out.print("  等级：" + m.getGrade());	//CRM没有没有等级
//			System.out.print("  积分：" + m.getIntegral());
//			System.out.print("  会员状态：" + m.getStatus()); //1:已激活  2：未激活  3注销/删除
//			System.out.print("  更新标记：" + m.getTarget()); //暂时得不到
//			System.out.print("  更新时间：" + m.getUpdateTime()+"\n");
//		}
//		ExternalMemberActivate m = new MemberClient("http://localhost:8081/metro/ws").memberActivate(80, "13456789765", "111");
//		System.out.print("  会员ID：" + m.getMemberId());
//		System.out.print("  手机号码：" + m.getPhone());
//		System.out.print("  注册日期：" + m.getCreateTime());
//		System.out.print("  是否激活：" + m.getIsActive());	//1:已激活   0:未激活
//		System.out.print("  激活手机号：" + m.getActivePhone());
//		Dic
		
		String pwd = DES3.encryptStrMode(DES3.getKeyBytes("11223344556688"), "123456");
//		ExternalMemberLogin m = new MemberClient("http://localhost:8081/metro/ws").memberLogin(80, "15220060657", pwd);
//		System.out.print("  会员ID：" + m.getMemberId());
//		System.out.print("  邮箱：" + m.getEmail());
//		System.out.print("  手机号码：" + m.getPhone());
//		System.out.print("  注册日期：" + m.getCreateTime());
//		System.out.print("  是否激活：" + m.getIsActive());	//1:已激活   2:未激活
//		System.out.print("  激活手机号：" + m.getActivePhone());
//		System.out.print("  等级：" + m.getGrade());	//CRM没有没有等级
//		System.out.print("  积分：" + m.getIntegral());
//		System.out.print("  会员状态：" + m.getStatus()); //1:已激活  2：未激活  3注销/删除
//		System.out.print("  登录状态：" + m.getLoginStatus());
//		System.out.print(" 储值卡余额："+m.getMoney()+"\n");
		
		//case1:手机注册会员
		String email = "";
		String phone = ""; //手机（必选）
		String createTime = "2013-02-22 12:2:2"; //日期（必选）
		Integer isActivate = 2; //是否激活（必选）
		String activatePhone = "15915312345"; //激活手机号（必选）
		String grade = "";	//等级
		String birth = "";  
		Integer integral = 10; //积分（必选）
		Integer status = 2;  // 会员状态（必选）1:已激活  2：未激活  3删除
		String password = DES3.encryptStrMode(DES3.getKeyBytes("11223344556688"), "123456");		//123456 密码     11223344556688密钥(不可改)
		
		//ExternalMemberReg m = clientService.memberRegister(email,phone,createTime,isActivate,activatePhone,grade,birth,integral,status,password);


		ExternalMemberReg m = new MemberClient("http://localhost:8081/metro/ws").memberRegister(email,phone,createTime,isActivate,activatePhone,grade,birth,integral,status,password);
		System.out.print("  会员ID：" + m.getMemberId());
		System.out.print("  邮箱：" + m.getEmail());
		System.out.print("  手机号码：" + m.getPhone());
		System.out.print("  注册日期：" + m.getCreateTime());
		System.out.print("  是否激活：" + m.getIsActive());	// 1:已激活  2：未激活
		System.out.print("  激活手机号：" + m.getActivePhone()+"\n");

//		
//		req2.setId(7);
//		req2.setOldPassword("12345@#$%^&*()6lll");
//		req2.setNewPassword("123456");
//		MemberPasswordModifyRes res2 = new MemberClient("http://192.168.4.236:8000/metro/ws").modifyMemberPassword(req2);
//		System.out.println("MemberPasswordModify updateStatus is " + res2.getUpdateStatus());
//		System.out.println("MemberPasswordModify updateDesc is " + res2.getUpdateDesc());
	}

	public List<Member> getMembers(String name) {
		MultivaluedMap<String, String> params = new MultivaluedMapImpl();
		params.add("name", name);
		WebResource r = getClient().resource(url + "/member/list").queryParams(
				params);
		try {
			List<Member> m = r.accept("application/json").get(
					new GenericType<List<Member>>() {
					});
			return m;
		} catch (UniformInterfaceException e) {
			System.err
					.println("Status: " + e.getResponse().getResponseStatus());
			throw new IllegalStateException(e);
		}
	}
	
	/**
	 * 修改会员基本信息
	 * 
	 * @param memberModifyReq
	 * @return
	 */
	public MemberModifyRes modifyMember(MemberModifyReq memberModifyReq) {
		
		if(null == memberModifyReq){
			return null;
		}
		WebResource resource = getClient().resource(url + "/member/modify");
		System.out.println("===" + resource.toString());
		try {
			MemberModifyRes memberModifyRes = resource.accept(
					"application/json").put(MemberModifyRes.class,
					memberModifyReq);
			return memberModifyRes;
		} catch (UniformInterfaceException e) {
			System.err
					.println("Status: " + e.getResponse().getResponseStatus());
			throw new IllegalStateException(e);
		}
	}
	
	/**
	 * 修改会员密码信息
	 * 
	 * @param memberModifyReq
	 * @return
	 */
	public MemberPasswordModifyRes modifyMemberPassword(
			MemberPasswordModifyReq memberPasswordModifyReq) {
		
		if(null == memberPasswordModifyReq){
			return null;
		}
		// 设定密码，并用3DES加密
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmss");
		String updateTime = dateFormat.format(new Date());
		memberPasswordModifyReq.setUpdateTime(updateTime);

		String oldPassword = DES3.encryptStrMode(DES3.getKeyBytes(updateTime),
				memberPasswordModifyReq.getOldPassword());
		String newPassword = DES3.encryptStrMode(DES3.getKeyBytes(updateTime),
				memberPasswordModifyReq.getNewPassword());
		memberPasswordModifyReq.setOldPassword(oldPassword);
		memberPasswordModifyReq.setNewPassword(newPassword);
		
		WebResource resource = getClient().resource(
				url + "/member/passwordModify");
		System.out.println("===" + resource.toString());
		try {
			MemberPasswordModifyRes memberPasswordModifyRes = resource.accept(
					"application/json").post(MemberPasswordModifyRes.class,
					memberPasswordModifyReq);
			return memberPasswordModifyRes;
		} catch (UniformInterfaceException e) {
			System.err
					.println("Status: " + e.getResponse().getResponseStatus());
			throw new IllegalStateException(e);
		}
	}
	
	public List<ExternalMember> offExternalMember(String OperateType,String PreSyncTime,String PhoneNum){
		MultivaluedMap<String, String> params = new MultivaluedMapImpl();
		params.add("OperateType", OperateType);
		params.add("PreSyncTime", PreSyncTime);
		params.add("PhoneNum", PhoneNum);
		WebResource resource = getClient().resource(url + "/member/offExternalMember").queryParams(params);
		System.out.println("===" + resource.toString());
		return resource.accept("application/json").get(new GenericType<List<ExternalMember>>(){});
	}
	
	public ExternalMemberActivate memberActivate(Integer memberId,String phone,String activeCode){
		MultivaluedMap<String, String> params = new MultivaluedMapImpl();
		params.add("memberId", memberId.toString());
		params.add("phone", phone);
		params.add("activeCode", activeCode);
		WebResource resource = getClient().resource(url + "/member/offExternalMemberActive").queryParams(params);
		return resource.accept("application/json").get(new GenericType<ExternalMemberActivate>(){});
	}
	
	public ExternalMemberLogin memberLogin(Integer memberId,String phone,String password){
		MultivaluedMap<String, String> params = new MultivaluedMapImpl();
		params.add("memberId", memberId.toString());
		params.add("phone", phone);
		params.add("password", password);
		WebResource resource = getClient().resource(url + "/member/offExternalMemberLogin").queryParams(params);
		return resource.accept("application/json").get(new GenericType<ExternalMemberLogin>(){});
	}
	
	public ExternalMemberReg memberRegister(String email,String phone,String createTime,Integer isActivate,
			String activatePhone,String grade,String birth,Integer integral,Integer status,String password){
		MultivaluedMap<String, String> params = new MultivaluedMapImpl();
		params.add("email", email);
		params.add("phone", phone);
		params.add("createTime", createTime.toString());
		params.add("isActivate", isActivate.toString());
		params.add("activatePhone", activatePhone);
		params.add("grade", grade);
		params.add("birth", birth.toString());
		params.add("integral", integral.toString());
		params.add("status", status.toString());
		params.add("status", password.toString());
		WebResource resource = getClient().resource(url + "/member/offExternalMemberRegister").queryParams(params);
		return resource.accept("application/json").get(new GenericType<ExternalMemberReg>(){});
	}
	
	
}

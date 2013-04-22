package com.chinarewards.metro.control.line;

import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.DataInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.imageio.ImageIO;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.dom4j.DocumentException;
import org.imgscalr.Scalr;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.chinarewards.metro.core.common.CommonUtil;
import com.chinarewards.metro.core.common.Constants;
import com.chinarewards.metro.core.common.DateTools;
import com.chinarewards.metro.core.common.Dictionary;
import com.chinarewards.metro.core.common.FileUtil;
import com.chinarewards.metro.core.common.Page;
import com.chinarewards.metro.core.common.UUIDUtil;
import com.chinarewards.metro.core.common.UserContext;
import com.chinarewards.metro.domain.file.FileItem;
import com.chinarewards.metro.domain.metro.MetroLine;
import com.chinarewards.metro.domain.metro.MetroSite;
import com.chinarewards.metro.domain.shop.Shop;
import com.chinarewards.metro.domain.shop.ShopChain;
import com.chinarewards.metro.domain.shop.ShopFile;
import com.chinarewards.metro.domain.user.OperationEvent;
import com.chinarewards.metro.model.common.AjaxResponseCommonVo;
import com.chinarewards.metro.service.line.ILineService;
import com.chinarewards.metro.service.system.ISysLogService;

@Controller
@RequestMapping("/line")
public class MetroLineControl {

	static Logger logger = Logger.getLogger(MetroLineControl.class.getName());

	@Autowired
	private ILineService lineService;
	@Autowired
	private ISysLogService sysLogService;
	
	@RequestMapping("/index")
	public String lineIndex(){
		return "line/lineList";
	}
	
	@RequestMapping("/linePage")
	public String linePage(){
		return "line/lineUpdate";
	}
	
	@RequestMapping("/lineUpdatePage")
	public String lineUpdatePage(HttpSession session,Integer id,Model model){
		model.addAttribute("line",lineService.findLineByid(id));
		Map<String, FileItem> images = lineService.findLineImg(id);
		String imageSessionName = UUIDUtil.generate();
		session.setAttribute(imageSessionName, images);
		model.addAttribute("images", CommonUtil.toJson(images));
		model.addAttribute("imageSessionName", imageSessionName);
		return "line/lineUpdate";
	}
	
	/**
	 * 查询站台
	 * @param site
	 * @param page
	 * @return
	 */
	@RequestMapping("/findSites")
	public Map<String,Object> findSites(MetroSite site,Page page){
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("rows", lineService.findSites(site, page));
		map.put("total", page.getTotalRows());
		return map;
	}
	
	/**
	 * 线路选择时,如果线路存在该站台机不显示
	 * @param site
	 * @param page
	 * @return
	 */
	@RequestMapping("/findLineSites")
	public Map<String,Object> findLineSites(String name,Integer lindId,Page page){
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("rows", lineService.findLineSites(name,lindId, page));
		map.put("total", page.getTotalRows());
		return map;
	}
	
	@RequestMapping("/saveLine")
	public void saveMetroLine(MetroLine line,String siteJson,String imageSessionName) throws Exception{
		try{
			lineService.saveMetroLine(line, siteJson,imageSessionName);
			sysLogService.addSysLog("站台新增", line.getName(), OperationEvent.EVENT_SAVE.getName(), "成功");
		}catch(Exception e){
			sysLogService.addSysLog("站台新增", line.getName(), OperationEvent.EVENT_SAVE.getName(), "失败"+e.getMessage());
			throw new RuntimeException(e);
		}
	}
	/**
	 * 查询地铁名称或编号是否存在
	 */
	@ResponseBody
	@RequestMapping("/findMetroLineByName")
	public Integer findMetroLineByName(MetroLine line){
		MetroLine l = lineService.findMetroLineByName(line);
		if(l==null){
			return 0;
		}else{
			if(l.getId().equals(line.getId())){
				return 0;
			}
			return 1;
		}
	}
	
	/**
	 * 查询地铁名称或编号是否存在
	 */
	@ResponseBody
	@RequestMapping("/findMetroLineByNum")
	public Integer findMetroLineByNum(MetroLine line){
		MetroLine l = lineService.findMetroLineByNum(line);
		if(l==null){
			return 0;
		}else{
			if(l.getId().equals(line.getId())){
				return 0;
			}
			return 1;
		}
	}
	
	@RequestMapping("/findLines")
	public Map<String,Object> findLines(MetroLine line,Page page){
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("rows", lineService.findLines(line, page));
		map.put("total", page.getTotalRows());
		return map;
	}
	
	@RequestMapping("/findSiteLines")
	public Map<String,Object> findSiteLines(MetroLine line,Page page){
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("rows", lineService.findSiteLines(line, page));
		map.put("total", page.getTotalRows());
		return map;
	}
	
	@RequestMapping("/findMetroLineSites")
	public Map<String,Object> findMetroLineSites(Integer lindId,Integer lindId_,Page page){ 
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("rows", lineService.findMetroLineByLindId(lindId==null?lindId_:lindId));
		map.put("total", page.getTotalRows());
		return map; 
	}
	
	@ResponseBody
	@RequestMapping("/updateMetroLine")
	public Integer updateMetroLine(MetroLine line,String inserted,String deleted,String updated ) throws Exception{
		try{
			int i = 0;
			if(line.getId() == null){
				i = lineService.updateMetroLine(line, inserted, deleted, updated);
				sysLogService.addSysLog("线路新增", line.getName(), OperationEvent.EVENT_SAVE.getName(), "成功");
			}else{
				i = lineService.updateMetroLine(line, inserted, deleted, updated);
				sysLogService.addSysLog("线路维护", line.getName(), OperationEvent.EVENT_UPDATE.getName(), "成功");
			}
			return i;
		}catch(Exception e){
			if(line.getId() == null){
				sysLogService.addSysLog("线路新增", line.getName(), OperationEvent.EVENT_SAVE.getName(), "失败"+e.getMessage());
			}else{
				sysLogService.addSysLog("线路维护", line.getName(), OperationEvent.EVENT_UPDATE.getName(), "失败"+e.getMessage());
			}
			
			throw new RuntimeException(e);
		}
	}
	
	@RequestMapping("/delMetroLine")
	@ResponseBody
	public Integer delMetroLine(String id,String names) throws Exception{
		try{
			int i = lineService.delMetroLine(id);
			for(String s : names.split(",")){
				sysLogService.addSysLog("线路维护", s, OperationEvent.EVENT_DELETE.getName(), "成功");
			}
			return i;
		}catch(Exception e){
			for(String s : names.split(",")){
				sysLogService.addSysLog("线路维护", s, OperationEvent.EVENT_DELETE.getName(), "失败"+e.getMessage());
			}
			throw new RuntimeException(e); 
		}
		
	}
	
	/**
	 * 站台页面(siteUpdate.jsp) 修改 新增同一页面
	 */
	@RequestMapping("/sitePage")
	public String sitePage(){
		return "line/siteUpdate";
	}
	
	@RequestMapping("/siteUpdatePage")
	public String siteUpdatePage(HttpSession session,Integer id,Model model){
		model.addAttribute("site", lineService.findSiteById(id));
		Map<String, FileItem> images = lineService.findSiteImg(id);
		String imageSessionName = UUIDUtil.generate();
		session.setAttribute(imageSessionName, images);
		model.addAttribute("images", CommonUtil.toJson(images));
		model.addAttribute("imageSessionName", imageSessionName);
		return "line/siteUpdate";
	}
	
	@RequestMapping("/siteIndex")
	public String siteIndex(){
		return "line/siteList";
	}
	
	@ResponseBody
	@RequestMapping("/saveSite")
	public Integer saveMetroSite(MetroSite site,String lineJson,String shopJson) throws Exception{
		try {
			int i = lineService.saveMetroSite(site, lineJson,shopJson);
			sysLogService.addSysLog("站台新增", site.getName(), OperationEvent.EVENT_SAVE.getName(), "成功");
			return i;
		} catch (Exception e) {
			sysLogService.addSysLog("站台新增", site.getName(), OperationEvent.EVENT_SAVE.getName(), "失败"+e.getMessage());
			throw new RuntimeException(e);
		}
	}
	
	@RequestMapping("/delMetroSite")
	@ResponseBody
	public Integer delMetroSite(String id,String names) throws Exception{
		try{
			int i =  lineService.delMetroSite(id);
			for(String s:names.split(",")){
				sysLogService.addSysLog("站台维护",s, OperationEvent.EVENT_DELETE.getName(), "成功");
			}
			return i;
		} catch (Exception e) {
			for(String s:names.split(",")){
				sysLogService.addSysLog("站台维护",s, OperationEvent.EVENT_DELETE.getName(), "失败"+e.getMessage());
			}
			throw new RuntimeException(e);
		}
	}
	
	@ResponseBody
	@RequestMapping("/updateMetroSite")
	public Integer updateMetroSite(MetroSite site,String lineinserted,String linedeleted,
			String lineupdated,String shopinserted,String shopdeleted,String shopupdated,String imageSessionName) throws Exception{
		try{
			int i = 0;
			if(site.getId() == null){
				i = lineService.updateMetroSite(site, lineinserted, linedeleted, lineupdated, shopinserted, shopdeleted, shopupdated,imageSessionName);
				sysLogService.addSysLog("站台新增", site.getName(), OperationEvent.EVENT_SAVE.getName(), "成功");
			}else{
				i = lineService.updateMetroSite(site, lineinserted, linedeleted, lineupdated, shopinserted, shopdeleted, shopupdated,imageSessionName);
				sysLogService.addSysLog("站台维护", site.getName(), OperationEvent.EVENT_UPDATE.getName(), "成功");
			}
			return i;
		}catch (Exception e) {
			if(site.getId() == null){
				sysLogService.addSysLog("站台新增", site.getName(), OperationEvent.EVENT_SAVE.getName(), "失败"+e.getMessage());
			}else{
				sysLogService.addSysLog("站台维护", site.getName(), OperationEvent.EVENT_UPDATE.getName(), "失败"+e.getMessage());
			}
			
			throw new RuntimeException(e);
		}
	}
	/**
	 * 判断站台名称是否存在
	 * @param name
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/findSiteByName")
	public Integer findSiteByName(String name){
		MetroSite site = lineService.findSiteByName(name);
		if(site == null){
			return 0;
		}else{
			return 1;
		}
	}
	
	/**
	 * 
	 */
	@RequestMapping("/findLineBySiteId")
	public Map<String,Object> findLineBySiteId(Integer id,Integer id_){
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("rows", lineService.findLineBySiteId(id==null?id_:id));
		map.put("total", 0);
		return map;
	}
	
	@RequestMapping("/findShopBySiteId")
	public Map<String,Object> findShopBySiteId(Integer id,Integer id_){
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("rows", lineService.findShopBySiteId(id==null?id_:id));
		map.put("total", 0);
		return map; 
	}
	
	@RequestMapping("/findShops")
	public Map<String,Object> findShops(Shop shop,Page page){ 
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("rows", lineService.findShops(shop, page));
		map.put("total", page.getTotalRows());
		return map; 
	}
	/**
	 * 解析百度上海地铁地图XML保存 线路/站台
	 * @throws DocumentException 
	 */
//	@RequestMapping("/readXmlSaveLineSite")
	@ResponseBody
	public void readXmlSaveLineSite() throws DocumentException{
		lineService.readXmlSaveLineSiteService();
	}
	
	/**
	 * 门店
	 */
	@RequestMapping("/shopPage")
	public String shopPage(Model model){
		model.addAttribute("shopTypes", Dictionary.findShopType());
		return "line/shop";
	}
	/**
	 * 保存门店
	 * @param shop
	 * @throws Exception 
	 */
	@RequestMapping("/saveShop")
	@ResponseBody
	public void saveShop(@RequestParam("csv") MultipartFile mFile,Shop shop,HttpServletResponse res,
							String imageSessionName) throws Exception{
		
		try{
			if(shop.getId() == null){
				shop = lineService.saveShop(shop,mFile,imageSessionName);
				sysLogService.addSysLog("门店新增", shop.getName(), OperationEvent.EVENT_SAVE.getName(), "成功");
			}else{
				shop = lineService.saveShop(shop,mFile,imageSessionName);
				sysLogService.addSysLog("门店维护", shop.getName(), OperationEvent.EVENT_UPDATE.getName(), "成功");
			}
			res.setContentType("text/html;charset=utf-8");
			PrintWriter witer = res.getWriter();
			witer.print(CommonUtil.toJson(shop));
			witer.flush();
			witer.close();
		}catch (Exception e) {
			if(shop.getId() == null){
				sysLogService.addSysLog("门店新增", shop.getName(), OperationEvent.EVENT_SAVE.getName(), "失败"+e.getMessage());
			}else{
				sysLogService.addSysLog("门店维护", shop.getName(), OperationEvent.EVENT_UPDATE.getName(), "失败"+e.getMessage());
			}
			throw new RuntimeException(e);
		}
	}
	/**
	 * 删除门店
	 * @param shop
	 * @throws Exception 
	 */
	@RequestMapping("/delShop")
	@ResponseBody
	public void delShop(String ids,String names) throws Exception{
		
		try {
			lineService.delShop(ids);
			for(String s : names.split(",")){
				sysLogService.addSysLog("门店维护", s, OperationEvent.EVENT_DELETE.getName(), "成功");
			}
		} catch (Exception e) {
			for(String s : names.split(",")){
				sysLogService.addSysLog("门店维护", s, OperationEvent.EVENT_DELETE.getName(), "失败"+e.getMessage());
			}
			throw new RuntimeException(e);
		}
	}
	
	/**
	 * 保存门店 without upload
	 * @param shop
	 * @throws Exception 
	 */
	@RequestMapping("/saveShopWithOut")
	@ResponseBody
	public void saveShopWithOut(Shop shop,HttpServletResponse res,String imageSessionName) throws Exception{
		Shop s;
		try {
			if(shop.getId() == null){
				s = lineService.saveShopWithOut(shop,imageSessionName);
				sysLogService.addSysLog("门店新增", shop.getName(), OperationEvent.EVENT_SAVE.getName(), "成功");
			}else{
				s = lineService.saveShopWithOut(shop,imageSessionName);
				sysLogService.addSysLog("门店维护", shop.getName(), OperationEvent.EVENT_UPDATE.getName(), "成功");
			}
			res.setContentType("text/html;charset=utf-8");
			PrintWriter witer = res.getWriter();
			witer.print(CommonUtil.toJson(s));
			witer.flush();
			witer.close();
		} catch (Exception e) {
			if(shop.getId() == null){
				sysLogService.addSysLog("门店新增", shop.getName(), OperationEvent.EVENT_SAVE.getName(), "失败"+e.getMessage());
			}else{
				sysLogService.addSysLog("门店新增", shop.getName(), OperationEvent.EVENT_UPDATE.getName(), "失败"+e.getMessage());
			}
			
			throw new RuntimeException(e);
		}
		
		
	}
	
	@RequestMapping("/shopPic")
	public String shopPic(Model model,Integer shopId){
		model.addAttribute("list", lineService.findShopPic(shopId));
		model.addAttribute("path", "SHOP_IMG");
		return "line/shopPic";
	}
	
	/**
	 *  图片上传
	 * @throws Exception 
	 */
	@RequestMapping(value = "/shopPicUpload")
	public void shopPicUpload(@RequestParam("files") MultipartFile mFile,HttpServletResponse response,Shop shop) throws Exception{
		String fileName = mFile.getOriginalFilename();
		String suffix = fileName.substring(fileName.length()-4,fileName.length());
		BufferedImage sourceImg = ImageIO.read(mFile.getInputStream());
		String fileNewName = UUIDUtil.generate() + suffix;
		ShopFile shopFile = new ShopFile();
		FileItem fileItem = new FileItem();
		fileItem.setCreatedAt(DateTools.dateToHour());
		fileItem.setCreatedBy(UserContext.getUserId());
		fileItem.setFilesize(mFile.getSize());
		fileItem.setOriginalFilename(fileName);
		fileItem.setUrl(fileNewName);
		fileItem.setMimeType(mFile.getContentType());
		fileItem.setLastModifiedAt(DateTools.dateToHour());
		fileItem.setLastModifiedBy(UserContext.getUserId());
		fileItem.setWidth(sourceImg.getWidth());
		fileItem.setHeight(sourceImg.getHeight());
		shopFile.setShop(shop);
		lineService.saveShopFile(fileItem,shopFile);
		FileUtil.saveFile(mFile.getInputStream(), Constants.SHOP_IMG, fileNewName);
		FileUtil.outPic(mFile, "SHOP_IMG", fileNewName, response);
	}
	
	/**
	 * 获取显示图片
	 * @param mFile
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping(value = "/shopPicShow")
	public void shopPicShow(String path,String fileName,HttpServletResponse response) throws Exception{
		File file = new File(Dictionary.getPicPath(path) + fileName);
		 response.setContentType("image/jpeg");
         response.setContentLength((int) file.length());
         response.setHeader("Content-Disposition", "inline; filename=\"" + file.getName() + "\"" );
         byte[] bbuf = new byte[1024];
         DataInputStream in = new DataInputStream(new FileInputStream(file));
         int bytes = 0;
         ServletOutputStream op = response.getOutputStream();
         while ((in != null) && ((bytes = in.read(bbuf)) != -1)) {
        	 op.write(bbuf, 0, bytes);
         }
         in.close();
         op.flush();
         op.close();
	}
	
	/**
	 * 显示缩略图
	 * @throws Exception 
	 */
	@RequestMapping("/showGetthumbPic")
	public void showGetthumbPic(String path ,String fileName,HttpServletResponse response) throws Exception{
		File file = new File(Dictionary.getPicPath(path) + fileName);
        if (file.exists()) {
            String mimetype = "image/jpeg";
            if (mimetype.endsWith("png") || mimetype.endsWith("jpeg") || mimetype.endsWith("gif")) {
                BufferedImage im = ImageIO.read(file);
                if (im != null) {
                    BufferedImage thumb = Scalr.resize(im, 75); 
                    ByteArrayOutputStream os = new ByteArrayOutputStream();
                    if (mimetype.endsWith("png")) {
                        ImageIO.write(thumb, "PNG" , os);
                        response.setContentType("image/png");
                    } else if (mimetype.endsWith("jpeg")) {
                        ImageIO.write(thumb, "jpg" , os);
                        response.setContentType("image/jpeg");
                    } else {
                        ImageIO.write(thumb, "GIF" , os);
                        response.setContentType("image/gif");
                    }
                    ServletOutputStream srvos = response.getOutputStream();
                    response.setContentLength(os.size());
                    response.setHeader( "Content-Disposition", "inline; filename=\"" + file.getName() + "\"" );
                    os.writeTo(srvos);
                    srvos.flush();
                    srvos.close();
                }
            }
        }
	}
	/**
	 * 删除图片
	 * @param id
	 * @param fileName
	 */
	@RequestMapping("/delShopPic")
	public void delShopPic(String id,String fileName){
		lineService.delShopPic(id, fileName);
	}
	
	@RequestMapping("/typeAndPost")
	public String typeAndPost(Integer shopId,Model model){
		model.addAttribute("shopId",shopId);
		return "line/typeAndPost";
	}
	
	@RequestMapping("/saveTypeAndPost")
	public void saveTypeAndPost(String typeinserted,String typedeleted,Integer shopId,String shopName,
			String typeupdated,String posinserted,String posdeleted,String posupdated) throws Exception{
		try {
			lineService.saveTypeAndPost(typeinserted, typedeleted, typeupdated, posinserted, posdeleted, posupdated,shopId);
			//  消费类型及POS机维护
			sysLogService.addSysLog("门店维护", shopName, OperationEvent.EVENT_UPDATE.getName(), "成功");
		} catch (Exception e) {
			sysLogService.addSysLog("门店维护", shopName, OperationEvent.EVENT_UPDATE.getName(), "失败"+e.getMessage());
			throw new RuntimeException(e);
		}
	}
	
	/**
	 * 查询消费类型
	 */
	@RequestMapping("/findType")
	public Map<String,Object> findType(Integer shopId,Integer shopId_){
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("rows", lineService.findType(shopId==null?shopId_:shopId));
		map.put("total", 0);
		return map;
	}
	
	/**
	 * 查询消费类型
	 */
	@RequestMapping("/findPost")
	public Map<String,Object> findPost(Integer shopId,Integer shopId_){
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("rows", lineService.findPost(shopId==null?shopId_:shopId));
		map.put("total", 0);
		return map 	;
	}
	
	/**
	 * 所属站台
	 * @return
	 */
	@RequestMapping("/shopSite")
	public String shopSite(Integer id,Integer orderNo,Model model){
		model.addAttribute("site", lineService.findSiteById(id));
		model.addAttribute("orderNo", orderNo);
		return  "line/shopSite";
	}

	@RequestMapping("/saveShopSite")
	public void saveShopSite(Integer siteId,Integer orderNo,Integer shopId,String shopName){
		
		try {
			lineService.saveShopSite(siteId, orderNo, shopId);
			//+ "  所属站台维护"
			sysLogService.addSysLog("门店维护", shopName , OperationEvent.EVENT_UPDATE.getName(), "成功");
		} catch (Exception e) {
			sysLogService.addSysLog("门店维护", shopName, OperationEvent.EVENT_UPDATE.getName(), "失败"+e.getMessage());
			throw new RuntimeException(e);
		}
	}
	
	/**
	 * 品牌维护
	 * @return
	 */
	@RequestMapping("/shopBrand")
	public String shopBrand(Integer shopId,Model model){
		model.addAttribute("shopId", shopId);
		return  "line/shopBrand";
	}
	
	@RequestMapping("/saveShopBrand")
	public void saveShopBrand(String inserted,String deleted,String updated,Integer shopId,String shopName) throws Exception{
		
		try {
			lineService.saveShopBrand(inserted, deleted, updated, shopId);
			// + "  品牌维护"
			sysLogService.addSysLog("门店维护", shopName, OperationEvent.EVENT_UPDATE.getName(), "成功");
		} catch (Exception e) {
			sysLogService.addSysLog("门店维护", shopName, OperationEvent.EVENT_UPDATE.getName(), "失败"+e.getMessage());
			throw new RuntimeException(e);
		}
	}
	
	@RequestMapping("/findShopBrand")
	public Map<String,Object> findShopBrand(Integer shopId,Integer shopId_) throws Exception{
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("rows", lineService.findShopBrand(shopId==null?shopId_:shopId));
		map.put("total", 0);
		return map;
	}
	
	/**
	 * 门店优惠码导入列表
	 */
	@RequestMapping("/shopPromoCode")
	public String shopPromoCode(Integer shopId,Model model){
		model.addAttribute("shopId", shopId);
		return "line/shopPromoCode";
	}
	
	@RequestMapping("/findShopPromoCode")
	public Map<String,Object> findShopPromoCode(Integer shopId_,Integer shopId){
		Map<String,Object> map = new HashMap<String, Object>();
		List<Shop> list = lineService.findShopPromoCode(shopId==null?shopId_:shopId);
		map.put("rows", list);
		map.put("total", list.size());
		return map;
	}
	
	/**
	 * 优惠码Detail
	 */
	@RequestMapping("/shopPromoCodeDetail")
	public String shopPromoCodeDetail(Model model,String importDate){
		model.addAttribute("importDate", importDate);
		return "line/shopPromoCodeDetail";
	}
	
	@RequestMapping("/findShopPromoCodeDetail")
	public Map<String,Object> findShopPromoCodeDetail(String num,String importDate,Page page){
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("rows", lineService.findShopPromoCodeDetail(num,importDate, page));
		map.put("total", page.getTotalRows());
		return map;
	}
	
	/**
	 * 门店维护
	 * @return
	 */
	@RequestMapping("/shopList")
	public String shopList(Model model){
		model.addAttribute("shopTypes", Dictionary.findShopType());
		return "line/shopList";
	}
	
	@RequestMapping("/findShopList")
	public Map<String,Object> findShopList(Shop shop,Page page){
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("rows", lineService.findShopList(shop, page));
		map.put("total", page.getTotalRows());
		return map;
	}
	
	@RequestMapping("/updateShopPage")
	public String updateShopPage(HttpSession session,Model model,Integer id){
		model.addAttribute("shop", lineService.findShopById(id));
		model.addAttribute("shopTypes", Dictionary.findShopType());
		Map<String, FileItem> images = lineService.findShopImg(id);
		String imageSessionName = UUIDUtil.generate();
		session.setAttribute(imageSessionName, images);
		model.addAttribute("images", CommonUtil.toJson(images));
		model.addAttribute("imageSessionName", imageSessionName);
		return "line/shop";
	}

	/**
	 * 门店商品
	 */
	@RequestMapping("/shopMerchandise")
	public String shopMerchandise(Integer shopId,Model model){
		model.addAttribute("shopId", shopId);
		return "line/shopMerchandise";
	}
	
	@RequestMapping("/findShopMerchandise")
	public Map<String,Object> findShopMerchandise(Integer shopId,Page page){
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("rows", lineService.findShopMerchandise(shopId, page));
		map.put("total", page.getTotalRows());
		return map;
	} 
	
	/**
	 * 站台选择线路时，判断排序编号是否重复
	 */
	@RequestMapping("/findSiteOrderNo")
	@ResponseBody
	public Integer findSiteOrderNo(Integer lineId, Integer orderNo,Integer orderNo_){
		return lineService.findSiteOrderNo(lineId, orderNo,orderNo_);
	}
	
	@RequestMapping("/findShopSite")
	@ResponseBody
	public Integer findShopSite(Integer shopId,Integer siteId){
		return lineService.findShopSite(shopId,siteId);
	}
	
	/**
	 * POS机绑定时判断是存在
	 * @param code
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/findPosBinByCode")
	public Integer findPosBinByCode(String code,String oldCode){
		return lineService.findPosBinByCode(code,oldCode);
	}
	
	/**
	 * 验证Shop站台排序编号是否存在
	 * @param siteId
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/validateShopSiteCode")
	public Integer validateShopSiteCode(Integer siteId,Integer orderNo,Integer shopId){
		List<Shop> list = lineService.findShopBySiteId(siteId);
		int i = 0;
		for(Shop s : list){
			if(s.getOrderNo().equals(orderNo) && !s.getId().equals(shopId)){
				i = 1; break;
			}
		}
		return i;
	}
	
	/**
	 * 保存site图片
	 * @param imageSessionName
	 * @param siteId
	 * @param session
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@ResponseBody
	@RequestMapping("/saveSiteFile")
	public AjaxResponseCommonVo saveSiteFile(String imageSessionName,Integer siteId,HttpSession session) throws Exception{
		AjaxResponseCommonVo commonVo = new AjaxResponseCommonVo();
		Map<String, FileItem> images = (Map<String, FileItem>)session.getAttribute(imageSessionName);
		if(null == images || images.size() == 0){
			commonVo.setMsg("请先上传图片");
		}
		else{
			try {
				lineService.saveSiteFile(imageSessionName,siteId);
				commonVo.setMsg("保存成功");
			} catch (IOException e) {
				commonVo.setMsg("错误："+e.getMessage());
				e.printStackTrace();
			}
		}
		return commonVo;
	}
	
	/**
	 * 保存line图片
	 * @param imageSessionName
	 * @param lineId
	 * @param session
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@ResponseBody
	@RequestMapping("/saveLineFile")
	public AjaxResponseCommonVo saveLineFile(String imageSessionName,Integer lineId,HttpSession session) throws Exception{
		AjaxResponseCommonVo commonVo = new AjaxResponseCommonVo();
		Map<String, FileItem> images = (Map<String, FileItem>)session.getAttribute(imageSessionName);
		if(null == images || images.size() == 0){
			commonVo.setMsg("请先上传图片");
		}
		else{
			try {
				lineService.saveLineFile(imageSessionName,lineId);
				commonVo.setMsg("保存成功");
			} catch (IOException e) {
				commonVo.setMsg("错误："+e.getMessage());
				e.printStackTrace();
			}
		}
		return commonVo;
	}
	/**
	 * 保存save shopFile
	 * @param imageSessionName
	 * @param shopId
	 * @param session
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@ResponseBody
	@RequestMapping("/saveShopFile")
	public AjaxResponseCommonVo saveShopFile(String imageSessionName,Integer shopId,HttpSession session) throws Exception{
		AjaxResponseCommonVo commonVo = new AjaxResponseCommonVo();
		Map<String, FileItem> images = (Map<String, FileItem>)session.getAttribute(imageSessionName);
		if(null == images || images.size() == 0){
			commonVo.setMsg("请先上传图片");
		}
		else{
			try {
				lineService.saveShopFile(imageSessionName,shopId);
				commonVo.setMsg("保存成功");
			} catch (IOException e) {
				commonVo.setMsg("错误："+e.getMessage());
				e.printStackTrace();
			}
		}
		return commonVo;
	}
	
	/*****   连锁管理    *******/
	
	@RequestMapping("/shopChain")
	public String shopChain(){
		return "line/shopChain";
	}
	
	@ResponseBody
	@RequestMapping("/saveShopChain")
	public void saveShopChain(ShopChain chain){
		try {
			if(chain.getId() == null){
				lineService.saveShopChain(chain);
				sysLogService.addSysLog("连锁新增", chain.getName(), OperationEvent.EVENT_SAVE.getName(), "成功");
			}else{
				lineService.saveShopChain(chain);
				sysLogService.addSysLog("连锁维护", chain.getName(), OperationEvent.EVENT_UPDATE.getName(), "成功");
			}
		} catch (Exception e) {
			if(chain.getId() == null){
				sysLogService.addSysLog("连锁新增", chain.getName(), OperationEvent.EVENT_SAVE.getName(), "失败"+e.getMessage());
			}else{
				sysLogService.addSysLog("连锁维护", chain.getName(), OperationEvent.EVENT_UPDATE.getName(), "失败"+e.getMessage());
			}
			throw new RuntimeException(e);
		}
	}
	
	@RequestMapping("/shopChainList")
	public String shopChainList(){
		return "line/shopChainList";
	}
	
	@RequestMapping("/findShopChainById")
	public String findShopChainById(Integer id,Model model){
		model.addAttribute("chain", lineService.findShopChainById(id));
		return "line/shopChain";
	}
	
	@RequestMapping("/findShopChainByNo")
	@ResponseBody
	public Integer findShopChainByNo(String numno,Integer id){
		ShopChain s = lineService.findShopChainByNo(numno);
		if(s == null){
			return 0;
		}else{
			if(s.getId().equals(id)){
				return 0;
			}
			return 1;
		}
	}
	
	@RequestMapping("/findShopChain")
	public Map<String,Object> findShopChain(ShopChain chain,Page page){
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("rows", lineService.findShopChain(chain, page));
		map.put("total", page.getTotalRows());
		return map;
	}
	
	@RequestMapping("/delShopChain")
	@ResponseBody
	public String delShopChain(String ids,String names,String numno){
		String s = "";
		Integer[] idss = CommonUtil.getIntegers(ids);
		for(int i=0;i<idss.length;i++){
			List<Shop> list = lineService.findShopByChainId(idss[i]);
			if(list.size() > 0){
				s = "编号为"+numno.split(",")[i]+"的总店已经被其他门店绑定,不能删除";break;
			}
		}
		
		if("".equals(s)){
			try {
				lineService.delShopChain(ids);
				for(String ss : names.split(",")){
					sysLogService.addSysLog("连锁维护", ss, OperationEvent.EVENT_DELETE.getName(), "成功");
				}
			} catch (Exception e) {
				for(String ss : names.split(",")){
					sysLogService.addSysLog("连锁维护", ss, OperationEvent.EVENT_DELETE.getName(), "失败"+e.getMessage());
				}
				throw new RuntimeException(e);
			}
			s = "删除成功";
			return s;
		}else{
			return s;
		}
	}
	
}

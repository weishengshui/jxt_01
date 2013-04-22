/**
 * 
 * 读取配置文件
 * @version 1.0
 * 
 */
package jxt.elt.common;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;


public class PropertiesReader {
	
	private Properties prop = new Properties();

	  /**
	   * 以“/com/oki/config/cfg.properties”作为缺省的配置文件读取配置信息
	 * @throws IOException 
	   * @throws IOException
	   */
	  public PropertiesReader() throws IOException{
	      propertyRead("/jdbc.properties");
	  }

	  /**
	   * 指定一个配置文件，读取配置信息，注意：指定的配置文件必须带路径.
	   * @param propertyFile 配置文件
	 * @throws IOException 
	   * @throws IOException 访问配置文件异常
	   */
	  public PropertiesReader(String propertyFile) throws IOException{
	      propertyRead(propertyFile);
	  }

	  /**
	   * 读取配置文件
	   * @param propertyFile 配置文件名称
	 * @throws IOException 
	   * @throws IOException 读取配置文件出错
	   */
	  private void propertyRead(String propertyFile) throws IOException{
		  prop.clear();	
		  InputStream is=null;
	      try {
	    	  is = getClass().getResourceAsStream(propertyFile);
	    	  prop.load(is);
			} catch (IOException e) {
				e.printStackTrace();
			} finally{
				if(is!=null)
					is.close();
			}
	  }

	  /**
	   * 获取配置文件某一key对应的值
	   * @param aprop key的名称
	   * @return  对应的value
	   */
	  public String getProperty(String aprop){
		 if(prop.containsKey(aprop)){
			 return prop.getProperty(aprop).trim();
		 }else{
			 return null;
		 }
	  }
	  
	  public static void main(String[] str) throws IOException{
		  PropertiesReader read = new PropertiesReader();
		  String a = read.getProperty("a");
		  try {
			System.out.println(a);
		} catch (Exception e) {
			e.printStackTrace();
		}
	  }
	  
}

package com.ssh.util;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import org.apache.log4j.Logger;

public class FileUtil {
	/**
	 * 创建文件夹
	 * 
	 * @param path
	 *            目录
	 */
	private static Logger logger = Logger.getLogger(FileUtil.class.getName());
	public void createDir(String path) {
		File dir = new File(path);
		if (!dir.exists()) {
			dir.mkdir();
			logger.info("创建文件夹成功！");
		}
	}

	/**
	 * 递归删除文件夹 要利用File类的delete()方法删除目录时， 必须保证该目录下没有文件或者子目录，否则删除失败，
	 * 因此在实际应用中，我们要删除目录， 必须利用递归删除该目录下的所有子目录和文件， 然后再删除该目录。
	 * 
	 * @param path
	 */
	public void delDir(String path) {
		File dir = new File(path);
		if (dir.exists()) {
			File[] tmp = dir.listFiles();
			for (int i = 0; i < tmp.length; i++) {
				if (tmp[i].isDirectory()) {
					delDir(path + "/" + tmp[i].getName());
				} else {
					tmp[i].delete();
				}
			}
			dir.delete();
		}
	}

	/*
	 * 转移文件目录不等同于复制文件，复制文件是复制后两个目录都存在该文件， 而转移文件目录则是转移后，只有新目录中存在该文件
	 */
	/**
	 * 转移文件目录
	 * 
	 * @param filename
	 *            文件名
	 * @param oldpath
	 *            旧目录
	 * @param newpath
	 *            新目录
	 * @param cover
	 *            若新目录下存在和转移文件具有相同文件名的文件时，是否覆盖新目录下文件， cover=true将会覆盖原文件，否则不操作
	 */
	public void changeDirectory(String filename, String oldpath,
			String newpath, boolean cover) {
		if (!oldpath.equals(newpath)) {
			File oldfile = new File(oldpath + "/" + filename);
			File newfile = new File(newpath + "/" + filename);
			if (newfile.exists()) {
				if (cover)
					oldfile.renameTo(newfile);
				else
					logger.warn("在新目录下已经存在：" + filename);
			} else {
				oldfile.renameTo(newfile);
			}
		}
	}

	/**
	 * 创建新文件
	 * 
	 * @param path
	 *            目录
	 * @param filename
	 *            文件名
	 * @throws IOException
	 */
	public void createFile(String path, String filename) throws IOException {
		File file = new File(path + "/" + filename);
		if (!file.exists()) {
			file.createNewFile();
			logger.info("创建文件成功！");
		}
	}

	/*
	 * 利用BufferedWriter写入文件内容
	 * 
	 * 利用Buffer操作IO速度会稍微快一点
	 */
	public void writeFile(String filename) {
		File file = new File(filename);
		try {
			if (!file.exists())
				file.createNewFile();
			FileWriter fw = new FileWriter(file, true);
			BufferedWriter bw = new BufferedWriter(fw);
			for (int i = 0; i < 10; i++)
				bw.write("这是第" + (i + 1) + "行，应该没错哈 ");
			
			bw.close();
			bw = null;
			fw.close();
			fw = null;
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	/**
	 * 读文件 利用BufferedReader读取在IO操作，利用BufferedReader和BufferedWriter效率会更高一点
	 * 
	 * @param path
	 * @return
	 * @throws IOException
	 */
	public String readFile(String path) throws IOException {
		StringBuffer sb = new StringBuffer();
		BufferedReader br = null;
		try{
			File file = new File(path);
			if (!file.exists() || file.isDirectory())
				throw new FileNotFoundException();
			br = new BufferedReader(new FileReader(file));
			String temp = null;
			temp = br.readLine();
			while (temp != null) {
				sb.append(temp + " ");
				temp = br.readLine();
			}
		}
		catch(IOException e){
			e.printStackTrace();
		}
		finally{
			if(br != null)
				br.close();
			return sb.toString();
		}
	}

	/**
	 * 文件重命名--如果重命名的目标文件已经存在,则不会进行任何操作
	 * 
	 * @param path
	 *            文件目录
	 * @param oldname
	 *            原来的文件名
	 * @param newname
	 *            新文件名
	 */
	public void renameFile(String path, String oldname, String newname) {
		if (!oldname.equals(newname)) {
			File oldfile = new File(path + "/" + oldname);
			File newfile = new File(path + "/" + newname);
			if (newfile.exists())
				logger.warn(newname + "已经存在！");
			else {
				oldfile.renameTo(newfile);
			}
		}
	}

	/**
	 * 以文件流的方式复制文件 支持中文处理，并且可以复制多种类型，比如txt，xml，jpg，doc等多种格式
	 * 
	 * @param src
	 *            文件源目录
	 * @param dest
	 *            文件目的目录
	 * @throws IOException
	 */
	public void copyFile(String src, String dest) throws IOException {
		FileInputStream in = new FileInputStream(src);
		File file = new File(dest);
		if (!file.exists())
			file.createNewFile();
		FileOutputStream out = new FileOutputStream(file);
		int c;
		byte buffer[] = new byte[1024];
		while ((c = in.read(buffer)) != -1) {
			for (int i = 0; i < c; i++)
				out.write(buffer[i]);
		}
		logger.info("文件拷贝完毕！");
		in.close();
		out.close();
	}

	/**
	 * 删除文件
	 * 
	 * @param path
	 *            目录
	 * @param filename
	 *            文件名
	 */
	public void delFile(String path, String filename) {
		File file = new File(path + "/" + filename);
		if (file.exists() && file.isFile())
			file.delete();
	}

}

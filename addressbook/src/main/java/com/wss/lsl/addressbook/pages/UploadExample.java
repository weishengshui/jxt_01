package com.wss.lsl.addressbook.pages;

import java.io.File;

import org.apache.tapestry5.annotations.Property;
import org.apache.tapestry5.upload.services.UploadedFile;

public class UploadExample {

	@Property
	private UploadedFile file;
	@Property
	private UploadedFile file2;

	public void onSuccessFromUploadFile() {

		File tempFile = new File(System.getProperty("user.dir"),
				file.getFileName());

		file.write(tempFile);
		
		tempFile = new File(System.getProperty("user.dir"),
				file2.getFileName());
		file2.write(tempFile);
	}
}

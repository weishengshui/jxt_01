package com.wss.lsl.addressbook.pages;

import java.io.File;

import org.apache.commons.fileupload.FileUploadException;
import org.apache.tapestry5.PersistenceConstants;
import org.apache.tapestry5.annotations.Persist;
import org.apache.tapestry5.annotations.Property;
import org.apache.tapestry5.upload.services.UploadedFile;

public class UploadExample {

	@Property
	private UploadedFile file;
	@Property
	private UploadedFile file2;
	@Persist(PersistenceConstants.FLASH)
	@Property
	private String message;

	public void onSuccessFromUploadFile() {

		File tempFile = new File(System.getProperty("user.dir"),
				file.getFileName());

		file.write(tempFile);

		tempFile = new File(System.getProperty("user.dir"), file2.getFileName());
		file2.write(tempFile);
	}

	public Object onUploadException(FileUploadException exception) {

		message = "Upload exception: " + exception.getMessage();

		return this;
	}
}

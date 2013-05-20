package com.chinarewards.alading.crypto;

import java.io.StringReader;
import java.io.StringWriter;
import java.security.KeyFactory;
import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.Security;
import java.security.Signature;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.spec.X509EncodedKeySpec;

import org.bouncycastle.jce.provider.BouncyCastleProvider;
import org.bouncycastle.util.io.pem.PemObject;
import org.bouncycastle.util.io.pem.PemReader;
import org.bouncycastle.util.io.pem.PemWriter;

public class SignatureUtils {

	static {
		Security.addProvider(new BouncyCastleProvider());
	}

	public static String getSignatureHash(String privKeyPEMString,
			String content) throws Exception {

		PemReader pemReader = new PemReader(new StringReader(privKeyPEMString));
		PemObject pem = pemReader.readPemObject();

		PKCS8EncodedKeySpec keyspec = new PKCS8EncodedKeySpec(pem.getContent());
		KeyFactory kf = KeyFactory.getInstance("RSA");
		PrivateKey privKey = kf.generatePrivate(keyspec);

		pemReader.close();

		Signature sig = Signature.getInstance("SHA1WithRSA");
		sig.initSign(privKey);
		sig.update(content.getBytes("UTF-8"));
		byte[] signature = sig.sign();
		StringWriter sw = new StringWriter();
		PemWriter pemWriter = new PemWriter(sw);
		pemWriter.writeObject(new PemObject("RSA SIGNATURE", signature));
		pemWriter.close();

		String output = sw.getBuffer().toString();
		return output;
	}

	public static boolean verifySignatureHash(String pubKeyPEMString,
			String content, String signatureHash) throws Exception {
		PemReader pemReader = new PemReader(new StringReader(pubKeyPEMString));
		PemObject pem = pemReader.readPemObject();

		X509EncodedKeySpec keyspec = new X509EncodedKeySpec(pem.getContent());
		KeyFactory kf = KeyFactory.getInstance("RSA");
		PublicKey pubKey = kf.generatePublic(keyspec);
		pemReader.close();

		PemReader pemSignReader = new PemReader(new StringReader(signatureHash));
		PemObject signature = pemSignReader.readPemObject();
		pemSignReader.close();

		Signature sig = Signature.getInstance("SHA1WithRSA");
		sig.initVerify(pubKey);
		sig.update(content.getBytes("UTF-8"));
		return sig.verify(signature.getContent());
	}

	public static KeyPair generateKeyPair() throws Exception {
		KeyPairGenerator keyGen = KeyPairGenerator.getInstance("RSA");
		keyGen.initialize(512);
		return keyGen.generateKeyPair();
	}

	public static String getPemString(PrivateKey key) throws Exception {
		StringWriter sw = new StringWriter();
		PemWriter pWriter = new PemWriter(sw);
		pWriter.writeObject(new PemObject("RSA PRIVATE KEY", key.getEncoded()));
		pWriter.close();
		return sw.toString();
	}

	public static String getPemString(PublicKey key) throws Exception {
		StringWriter sw = new StringWriter();
		PemWriter pWriter = new PemWriter(sw);
		pWriter.writeObject(new PemObject("PUBLIC KEY", key.getEncoded()));
		pWriter.close();
		return sw.toString();
	}
}

package com.wss.lsl.myapp.pages;

import java.util.Random;

import org.apache.tapestry5.annotations.InjectPage;
import org.apache.tapestry5.annotations.Log;


/**
 * Start page of application myapp2.
 */
public class Index {
	
	private final Random random = new Random(System.nanoTime());
	
	@InjectPage
	private Guess guess;
	
	@Log
	public Object onActionFromStart(){
		
		int target = random.nextInt(10)+1;
		guess.setUp(target);
		
		return guess;
	}
}

package com.wss.lsl.baijiaxing.test;

import static org.junit.Assert.*;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Comparator;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.ListIterator;
import java.util.Map;
import java.util.Set;
import java.util.SortedSet;
import java.util.TreeMap;
import java.util.TreeSet;
import java.util.Vector;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicInteger;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

public class MapTests {
	
	public AtomicInteger integer; // 原子类

	@Before
	public void setUp() throws Exception {
		integer = new AtomicInteger();
		integer.set(1);
		integer.addAndGet(1);
	}

	@After
	public void tearDown() throws Exception {
	}

	@Test
	public void test() {
		Map<String, Integer> hashMap = new HashMap<String, Integer>();
		hashMap.put("1", 1);
		hashMap.put("2", 2);
		hashMap.put("3", 3);
		hashMap.put("3", 3);
		hashMap.put(null, null);
		
		Map<String, Integer> treeMap = new TreeMap<String, Integer>();
		treeMap.put("1", 1);
		treeMap.put("2", 2);
//		treeMap.put(null, null); // NullPointerException
		treeMap.put("4", null);
		treeMap.put("4", 4);
		treeMap.put("3", 3);
		
		Map<String, Integer> hashtable = new Hashtable<String, Integer>();
		hashtable.put("1", 1);
		hashtable.put("2", 2);
		hashtable.put("3", 3);
		hashtable.put("3", 3);
		hashtable.put("4", 4);
		/**
		 * NullPointerException 
		 */
		// hashtable.put(null, null);
		// hashtable.put(null, 4);
		// hashtable.put("5", null);
		
		assertTrue(4==hashMap.size());
		assertTrue(4==treeMap.size());
		assertTrue(4==hashtable.size());
		
		int j = 1;
		System.out.println("--------------------------- hashMap ---------------------------");
		for(Map.Entry<String, Integer> entry : hashMap.entrySet()){
			System.out.println("key = "+entry.getKey()+"\t value = "+entry.getValue());
		}
		System.out.println("--------------------------- treeMap ---------------------------");
		for(Map.Entry<String, Integer> entry : treeMap.entrySet()){
			assertEquals(j+"", entry.getKey());
			assertTrue(j==entry.getValue());
			System.out.println("key = "+entry.getKey()+"\t value = "+entry.getValue());
			j++;
		}
		System.out.println("--------------------------- hashtable ---------------------------");
		for(Map.Entry<String, Integer> entry : hashtable.entrySet()){
			System.out.println("key = "+entry.getKey()+"\t value = "+entry.getValue());
		}
		
		// change value
		j = 4;
		for(Map.Entry<String, Integer> entry : hashMap.entrySet()){
			entry.setValue(j--);
		}
		for(Map.Entry<String, Integer> entry : treeMap.entrySet()){
			entry.setValue(j--);
		}
		for(Map.Entry<String, Integer> entry : hashtable.entrySet()){
			entry.setValue(j--);
		}
		
		j = 1;
		System.out.println("--------------------------- hashMap ---------------------------");
		for(Map.Entry<String, Integer> entry : hashMap.entrySet()){
			System.out.println("key = "+entry.getKey()+"\t value = "+entry.getValue());
		}
		System.out.println("--------------------------- treeMap ---------------------------");
		for(Map.Entry<String, Integer> entry : treeMap.entrySet()){
			System.out.println("key = "+entry.getKey()+"\t value = "+entry.getValue());
		}
		System.out.println("--------------------------- hashtable ---------------------------");
		for(Map.Entry<String, Integer> entry : hashtable.entrySet()){
			System.out.println("key = "+entry.getKey()+"\t value = "+entry.getValue());
		}
	}
	
	@Test
	public void vector(){
		System.out.println("--------------------------- vector ---------------------------");
		Vector<String> vector = new Vector<String>();
		vector.add("1");
		vector.add("2");
		vector.add("3");
		vector.add("3");
		vector.add("4");
		vector.add("5");
		vector.add("wss");
		vector.add("lsl");
		vector.add(null);
		for(Iterator<String> it = vector.iterator(); it.hasNext(); ){
			System.out.println(it.next());
		}
		for(ListIterator<String> it = vector.listIterator(); it.hasNext(); ){
			System.out.println(it.next());
		}
		
		System.out.println("--------------------------- linkedList ---------------------------");
		LinkedList<String> linkedList = new LinkedList<String>();
		linkedList.add("c");
		linkedList.add("b");
		linkedList.add("a");
		linkedList.add(null);
		for(Iterator<String> it = linkedList.iterator(); it.hasNext(); ){
			System.out.println(it.next());
		}
		
		System.out.println("--------------------------- arrayList ---------------------------");
		ArrayList<String> arrayList = new ArrayList<String>();
		arrayList.add("c");
		arrayList.add("b");
		arrayList.add("a");
		arrayList.add(null);
		for(Iterator<String> it = arrayList.iterator(); it.hasNext(); ){
			System.out.println(it.next());
		}
	}
	
	@Test
	public void set(){
		Set<Object> hashSet = new HashSet<Object>();
		hashSet.add(hashSet);
		hashSet.add("123");
		hashSet.add("123");
		hashSet.add(null);
		System.out.println("--------------------------- hashSet ---------------------------");
		for(Iterator<Object> it = hashSet.iterator(); it.hasNext();){
			System.out.println(it.next());
		}
		
		Set<String> treeSet = new TreeSet<String>();
		treeSet.add("c");
		treeSet.add("b");
		treeSet.add("a");
		treeSet.add("a");
//		treeSet.add(null); NullPointerException
		System.out.println("--------------------------- treeSet ---------------------------");
		for(Iterator<String> it = treeSet.iterator(); it.hasNext();){
			System.out.println(it.next());
		}
	}
}

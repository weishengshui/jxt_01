/*
���ƣ�������ʱ�ӣ�һ�ζ�ȡ��ʵʱ��ʾ��
���ܣ��ڿͻ������������ʾ�������˵�ʱ�䡣
ԭ��	
	�㷨���裺
	1. ��ȡ����˵�����ʱ�䡣
	2. ���ݿͻ����������ʱ����Եõ��������Ϳͻ��˵�ʱ��
	3. ��������ʱ�� = �ͻ��˵�ʱ�ӣ��仯ֵ��+ ʱ���̶�ֵ��
	
	�����ͻ��˾�û�б�Ҫʵʱ�ĵ���������ȥȡʱ�䡣

���ߣ�������
��Դ��http://www.cnblogs.com/march3/archive/2009/05/14/1456720.html
˵����
	1. �������֧��
	2. ����������ʱ�޷����Ƶ�ԭ�򣬻���һ������
	    �û�����ͨ�� set_delay() ������������
������
	s_year, s_month, s_day, s_hour, s_min, s_sec  
	�ֱ�Ϊ�������˵� �� �� �� ʱ �� �룬

	���磺2008,9,19,0,9,0 ��ʾ 2008��9��19�� 0��9��0��
*/
var ServerClock = 
			function(s_year,s_month,s_day,s_hour,s_min,s_sec)
{
	//���ƴӷ�����������ҳ����ͻ��˵���ʱʱ�䣬Ĭ��Ϊ1�롣
	var _delay = 1000;
	
	//�������˵�ʱ��
	var serverTime = null;
	if(arguments.length == 0)
	{
		//û�����÷������˵�ʱ�䣬����ǰʱ�䴦��
		serverTime = new Date(); 
		_delay = 0;
	}
	else
		serverTime = 
			new Date(s_year,s_month-1,s_day,s_hour,s_min,s_sec);

	//�ͻ����������ʱ��
	var clientTime = new Date();
	//��ȡʱ���
	var _diff = serverTime.getTime() - clientTime.getTime(); 

	//���ôӷ�����������ҳ����ͻ��˵���ʱʱ�䣬Ĭ��Ϊ1�롣
	this.set_delay = function(value){_delay=value;};

	//��ȡ���������ʱ��
	this.get_ServerTime = function(formatstring)
	{
		clientTime = new Date();
		serverTime.setTime(clientTime.getTime()+_diff+_delay);
		if(formatstring == null)
			return serverTime;
		else
			return serverTime.format(formatstring);
	};	
}

/*
Date ��չ��Ա
*/
/* English */
Date.MonthNames = new Array(
	'January',
	'February',
	'March',
	'April',
	'May',
	'June',
	'July',
	'August',
	'September',
	'October',
	'November',
	'December'
);
Date.DayNames = new Array(
	'Sunday',
	'Monday',
	'Tuesday',
	'Wednesday',
	'Thursday',
	'Friday',
	'Saturday'
);
/*����*/
Date.MonthNames = new Array(
	'һ��',
	'����',
	'����',
	'����',
	'����',
	'����',
	'����',
	'����',
	'����',
	'ʮ��',
	'ʮһ��',
	'ʮ����'
);
Date.DayNames = new Array(
	'������',
	'����һ',
	'���ڶ�',
	'������',
	'������',
	'������',
	'������'
);

/*
Date format ������չ����
���ԣ�http://javascript.about.com/library/bldateformat.htm
*/
Date.prototype.format=function (format) {
	if(format==null)format="yyyy/MM/dd HH:mm:ss.SSS";
	var year=this.getFullYear();
	var month=this.getMonth();
	var sMonth=Date.MonthNames[month];
	var date=this.getDate();
	var day=this.getDay();
	var hr=this.getHours();
	var min=this.getMinutes();
	var sec=this.getSeconds();
	var daysInYear=Math.ceil((this-new Date(year,0,0))/86400000);
	var weekInYear=Math.ceil((daysInYear+new Date(year,0,1).getDay())/7);
	var weekInMonth=Math.ceil((date+new Date(year,month,1).getDay())/7);
	return format.replace("yyyy",year).
		replace("yy",year.toString ().substr(2)).
		replace("dd",(date<10?"0":"")+date).	
		replace("HH",(hr<10?"0":"")+hr).
		replace("KK",(hr%12<10?"0":"")+hr%12).
		replace("kk",(hr>0&&hr<10?"0":"")+(((hr+23)%24)+1)).
		replace("hh",(hr>0&&hr<10||hr>12&&hr<22?"0":"")+(((hr+11)%12)+1)).
		replace("mm",(min<10?"0":"")+min).
		replace("ss",(sec<10?"0":"")+sec).
		replace("SSS",this%1000).
		replace("a",(hr<12?"AM":"PM")).
		replace("W",weekInMonth).
		replace("F",Math.ceil(date/7)).
		replace(/E/g,Date.DayNames[day]).
		replace("D",daysInYear).
		replace("w",weekInYear).
		replace(/MMMM+/,sMonth).
		replace("MMM",sMonth.substring(0,3)).
		replace("MM",(month<9?"0":"")+(month+1));
}

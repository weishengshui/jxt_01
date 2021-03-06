window.pageConfig = {
			compatible: true,
       		product: {
				skuid: 849503,
				name: '\u5b8f\u7881\uff08\u0061\u0063\u0065\u0072\uff09\u0020\u0045\u0043\u002d\u0034\u0037\u0031\u0047\u002d\u0035\u0033\u0032\u0031\u0034\u0047\u0035\u0030\u004d\u006e\u006b\u0073\u0020\u0031\u0034\u002e\u0030\u82f1\u5bf8\u7b14\u8bb0\u672c\u7535\u8111\u0020\u0028\u0069\u0035\u002d\u0033\u0032\u0031\u0030\u004d\u0020\u0034\u0047\u0020\u0035\u0030\u0030\u0047\u0020\u0047\u0054\u0036\u0033\u0030\u004d\u0020\u0031\u0047\u72ec\u663e\u0020\u004c\u0069\u006e\u0075\u0078\u0029',
				skuidkey:'6535D2B3D6FC992E6641FB347AB55DBC',
				href: 'http://item.jd.com/849503.html',
				src: 'g7/M03/0D/11/rBEHZVCXJvUIAAAAAAEq4uvrNhYAACpeQN9OZcAASr6498.jpg',
				cat: [670,671,672],
				brand: 1000,
				tips: false,
				type: 1
			}
		};


// http://misc.360buyimg.com/lib/js/2012/base-v1.js
window.pageConfig=window.pageConfig||{};
pageConfig.wideVersion=(function(){
	return(screen.width>=1210)
})();
if(pageConfig.wideVersion&&pageConfig.compatible){
	document.getElementsByTagName("body")[0].className="root61"
}
pageConfig.FN_getDomain=function(){
	var a=location.hostname;
	return(/360buy.com/.test(a))?"360buy.com":"jd.com"
};

pageConfig.FN_StringFormat=function(){
	var e=arguments[0],f=arguments.length;
	if(f>0){
		for(var d=0;d<f;d++){
			e=e.replace(new RegExp("\\{"+d+"\\}","g"),arguments[d+1])
		}
	}
	return e
};
pageConfig.FN_GetDomain=function(b,c){
	var a="http://{0}.jd.com/{1}";
	switch(b){
		case 1:a=this.FN_StringFormat(a,"item","");break;
		case 2:a=this.FN_StringFormat(a,"book","");break;
		case 3:a=this.FN_StringFormat(a,"mvd","");break;
		case 4:a=this.FN_StringFormat(a,"e","");break;
		case 7:a=this.FN_StringFormat(a,"music","");
		break;default:break
	}
	return a
};
pageConfig.FN_GetImageDomain=function(d){
	var c,d=String(d);
	switch(d.match(/(\d)$/)[1]%5){
		case 0:c=10;break;
		case 1:c=11;break;
		case 2:c=12;break;
		case 3:c=13;break;
		case 4:c=14;break;
		default:c=10
	}
	return "http://img{0}.360buyimg.com/".replace("{0}",c)
};
pageConfig.FN_ImgError=function(b){
	var c=b.getElementsByTagName("img");
	for(var a=0;a<c.length;a++){
		c[a].onerror=function(){
			var d="",e=this.getAttribute("data-img");
			if(!e){
				return
			}
			switch(e){
				case"1":d="err-product";break;
				case"2":d="err-poster";break;
				case"3":d="err-price";
				break;default:return
			}
			this.src="http://misc.360buyimg.com/lib/img/e/blank.gif";
			this.className=d
		}
	}
};


pageConfig.FN_GetCompatibleData=function(b){
	var a=(screen.width<1210);
	if(a){
		b.width=b.widthB?b.widthB:b.width;
		b.height=b.heightB?b.heightB:b.height;
		b.src=b.srcB?b.srcB:b.src
	}
	return b
};

function login(){
	location.href="https://passport.jd.com/new/login.aspx?ReturnUrl="+escape(location.href).replace(/\//g,"%2F");
	return false
}
function regist(){
	location.href="https://passport.jd.com/new/registpersonal.aspx?ReturnUrl="+escape(location.href);
	return false
}

function readCookie(b){
	var e=b+"=";
	var a=document.cookie.split(";");
	for(var d=0;d<a.length;d++){
		var f=a[d];
		while(f.charAt(0)==" "){
			f=f.substring(1,f.length)
		}
		if(f.indexOf(e)==0){
			return f.substring(e.length,f.length)
		}
	}
	return null
}


function search(h){
	var p="http://search.jd.com/Search?keyword={keyword}&enc={enc}{additional}{area}";
	var b=search.additinal||"";
	var o=document.getElementById(h);
	var g=o.value;
	g=g.replace(/^\s*(.*?)\s*$/,"$1");
	if(g.length>100){
		g=g.substring(0,100)
	}
	if(""==g){
		window.location.href=window.location.href;
		return
	}
	var i=0;
	if("undefined"!=typeof(window.pageConfig)&&"undefined"!=typeof(window.pageConfig.searchType)){
		i=window.pageConfig.searchType
	}
	var n="&cid{level}={cid}";
	var s=("string"==typeof(search.cid)?search.cid:"");
	var f=("string"==typeof(search.cLevel)?search.cLevel:"");
	var j=("string"==typeof(search.ev_val)?search.ev_val:"");
	var l=false;
	switch(i){
		case 0:l=true;break;
		case 1:l=true;f="-1";b+="&book=y";break;
		case 2:f="-1";b+="&mvd=music";break;
		case 3:f="-1";b+="&mvd=movie";break;
		case 4:f="-1";b+="&mvd=education";break;
		case 5:var k="&other_filters=%3Bcid1%2CL{cid1}M{cid1}[cid2]";
		switch(f){
			case"51":n=k.replace(/\[cid2]/,"");n=n.replace(/\{cid1}/g,"5272");break;case"52":n=k.replace(/\{cid1}/g,"5272");n=n.replace(/\[cid2]/,"%3Bcid2%2CL{cid}M{cid}");break;case"61":n=k.replace(/\[cid2]/,"");n=n.replace(/\{cid1}/g,"5273");break;case"62":n=k.replace(/\{cid1}/g,"5273");n=n.replace(/\[cid2]/,"%3Bcid2%2CL{cid}M{cid}");break;case"71":n=k.replace(/\[cid2]/,"");n=n.replace(/\{cid1}/g,"5274");break;case"72":n=k.replace(/\{cid1}/g,"5274");n=n.replace(/\[cid2]/,"%3Bcid2%2CL{cid}M{cid}");break;case"81":n=k.replace(/\[cid2]/,"");n=n.replace(/\{cid1}/g,"5275");break;case"82":n=k.replace(/\{cid1}/g,"5275");n=n.replace(/\[cid2]/,"%3Bcid2%2CL{cid}M{cid}");break;default:break}p="http://search.e.jd.com/searchDigitalBook?ajaxSearch=0&enc=utf-8&key={keyword}&page=1{additional}";break;case 6:f="-1";p="http://music."+pageConfig.FN_getDomain()+"/8_0_desc_0_0_1_15.html?key={keyword}";break;default:break}if("string"==typeof(s)&&""!=s&&"string"==typeof(f)){var m=/^(?:[1-8])?([1-3])$/;if("-1"==f){f=""}else{if(m.test(f)){f=RegExp.$1}else{f=""}}var d=n.replace(/\{level}/,f);d=d.replace(/\{cid}/g,s);b+=d}if("string"==typeof(j)&&""!=j){b+="&ev="+j}var r="";if(l){var u=CookieUtil.getCookie("ipLoc-djd");if(null!=u){var q=u.split("-");if(q.length>0){var t=q[0];r="&area="+t}}}g=encodeURIComponent(g);sUrl=p.replace(/\{keyword}/,g);sUrl=sUrl.replace(/\{enc}/,"utf-8");sUrl=sUrl.replace(/\{additional}/,b);sUrl=sUrl.replace(/\{area}/,r);if("undefined"==typeof(search.isSubmitted)||false==search.isSubmitted){setTimeout(function(){window.location.href=sUrl},10);search.isSubmitted=true}}document.domain=pageConfig.FN_getDomain();


// http://misc.360buyimg.com/lib/js/e/jquery-1.2.6.pack.js
eval(function(p,a,c,k,e,r){e=function(c){return(c<a?'':e(parseInt(c/a)))+((c=c%a)>35?String.fromCharCode(c+29):c.toString(36))};if(!''.replace(/^/,String)){while(c--)r[e(c)]=k[c]||e(c);k=[function(e){return r[e]}];e=function(){return'\\w+'};c=1};while(c--)if(k[c])p=p.replace(new RegExp('\\b'+e(c)+'\\b','g'),k[c]);return p}('(H(){J w=1b.4M,3m$=1b.$;J D=1b.4M=1b.$=H(a,b){I 2B D.17.5j(a,b)};J u=/^[^<]*(<(.|\\s)+>)[^>]*$|^#(\\w+)$/,62=/^.[^:#\\[\\.]*$/,12;D.17=D.44={5j:H(d,b){d=d||S;G(d.16){7[0]=d;7.K=1;I 7}G(1j d=="23"){J c=u.2D(d);G(c&&(c[1]||!b)){G(c[1])d=D.4h([c[1]],b);N{J a=S.61(c[3]);G(a){G(a.2v!=c[3])I D().2q(d);I D(a)}d=[]}}N I D(b).2q(d)}N G(D.1D(d))I D(S)[D.17.27?"27":"43"](d);I 7.6Y(D.2d(d))},5w:"1.2.6",8G:H(){I 7.K},K:0,3p:H(a){I a==12?D.2d(7):7[a]},2I:H(b){J a=D(b);a.5n=7;I a},6Y:H(a){7.K=0;2p.44.1p.1w(7,a);I 7},P:H(a,b){I D.P(7,a,b)},5i:H(b){J a=-1;I D.2L(b&&b.5w?b[0]:b,7)},1K:H(c,a,b){J d=c;G(c.1q==56)G(a===12)I 7[0]&&D[b||"1K"](7[0],c);N{d={};d[c]=a}I 7.P(H(i){R(c 1n d)D.1K(b?7.V:7,c,D.1i(7,d[c],b,i,c))})},1g:H(b,a){G((b==\'2h\'||b==\'1Z\')&&3d(a)<0)a=12;I 7.1K(b,a,"2a")},1r:H(b){G(1j b!="49"&&b!=U)I 7.4E().3v((7[0]&&7[0].2z||S).5F(b));J a="";D.P(b||7,H(){D.P(7.3t,H(){G(7.16!=8)a+=7.16!=1?7.76:D.17.1r([7])})});I a},5z:H(b){G(7[0])D(b,7[0].2z).5y().39(7[0]).2l(H(){J a=7;1B(a.1x)a=a.1x;I a}).3v(7);I 7},8Y:H(a){I 7.P(H(){D(7).6Q().5z(a)})},8R:H(a){I 7.P(H(){D(7).5z(a)})},3v:H(){I 7.3W(19,M,Q,H(a){G(7.16==1)7.3U(a)})},6F:H(){I 7.3W(19,M,M,H(a){G(7.16==1)7.39(a,7.1x)})},6E:H(){I 7.3W(19,Q,Q,H(a){7.1d.39(a,7)})},5q:H(){I 7.3W(19,Q,M,H(a){7.1d.39(a,7.2H)})},3l:H(){I 7.5n||D([])},2q:H(b){J c=D.2l(7,H(a){I D.2q(b,a)});I 7.2I(/[^+>] [^+>]/.11(b)||b.1h("..")>-1?D.4r(c):c)},5y:H(e){J f=7.2l(H(){G(D.14.1f&&!D.4n(7)){J a=7.6o(M),5h=S.3h("1v");5h.3U(a);I D.4h([5h.4H])[0]}N I 7.6o(M)});J d=f.2q("*").5c().P(H(){G(7[E]!=12)7[E]=U});G(e===M)7.2q("*").5c().P(H(i){G(7.16==3)I;J c=D.L(7,"3w");R(J a 1n c)R(J b 1n c[a])D.W.1e(d[i],a,c[a][b],c[a][b].L)});I f},1E:H(b){I 7.2I(D.1D(b)&&D.3C(7,H(a,i){I b.1k(a,i)})||D.3g(b,7))},4Y:H(b){G(b.1q==56)G(62.11(b))I 7.2I(D.3g(b,7,M));N b=D.3g(b,7);J a=b.K&&b[b.K-1]!==12&&!b.16;I 7.1E(H(){I a?D.2L(7,b)<0:7!=b})},1e:H(a){I 7.2I(D.4r(D.2R(7.3p(),1j a==\'23\'?D(a):D.2d(a))))},3F:H(a){I!!a&&D.3g(a,7).K>0},7T:H(a){I 7.3F("."+a)},6e:H(b){G(b==12){G(7.K){J c=7[0];G(D.Y(c,"2A")){J e=c.64,63=[],15=c.15,2V=c.O=="2A-2V";G(e<0)I U;R(J i=2V?e:0,2f=2V?e+1:15.K;i<2f;i++){J d=15[i];G(d.2W){b=D.14.1f&&!d.at.2x.an?d.1r:d.2x;G(2V)I b;63.1p(b)}}I 63}N I(7[0].2x||"").1o(/\\r/g,"")}I 12}G(b.1q==4L)b+=\'\';I 7.P(H(){G(7.16!=1)I;G(b.1q==2p&&/5O|5L/.11(7.O))7.4J=(D.2L(7.2x,b)>=0||D.2L(7.34,b)>=0);N G(D.Y(7,"2A")){J a=D.2d(b);D("9R",7).P(H(){7.2W=(D.2L(7.2x,a)>=0||D.2L(7.1r,a)>=0)});G(!a.K)7.64=-1}N 7.2x=b})},2K:H(a){I a==12?(7[0]?7[0].4H:U):7.4E().3v(a)},7b:H(a){I 7.5q(a).21()},79:H(i){I 7.3s(i,i+1)},3s:H(){I 7.2I(2p.44.3s.1w(7,19))},2l:H(b){I 7.2I(D.2l(7,H(a,i){I b.1k(a,i,a)}))},5c:H(){I 7.1e(7.5n)},L:H(d,b){J a=d.1R(".");a[1]=a[1]?"."+a[1]:"";G(b===12){J c=7.5C("9z"+a[1]+"!",[a[0]]);G(c===12&&7.K)c=D.L(7[0],d);I c===12&&a[1]?7.L(a[0]):c}N I 7.1P("9u"+a[1]+"!",[a[0],b]).P(H(){D.L(7,d,b)})},3b:H(a){I 7.P(H(){D.3b(7,a)})},3W:H(g,f,h,d){J e=7.K>1,3x;I 7.P(H(){G(!3x){3x=D.4h(g,7.2z);G(h)3x.9o()}J b=7;G(f&&D.Y(7,"1T")&&D.Y(3x[0],"4F"))b=7.3H("22")[0]||7.3U(7.2z.3h("22"));J c=D([]);D.P(3x,H(){J a=e?D(7).5y(M)[0]:7;G(D.Y(a,"1m"))c=c.1e(a);N{G(a.16==1)c=c.1e(D("1m",a).21());d.1k(b,a)}});c.P(6T)})}};D.17.5j.44=D.17;H 6T(i,a){G(a.4d)D.3Y({1a:a.4d,31:Q,1O:"1m"});N D.5u(a.1r||a.6O||a.4H||"");G(a.1d)a.1d.37(a)}H 1z(){I+2B 8J}D.1l=D.17.1l=H(){J b=19[0]||{},i=1,K=19.K,4x=Q,15;G(b.1q==8I){4x=b;b=19[1]||{};i=2}G(1j b!="49"&&1j b!="H")b={};G(K==i){b=7;--i}R(;i<K;i++)G((15=19[i])!=U)R(J c 1n 15){J a=b[c],2w=15[c];G(b===2w)6M;G(4x&&2w&&1j 2w=="49"&&!2w.16)b[c]=D.1l(4x,a||(2w.K!=U?[]:{}),2w);N G(2w!==12)b[c]=2w}I b};J E="4M"+1z(),6K=0,5r={},6G=/z-?5i|8B-?8A|1y|6B|8v-?1Z/i,3P=S.3P||{};D.1l({8u:H(a){1b.$=3m$;G(a)1b.4M=w;I D},1D:H(a){I!!a&&1j a!="23"&&!a.Y&&a.1q!=2p&&/^[\\s[]?H/.11(a+"")},4n:H(a){I a.1C&&!a.1c||a.2j&&a.2z&&!a.2z.1c},5u:H(a){a=D.3k(a);G(a){J b=S.3H("6w")[0]||S.1C,1m=S.3h("1m");1m.O="1r/4t";G(D.14.1f)1m.1r=a;N 1m.3U(S.5F(a));b.39(1m,b.1x);b.37(1m)}},Y:H(b,a){I b.Y&&b.Y.2r()==a.2r()},1Y:{},L:H(c,d,b){c=c==1b?5r:c;J a=c[E];G(!a)a=c[E]=++6K;G(d&&!D.1Y[a])D.1Y[a]={};G(b!==12)D.1Y[a][d]=b;I d?D.1Y[a][d]:a},3b:H(c,b){c=c==1b?5r:c;J a=c[E];G(b){G(D.1Y[a]){2U D.1Y[a][b];b="";R(b 1n D.1Y[a])1X;G(!b)D.3b(c)}}N{1U{2U c[E]}1V(e){G(c.5l)c.5l(E)}2U D.1Y[a]}},P:H(d,a,c){J e,i=0,K=d.K;G(c){G(K==12){R(e 1n d)G(a.1w(d[e],c)===Q)1X}N R(;i<K;)G(a.1w(d[i++],c)===Q)1X}N{G(K==12){R(e 1n d)G(a.1k(d[e],e,d[e])===Q)1X}N R(J b=d[0];i<K&&a.1k(b,i,b)!==Q;b=d[++i]){}}I d},1i:H(b,a,c,i,d){G(D.1D(a))a=a.1k(b,i);I a&&a.1q==4L&&c=="2a"&&!6G.11(d)?a+"2X":a},1F:{1e:H(c,b){D.P((b||"").1R(/\\s+/),H(i,a){G(c.16==1&&!D.1F.3T(c.1F,a))c.1F+=(c.1F?" ":"")+a})},21:H(c,b){G(c.16==1)c.1F=b!=12?D.3C(c.1F.1R(/\\s+/),H(a){I!D.1F.3T(b,a)}).6s(" "):""},3T:H(b,a){I D.2L(a,(b.1F||b).6r().1R(/\\s+/))>-1}},6q:H(b,c,a){J e={};R(J d 1n c){e[d]=b.V[d];b.V[d]=c[d]}a.1k(b);R(J d 1n c)b.V[d]=e[d]},1g:H(d,e,c){G(e=="2h"||e=="1Z"){J b,3X={30:"5x",5g:"1G",18:"3I"},35=e=="2h"?["5e","6k"]:["5G","6i"];H 5b(){b=e=="2h"?d.8f:d.8c;J a=0,2C=0;D.P(35,H(){a+=3d(D.2a(d,"57"+7,M))||0;2C+=3d(D.2a(d,"2C"+7+"4b",M))||0});b-=29.83(a+2C)}G(D(d).3F(":4j"))5b();N D.6q(d,3X,5b);I 29.2f(0,b)}I D.2a(d,e,c)},2a:H(f,l,k){J e,V=f.V;H 3E(b){G(!D.14.2k)I Q;J a=3P.54(b,U);I!a||a.52("3E")==""}G(l=="1y"&&D.14.1f){e=D.1K(V,"1y");I e==""?"1":e}G(D.14.2G&&l=="18"){J d=V.50;V.50="0 7Y 7W";V.50=d}G(l.1I(/4i/i))l=y;G(!k&&V&&V[l])e=V[l];N G(3P.54){G(l.1I(/4i/i))l="4i";l=l.1o(/([A-Z])/g,"-$1").3y();J c=3P.54(f,U);G(c&&!3E(f))e=c.52(l);N{J g=[],2E=[],a=f,i=0;R(;a&&3E(a);a=a.1d)2E.6h(a);R(;i<2E.K;i++)G(3E(2E[i])){g[i]=2E[i].V.18;2E[i].V.18="3I"}e=l=="18"&&g[2E.K-1]!=U?"2F":(c&&c.52(l))||"";R(i=0;i<g.K;i++)G(g[i]!=U)2E[i].V.18=g[i]}G(l=="1y"&&e=="")e="1"}N G(f.4g){J h=l.1o(/\\-(\\w)/g,H(a,b){I b.2r()});e=f.4g[l]||f.4g[h];G(!/^\\d+(2X)?$/i.11(e)&&/^\\d/.11(e)){J j=V.1A,66=f.65.1A;f.65.1A=f.4g.1A;V.1A=e||0;e=V.aM+"2X";V.1A=j;f.65.1A=66}}I e},4h:H(l,h){J k=[];h=h||S;G(1j h.3h==\'12\')h=h.2z||h[0]&&h[0].2z||S;D.P(l,H(i,d){G(!d)I;G(d.1q==4L)d+=\'\';G(1j d=="23"){d=d.1o(/(<(\\w+)[^>]*?)\\/>/g,H(b,a,c){I c.1I(/^(aK|4f|7E|aG|4T|7A|aB|3n|az|ay|av)$/i)?b:a+"></"+c+">"});J f=D.3k(d).3y(),1v=h.3h("1v");J e=!f.1h("<au")&&[1,"<2A 7w=\'7w\'>","</2A>"]||!f.1h("<ar")&&[1,"<7v>","</7v>"]||f.1I(/^<(aq|22|am|ak|ai)/)&&[1,"<1T>","</1T>"]||!f.1h("<4F")&&[2,"<1T><22>","</22></1T>"]||(!f.1h("<af")||!f.1h("<ad"))&&[3,"<1T><22><4F>","</4F></22></1T>"]||!f.1h("<7E")&&[2,"<1T><22></22><7q>","</7q></1T>"]||D.14.1f&&[1,"1v<1v>","</1v>"]||[0,"",""];1v.4H=e[1]+d+e[2];1B(e[0]--)1v=1v.5T;G(D.14.1f){J g=!f.1h("<1T")&&f.1h("<22")<0?1v.1x&&1v.1x.3t:e[1]=="<1T>"&&f.1h("<22")<0?1v.3t:[];R(J j=g.K-1;j>=0;--j)G(D.Y(g[j],"22")&&!g[j].3t.K)g[j].1d.37(g[j]);G(/^\\s/.11(d))1v.39(h.5F(d.1I(/^\\s*/)[0]),1v.1x)}d=D.2d(1v.3t)}G(d.K===0&&(!D.Y(d,"3V")&&!D.Y(d,"2A")))I;G(d[0]==12||D.Y(d,"3V")||d.15)k.1p(d);N k=D.2R(k,d)});I k},1K:H(d,f,c){G(!d||d.16==3||d.16==8)I 12;J e=!D.4n(d),40=c!==12,1f=D.14.1f;f=e&&D.3X[f]||f;G(d.2j){J g=/5Q|4d|V/.11(f);G(f=="2W"&&D.14.2k)d.1d.64;G(f 1n d&&e&&!g){G(40){G(f=="O"&&D.Y(d,"4T")&&d.1d)7p"O a3 a1\'t 9V 9U";d[f]=c}G(D.Y(d,"3V")&&d.7i(f))I d.7i(f).76;I d[f]}G(1f&&e&&f=="V")I D.1K(d.V,"9T",c);G(40)d.9Q(f,""+c);J h=1f&&e&&g?d.4G(f,2):d.4G(f);I h===U?12:h}G(1f&&f=="1y"){G(40){d.6B=1;d.1E=(d.1E||"").1o(/7f\\([^)]*\\)/,"")+(3r(c)+\'\'=="9L"?"":"7f(1y="+c*7a+")")}I d.1E&&d.1E.1h("1y=")>=0?(3d(d.1E.1I(/1y=([^)]*)/)[1])/7a)+\'\':""}f=f.1o(/-([a-z])/9H,H(a,b){I b.2r()});G(40)d[f]=c;I d[f]},3k:H(a){I(a||"").1o(/^\\s+|\\s+$/g,"")},2d:H(b){J a=[];G(b!=U){J i=b.K;G(i==U||b.1R||b.4I||b.1k)a[0]=b;N 1B(i)a[--i]=b[i]}I a},2L:H(b,a){R(J i=0,K=a.K;i<K;i++)G(a[i]===b)I i;I-1},2R:H(a,b){J i=0,T,2S=a.K;G(D.14.1f){1B(T=b[i++])G(T.16!=8)a[2S++]=T}N 1B(T=b[i++])a[2S++]=T;I a},4r:H(a){J c=[],2o={};1U{R(J i=0,K=a.K;i<K;i++){J b=D.L(a[i]);G(!2o[b]){2o[b]=M;c.1p(a[i])}}}1V(e){c=a}I c},3C:H(c,a,d){J b=[];R(J i=0,K=c.K;i<K;i++)G(!d!=!a(c[i],i))b.1p(c[i]);I b},2l:H(d,a){J c=[];R(J i=0,K=d.K;i<K;i++){J b=a(d[i],i);G(b!=U)c[c.K]=b}I c.7d.1w([],c)}});J v=9B.9A.3y();D.14={5B:(v.1I(/.+(?:9y|9x|9w|9v)[\\/: ]([\\d.]+)/)||[])[1],2k:/75/.11(v),2G:/2G/.11(v),1f:/1f/.11(v)&&!/2G/.11(v),42:/42/.11(v)&&!/(9s|75)/.11(v)};J y=D.14.1f?"7o":"72";D.1l({71:!D.14.1f||S.70=="6Z",3X:{"R":"9n","9k":"1F","4i":y,72:y,7o:y,9h:"9f",9e:"9d",9b:"99"}});D.P({6W:H(a){I a.1d},97:H(a){I D.4S(a,"1d")},95:H(a){I D.3a(a,2,"2H")},91:H(a){I D.3a(a,2,"4l")},8Z:H(a){I D.4S(a,"2H")},8X:H(a){I D.4S(a,"4l")},8W:H(a){I D.5v(a.1d.1x,a)},8V:H(a){I D.5v(a.1x)},6Q:H(a){I D.Y(a,"8U")?a.8T||a.8S.S:D.2d(a.3t)}},H(c,d){D.17[c]=H(b){J a=D.2l(7,d);G(b&&1j b=="23")a=D.3g(b,a);I 7.2I(D.4r(a))}});D.P({6P:"3v",8Q:"6F",39:"6E",8P:"5q",8O:"7b"},H(c,b){D.17[c]=H(){J a=19;I 7.P(H(){R(J i=0,K=a.K;i<K;i++)D(a[i])[b](7)})}});D.P({8N:H(a){D.1K(7,a,"");G(7.16==1)7.5l(a)},8M:H(a){D.1F.1e(7,a)},8L:H(a){D.1F.21(7,a)},8K:H(a){D.1F[D.1F.3T(7,a)?"21":"1e"](7,a)},21:H(a){G(!a||D.1E(a,[7]).r.K){D("*",7).1e(7).P(H(){D.W.21(7);D.3b(7)});G(7.1d)7.1d.37(7)}},4E:H(){D(">*",7).21();1B(7.1x)7.37(7.1x)}},H(a,b){D.17[a]=H(){I 7.P(b,19)}});D.P(["6N","4b"],H(i,c){J b=c.3y();D.17[b]=H(a){I 7[0]==1b?D.14.2G&&S.1c["5t"+c]||D.14.2k&&1b["5s"+c]||S.70=="6Z"&&S.1C["5t"+c]||S.1c["5t"+c]:7[0]==S?29.2f(29.2f(S.1c["4y"+c],S.1C["4y"+c]),29.2f(S.1c["2i"+c],S.1C["2i"+c])):a==12?(7.K?D.1g(7[0],b):U):7.1g(b,a.1q==56?a:a+"2X")}});H 25(a,b){I a[0]&&3r(D.2a(a[0],b,M),10)||0}J C=D.14.2k&&3r(D.14.5B)<8H?"(?:[\\\\w*3m-]|\\\\\\\\.)":"(?:[\\\\w\\8F-\\8E*3m-]|\\\\\\\\.)",6L=2B 4v("^>\\\\s*("+C+"+)"),6J=2B 4v("^("+C+"+)(#)("+C+"+)"),6I=2B 4v("^([#.]?)("+C+"*)");D.1l({6H:{"":H(a,i,m){I m[2]=="*"||D.Y(a,m[2])},"#":H(a,i,m){I a.4G("2v")==m[2]},":":{8D:H(a,i,m){I i<m[3]-0},8C:H(a,i,m){I i>m[3]-0},3a:H(a,i,m){I m[3]-0==i},79:H(a,i,m){I m[3]-0==i},3o:H(a,i){I i==0},3S:H(a,i,m,r){I i==r.K-1},6D:H(a,i){I i%2==0},6C:H(a,i){I i%2},"3o-4u":H(a){I a.1d.3H("*")[0]==a},"3S-4u":H(a){I D.3a(a.1d.5T,1,"4l")==a},"8z-4u":H(a){I!D.3a(a.1d.5T,2,"4l")},6W:H(a){I a.1x},4E:H(a){I!a.1x},8y:H(a,i,m){I(a.6O||a.8x||D(a).1r()||"").1h(m[3])>=0},4j:H(a){I"1G"!=a.O&&D.1g(a,"18")!="2F"&&D.1g(a,"5g")!="1G"},1G:H(a){I"1G"==a.O||D.1g(a,"18")=="2F"||D.1g(a,"5g")=="1G"},8w:H(a){I!a.3R},3R:H(a){I a.3R},4J:H(a){I a.4J},2W:H(a){I a.2W||D.1K(a,"2W")},1r:H(a){I"1r"==a.O},5O:H(a){I"5O"==a.O},5L:H(a){I"5L"==a.O},5p:H(a){I"5p"==a.O},3Q:H(a){I"3Q"==a.O},5o:H(a){I"5o"==a.O},6A:H(a){I"6A"==a.O},6z:H(a){I"6z"==a.O},2s:H(a){I"2s"==a.O||D.Y(a,"2s")},4T:H(a){I/4T|2A|6y|2s/i.11(a.Y)},3T:H(a,i,m){I D.2q(m[3],a).K},8t:H(a){I/h\\d/i.11(a.Y)},8s:H(a){I D.3C(D.3O,H(b){I a==b.T}).K}}},6x:[/^(\\[) *@?([\\w-]+) *([!*$^~=]*) *(\'?"?)(.*?)\\4 *\\]/,/^(:)([\\w-]+)\\("?\'?(.*?(\\(.*?\\))?[^(]*?)"?\'?\\)/,2B 4v("^([:.#]*)("+C+"+)")],3g:H(a,c,b){J d,1t=[];1B(a&&a!=d){d=a;J f=D.1E(a,c,b);a=f.t.1o(/^\\s*,\\s*/,"");1t=b?c=f.r:D.2R(1t,f.r)}I 1t},2q:H(t,o){G(1j t!="23")I[t];G(o&&o.16!=1&&o.16!=9)I[];o=o||S;J d=[o],2o=[],3S,Y;1B(t&&3S!=t){J r=[];3S=t;t=D.3k(t);J l=Q,3j=6L,m=3j.2D(t);G(m){Y=m[1].2r();R(J i=0;d[i];i++)R(J c=d[i].1x;c;c=c.2H)G(c.16==1&&(Y=="*"||c.Y.2r()==Y))r.1p(c);d=r;t=t.1o(3j,"");G(t.1h(" ")==0)6M;l=M}N{3j=/^([>+~])\\s*(\\w*)/i;G((m=3j.2D(t))!=U){r=[];J k={};Y=m[2].2r();m=m[1];R(J j=0,3i=d.K;j<3i;j++){J n=m=="~"||m=="+"?d[j].2H:d[j].1x;R(;n;n=n.2H)G(n.16==1){J g=D.L(n);G(m=="~"&&k[g])1X;G(!Y||n.Y.2r()==Y){G(m=="~")k[g]=M;r.1p(n)}G(m=="+")1X}}d=r;t=D.3k(t.1o(3j,""));l=M}}G(t&&!l){G(!t.1h(",")){G(o==d[0])d.4s();2o=D.2R(2o,d);r=d=[o];t=" "+t.6v(1,t.K)}N{J h=6J;J m=h.2D(t);G(m){m=[0,m[2],m[3],m[1]]}N{h=6I;m=h.2D(t)}m[2]=m[2].1o(/\\\\/g,"");J f=d[d.K-1];G(m[1]=="#"&&f&&f.61&&!D.4n(f)){J p=f.61(m[2]);G((D.14.1f||D.14.2G)&&p&&1j p.2v=="23"&&p.2v!=m[2])p=D(\'[@2v="\'+m[2]+\'"]\',f)[0];d=r=p&&(!m[3]||D.Y(p,m[3]))?[p]:[]}N{R(J i=0;d[i];i++){J a=m[1]=="#"&&m[3]?m[3]:m[1]!=""||m[0]==""?"*":m[2];G(a=="*"&&d[i].Y.3y()=="49")a="3n";r=D.2R(r,d[i].3H(a))}G(m[1]==".")r=D.5m(r,m[2]);G(m[1]=="#"){J e=[];R(J i=0;r[i];i++)G(r[i].4G("2v")==m[2]){e=[r[i]];1X}r=e}d=r}t=t.1o(h,"")}}G(t){J b=D.1E(t,r);d=r=b.r;t=D.3k(b.t)}}G(t)d=[];G(d&&o==d[0])d.4s();2o=D.2R(2o,d);I 2o},5m:H(r,m,a){m=" "+m+" ";J c=[];R(J i=0;r[i];i++){J b=(" "+r[i].1F+" ").1h(m)>=0;G(!a&&b||a&&!b)c.1p(r[i])}I c},1E:H(t,r,h){J d;1B(t&&t!=d){d=t;J p=D.6x,m;R(J i=0;p[i];i++){m=p[i].2D(t);G(m){t=t.8r(m[0].K);m[2]=m[2].1o(/\\\\/g,"");1X}}G(!m)1X;G(m[1]==":"&&m[2]=="4Y")r=62.11(m[3])?D.1E(m[3],r,M).r:D(r).4Y(m[3]);N G(m[1]==".")r=D.5m(r,m[2],h);N G(m[1]=="["){J g=[],O=m[3];R(J i=0,3i=r.K;i<3i;i++){J a=r[i],z=a[D.3X[m[2]]||m[2]];G(z==U||/5Q|4d|2W/.11(m[2]))z=D.1K(a,m[2])||\'\';G((O==""&&!!z||O=="="&&z==m[5]||O=="!="&&z!=m[5]||O=="^="&&z&&!z.1h(m[5])||O=="$="&&z.6v(z.K-m[5].K)==m[5]||(O=="*="||O=="~=")&&z.1h(m[5])>=0)^h)g.1p(a)}r=g}N G(m[1]==":"&&m[2]=="3a-4u"){J e={},g=[],11=/(-?)(\\d*)n((?:\\+|-)?\\d*)/.2D(m[3]=="6D"&&"2n"||m[3]=="6C"&&"2n+1"||!/\\D/.11(m[3])&&"8q+"+m[3]||m[3]),3o=(11[1]+(11[2]||1))-0,d=11[3]-0;R(J i=0,3i=r.K;i<3i;i++){J j=r[i],1d=j.1d,2v=D.L(1d);G(!e[2v]){J c=1;R(J n=1d.1x;n;n=n.2H)G(n.16==1)n.4q=c++;e[2v]=M}J b=Q;G(3o==0){G(j.4q==d)b=M}N G((j.4q-d)%3o==0&&(j.4q-d)/3o>=0)b=M;G(b^h)g.1p(j)}r=g}N{J f=D.6H[m[1]];G(1j f=="49")f=f[m[2]];G(1j f=="23")f=6u("Q||H(a,i){I "+f+";}");r=D.3C(r,H(a,i){I f(a,i,m,r)},h)}}I{r:r,t:t}},4S:H(b,c){J a=[],1t=b[c];1B(1t&&1t!=S){G(1t.16==1)a.1p(1t);1t=1t[c]}I a},3a:H(a,e,c,b){e=e||1;J d=0;R(;a;a=a[c])G(a.16==1&&++d==e)1X;I a},5v:H(n,a){J r=[];R(;n;n=n.2H){G(n.16==1&&n!=a)r.1p(n)}I r}});D.W={1e:H(f,i,g,e){G(f.16==3||f.16==8)I;G(D.14.1f&&f.4I)f=1b;G(!g.24)g.24=7.24++;G(e!=12){J h=g;g=7.3M(h,H(){I h.1w(7,19)});g.L=e}J j=D.L(f,"3w")||D.L(f,"3w",{}),1H=D.L(f,"1H")||D.L(f,"1H",H(){G(1j D!="12"&&!D.W.5k)I D.W.1H.1w(19.3L.T,19)});1H.T=f;D.P(i.1R(/\\s+/),H(c,b){J a=b.1R(".");b=a[0];g.O=a[1];J d=j[b];G(!d){d=j[b]={};G(!D.W.2t[b]||D.W.2t[b].4p.1k(f)===Q){G(f.3K)f.3K(b,1H,Q);N G(f.6t)f.6t("4o"+b,1H)}}d[g.24]=g;D.W.26[b]=M});f=U},24:1,26:{},21:H(e,h,f){G(e.16==3||e.16==8)I;J i=D.L(e,"3w"),1L,5i;G(i){G(h==12||(1j h=="23"&&h.8p(0)=="."))R(J g 1n i)7.21(e,g+(h||""));N{G(h.O){f=h.2y;h=h.O}D.P(h.1R(/\\s+/),H(b,a){J c=a.1R(".");a=c[0];G(i[a]){G(f)2U i[a][f.24];N R(f 1n i[a])G(!c[1]||i[a][f].O==c[1])2U i[a][f];R(1L 1n i[a])1X;G(!1L){G(!D.W.2t[a]||D.W.2t[a].4A.1k(e)===Q){G(e.6p)e.6p(a,D.L(e,"1H"),Q);N G(e.6n)e.6n("4o"+a,D.L(e,"1H"))}1L=U;2U i[a]}}})}R(1L 1n i)1X;G(!1L){J d=D.L(e,"1H");G(d)d.T=U;D.3b(e,"3w");D.3b(e,"1H")}}},1P:H(h,c,f,g,i){c=D.2d(c);G(h.1h("!")>=0){h=h.3s(0,-1);J a=M}G(!f){G(7.26[h])D("*").1e([1b,S]).1P(h,c)}N{G(f.16==3||f.16==8)I 12;J b,1L,17=D.1D(f[h]||U),W=!c[0]||!c[0].32;G(W){c.6h({O:h,2J:f,32:H(){},3J:H(){},4C:1z()});c[0][E]=M}c[0].O=h;G(a)c[0].6m=M;J d=D.L(f,"1H");G(d)b=d.1w(f,c);G((!17||(D.Y(f,\'a\')&&h=="4V"))&&f["4o"+h]&&f["4o"+h].1w(f,c)===Q)b=Q;G(W)c.4s();G(i&&D.1D(i)){1L=i.1w(f,b==U?c:c.7d(b));G(1L!==12)b=1L}G(17&&g!==Q&&b!==Q&&!(D.Y(f,\'a\')&&h=="4V")){7.5k=M;1U{f[h]()}1V(e){}}7.5k=Q}I b},1H:H(b){J a,1L,38,5f,4m;b=19[0]=D.W.6l(b||1b.W);38=b.O.1R(".");b.O=38[0];38=38[1];5f=!38&&!b.6m;4m=(D.L(7,"3w")||{})[b.O];R(J j 1n 4m){J c=4m[j];G(5f||c.O==38){b.2y=c;b.L=c.L;1L=c.1w(7,19);G(a!==Q)a=1L;G(1L===Q){b.32();b.3J()}}}I a},6l:H(b){G(b[E]==M)I b;J d=b;b={8o:d};J c="8n 8m 8l 8k 2s 8j 47 5d 6j 5E 8i L 8h 8g 4K 2y 5a 59 8e 8b 58 6f 8a 88 4k 87 86 84 6d 2J 4C 6c O 82 81 35".1R(" ");R(J i=c.K;i;i--)b[c[i]]=d[c[i]];b[E]=M;b.32=H(){G(d.32)d.32();d.80=Q};b.3J=H(){G(d.3J)d.3J();d.7Z=M};b.4C=b.4C||1z();G(!b.2J)b.2J=b.6d||S;G(b.2J.16==3)b.2J=b.2J.1d;G(!b.4k&&b.4K)b.4k=b.4K==b.2J?b.6c:b.4K;G(b.58==U&&b.5d!=U){J a=S.1C,1c=S.1c;b.58=b.5d+(a&&a.2e||1c&&1c.2e||0)-(a.6b||0);b.6f=b.6j+(a&&a.2c||1c&&1c.2c||0)-(a.6a||0)}G(!b.35&&((b.47||b.47===0)?b.47:b.5a))b.35=b.47||b.5a;G(!b.59&&b.5E)b.59=b.5E;G(!b.35&&b.2s)b.35=(b.2s&1?1:(b.2s&2?3:(b.2s&4?2:0)));I b},3M:H(a,b){b.24=a.24=a.24||b.24||7.24++;I b},2t:{27:{4p:H(){55();I},4A:H(){I}},3D:{4p:H(){G(D.14.1f)I Q;D(7).2O("53",D.W.2t.3D.2y);I M},4A:H(){G(D.14.1f)I Q;D(7).4e("53",D.W.2t.3D.2y);I M},2y:H(a){G(F(a,7))I M;a.O="3D";I D.W.1H.1w(7,19)}},3N:{4p:H(){G(D.14.1f)I Q;D(7).2O("51",D.W.2t.3N.2y);I M},4A:H(){G(D.14.1f)I Q;D(7).4e("51",D.W.2t.3N.2y);I M},2y:H(a){G(F(a,7))I M;a.O="3N";I D.W.1H.1w(7,19)}}}};D.17.1l({2O:H(c,a,b){I c=="4X"?7.2V(c,a,b):7.P(H(){D.W.1e(7,c,b||a,b&&a)})},2V:H(d,b,c){J e=D.W.3M(c||b,H(a){D(7).4e(a,e);I(c||b).1w(7,19)});I 7.P(H(){D.W.1e(7,d,e,c&&b)})},4e:H(a,b){I 7.P(H(){D.W.21(7,a,b)})},1P:H(c,a,b){I 7.P(H(){D.W.1P(c,a,7,M,b)})},5C:H(c,a,b){I 7[0]&&D.W.1P(c,a,7[0],Q,b)},2m:H(b){J c=19,i=1;1B(i<c.K)D.W.3M(b,c[i++]);I 7.4V(D.W.3M(b,H(a){7.4Z=(7.4Z||0)%i;a.32();I c[7.4Z++].1w(7,19)||Q}))},7X:H(a,b){I 7.2O(\'3D\',a).2O(\'3N\',b)},27:H(a){55();G(D.2Q)a.1k(S,D);N D.3A.1p(H(){I a.1k(7,D)});I 7}});D.1l({2Q:Q,3A:[],27:H(){G(!D.2Q){D.2Q=M;G(D.3A){D.P(D.3A,H(){7.1k(S)});D.3A=U}D(S).5C("27")}}});J x=Q;H 55(){G(x)I;x=M;G(S.3K&&!D.14.2G)S.3K("69",D.27,Q);G(D.14.1f&&1b==1S)(H(){G(D.2Q)I;1U{S.1C.7V("1A")}1V(3e){3B(19.3L,0);I}D.27()})();G(D.14.2G)S.3K("69",H(){G(D.2Q)I;R(J i=0;i<S.4W.K;i++)G(S.4W[i].3R){3B(19.3L,0);I}D.27()},Q);G(D.14.2k){J a;(H(){G(D.2Q)I;G(S.3f!="68"&&S.3f!="1J"){3B(19.3L,0);I}G(a===12)a=D("V, 7A[7U=7S]").K;G(S.4W.K!=a){3B(19.3L,0);I}D.27()})()}D.W.1e(1b,"43",D.27)}D.P(("7R,7Q,43,85,4y,4X,4V,7P,"+"7O,7N,89,53,51,7M,2A,"+"5o,7L,7K,8d,3e").1R(","),H(i,b){D.17[b]=H(a){I a?7.2O(b,a):7.1P(b)}});J F=H(a,c){J b=a.4k;1B(b&&b!=c)1U{b=b.1d}1V(3e){b=c}I b==c};D(1b).2O("4X",H(){D("*").1e(S).4e()});D.17.1l({67:D.17.43,43:H(g,d,c){G(1j g!=\'23\')I 7.67(g);J e=g.1h(" ");G(e>=0){J i=g.3s(e,g.K);g=g.3s(0,e)}c=c||H(){};J f="2P";G(d)G(D.1D(d)){c=d;d=U}N{d=D.3n(d);f="6g"}J h=7;D.3Y({1a:g,O:f,1O:"2K",L:d,1J:H(a,b){G(b=="1W"||b=="7J")h.2K(i?D("<1v/>").3v(a.4U.1o(/<1m(.|\\s)*?\\/1m>/g,"")).2q(i):a.4U);h.P(c,[a.4U,b,a])}});I 7},aL:H(){I D.3n(7.7I())},7I:H(){I 7.2l(H(){I D.Y(7,"3V")?D.2d(7.aH):7}).1E(H(){I 7.34&&!7.3R&&(7.4J||/2A|6y/i.11(7.Y)||/1r|1G|3Q/i.11(7.O))}).2l(H(i,c){J b=D(7).6e();I b==U?U:b.1q==2p?D.2l(b,H(a,i){I{34:c.34,2x:a}}):{34:c.34,2x:b}}).3p()}});D.P("7H,7G,7F,7D,7C,7B".1R(","),H(i,o){D.17[o]=H(f){I 7.2O(o,f)}});J B=1z();D.1l({3p:H(d,b,a,c){G(D.1D(b)){a=b;b=U}I D.3Y({O:"2P",1a:d,L:b,1W:a,1O:c})},aE:H(b,a){I D.3p(b,U,a,"1m")},aD:H(c,b,a){I D.3p(c,b,a,"3z")},aC:H(d,b,a,c){G(D.1D(b)){a=b;b={}}I D.3Y({O:"6g",1a:d,L:b,1W:a,1O:c})},aA:H(a){D.1l(D.60,a)},60:{1a:5Z.5Q,26:M,O:"2P",2T:0,7z:"4R/x-ax-3V-aw",7x:M,31:M,L:U,5Y:U,3Q:U,4Q:{2N:"4R/2N, 1r/2N",2K:"1r/2K",1m:"1r/4t, 4R/4t",3z:"4R/3z, 1r/4t",1r:"1r/as",4w:"*/*"}},4z:{},3Y:H(s){s=D.1l(M,s,D.1l(M,{},D.60,s));J g,2Z=/=\\?(&|$)/g,1u,L,O=s.O.2r();G(s.L&&s.7x&&1j s.L!="23")s.L=D.3n(s.L);G(s.1O=="4P"){G(O=="2P"){G(!s.1a.1I(2Z))s.1a+=(s.1a.1I(/\\?/)?"&":"?")+(s.4P||"7u")+"=?"}N G(!s.L||!s.L.1I(2Z))s.L=(s.L?s.L+"&":"")+(s.4P||"7u")+"=?";s.1O="3z"}G(s.1O=="3z"&&(s.L&&s.L.1I(2Z)||s.1a.1I(2Z))){g="4P"+B++;G(s.L)s.L=(s.L+"").1o(2Z,"="+g+"$1");s.1a=s.1a.1o(2Z,"="+g+"$1");s.1O="1m";1b[g]=H(a){L=a;1W();1J();1b[g]=12;1U{2U 1b[g]}1V(e){}G(i)i.37(h)}}G(s.1O=="1m"&&s.1Y==U)s.1Y=Q;G(s.1Y===Q&&O=="2P"){J j=1z();J k=s.1a.1o(/(\\?|&)3m=.*?(&|$)/,"$ap="+j+"$2");s.1a=k+((k==s.1a)?(s.1a.1I(/\\?/)?"&":"?")+"3m="+j:"")}G(s.L&&O=="2P"){s.1a+=(s.1a.1I(/\\?/)?"&":"?")+s.L;s.L=U}G(s.26&&!D.4O++)D.W.1P("7H");J n=/^(?:\\w+:)?\\/\\/([^\\/?#]+)/;G(s.1O=="1m"&&O=="2P"&&n.11(s.1a)&&n.2D(s.1a)[1]!=5Z.al){J i=S.3H("6w")[0];J h=S.3h("1m");h.4d=s.1a;G(s.7t)h.aj=s.7t;G(!g){J l=Q;h.ah=h.ag=H(){G(!l&&(!7.3f||7.3f=="68"||7.3f=="1J")){l=M;1W();1J();i.37(h)}}}i.3U(h);I 12}J m=Q;J c=1b.7s?2B 7s("ae.ac"):2B 7r();G(s.5Y)c.6R(O,s.1a,s.31,s.5Y,s.3Q);N c.6R(O,s.1a,s.31);1U{G(s.L)c.4B("ab-aa",s.7z);G(s.5S)c.4B("a9-5R-a8",D.4z[s.1a]||"a7, a6 a5 a4 5N:5N:5N a2");c.4B("X-9Z-9Y","7r");c.4B("9W",s.1O&&s.4Q[s.1O]?s.4Q[s.1O]+", */*":s.4Q.4w)}1V(e){}G(s.7m&&s.7m(c,s)===Q){s.26&&D.4O--;c.7l();I Q}G(s.26)D.W.1P("7B",[c,s]);J d=H(a){G(!m&&c&&(c.3f==4||a=="2T")){m=M;G(f){7k(f);f=U}1u=a=="2T"&&"2T"||!D.7j(c)&&"3e"||s.5S&&D.7h(c,s.1a)&&"7J"||"1W";G(1u=="1W"){1U{L=D.6X(c,s.1O,s.9S)}1V(e){1u="5J"}}G(1u=="1W"){J b;1U{b=c.5I("7g-5R")}1V(e){}G(s.5S&&b)D.4z[s.1a]=b;G(!g)1W()}N D.5H(s,c,1u);1J();G(s.31)c=U}};G(s.31){J f=4I(d,13);G(s.2T>0)3B(H(){G(c){c.7l();G(!m)d("2T")}},s.2T)}1U{c.9P(s.L)}1V(e){D.5H(s,c,U,e)}G(!s.31)d();H 1W(){G(s.1W)s.1W(L,1u);G(s.26)D.W.1P("7C",[c,s])}H 1J(){G(s.1J)s.1J(c,1u);G(s.26)D.W.1P("7F",[c,s]);G(s.26&&!--D.4O)D.W.1P("7G")}I c},5H:H(s,a,b,e){G(s.3e)s.3e(a,b,e);G(s.26)D.W.1P("7D",[a,s,e])},4O:0,7j:H(a){1U{I!a.1u&&5Z.9O=="5p:"||(a.1u>=7e&&a.1u<9N)||a.1u==7c||a.1u==9K||D.14.2k&&a.1u==12}1V(e){}I Q},7h:H(a,c){1U{J b=a.5I("7g-5R");I a.1u==7c||b==D.4z[c]||D.14.2k&&a.1u==12}1V(e){}I Q},6X:H(a,c,b){J d=a.5I("9J-O"),2N=c=="2N"||!c&&d&&d.1h("2N")>=0,L=2N?a.9I:a.4U;G(2N&&L.1C.2j=="5J")7p"5J";G(b)L=b(L,c);G(c=="1m")D.5u(L);G(c=="3z")L=6u("("+L+")");I L},3n:H(a){J s=[];G(a.1q==2p||a.5w)D.P(a,H(){s.1p(3u(7.34)+"="+3u(7.2x))});N R(J j 1n a)G(a[j]&&a[j].1q==2p)D.P(a[j],H(){s.1p(3u(j)+"="+3u(7))});N s.1p(3u(j)+"="+3u(D.1D(a[j])?a[j]():a[j]));I s.6s("&").1o(/%20/g,"+")}});D.17.1l({1N:H(c,b){I c?7.2g({1Z:"1N",2h:"1N",1y:"1N"},c,b):7.1E(":1G").P(H(){7.V.18=7.5D||"";G(D.1g(7,"18")=="2F"){J a=D("<"+7.2j+" />").6P("1c");7.V.18=a.1g("18");G(7.V.18=="2F")7.V.18="3I";a.21()}}).3l()},1M:H(b,a){I b?7.2g({1Z:"1M",2h:"1M",1y:"1M"},b,a):7.1E(":4j").P(H(){7.5D=7.5D||D.1g(7,"18");7.V.18="2F"}).3l()},78:D.17.2m,2m:H(a,b){I D.1D(a)&&D.1D(b)?7.78.1w(7,19):a?7.2g({1Z:"2m",2h:"2m",1y:"2m"},a,b):7.P(H(){D(7)[D(7).3F(":1G")?"1N":"1M"]()})},9G:H(b,a){I 7.2g({1Z:"1N"},b,a)},9F:H(b,a){I 7.2g({1Z:"1M"},b,a)},9E:H(b,a){I 7.2g({1Z:"2m"},b,a)},9D:H(b,a){I 7.2g({1y:"1N"},b,a)},9M:H(b,a){I 7.2g({1y:"1M"},b,a)},9C:H(c,a,b){I 7.2g({1y:a},c,b)},2g:H(k,j,i,g){J h=D.77(j,i,g);I 7[h.36===Q?"P":"36"](H(){G(7.16!=1)I Q;J f=D.1l({},h),p,1G=D(7).3F(":1G"),46=7;R(p 1n k){G(k[p]=="1M"&&1G||k[p]=="1N"&&!1G)I f.1J.1k(7);G(p=="1Z"||p=="2h"){f.18=D.1g(7,"18");f.33=7.V.33}}G(f.33!=U)7.V.33="1G";f.45=D.1l({},k);D.P(k,H(c,a){J e=2B D.28(46,f,c);G(/2m|1N|1M/.11(a))e[a=="2m"?1G?"1N":"1M":a](k);N{J b=a.6r().1I(/^([+-]=)?([\\d+-.]+)(.*)$/),2b=e.1t(M)||0;G(b){J d=3d(b[2]),2M=b[3]||"2X";G(2M!="2X"){46.V[c]=(d||1)+2M;2b=((d||1)/e.1t(M))*2b;46.V[c]=2b+2M}G(b[1])d=((b[1]=="-="?-1:1)*d)+2b;e.3G(2b,d,2M)}N e.3G(2b,a,"")}});I M})},36:H(a,b){G(D.1D(a)||(a&&a.1q==2p)){b=a;a="28"}G(!a||(1j a=="23"&&!b))I A(7[0],a);I 7.P(H(){G(b.1q==2p)A(7,a,b);N{A(7,a).1p(b);G(A(7,a).K==1)b.1k(7)}})},9X:H(b,c){J a=D.3O;G(b)7.36([]);7.P(H(){R(J i=a.K-1;i>=0;i--)G(a[i].T==7){G(c)a[i](M);a.7n(i,1)}});G(!c)7.5A();I 7}});J A=H(b,c,a){G(b){c=c||"28";J q=D.L(b,c+"36");G(!q||a)q=D.L(b,c+"36",D.2d(a))}I q};D.17.5A=H(a){a=a||"28";I 7.P(H(){J q=A(7,a);q.4s();G(q.K)q[0].1k(7)})};D.1l({77:H(b,a,c){J d=b&&b.1q==a0?b:{1J:c||!c&&a||D.1D(b)&&b,2u:b,41:c&&a||a&&a.1q!=9t&&a};d.2u=(d.2u&&d.2u.1q==4L?d.2u:D.28.5K[d.2u])||D.28.5K.74;d.5M=d.1J;d.1J=H(){G(d.36!==Q)D(7).5A();G(D.1D(d.5M))d.5M.1k(7)};I d},41:{73:H(p,n,b,a){I b+a*p},5P:H(p,n,b,a){I((-29.9r(p*29.9q)/2)+0.5)*a+b}},3O:[],48:U,28:H(b,c,a){7.15=c;7.T=b;7.1i=a;G(!c.3Z)c.3Z={}}});D.28.44={4D:H(){G(7.15.2Y)7.15.2Y.1k(7.T,7.1z,7);(D.28.2Y[7.1i]||D.28.2Y.4w)(7);G(7.1i=="1Z"||7.1i=="2h")7.T.V.18="3I"},1t:H(a){G(7.T[7.1i]!=U&&7.T.V[7.1i]==U)I 7.T[7.1i];J r=3d(D.1g(7.T,7.1i,a));I r&&r>-9p?r:3d(D.2a(7.T,7.1i))||0},3G:H(c,b,d){7.5V=1z();7.2b=c;7.3l=b;7.2M=d||7.2M||"2X";7.1z=7.2b;7.2S=7.4N=0;7.4D();J e=7;H t(a){I e.2Y(a)}t.T=7.T;D.3O.1p(t);G(D.48==U){D.48=4I(H(){J a=D.3O;R(J i=0;i<a.K;i++)G(!a[i]())a.7n(i--,1);G(!a.K){7k(D.48);D.48=U}},13)}},1N:H(){7.15.3Z[7.1i]=D.1K(7.T.V,7.1i);7.15.1N=M;7.3G(0,7.1t());G(7.1i=="2h"||7.1i=="1Z")7.T.V[7.1i]="9m";D(7.T).1N()},1M:H(){7.15.3Z[7.1i]=D.1K(7.T.V,7.1i);7.15.1M=M;7.3G(7.1t(),0)},2Y:H(a){J t=1z();G(a||t>7.15.2u+7.5V){7.1z=7.3l;7.2S=7.4N=1;7.4D();7.15.45[7.1i]=M;J b=M;R(J i 1n 7.15.45)G(7.15.45[i]!==M)b=Q;G(b){G(7.15.18!=U){7.T.V.33=7.15.33;7.T.V.18=7.15.18;G(D.1g(7.T,"18")=="2F")7.T.V.18="3I"}G(7.15.1M)7.T.V.18="2F";G(7.15.1M||7.15.1N)R(J p 1n 7.15.45)D.1K(7.T.V,p,7.15.3Z[p])}G(b)7.15.1J.1k(7.T);I Q}N{J n=t-7.5V;7.4N=n/7.15.2u;7.2S=D.41[7.15.41||(D.41.5P?"5P":"73")](7.4N,n,0,1,7.15.2u);7.1z=7.2b+((7.3l-7.2b)*7.2S);7.4D()}I M}};D.1l(D.28,{5K:{9l:9j,9i:7e,74:9g},2Y:{2e:H(a){a.T.2e=a.1z},2c:H(a){a.T.2c=a.1z},1y:H(a){D.1K(a.T.V,"1y",a.1z)},4w:H(a){a.T.V[a.1i]=a.1z+a.2M}}});D.17.2i=H(){J b=0,1S=0,T=7[0],3q;G(T)ao(D.14){J d=T.1d,4a=T,1s=T.1s,1Q=T.2z,5U=2k&&3r(5B)<9c&&!/9a/i.11(v),1g=D.2a,3c=1g(T,"30")=="3c";G(T.7y){J c=T.7y();1e(c.1A+29.2f(1Q.1C.2e,1Q.1c.2e),c.1S+29.2f(1Q.1C.2c,1Q.1c.2c));1e(-1Q.1C.6b,-1Q.1C.6a)}N{1e(T.5X,T.5W);1B(1s){1e(1s.5X,1s.5W);G(42&&!/^t(98|d|h)$/i.11(1s.2j)||2k&&!5U)2C(1s);G(!3c&&1g(1s,"30")=="3c")3c=M;4a=/^1c$/i.11(1s.2j)?4a:1s;1s=1s.1s}1B(d&&d.2j&&!/^1c|2K$/i.11(d.2j)){G(!/^96|1T.*$/i.11(1g(d,"18")))1e(-d.2e,-d.2c);G(42&&1g(d,"33")!="4j")2C(d);d=d.1d}G((5U&&(3c||1g(4a,"30")=="5x"))||(42&&1g(4a,"30")!="5x"))1e(-1Q.1c.5X,-1Q.1c.5W);G(3c)1e(29.2f(1Q.1C.2e,1Q.1c.2e),29.2f(1Q.1C.2c,1Q.1c.2c))}3q={1S:1S,1A:b}}H 2C(a){1e(D.2a(a,"6V",M),D.2a(a,"6U",M))}H 1e(l,t){b+=3r(l,10)||0;1S+=3r(t,10)||0}I 3q};D.17.1l({30:H(){J a=0,1S=0,3q;G(7[0]){J b=7.1s(),2i=7.2i(),4c=/^1c|2K$/i.11(b[0].2j)?{1S:0,1A:0}:b.2i();2i.1S-=25(7,\'94\');2i.1A-=25(7,\'aF\');4c.1S+=25(b,\'6U\');4c.1A+=25(b,\'6V\');3q={1S:2i.1S-4c.1S,1A:2i.1A-4c.1A}}I 3q},1s:H(){J a=7[0].1s;1B(a&&(!/^1c|2K$/i.11(a.2j)&&D.1g(a,\'30\')==\'93\'))a=a.1s;I D(a)}});D.P([\'5e\',\'5G\'],H(i,b){J c=\'4y\'+b;D.17[c]=H(a){G(!7[0])I;I a!=12?7.P(H(){7==1b||7==S?1b.92(!i?a:D(1b).2e(),i?a:D(1b).2c()):7[c]=a}):7[0]==1b||7[0]==S?46[i?\'aI\':\'aJ\']||D.71&&S.1C[c]||S.1c[c]:7[0][c]}});D.P(["6N","4b"],H(i,b){J c=i?"5e":"5G",4f=i?"6k":"6i";D.17["5s"+b]=H(){I 7[b.3y()]()+25(7,"57"+c)+25(7,"57"+4f)};D.17["90"+b]=H(a){I 7["5s"+b]()+25(7,"2C"+c+"4b")+25(7,"2C"+4f+"4b")+(a?25(7,"6S"+c)+25(7,"6S"+4f):0)}})})();',62,669,'|||||||this|||||||||||||||||||||||||||||||||||if|function|return|var|length|data|true|else|type|each|false|for|document|elem|null|style|event||nodeName|||test|undefined||browser|options|nodeType|fn|display|arguments|url|window|body|parentNode|add|msie|css|indexOf|prop|typeof|call|extend|script|in|replace|push|constructor|text|offsetParent|cur|status|div|apply|firstChild|opacity|now|left|while|documentElement|isFunction|filter|className|hidden|handle|match|complete|attr|ret|hide|show|dataType|trigger|doc|split|top|table|try|catch|success|break|cache|height||remove|tbody|string|guid|num|global|ready|fx|Math|curCSS|start|scrollTop|makeArray|scrollLeft|max|animate|width|offset|tagName|safari|map|toggle||done|Array|find|toUpperCase|button|special|duration|id|copy|value|handler|ownerDocument|select|new|border|exec|stack|none|opera|nextSibling|pushStack|target|html|inArray|unit|xml|bind|GET|isReady|merge|pos|timeout|delete|one|selected|px|step|jsre|position|async|preventDefault|overflow|name|which|queue|removeChild|namespace|insertBefore|nth|removeData|fixed|parseFloat|error|readyState|multiFilter|createElement|rl|re|trim|end|_|param|first|get|results|parseInt|slice|childNodes|encodeURIComponent|append|events|elems|toLowerCase|json|readyList|setTimeout|grep|mouseenter|color|is|custom|getElementsByTagName|block|stopPropagation|addEventListener|callee|proxy|mouseleave|timers|defaultView|password|disabled|last|has|appendChild|form|domManip|props|ajax|orig|set|easing|mozilla|load|prototype|curAnim|self|charCode|timerId|object|offsetChild|Width|parentOffset|src|unbind|br|currentStyle|clean|float|visible|relatedTarget|previousSibling|handlers|isXMLDoc|on|setup|nodeIndex|unique|shift|javascript|child|RegExp|_default|deep|scroll|lastModified|teardown|setRequestHeader|timeStamp|update|empty|tr|getAttribute|innerHTML|setInterval|checked|fromElement|Number|jQuery|state|active|jsonp|accepts|application|dir|input|responseText|click|styleSheets|unload|not|lastToggle|outline|mouseout|getPropertyValue|mouseover|getComputedStyle|bindReady|String|padding|pageX|metaKey|keyCode|getWH|andSelf|clientX|Left|all|visibility|container|index|init|triggered|removeAttribute|classFilter|prevObject|submit|file|after|windowData|inner|client|globalEval|sibling|jquery|absolute|clone|wrapAll|dequeue|version|triggerHandler|oldblock|ctrlKey|createTextNode|Top|handleError|getResponseHeader|parsererror|speeds|checkbox|old|00|radio|swing|href|Modified|ifModified|lastChild|safari2|startTime|offsetTop|offsetLeft|username|location|ajaxSettings|getElementById|isSimple|values|selectedIndex|runtimeStyle|rsLeft|_load|loaded|DOMContentLoaded|clientTop|clientLeft|toElement|srcElement|val|pageY|POST|unshift|Bottom|clientY|Right|fix|exclusive|detachEvent|cloneNode|removeEventListener|swap|toString|join|attachEvent|eval|substr|head|parse|textarea|reset|image|zoom|odd|even|before|prepend|exclude|expr|quickClass|quickID|uuid|quickChild|continue|Height|textContent|appendTo|contents|open|margin|evalScript|borderTopWidth|borderLeftWidth|parent|httpData|setArray|CSS1Compat|compatMode|boxModel|cssFloat|linear|def|webkit|nodeValue|speed|_toggle|eq|100|replaceWith|304|concat|200|alpha|Last|httpNotModified|getAttributeNode|httpSuccess|clearInterval|abort|beforeSend|splice|styleFloat|throw|colgroup|XMLHttpRequest|ActiveXObject|scriptCharset|callback|fieldset|multiple|processData|getBoundingClientRect|contentType|link|ajaxSend|ajaxSuccess|ajaxError|col|ajaxComplete|ajaxStop|ajaxStart|serializeArray|notmodified|keypress|keydown|change|mouseup|mousedown|dblclick|focus|blur|stylesheet|hasClass|rel|doScroll|black|hover|solid|cancelBubble|returnValue|wheelDelta|view|round|shiftKey|resize|screenY|screenX|relatedNode|mousemove|prevValue|originalTarget|offsetHeight|keyup|newValue|offsetWidth|eventPhase|detail|currentTarget|cancelable|bubbles|attrName|attrChange|altKey|originalEvent|charAt|0n|substring|animated|header|noConflict|line|enabled|innerText|contains|only|weight|font|gt|lt|uFFFF|u0128|size|417|Boolean|Date|toggleClass|removeClass|addClass|removeAttr|replaceAll|insertAfter|prependTo|wrap|contentWindow|contentDocument|iframe|children|siblings|prevAll|wrapInner|nextAll|outer|prev|scrollTo|static|marginTop|next|inline|parents|able|cellSpacing|adobeair|cellspacing|522|maxLength|maxlength|readOnly|400|readonly|fast|600|class|slow|1px|htmlFor|reverse|10000|PI|cos|compatible|Function|setData|ie|ra|it|rv|getData|userAgent|navigator|fadeTo|fadeIn|slideToggle|slideUp|slideDown|ig|responseXML|content|1223|NaN|fadeOut|300|protocol|send|setAttribute|option|dataFilter|cssText|changed|be|Accept|stop|With|Requested|Object|can|GMT|property|1970|Jan|01|Thu|Since|If|Type|Content|XMLHTTP|th|Microsoft|td|onreadystatechange|onload|cap|charset|colg|host|tfoot|specified|with|1_|thead|leg|plain|attributes|opt|embed|urlencoded|www|area|hr|ajaxSetup|meta|post|getJSON|getScript|marginLeft|img|elements|pageYOffset|pageXOffset|abbr|serialize|pixelLeft'.split('|'),0,{}));


// http://misc.360buyimg.com/lib/js/2012/lib-v1.js
/*
 Lib-v1.js 
 Date: 2013-05-23 
 */
function StringBuilder(){this.strings=[],this.length=0}function jdThickBoxclose(){$(".thickclose").trigger("click")}function FriendScript(){var t=getparam();if(""!=t){var e=document.createElement("script");e.type="text/javascript",e.src=jdFriendUrl+"?roid="+Math.random()+t,e.charset="GB2312",document.getElementsByTagName("head")[0].appendChild(e)}}function getparam(){for(var t="",e="",i=location.search.substring(1),n=i.split("&"),r=0;n.length>r;r++){var a=n[r].indexOf("=");-1!=a&&(n[r].substring(0,a),"sid"==n[r].substring(0,a)&&(t=unescape(n[r].substring(a+1))),"t"==n[r].substring(0,a)&&(e=unescape(n[r].substring(a+1))))}return""!=t||""!=e?"&sid="+escape(t)+"&t="+escape(e):""}function mlazyload(t){var e={defObj:null,defHeight:0,fn:null};e=$.extend(e,t||{});var i=(e.defHeight,"object"==typeof e.defObj?e.defObj:$(e.defObj));if(!(1>i.length)){var n=function(){var t=document,i="ipad"==navigator.userAgent.toLowerCase().match(/iPad/i)?window.pageYOffset:Math.max(t.documentElement.scrollTop,t.body.scrollTop);return t.documentElement.clientHeight+i-e.defHeight},r=function(){i.offset().top<=n()&&!i.attr("load")&&(i.attr("load","true"),e.fn&&e.fn())};r(),$(window).bind("scroll",function(){r()})}}(function(){var t=document.getElementById("nav-dapeigou");t&&(t.innerHTML='<a href="http://channel.jd.com/chaoshi.html">\u4eac\u4e1c\u8d85\u5e02</a>')})(),pageConfig.FN_getDomain===void 0&&(pageConfig.FN_getDomain=function(){var t=location.hostname;return/360buy.com/.test(t)?"360buy.com":"jd.com"}),function(){var t=$("#service-2013 a[href='http://en.360buy.com/']");t.length&&t.attr("href","http://help.en.360buy.com/help/question-2.html")}(),function(){var t=$("#footer-2013 a[href='http://about.58.com/fqz/index.html']");t.length&&t.attr("href","http://www.bj.cyberpolice.cn/index.do")}(),"object"!=typeof JSON&&(JSON={}),function(){function f(t){return 10>t?"0"+t:t}function quote(t){return escapable.lastIndex=0,escapable.test(t)?'"'+t.replace(escapable,function(t){var e=meta[t];return"string"==typeof e?e:"\\u"+("0000"+t.charCodeAt(0).toString(16)).slice(-4)})+'"':'"'+t+'"'}function str(t,e){var i,n,r,a,o,s=gap,l=e[t];switch(l&&"object"==typeof l&&"function"==typeof l.toJSON&&(l=l.toJSON(t)),"function"==typeof rep&&(l=rep.call(e,t,l)),typeof l){case"string":return quote(l);case"number":return isFinite(l)?l+"":"null";case"boolean":case"null":return l+"";case"object":if(!l)return"null";if(gap+=indent,o=[],"[object Array]"===Object.prototype.toString.apply(l)){for(a=l.length,i=0;a>i;i+=1)o[i]=str(i,l)||"null";return r=0===o.length?"[]":gap?"[\n"+gap+o.join(",\n"+gap)+"\n"+s+"]":"["+o.join(",")+"]",gap=s,r}if(rep&&"object"==typeof rep)for(a=rep.length,i=0;a>i;i+=1)"string"==typeof rep[i]&&(n=rep[i],r=str(n,l),r&&o.push(quote(n)+(gap?": ":":")+r));else for(n in l)Object.prototype.hasOwnProperty.call(l,n)&&(r=str(n,l),r&&o.push(quote(n)+(gap?": ":":")+r));return r=0===o.length?"{}":gap?"{\n"+gap+o.join(",\n"+gap)+"\n"+s+"}":"{"+o.join(",")+"}",gap=s,r}}"function"!=typeof Date.prototype.toJSON&&(Date.prototype.toJSON=function(){return isFinite(this.valueOf())?this.getUTCFullYear()+"-"+f(this.getUTCMonth()+1)+"-"+f(this.getUTCDate())+"T"+f(this.getUTCHours())+":"+f(this.getUTCMinutes())+":"+f(this.getUTCSeconds())+"Z":null},String.prototype.toJSON=Number.prototype.toJSON=Boolean.prototype.toJSON=function(){return this.valueOf()});var cx=/[\u0000\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g,escapable=/[\\\"\x00-\x1f\x7f-\x9f\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g,gap,indent,meta={"\b":"\\b","	":"\\t","\n":"\\n","\f":"\\f","\r":"\\r",'"':'\\"',"\\":"\\\\"},rep;"function"!=typeof JSON.stringify&&(JSON.stringify=function(t,e,i){var n;if(gap="",indent="","number"==typeof i)for(n=0;i>n;n+=1)indent+=" ";else"string"==typeof i&&(indent=i);if(rep=e,e&&"function"!=typeof e&&("object"!=typeof e||"number"!=typeof e.length))throw Error("JSON.stringify");return str("",{"":t})}),"function"!=typeof JSON.parse&&(JSON.parse=function(text,reviver){function walk(t,e){var i,n,r=t[e];if(r&&"object"==typeof r)for(i in r)Object.prototype.hasOwnProperty.call(r,i)&&(n=walk(r,i),void 0!==n?r[i]=n:delete r[i]);return reviver.call(t,e,r)}var j;if(text+="",cx.lastIndex=0,cx.test(text)&&(text=text.replace(cx,function(t){return"\\u"+("0000"+t.charCodeAt(0).toString(16)).slice(-4)})),/^[\],:{}\s]*$/.test(text.replace(/\\(?:["\\\/bfnrt]|u[0-9a-fA-F]{4})/g,"@").replace(/"[^"\\\n\r]*"|true|false|null|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?/g,"]").replace(/(?:^|:|,)(?:\s*\[)+/g,"")))return j=eval("("+text+")"),"function"==typeof reviver?walk({"":j},""):j;throw new SyntaxError("JSON.parse")})}(),eval(function(t,e,i,n,r,a){if(r=function(t){return(e>t?"":r(parseInt(t/e)))+((t%=e)>35?String.fromCharCode(t+29):t.toString(36))},!"".replace(/^/,String)){for(;i--;)a[r(i)]=n[i]||r(i);n=[function(t){return a[t]}],r=function(){return"\\w+"},i=1}for(;i--;)n[i]&&(t=t.replace(RegExp("\\b"+r(i)+"\\b","g"),n[i]));return t}("(4($){$.R($.7,{3:4(c,b,d){9 e=2,q;5($.O(c))d=b,b=c,c=z;$.h($.3.j,4(i,a){5(e.8==a.8&&e.g==a.g&&c==a.m&&(!b||b.$6==a.7.$6)&&(!d||d.$6==a.o.$6))l(q=a)&&v});q=q||Y $.3(2.8,2.g,c,b,d);q.u=v;$.3.s(q.F);l 2},T:4(c,b,d){9 e=2;5($.O(c))d=b,b=c,c=z;$.h($.3.j,4(i,a){5(e.8==a.8&&e.g==a.g&&(!c||c==a.m)&&(!b||b.$6==a.7.$6)&&(!d||d.$6==a.o.$6)&&!2.u)$.3.y(a.F)});l 2}});$.3=4(e,c,a,b,d){2.8=e;2.g=c||S;2.m=a;2.7=b;2.o=d;2.t=[];2.u=v;2.F=$.3.j.K(2)-1;b.$6=b.$6||$.3.I++;5(d)d.$6=d.$6||$.3.I++;l 2};$.3.p={y:4(){9 b=2;5(2.m)2.t.16(2.m,2.7);E 5(2.o)2.t.h(4(i,a){b.o.x(a)});2.t=[];2.u=Q},s:4(){5(2.u)l;9 b=2;9 c=2.t,w=$(2.8,2.g),H=w.11(c);2.t=w;5(2.m){H.10(2.m,2.7);5(c.C>0)$.h(c,4(i,a){5($.B(a,w)<0)$.Z.P(a,b.m,b.7)})}E{H.h(4(){b.7.x(2)});5(2.o&&c.C>0)$.h(c,4(i,a){5($.B(a,w)<0)b.o.x(a)})}}};$.R($.3,{I:0,j:[],k:[],A:v,D:X,N:4(){5($.3.A&&$.3.k.C){9 a=$.3.k.C;W(a--)$.3.j[$.3.k.V()].s()}},U:4(){$.3.A=v},M:4(){$.3.A=Q;$.3.s()},L:4(){$.h(G,4(i,n){5(!$.7[n])l;9 a=$.7[n];$.7[n]=4(){9 r=a.x(2,G);$.3.s();l r}})},s:4(b){5(b!=z){5($.B(b,$.3.k)<0)$.3.k.K(b)}E $.h($.3.j,4(a){5($.B(a,$.3.k)<0)$.3.k.K(a)});5($.3.D)1j($.3.D);$.3.D=1i($.3.N,1h)},y:4(b){5(b!=z)$.3.j[b].y();E $.h($.3.j,4(a){$.3.j[a].y()})}});$.3.L('1g','1f','1e','1b','1a','19','18','17','1c','15','1d','P');$(4(){$.3.M()});9 f=$.p.J;$.p.J=4(a,c){9 r=f.x(2,G);5(a&&a.8)r.g=a.g,r.8=a.8;5(14 a=='13')r.g=c||S,r.8=a;l r};$.p.J.p=$.p})(12);",62,82,"||this|livequery|function|if|lqguid|fn|selector|var|||||||context|each||queries|queue|return|type||fn2|prototype|||run|elements|stopped|false|els|apply|stop|undefined|running|inArray|length|timeout|else|id|arguments|nEls|guid|init|push|registerPlugin|play|checkQueue|isFunction|remove|true|extend|document|expire|pause|shift|while|null|new|event|bind|not|jQuery|string|typeof|toggleClass|unbind|addClass|removeAttr|attr|wrap|before|removeClass|empty|after|prepend|append|20|setTimeout|clearTimeout".split("|"),0,{})),new function(t){var e=t.separator||"&",i=t.spaces===!1?!1:!0;t.suffix===!1?"":"[]";var n=t.prefix===!1?!1:!0,r=n?t.hash===!0?"#":"?":"",a=t.numbers===!1?!1:!0;jQuery.query=new function(){var t=function(t,e){return void 0!=t&&null!==t&&(e?t.constructor==e:!0)},n=function(t){for(var e,i=/\[([^[]*)\]/g,n=/^(\S+?)(\[\S*\])?$/.exec(t),r=n[1],a=[];e=i.exec(n[2]);)a.push(e[1]);return[r,a]},o=function(e,i,n){var r=i.shift();if("object"!=typeof e&&(e=null),""===r)if(e||(e=[]),t(e,Array))e.push(0==i.length?n:o(null,i.slice(0),n));else if(t(e,Object)){for(var a=0;null!=e[a++];);e[--a]=0==i.length?n:o(e[a],i.slice(0),n)}else e=[],e.push(0==i.length?n:o(null,i.slice(0),n));else if(r&&r.match(/^\s*[0-9]+\s*$/)){var s=parseInt(r,10);e||(e=[]),e[s]=0==i.length?n:o(e[s],i.slice(0),n)}else{if(!r)return n;var s=r.replace(/^\s*|\s*$/g,"");if(e||(e={}),t(e,Array)){for(var l={},a=0;e.length>a;++a)l[a]=e[a];e=l}e[s]=0==i.length?n:o(e[s],i.slice(0),n)}return e},s=function(t){var e=this;return e.keys={},t.queryObject?jQuery.each(t.get(),function(t,i){e.SET(t,i)}):jQuery.each(arguments,function(){var t=""+this;t=t.replace(/^[?#]/,""),t=t.replace(/[;&]$/,""),i&&(t=t.replace(/[+]/g," ")),jQuery.each(t.split(/[&;]/),function(){var t=decodeURIComponent(this.split("=")[0]),i=decodeURIComponent(encodeURIComponent(this.split("=")[1]));t&&(a&&(/^[+-]?[0-9]+\.[0-9]*$/.test(i)?i=parseFloat(i):/^[+-]?[0-9]+$/.test(i)&&(i=parseInt(i,10))),i=i||0===i?i:!0,i!==!1&&i!==!0&&"number"!=typeof i&&(i=i),e.SET(t,i))})}),e};return s.prototype={queryObject:!0,has:function(e,i){var n=this.get(e);return t(n,i)},GET:function(e){if(!t(e))return this.keys;for(var i=n(e),r=i[0],a=i[1],o=this.keys[r];null!=o&&0!=a.length;)o=o[a.shift()];return"number"==typeof o?o:o||""},get:function(e){var i=this.GET(e);return t(i,Object)?jQuery.extend(!0,{},i):t(i,Array)?i.slice(0):i},SET:function(e,i){var r=t(i)?i:null,a=n(e),s=a[0],l=a[1],c=this.keys[s];return this.keys[s]=o(c,l.slice(0),r),this},set:function(t,e){return this.copy().SET(t,e)},REMOVE:function(t){return this.SET(t,null).COMPACT()},remove:function(t){return this.copy().REMOVE(t)},EMPTY:function(){var t=this;return jQuery.each(t.keys,function(e){delete t.keys[e]}),t},load:function(t){var e=t.replace(/^.*?[#](.+?)(?:\?.+)?$/,"$1"),i=t.replace(/^.*?[?](.+?)(?:#.+)?$/,"$1");return new s(t.length==i.length?"":i,t.length==e.length?"":e)},empty:function(){return this.copy().EMPTY()},copy:function(){return new s(this)},COMPACT:function(){function e(i){function n(e,i,n){t(e,Array)?e.push(n):e[i]=n}var r="object"==typeof i?t(i,Array)?[]:{}:i;return"object"==typeof i&&jQuery.each(i,function(i,a){return t(a)?(n(r,i,e(a)),void 0):!0}),r}return this.keys=e(this.keys),this},compact:function(){return this.copy().COMPACT()},toString:function(){var i=[],n=[],a=function(e,i,n){if(t(n)&&n!==!1){var r=[encodeURIComponent(i)];n!==!0&&(r.push("="),r.push(encodeURIComponent(n))),e.push(r.join(""))}},o=function(t,e){var i=function(t){return e&&""!=e?[e,"[",t,"]"].join(""):[t].join("")};jQuery.each(t,function(t,e){"object"==typeof e?o(e,i(t)):a(n,i(t),e)})};return o(this.keys),n.length>0&&i.push(r),i.push(n.join(e)),i.join("")}},new s(location.search,location.hash)}}(jQuery.query||{}),eval(function(t,e,i,n,r,a){if(r=function(t){return(e>t?"":r(parseInt(t/e)))+((t%=e)>35?String.fromCharCode(t+29):t.toString(36))},!"".replace(/^/,String)){for(;i--;)a[r(i)]=n[i]||r(i);n=[function(t){return a[t]}],r=function(){return"\\w+"},i=1}for(;i--;)n[i]&&(t=t.replace(RegExp("\\b"+r(i)+"\\b","g"),n[i]));return t}("n.5=v(a,b,c){4(7 b!='w'){c=c||{};4(b===o){b='';c.3=-1}2 d='';4(c.3&&(7 c.3=='p'||c.3.q)){2 e;4(7 c.3=='p'){e=x y();e.z(e.A()+(c.3*B*r*r*C))}s{e=c.3}d=';3='+e.q()}2 f=c.8?';8='+(c.8):'';2 g=c.9?';9='+(c.9):'';2 h=c.t?';t':'';6.5=[a,'=',D(b),d,f,g,h].E('')}s{2 j=o;4(6.5&&6.5!=''){2 k=6.5.F(';');G(2 i=0;i<k.m;i++){2 l=n.H(k[i]);4(l.u(0,a.m+1)==(a+'=')){j=I(l.u(a.m+1));J}}}K j}};",47,47,"||var|expires|if|cookie|document|typeof|path|domain|||||||||||||length|jQuery|null|number|toUTCString|60|else|secure|substring|function|undefined|new|Date|setTime|getTime|24|1000|encodeURIComponent|join|split|for|trim|decodeURIComponent|break|return".split("|"),0,{})),Function.prototype.overwrite=function(t){var e=t;return e.original||(e.original=this),e},Date.prototype.toString=Date.prototype.toString.overwrite(function(t){var e=new String;return"string"==typeof t&&(e=t,e=e.replace(/yyyy|YYYY/,this.getFullYear()),e=e.replace(/yy|YY/,(""+this.getFullYear()).substr(2,2)),e=e.replace(/MM/,this.getMonth()>=9?this.getMonth()+1:"0"+(this.getMonth()+1)),e=e.replace(/M/,this.getMonth()),e=e.replace(/dd|DD/,this.getDate()>9?this.getDate():"0"+this.getDate()),e=e.replace(/d|D/,this.getDate()),e=e.replace(/hh|HH/,this.getHours()>9?this.getHours():"0"+this.getHours()),e=e.replace(/h|H/,this.getHours()),e=e.replace(/mm/,this.getMinutes()>9?this.getMinutes():"0"+this.getMinutes()),e=e.replace(/m/,this.getMinutes()),e=e.replace(/ss|SS/,this.getSeconds()>9?this.getSeconds():"0"+this.getSeconds()),e=e.replace(/s|S/,this.getSeconds())),e}),String.prototype.format=function(){var t=this;return arguments.length>0&&(parameters=$.makeArray(arguments),$.each(parameters,function(e,i){t=t.replace(RegExp("\\{"+e+"\\}","g"),i)})),t},StringBuilder.prototype.append=function(t){this.strings.push(t),this.length+=t.length},StringBuilder.prototype.toString=function(t,e){return this.strings.join("").substr(t,e)},function($){$.jmsajax=function(t){var e={type:"POST",dataType:"msjson",data:{},beforeSend:function(t){t.setRequestHeader("Content-type","application/json; charset=utf-8")},contentType:"application/json; charset=utf-8",error:function(t){alert("Status: "+(t.statusText?t.statusText:"Unknown")+"\nMessage: "+msJSON.parse(t.responseText?t.responseText:"Unknown").Message)}},t=$.extend(e,t);if(t.method&&(t.url+="/"+t.method),t.data)if("GET"==t.type){var i="";for(var n in t.data)""!=i&&(i+="&"),i+=n+"="+msJSON.stringify(t.data[n]);t.url+="?"+i,i=null,t.data="{}"}else"POST"==t.type&&(t.data=msJSON.stringify(t.data));if(t.success&&t.dataType&&"msjson"==t.dataType){var r=t.success;t.success=function(e,i){var n=dateparse(e);t.version?t.version>=3.5&&(n=n.d):0==e.indexOf('{"d":')&&(n=n.d),r(n,i)}}return $.ajax(t)},dateparse=function(t){try{return msJSON.parse(t,function(t,e){var i;return"string"==typeof e&&e.indexOf("Date")>=0&&(i=/^\/Date\(([0-9]+)\)\/$/.exec(e))?new Date(parseInt(i[1],10)):e})}catch(e){return null}},msJSON=function(){function f(t){return 10>t?"0"+t:t}function quote(t){return escapeable.lastIndex=0,escapeable.test(t)?'"'+t.replace(escapeable,function(t){var e=meta[t];return"string"==typeof e?e:"\\u"+("0000"+(+t.charCodeAt(0)).toString(16)).slice(-4)})+'"':'"'+t+'"'}function str(t,e){var i,n,r,a,o,s=gap,l=e[t];switch(l&&"object"==typeof l&&"function"==typeof l.toJSON&&(l=l.toJSON(t)),"function"==typeof rep&&(l=rep.call(e,t,l)),typeof l){case"string":return quote(l);case"number":return isFinite(l)?l+"":"null";case"boolean":case"null":return l+"";case"object":if(!l)return"null";if(l.toUTCString)return'"\\/Date('+l.getTime()+')\\/"';if(gap+=indent,o=[],"number"==typeof l.length&&!l.propertyIsEnumerable("length")){for(a=l.length,i=0;a>i;i+=1)o[i]=str(i,l)||"null";return r=0===o.length?"[]":gap?"[\n"+gap+o.join(",\n"+gap)+"\n"+s+"]":"["+o.join(",")+"]",gap=s,r}if(rep&&"object"==typeof rep)for(a=rep.length,i=0;a>i;i+=1)n=rep[i],"string"==typeof n&&(r=str(n,l,rep),r&&o.push(quote(n)+(gap?": ":":")+r));else for(n in l)Object.hasOwnProperty.call(l,n)&&(r=str(n,l,rep),r&&o.push(quote(n)+(gap?": ":":")+r));return r=0===o.length?"{}":gap?"{\n"+gap+o.join(",\n"+gap)+"\n"+s+"}":"{"+o.join(",")+"}",gap=s,r}}var cx=/[\u0000\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g,escapeable=/[\\\"\x00-\x1f\x7f-\x9f\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g,gap,indent,meta={"\b":"\\b","	":"\\t","\n":"\\n","\f":"\\f","\r":"\\r",'"':'\\"',"\\":"\\\\"},rep;return{stringify:function(t,e,i){var n;if(gap="",indent="","number"==typeof i)for(n=0;i>n;n+=1)indent+=" ";else"string"==typeof i&&(indent=i);if(rep=e,e&&"function"!=typeof e&&("object"!=typeof e||"number"!=typeof e.length))throw Error("JSON.stringify");return str("",{"":t})},parse:function(text,reviver){function walk(t,e){var i,n,r=t[e];if(r&&"object"==typeof r)for(i in r)Object.hasOwnProperty.call(r,i)&&(n=walk(r,i),void 0!==n?r[i]=n:delete r[i]);return reviver.call(t,e,r)}var j;if(cx.lastIndex=0,cx.test(text)&&(text=text.replace(cx,function(t){return"\\u"+("0000"+(+t.charCodeAt(0)).toString(16)).slice(-4)})),/^[\],:{}\s]*$/.test(text.replace(/\\(?:["\\\/bfnrt]|u[0-9a-fA-F]{4})/g,"@").replace(/"[^"\\\n\r]*"|true|false|null|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?/g,"]").replace(/(?:^|:|,)(?:\s*\[)+/g,"")))return j=eval("("+text+")"),"function"==typeof reviver?walk({"":j},""):j;throw new SyntaxError("JSON.parse")}}}()}(jQuery);var TrimPath;(function(){null==TrimPath&&(TrimPath={}),null==TrimPath.evalEx&&(TrimPath.evalEx=function(src){return eval(src)});var UNDEFINED;null==Array.prototype.pop&&(Array.prototype.pop=function(){return 0===this.length?UNDEFINED:this[--this.length]}),null==Array.prototype.push&&(Array.prototype.push=function(){for(var t=0;arguments.length>t;++t)this[this.length]=arguments[t];return this.length}),TrimPath.parseTemplate=function(t,e,i){null==i&&(i=TrimPath.parseTemplate_etc);var n=parse(t,e,i),r=TrimPath.evalEx(n,e,1);return null!=r?new i.Template(e,t,n,r,i):null};try{String.prototype.process=function(t,e){var i=TrimPath.parseTemplate(this,null);return null!=i?i.process(t,e):this}}catch(e){}TrimPath.parseTemplate_etc={},TrimPath.parseTemplate_etc.statementTag="forelse|for|if|elseif|else|var|macro",TrimPath.parseTemplate_etc.statementDef={"if":{delta:1,prefix:"if (",suffix:") {",paramMin:1},"else":{delta:0,prefix:"} else {"},elseif:{delta:0,prefix:"} else if (",suffix:") {",paramDefault:"true"},"/if":{delta:-1,prefix:"}"},"for":{delta:1,paramMin:3,prefixFunc:function(t,e,i,n){if("in"!=t[2])throw new n.ParseError(i,e.line,"bad for loop statement: "+t.join(" "));var r=t[1],a="__LIST__"+r;return["var ",a," = ",t[3],";","var __LENGTH_STACK__;","if (typeof(__LENGTH_STACK__) == 'undefined' || !__LENGTH_STACK__.length) __LENGTH_STACK__ = new Array();","__LENGTH_STACK__[__LENGTH_STACK__.length] = 0;","if ((",a,") != null) { ","var ",r,"_ct = 0;","for (var ",r,"_index in ",a,") { ",r,"_ct++;","if (typeof(",a,"[",r,"_index]) == 'function') {continue;}","__LENGTH_STACK__[__LENGTH_STACK__.length - 1]++;","var ",r," = ",a,"[",r,"_index];"].join("")}},forelse:{delta:0,prefix:"} } if (__LENGTH_STACK__[__LENGTH_STACK__.length - 1] == 0) { if (",suffix:") {",paramDefault:"true"},"/for":{delta:-1,prefix:"} }; delete __LENGTH_STACK__[__LENGTH_STACK__.length - 1];"},"var":{delta:0,prefix:"var ",suffix:";"},macro:{delta:1,prefixFunc:function(t){var e=t[1].split("(")[0];return["var ",e," = function",t.slice(1).join(" ").substring(e.length),"{ var _OUT_arr = []; var _OUT = { write: function(m) { if (m) _OUT_arr.push(m); } }; "].join("")}},"/macro":{delta:-1,prefix:" return _OUT_arr.join(''); };"}},TrimPath.parseTemplate_etc.modifierDef={eat:function(){return""},escape:function(t){return(t+"").replace(/&/g,"&").replace(/</g,"<").replace(/>/g,">")},capitalize:function(t){return(t+"").toUpperCase()},"default":function(t,e){return null!=t?t:e}},TrimPath.parseTemplate_etc.modifierDef.h=TrimPath.parseTemplate_etc.modifierDef.escape,TrimPath.parseTemplate_etc.Template=function(t,e,i,n,r){this.process=function(t,e){null==t&&(t={}),null==t._MODIFIERS&&(t._MODIFIERS={}),null==t.defined&&(t.defined=function(e){return void 0!=t[e]});for(var i in r.modifierDef)null==t._MODIFIERS[i]&&(t._MODIFIERS[i]=r.modifierDef[i]);null==e&&(e={});var a=[],o={write:function(t){a.push(t)}};try{n(o,t,e)}catch(s){if(1==e.throwExceptions)throw s;var l=new String(a.join("")+"[ERROR: "+(""+s)+(s.message?"; "+s.message:"")+"]");return l.exception=s,l}return a.join("")},this.name=t,this.source=e,this.sourceFunc=i,this.toString=function(){return"TrimPath.Template ["+t+"]"}},TrimPath.parseTemplate_etc.ParseError=function(t,e,i){this.name=t,this.line=e,this.message=i},TrimPath.parseTemplate_etc.ParseError.prototype.toString=function(){return"TrimPath template ParseError in "+this.name+": line "+this.line+", "+this.message};var parse=function(t,e,i){t=cleanWhiteSpace(t);for(var n=["var TrimPath_Template_TEMP = function(_OUT, _CONTEXT, _FLAGS) { with (_CONTEXT) {"],r={stack:[],line:1},a=-1;t.length>a+1;){var o=a;for(o=t.indexOf("{",o+1);o>=0;){var s=t.indexOf("}",o+1),l=t.substring(o,s),c=l.match(/^\{(cdata|minify|eval)/);if(c){var d=c[1],u=o+d.length+1,h=t.indexOf("}",u);if(h>=0){var p;p=0>=h-u?"{/"+d+"}":t.substring(u+1,h);var f=t.indexOf(p,h+1);if(f>=0){emitSectionText(t.substring(a+1,o),n);var m=t.substring(h+1,f);"cdata"==d?emitText(m,n):"minify"==d?emitText(scrubWhiteSpace(m),n):"eval"==d&&null!=m&&m.length>0&&n.push("_OUT.write( (function() { "+m+" })() );"),o=a=f+p.length-1}}}else if("$"!=t.charAt(o-1)&&"\\"!=t.charAt(o-1)){var g="/"==t.charAt(o+1)?2:1;if(0==t.substring(o+g,o+10+g).search(TrimPath.parseTemplate_etc.statementTag))break}o=t.indexOf("{",o+1)}if(0>o)break;var s=t.indexOf("}",o+1);if(0>s)break;emitSectionText(t.substring(a+1,o),n),emitStatement(t.substring(o,s+1),r,n,e,i),a=s}if(emitSectionText(t.substring(a+1),n),0!=r.stack.length)throw new i.ParseError(e,r.line,"unclosed, unmatched statement(s): "+r.stack.join(","));return n.push("}}; TrimPath_Template_TEMP"),n.join("")},emitStatement=function(t,e,i,n,r){var a=t.slice(1,-1).split(" "),o=r.statementDef[a[0]];if(null==o)return emitSectionText(t,i),void 0;if(0>o.delta){if(0>=e.stack.length)throw new r.ParseError(n,e.line,"close tag does not match any previous statement: "+t);e.stack.pop()}if(o.delta>0&&e.stack.push(t),null!=o.paramMin&&o.paramMin>=a.length)throw new r.ParseError(n,e.line,"statement needs more parameters: "+t);if(null!=o.prefixFunc?i.push(o.prefixFunc(a,e,n,r)):i.push(o.prefix),null!=o.suffix){if(1>=a.length)null!=o.paramDefault&&i.push(o.paramDefault);else for(var s=1;a.length>s;s++)s>1&&i.push(" "),i.push(a[s]);i.push(o.suffix)}},emitSectionText=function(t,e){if(!(0>=t.length)){for(var i=0,n=t.length-1;t.length>i&&"\n"==t.charAt(i);)i++;for(;n>=0&&(" "==t.charAt(n)||"	"==t.charAt(n));)n--;if(i>n&&(n=i),i>0){e.push('if (_FLAGS.keepWhitespace == true) _OUT.write("');var r=t.substring(0,i).replace("\n","\\n");"\n"==r.charAt(r.length-1)&&(r=r.substring(0,r.length-1)),e.push(r),e.push('");')}for(var a=t.substring(i,n+1).split("\n"),o=0;a.length>o;o++)emitSectionTextLine(a[o],e),a.length-1>o&&e.push('_OUT.write("\\n");\n');if(t.length>n+1){e.push('if (_FLAGS.keepWhitespace == true) _OUT.write("');var r=t.substring(n+1).replace("\n","\\n");"\n"==r.charAt(r.length-1)&&(r=r.substring(0,r.length-1)),e.push(r),e.push('");')}}},emitSectionTextLine=function(t,e){for(var i="}",n=-1;n+i.length<t.length;){var r="${",a="}",o=t.indexOf(r,n+i.length);if(0>o)break;"%"==t.charAt(o+2)&&(r="${%",a="%}");var s=t.indexOf(a,o+r.length);if(0>s)break;emitText(t.substring(n+i.length,o),e);var l=t.substring(o+r.length,s).replace(/\|\|/g,"#@@#").split("|");for(var c in l)l[c].replace&&(l[c]=l[c].replace(/#@@#/g,"||"));e.push("_OUT.write("),emitExpression(l,l.length-1,e),e.push(");"),n=s,i=a}emitText(t.substring(n+i.length),e)},emitText=function(t,e){null==t||0>=t.length||(t=t.replace(/\\/g,"\\\\"),t=t.replace(/\n/g,"\\n"),t=t.replace(/"/g,'\\"'),e.push('_OUT.write("'),e.push(t),e.push('");'))},emitExpression=function(t,e,i){var n=t[e];if(0>=e)return i.push(n),void 0;var r=n.split(":");i.push('_MODIFIERS["'),i.push(r[0]),i.push('"]('),emitExpression(t,e-1,i),r.length>1&&(i.push(","),i.push(r[1])),i.push(")")},cleanWhiteSpace=function(t){return t=t.replace(/\t/g,"    "),t=t.replace(/\r\n/g,"\n"),t=t.replace(/\r/g,"\n"),t=t.replace(/^(\s*\S*(\s+\S+)*)\s*$/,"$1")},scrubWhiteSpace=function(t){return t=t.replace(/^\s+/g,""),t=t.replace(/\s+$/g,""),t=t.replace(/\s+/g," "),t=t.replace(/^(\s*\S*(\s+\S+)*)\s*$/,"$1")};TrimPath.parseDOMTemplate=function(t,e,i){null==e&&(e=document);var n=e.getElementById(t),r=n.value;return null==r&&(r=n.innerHTML),r=r.replace(/</g,"<").replace(/>/g,">"),TrimPath.parseTemplate(r,t,i)},TrimPath.processDOMTemplate=function(t,e,i,n,r){return TrimPath.parseDOMTemplate(t,n,r).process(e,i)}})(),function($){$.extend({_jsonp:{scripts:{},counter:1,charset:"gb2312",head:document.getElementsByTagName("head")[0],name:function(callback){var name="_jsonp_"+(new Date).getTime()+"_"+this.counter;this.counter++;var cb=function(json){eval("delete "+name),callback(json),$._jsonp.head.removeChild($._jsonp.scripts[name]),delete $._jsonp.scripts[name]};return eval(name+" = cb"),name},load:function(t,e){var i=document.createElement("script");i.type="text/javascript",i.charset=this.charset,i.src=t,this.head.appendChild(i),this.scripts[e]=i}},getJSONP:function(t,e){var i=$._jsonp.name(e),t=t.replace(/{callback};/,i);return $._jsonp.load(t,i),this}})}(jQuery),function(t){t.fn.Jdropdown=function(e,i){if(this.length){"function"==typeof e&&(i=e,e={});var n=t.extend({event:"mouseover",current:"hover",delay:0},e||{}),r="mouseover"==n.event?"mouseout":"mouseleave";t.each(this,function(){var e=null,a=null,o=!1;t(this).bind(n.event,function(){if(o)clearTimeout(a);else{var r=t(this);e=setTimeout(function(){r.addClass(n.current),o=!0,i&&i(r)},n.delay)}}).bind(r,function(){if(o){var i=t(this);a=setTimeout(function(){i.removeClass(n.current),o=!1},n.delay)}else clearTimeout(e)})})}}}(jQuery),function(t){t.fn.Jtab=function(e,i){if(this.length){"function"==typeof e&&(i=e,e={});var n=t.extend({type:"static",auto:!1,event:"mouseover",currClass:"curr",source:"data-tag",hookKey:"data-widget",hookItemVal:"tab-item",hookContentVal:"tab-content",stay:5e3,delay:100,threshold:null,mainTimer:null,subTimer:null,index:0,compatible:!1},e||{}),r=t(this).find("*["+n.hookKey+"="+n.hookItemVal+"]"),a=t(this).find("*["+n.hookKey+"="+n.hookContentVal+"]"),o=n.source.toLowerCase().match(/http:\/\/|\d|\.aspx|\.ascx|\.asp|\.php|\.html\.htm|.shtml|.js/g);if(r.length!=a.length)return!1;var s=function(t,e){n.subTimer=setTimeout(function(){r.eq(n.index).removeClass(n.currClass),n.compatible&&a.eq(n.index).hide(),e?(n.index++,n.index==r.length&&(n.index=0)):n.index=t,n.type=null!=r.eq(n.index).attr(n.source)?"dynamic":"static",c()},n.delay)},l=function(){n.mainTimer=setInterval(function(){s(n.index,!0)},n.stay)},c=function(){switch(r.eq(n.index).addClass(n.currClass),n.compatible&&a.eq(n.index).show(),n.type){default:case"static":var t="";break;case"dynamic":var t=o?n.source:r.eq(n.index).attr(n.source);r.eq(n.index).removeAttr(n.source)}i&&i(t,a.eq(n.index),n.index)};r.each(function(e){t(this).bind(n.event,function(){clearTimeout(n.subTimer),clearInterval(n.mainTimer),s(e,!1)}).bind("mouseleave",function(){n.auto&&l()})}),"dynamic"==n.type&&s(n.index,!1),n.auto&&l()}}}(jQuery),function(t){t.fn.Jlazyload=function(e,i){if(this.length){var n,r,a=t.extend({type:null,offsetParent:null,source:"data-lazyload",placeholderImage:"http://misc.360buyimg.com/lib/img/e/blank.gif",placeholderClass:"loading-style2",threshold:200},e||{}),o=this,s=function(t){for(var e=t.scrollLeft,i=t.scrollTop,n=t.offsetWidth,r=t.offsetHeight;t.offsetParent;)e+=t.offsetLeft,i+=t.offsetTop,t=t.offsetParent;return{left:e,top:i,width:n,height:r}},l=function(){var t=document.documentElement,e=document.body,i=window.pageXOffset?window.pageXOffset:t.scrollLeft||e.scrollLeft,n=window.pageYOffset?window.pageYOffset:t.scrollTop||e.scrollTop,r=t.clientWidth,a=t.clientHeight;return{left:i,top:n,width:r,height:a}},c=function(t,e){var i,n,r,o,s,l,c=a.threshold?parseInt(a.threshold):0;return i=t.left+t.width/2,n=e.left+e.width/2,r=t.top+t.height/2,o=e.top+e.height/2,s=(t.width+e.width)/2,l=(t.height+e.height)/2,s+c>Math.abs(i-n)&&l+c>Math.abs(r-o)},d=function(t,e,n){a.placeholderImage&&a.placeholderClass&&n.attr("src",a.placeholderImage).addClass(a.placeholderClass),t&&(n.attr("src",e).removeAttr(a.source),i&&i(e,n))},u=function(e,n,r){if(e){var o=t("#"+n);o.html(r.val()).removeAttr(a.source),r.remove(),i&&i(n,r)}},h=function(t,e,n){t&&(n.removeAttr(a.source),i&&i(e,n))},p=function(){r=l(),o=o.filter(function(){return t(this).attr(a.source)}),t.each(o,function(){var e=t(this).attr(a.source);if(e){var i=a.offsetParent?s(t(a.offsetParent).get(0)):r,n=s(this),o=c(i,n);switch(a.type){case"image":d(o,e,t(this));break;case"textarea":u(o,e,t(this));break;case"module":h(o,e,t(this));break;default:}}})},f=function(){o.length>0&&(clearTimeout(n),n=setTimeout(function(){p()},10))};p(),a.offsetParent?t(a.offsetParent).bind("scroll",function(){f()}):t(window).bind("scroll",function(){f()}).bind("reset",function(){f()})}}}(jQuery),function(t){t.Jtimer=function(e,i){var n=t.extend({pids:null,template:null,reset:null,mainPlaceholder:"timed",subPlaceholder:"timer",resetPlaceholder:"reset",iconPlaceholder:"icon",finishedClass:"",timer:[]},e||{}),r=function(t){var e=t.split(" "),i=e[0].split("-"),n=e[1].split(":");return new Date(i[0],i[1]-1,i[2],n[0],n[1],n[2])},a=function(t){return 2>(t+"").length&&(t="0"+t),t},o=function(e,i){if(i!={}&&i&&i.start&&i.end){var o,s,l,c=r(i.start),d=r(i.server),u=r(i.end),h=(c-d)/1e3,p=(u-d)/1e3,f="#"+n.mainPlaceholder+e,m="#"+n.subPlaceholder+i.qid,g="#"+n.resetPlaceholder+i.qid;if(0>=h){var v=n.template.process(i);t(f).html(v)}n.timer[i.qid]=setInterval(function(){return h>0?(clearInterval(n.timer[i.qid]),void 0):(p>0?(o=Math.floor(p/3600),s=Math.floor((p-3600*o)/60),l=(p-3600*o)%60,t(m).html("\u5269\u4f59<b>"+a(o)+"</b>\u5c0f\u65f6<b>"+a(s)+"</b>\u5206<b>"+a(l)+"</b>\u79d2"),p--):(t(m).html("\u62a2\u8d2d\u7ed3\u675f\uff01"),n.iconPlaceholder&&(iconElement="#"+n.iconPlaceholder+i.qid,t(iconElement).attr("class",n.finishedClass).html("\u62a2\u5b8c")),n.reset&&(t(m).append('<a href="javascript:void(0)" id="'+g.substring(1)+'">\u5237\u65b0</a>'),t(g).bind("click",function(){t.each(n.timer,function(){clearInterval(this)}),n.reset()})),clearInterval(n.timer[i.qid])),void 0)},1e3)}},s=function(t,e){return r(t.end)-r(t.server)-(r(e.end)-r(e.server))};t.ajax({url:"http://qiang.jd.com/HomePageNewLimitBuy.ashx?callback=?",data:{ids:n.pids},dataType:"jsonp",success:function(e){e&&e.data&&(e.data.sort(s),t.each(e.data,function(t){o(t+1,e.data[t])})),i&&i()}})}}(jQuery),function(t){t.fn.Jslider=function(e,i){if(this.length){"function"==typeof e&&(i=e,e={});var n=t.extend({auto:!1,reInit:!1,data:[],defaultIndex:0,slideWidth:0,slideHeight:0,slideDirection:1,speed:"normal",stay:5e3,delay:150,maxAmount:null,template:null,showControls:!0},e||{}),r=t(this),a=null,o=null,s=null,l=null,c=null,d=function(){var t;n.maxAmount&&n.maxAmount<n.data.length&&n.data.splice(n.maxAmount,n.data.length-n.maxAmount),"object"==typeof n.data&&(n.data.length?(t={},t.json=n.data):t=n.data);var e=n.template;if(n.reInit){var l,c=e.controlsContent.process(t);t.json=t.json.slice(1),l=e.itemsContent.process(t),r.find(".slide-items").eq(0).append(l),r.find(".slide-controls").eq(0).html(c)}else{var d=e.itemsWrap.replace("{innerHTML}",e.itemsContent)+e.controlsWrap.replace("{innerHTML}",e.controlsContent),h=d.process(t);r.html(h)}a=r.find(".slide-items"),o=r.find(".slide-controls"),s=o.find("span"),u(),p(),i&&i(r)},u=function(){s.bind("mouseover",function(){var t=s.index(this);t!=n.defaultIndex&&(clearTimeout(c),clearInterval(l),c=setTimeout(function(){h(t)},n.delay))}).bind("mouseleave",function(){clearTimeout(c),clearInterval(l),p()}),a.bind("mouseover",function(){clearTimeout(c),clearInterval(l)}).bind("mouseleave",function(){p()})},h=function(e){s.each(function(i){i==e?t(this).addClass("curr"):t(this).removeClass("curr")});var i=0,r=0;if(3==n.slideDirection){var o=a.children(),l=o.eq(n.defaultIndex),c=o.eq(e);l.css({zIndex:0}),c.css({zIndex:1}),l.fadeOut("fase"),c.fadeIn("slow"),n.defaultIndex=e}else 1==n.slideDirection?(a.css({width:n.slideWidth*n.data.length}),i=-n.slideWidth*e):r=-n.slideHeight*e,a.animate({top:r+"px",left:i+"px"},n.speed,function(){n.defaultIndex=e})},p=function(){n.auto&&(l=setInterval(function(){var t=n.defaultIndex;t++,t==n.data.length&&(t=0),h(t)},n.stay))};d()}}}(jQuery),jQuery.fn.pagination=function(t,e){return e=jQuery.extend({items_per_page:10,num_display_entries:10,current_page:0,num_edge_entries:0,link_to:"#",prev_text:"Prev",next_text:"Next",ellipse_text:"...",prev_show_always:!0,next_show_always:!0,callback:function(){return!1}},e||{}),this.each(function(){function i(){return Math.ceil(t/e.items_per_page)}function n(){var t=Math.ceil(e.num_display_entries/2),n=i(),r=n-e.num_display_entries,a=o>t?Math.max(Math.min(o-t,r),0):0,s=o>t?Math.min(o+t,n):Math.min(e.num_display_entries,n);return[a,s]}function r(t,i){o=t,a();var n=e.callback(t,s);return n||(i.stopPropagation?i.stopPropagation():i.cancelBubble=!0),n}function a(){s.empty();var t=n(),a=i();1==a&&$(".Pagination").css({display:"none"});var l=function(t){return function(e){return r(t,e)}},c=function(t,i){if(t=0>t?0:a>t?t:a-1,i=jQuery.extend({text:t+1,classes:""},i||{}),t==o)var n=$("<a href='javascript:void(0)' class='current'>"+i.text+"</a>");
else var n=$("<a>"+i.text+"</a>").bind("click",l(t)).attr("href",e.link_to.replace(/__id__/,t));i.classes&&n.addClass(i.classes),s.append(n)};if(e.prev_text&&(o>0||e.prev_show_always)&&c(o-1,{text:e.prev_text,classes:"prev"}),t[0]>0&&e.num_edge_entries>0){for(var d=Math.min(e.num_edge_entries,t[0]),u=0;d>u;u++)c(u);e.num_edge_entries<t[0]&&e.ellipse_text&&jQuery("<span>"+e.ellipse_text+"</span>").appendTo(s)}for(var u=t[0];t[1]>u;u++)c(u);if(a>t[1]&&e.num_edge_entries>0){a-e.num_edge_entries>t[1]&&e.ellipse_text&&jQuery("<span>"+e.ellipse_text+"</span>").appendTo(s);for(var h=Math.max(a-e.num_edge_entries,t[1]),u=h;a>u;u++)c(u)}e.next_text&&(a-1>o||e.next_show_always)&&c(o+1,{text:e.next_text,classes:"next"})}var o=e.current_page;t=!t||0>t?1:t,e.items_per_page=!e.items_per_page||0>e.items_per_page?1:e.items_per_page;var s=jQuery(this);this.selectPage=function(t){r(t)},this.prevPage=function(){return o>0?(r(o-1),!0):!1},this.nextPage=function(){return i()-1>o?(r(o+1),!0):!1},a()})},function(t){t.extend(t.browser,{client:function(){return{width:document.documentElement.clientWidth,height:document.documentElement.clientHeight,bodyWidth:document.body.clientWidth,bodyHeight:document.body.clientHeight}},scroll:function(){return{width:document.documentElement.scrollWidth,height:document.documentElement.scrollHeight,bodyWidth:document.body.scrollWidth,bodyHeight:document.body.scrollHeight,left:document.documentElement.scrollLeft+document.body.scrollLeft,top:document.documentElement.scrollTop+document.body.scrollTop}},screen:function(){return{width:window.screen.width,height:window.screen.height}},isIE6:t.browser.msie&&6==t.browser.version,isMinW:function(e){return e>=Math.min(t.browser.client().bodyWidth,t.browser.client().width)},isMinH:function(e){return e>=t.browser.client().height}})}(jQuery),function(t){t.fn.jdPosition=function(e){var i=t.extend({mode:null},e||{});switch(i.mode){default:case"center":var n=t(this).outerWidth(),r=t(this).outerHeight(),a=(t.browser.isMinW(n),t.browser.isMinH(r));t(this).css({left:t.browser.scroll().left+Math.max((t.browser.client().width-n)/2,0)+"px",top:t.browser.isIE6?t.browser.scroll().top<=t.browser.client().bodyHeight-r?t.browser.scroll().top+Math.max((t.browser.client().height-r)/2,0)+"px":(t.browser.client().height-r)/2+"px":a?t.browser.scroll().top:t.browser.scroll().top+Math.max((t.browser.client().height-r)/2,0)+"px"});break;case"auto":break;case"fixed":}}}(jQuery),function(t){t.fn.jdThickBox=function(e,i){"function"==typeof e&&(i=e,e={});var n,r=t.extend({type:"text",source:null,width:null,height:null,title:null,_frame:"",_div:"",_box:"",_con:"",_loading:"thickloading",close:!1,_close:"",_fastClose:!1,_close_val:"\u00d7",_titleOn:!0,_title:"",_autoReposi:!1,_countdown:!1,_thickPadding:10,_thickBorder:1},e||{}),a="function"!=typeof this?t(this):null,o=function(){clearInterval(n),t(".thickframe").add(".thickdiv").hide(),t(".thickbox").empty().remove(),r._autoReposi&&t(window).unbind("resize.jdThickBox").unbind("scroll.jdThickBox")};if(r.close)return o(),!1;var s=function(t){return""!=t?t.match(/\w+/):""},l=function(e){0==t(".thickframe").length||0==t(".thickdiv").length?(t("<iframe class='thickframe' id='"+s(r._frame)+"' marginwidth='0' marginheight='0' frameborder='0' scrolling='no'></iframe>").appendTo(t(document.body)),t("<div class='thickdiv' id='"+s(r._div)+"'></div>").appendTo(t(document.body))):t(".thickframe").add(".thickdiv").show(),t("<div class='thickbox' id='"+s(r._box)+"'></div>").appendTo(t(document.body)),r._titleOn&&d(e),t("<div class='thickcon' id='"+s(r._con)+"' style='width:"+r.width+"px;height:"+r.height+"px;'></div>").appendTo(t(".thickbox")),r._countdown&&c(),t(".thickcon").addClass(r._loading),p(),u(),h(e),r._autoReposi&&t(window).bind("resize.jdThickBox",p).bind("scroll.jdThickBox",p),r._fastClose&&t(document.body).bind("click.jdThickBox",function(e){e=e?e:window.event;var i=e.srcElement?e.srcElement:e.target;"thickdiv"==i.className&&(t(this).unbind("click.jdThickBox"),o())})},c=function(){var e=r._countdown;t("<div class='thickcountdown' style='width:"+r.width+"'><span id='jd-countdown'>"+e+"</span>\u79d2\u540e\u81ea\u52a8\u5173\u95ed</div>").appendTo(t(".thickbox")),n=setInterval(function(){e--,t("#jd-countdown").html(e),0==e&&(e=r._countdown,o())},1e3)},d=function(e){r.title=null==r.title&&e?e.attr("title"):r.title,t("<div class='thicktitle' id='"+s(r._title)+"' style='width:"+r.width+"'><span>"+r.title+"</span></div>").appendTo(t(".thickbox"))},u=function(){null!=r._close&&(t("<a href='#' class='thickclose' id='"+s(r._close)+"'>"+r._close_val+"</a>").appendTo(t(".thickbox")),t(".thickclose").one("click",function(){return o(),!1}))},h=function(e){switch(r.source=null==r.source?e.attr("href"):r.source,r.type){default:case"text":t(".thickcon").html(r.source),t(".thickcon").removeClass(r._loading),i&&i();break;case"html":t(r.source).clone().appendTo(t(".thickcon")).show(),t(".thickcon").removeClass(r._loading),i&&i();break;case"image":r._index=null==r._index?a.index(e):r._index,t(".thickcon").append("<img src='"+r.source+"' width='"+r.width+"' height='"+r.height+"'>"),r.source=null,t(".thickcon").removeClass(r._loading),i&&i();break;case"ajax":case"json":i&&i(r.source,t(".thickcon"),function(){t(".thickcon").removeClass(r._loading)});break;case"iframe":t("<iframe src='"+r.source+"' marginwidth='0' marginheight='0' frameborder='0' scrolling='no' style='width:"+r.width+"px;height:"+r.height+"px;border:0;'></iframe>").appendTo(t(".thickcon")),t(".thickcon").removeClass(r._loading),i&&i()}},p=function(){var e=2*r._thickPadding+2*r._thickBorder+parseInt(r.width),i=(r._titleOn?t(".thicktitle").outerHeight():0)+t(".thickcon").outerHeight();if(t(".thickcon").css({width:r.width,height:r.height,paddingLeft:r._thickPadding,paddingRight:r._thickPadding,borderLeft:r._thickBorder,borderRight:r._thickBorder}),t(".thickbox").css({width:e+"px",height:i+"px"}),t(".thickbox").jdPosition({mode:"center"}),t.browser.isIE6){var n=t(".thickbox").outerWidth(),a=t(".thickbox").outerHeight(),o=t.browser.isMinW(n);t.browser.isMinH(a),t(".thickframe").add(".thickdiv").css({width:o?n:"100%",height:Math.max(t.browser.client().height,t.browser.client().bodyHeight)+"px"})}};null!=a?a.click(function(){return l(t(this)),!1}):l()},t.jdThickBox=t.fn.jdThickBox}(jQuery),function(t){t.fn.jdMarquee=function(e,i){"function"==typeof e&&(i=e,e={});var n,r=t.extend({deriction:"up",speed:10,auto:!1,width:null,height:null,step:1,control:!1,_front:null,_back:null,_stop:null,_continue:null,wrapstyle:"",stay:5e3,delay:20,dom:"div>ul>li".split(">"),mainTimer:null,subTimer:null,tag:!1,convert:!1,btn:null,disabled:"disabled",pos:{ojbect:null,clone:null}},e||{}),a=this.find(r.dom[1]),o=this.find(r.dom[2]);if("up"==r.deriction||"down"==r.deriction){var s=a.eq(0).outerHeight(),l=r.step*o.eq(0).outerHeight();a.css({width:r.width+"px",overflow:"hidden"})}if("left"==r.deriction||"right"==r.deriction){var c=o.length*o.eq(0).outerWidth();a.css({width:c+"px",overflow:"hidden"});var l=r.step*o.eq(0).outerWidth()}var d=function(){var t="<div style='position:relative;overflow:hidden;z-index:1;width:"+r.width+"px;height:"+r.height+"px;"+r.wrapstyle+"'></div>";switch(a.css({position:"absolute",left:0,top:0}).wrap(t),r.pos.object=0,n=a.clone(),a.after(n),r.deriction){default:case"up":a.css({marginLeft:0,marginTop:0}),n.css({marginLeft:0,marginTop:s+"px"}),r.pos.clone=s;break;case"down":a.css({marginLeft:0,marginTop:0}),n.css({marginLeft:0,marginTop:-s+"px"}),r.pos.clone=-s;break;case"left":a.css({marginTop:0,marginLeft:0}),n.css({marginTop:0,marginLeft:c+"px"}),r.pos.clone=c;break;case"right":a.css({marginTop:0,marginLeft:0}),n.css({marginTop:0,marginLeft:-c+"px"}),r.pos.clone=-c}r.auto&&(u(),a.hover(function(){p(r.mainTimer)},function(){u()}),n.hover(function(){p(r.mainTimer)},function(){u()})),i&&i(),r.control&&m()},u=function(t){p(r.mainTimer),r.stay=t?t:r.stay,r.mainTimer=setInterval(function(){h()},r.stay)},h=function(){p(r.subTimer),r.subTimer=setInterval(function(){b()},r.delay)},p=function(t){null!=t&&clearInterval(t)},f=function(e){e?(t(r._front).unbind("click"),t(r._back).unbind("click"),t(r._stop).unbind("click"),t(r._continue).unbind("click")):m()},m=function(){null!=r._front&&t(r._front).click(function(){t(r._front).addClass(r.disabled),f(!0),p(r.mainTimer),r.convert=!0,r.btn="front",h(),r.auto||(r.tag=!0),g()}),null!=r._back&&t(r._back).click(function(){t(r._back).addClass(r.disabled),f(!0),p(r.mainTimer),r.convert=!0,r.btn="back",h(),r.auto||(r.tag=!0),g()}),null!=r._stop&&t(r._stop).click(function(){p(r.mainTimer)}),null!=r._continue&&t(r._continue).click(function(){u()})},g=function(){r.tag&&r.convert&&(r.convert=!1,"front"==r.btn&&("down"==r.deriction&&(r.deriction="up"),"right"==r.deriction&&(r.deriction="left")),"back"==r.btn&&("up"==r.deriction&&(r.deriction="down"),"left"==r.deriction&&(r.deriction="right")),r.auto?u():u(4*r.delay))},v=function(t,e,i){i?(p(r.subTimer),r.pos.object=t,r.pos.clone=e,r.tag=!0):r.tag=!1,r.tag&&(r.convert?g():r.auto||p(r.mainTimer)),("up"==r.deriction||"down"==r.deriction)&&(a.css({marginTop:t+"px"}),n.css({marginTop:e+"px"})),("left"==r.deriction||"right"==r.deriction)&&(a.css({marginLeft:t+"px"}),n.css({marginLeft:e+"px"}))},b=function(){var e="up"==r.deriction||"down"==r.deriction?parseInt(a.get(0).style.marginTop):parseInt(a.get(0).style.marginLeft),i="up"==r.deriction||"down"==r.deriction?parseInt(n.get(0).style.marginTop):parseInt(n.get(0).style.marginLeft),o=Math.max(Math.abs(e-r.pos.object),Math.abs(i-r.pos.clone)),d=Math.ceil((l-o)/r.speed);switch(r.deriction){case"up":o==l?(v(e,i,!0),t(r._front).removeClass(r.disabled),f(!1)):(-s>=e&&(e=i+s,r.pos.object=e),-s>=i&&(i=e+s,r.pos.clone=i),v(e-d,i-d));break;case"down":o==l?(v(e,i,!0),t(r._back).removeClass(r.disabled),f(!1)):(e>=s&&(e=i-s,r.pos.object=e),i>=s&&(i=e-s,r.pos.clone=i),v(e+d,i+d));break;case"left":o==l?(v(e,i,!0),t(r._front).removeClass(r.disabled),f(!1)):(-c>=e&&(e=i+c,r.pos.object=e),-c>=i&&(i=e+c,r.pos.clone=i),v(e-d,i-d));break;case"right":o==l?(v(e,i,!0),t(r._back).removeClass(r.disabled),f(!1)):(e>=c&&(e=i-c,r.pos.object=e),i>=c&&(i=e-c,r.pos.clone=i),v(e+d,i+d))}};("up"==r.deriction||"down"==r.deriction)&&s>=r.height&&s>=r.step&&d(),("left"==r.deriction||"right"==r.deriction)&&c>=r.width&&c>=r.step&&d()}}(jQuery),$.login=function(t){t=$.extend({loginService:"http://passport."+pageConfig.FN_getDomain()+"/loginservice.aspx?callback=?",loginMethod:"Login",loginUrl:"https://passport."+pageConfig.FN_getDomain()+"/new/login.aspx",returnUrl:location.href,automatic:!0,complete:null,modal:!1},t||{}),""!=t.loginService&&""!=t.loginMethod&&$.getJSON(t.loginService,{method:t.loginMethod},function(e){null!=e&&(null!=t.complete&&t.complete(e.Identity),!e.Identity.IsAuthenticated&&t.automatic&&""!=t.loginUrl&&(t.modal?jdModelCallCenter.login():location.href=t.loginUrl+"?ReturnUrl="+escape(t.returnUrl)))})};var jdFriendUrl="http://club.jd.com/jdFriend/TuiJianService.aspx";window.onload=function(){FriendScript()},function(t){t.jdCalcul=function(e){var i=null,e=e.join(","),n="http://qiang.jd.com/HomePageLimitBuy.ashx?callback=?&ids="+e,r="http://item.jd.com/",a=function(e){var i=t.extend({contentid:"#limit",clockid:"#clock",rankid:"#rank",limitid:"#limitbuy"},e||{});if(!(e=={}||""==e||null==i.start||""==i.start||null==i.end||""==i.end||1>i.pros.length)){i.start=o(i.start),i.start=t.browser.mozzia?Date.parse(i.start):i.start,i.server=o(i.server),i.server=t.browser.mozzia?Date.parse(i.server):i.server,i.end=o(i.end),i.end=t.browser.mozzia?Date.parse(i.end):i.end,i.contentid=t(i.contentid+i.qid),i.clockid=t(i.clockid+i.qid),i.rankid=t(i.rankid+i.qid),i.limitid=t(i.limitid+i.qid);var n,a,s,l,c=(i.start-i.server)/1e3,d=(i.end-i.server)/1e3,u=function(){var e='<li><div class="p-img"><a href="{6}{0}.html" target="_blank"><img src="{1}" width="100" height="100" /></a>{2}</div><div class="p-name"><a href="{6}{0}.html" target="_blank">{3}</a></div><div class="p-price">\u62a2\u8d2d\u4ef7\uff1a<strong>{4}</strong>{5}</div></li>',n="<ul>";t.each(i.pros,function(t){var a=i.pros[t].id,o=i.pros[t].tp,s=1==i.pros[t].zt?"<div class='pi9'></div>":"<div class='pi10'></div>",l=unescape(i.pros[t].mc),c=i.pros[t].qg,d="("+i.pros[t].zk+"\u6298)";n+=e.replace(/\{0\}/g,a).replace("{1}",o).replace("{2}",s).replace("{3}",l).replace("{4}",c).replace("{5}",d).replace(/\{6\}/g,r)}),n+="</ul>",i.contentid.html(n)},h=function(){c>0||(d>0?(n=Math.floor(d/3600),a=Math.floor((d-3600*n)/60),s=(d-3600*n)%60,i.clockid.html("\u5269\u4f59<b>"+n+"</b>\u5c0f\u65f6<b>"+a+"</b>\u5206<b>"+s+"</b>\u79d2"),d--):(i.clockid.html("\u62a2\u8d2d\u7ed3\u675f"),clearInterval(l),i.limitid.hide(),i.rankid.length>0&&i.rankid.show()))};0>=c&&d>0&&(u(),i.rankid.length>0&&i.rankid.hide(),i.limitid.show()),h(),l=setInterval(function(){h()},1e3)}},o=function(t){var e=t.split(" "),i=e[0].split("-"),n=e[1].split(":");return new Date(i[0],i[1]-1,i[2],n[0],n[1],n[2])};t.ajax({url:n,dataType:"jsonp",success:function(e){e&&(i=e.data,t.each(i,function(t){a(i[t])}))}})}}(jQuery);var jdRecent={element:$("#recent ul"),jsurl:"http://www.jd.com/lishiset.aspx?callback=jdRecent.setData&id=",cookiename:"_recent",list:$.cookie("_recent"),url:location.href,init:function(){var t=this.url.match(/\/(\d{6}).html/),e=null!=t&&-1!=t[0].indexOf("html")?t[1]:"";if(this.list&&null!=this.list&&""!=this.list)""==e||-1!=this.list.indexOf(e)?this.list=this.list:(this.list.split(".").length>=10&&(this.list=this.list.replace(/.\d+$/,"")),this.list=e+"."+this.list);else{if(""==e)return this.getData(0);this.list=e}$.cookie(this.cookiename,this.list,{expires:7,path:"/",domain:"jd.com",secure:!1}),this.getData(this.list)},clear:function(){$.cookie(this.cookiename,"",{expires:7,path:"/",domain:"jd.com",secure:!1})},getData:function(t){if(0==t)return this.element.html("<li><div class='norecode'>\u6682\u65e0\u8bb0\u5f55!</div></li>"),void 0;var e=t.split(".");for(i in e)0==i&&this.element.empty(),$.getJSONP(this.jsurl+e[i],this.setData)},setData:function(t){this.element.append("<li><div class='p-img'><a href='"+t.url+"'><img src='"+t.img+"' /></a></div><div class='p-name'><a href='"+t.url+"'>"+decodeURIComponent(t.name)+"</a></div></li>")}};$("#clearRec").click(function(){jdRecent.clear(),jdRecent.getData(0)}),mlazyload({defObj:"#recent",defHeight:50,fn:function(){1==jdRecent.element.length&&jdRecent.init()}});var jdModelCallCenter={settings:{clstag1:0,clstag2:0},tbClose:function(){0!=$(".thickbox").length&&jdThickBoxclose()},login:function(){this.tbClose();var t=this,e=navigator.userAgent.toLowerCase(),i="ucweb"==e.match(/ucweb/i)||"rv:1.2.3.4"==e.match(/rv:1.2.3.4/i);return i?(location.href="https://passport."+pageConfig.FN_getDomain()+"/new/login.aspx?ReturnUrl="+escape(location.href),void 0):(setTimeout(function(){$.jdThickBox({type:"iframe",title:"\u60a8\u5c1a\u672a\u767b\u5f55",source:"http://passport."+pageConfig.FN_getDomain()+"/new/LoginFrame.aspx?clstag1="+t.settings.clstag1+"&clstag2="+t.settings.clstag2+"&r="+Math.random(),width:450,height:360,_title:"thicktitler",_close:"thickcloser",_con:"thickconr"})},20),void 0)},regist:function(){var t=this;this.tbClose(),setTimeout(function(){$.jdThickBox({type:"iframe",title:"\u60a8\u5c1a\u672a\u767b\u5f55",source:"http://passport."+pageConfig.FN_getDomain()+"/new/registPersonalFrame.aspx?clstag1="+t.settings.clstag1+"&clstag2="+t.settings.clstag2+"&r="+Math.random(),width:450,height:500,_title:"thicktitler",_close:"thickcloser",_con:"thickconr"})},20)},init:function(){var t=this;$.ajax({url:"http://passport."+pageConfig.FN_getDomain()+"/new/helloService.ashx?m=ls&sso=0",dataType:"jsonp",success:function(e){t.tbClose(),e&&e.info&&$("#loginbar").html(e.info),t.settings.fn()}})}};$.extend(jdModelCallCenter,{autoLocation:function(t){$.login({modal:!0,complete:function(e){null!=e&&null!=e.IsAuthenticated&&e.IsAuthenticated&&(window.location=t)}})}}),$.extend(jdModelCallCenter,{doAttention:function(t){var e="http://t.jd.com/product/followProduct.action?productId="+t;$.login({modal:!0,complete:function(t){if(null!=t&&null!=t.IsAuthenticated&&t.IsAuthenticated){var i=510,n=440;$.jdThickBox({type:"iframe",source:e+"&t="+Math.random(),width:i,height:n,title:"\u63d0\u793a",_box:"attboxr",_con:"attconr",_countdown:!1})}}})}}),$(".btn-coll").livequery("click",function(){var t=$(this),e=parseInt(t.attr("id").replace("coll",""));$.extend(jdModelCallCenter.settings,{clstag1:"login|keycount|5|3",clstag2:"login|keycount|5|4",id:e,fn:function(){jdModelCallCenter.doAttention(this.id)}}),jdModelCallCenter.settings.fn()});var category={OBJ:$("#_JD_ALLSORT"),URL_Serv:"http://www.360buy.com/ajaxservice.aspx?stype=SortJson",URL_BrandsServ:"http://www.360buy.com/lishi.aspx?callback=category.getBrandService&id=a,915,925^b,916,926^c,917,927^d,918,928^e,919,929^f,920,930^g,921,931^h,922,932^i,923,933^j,924,934^k,2096,2097^l,3512,3513^m,5274,5275",FN_GetLink:function(t,e){var i,n;switch(t){case 1:i=e.u,n=e.n;break;case 2:i=e.split("|")[0],n=e.split("|")[1]}return""==i?n:(/^http[s]?:\/\/([\w-]+\.)+[\w-]+([\w-.\/?%&=]*)?$/.test(i)||(i=i.replace(/-000$/,""),i=i.match(/^\d*-\d*$/)?"http://channel.jd.com/"+i+".html":"http://list.jd.com/"+i+".html"),'<a href="'+i+'">'+n+"</a>")},FN_SetLink:function(){var t="";return t},DATA_Simple:{1:[{l:"http://book.jd.com/",n:"\u56fe\u4e66"},{l:"http://mvd.jd.com/",n:"\u97f3\u50cf"},{l:"http://e.jd.com/",n:"\u6570\u5b57\u5546\u54c1"}],2:[{l:"http://channel.jd.com/electronic.html",n:"\u5bb6\u7528\u7535\u5668"}],3:[{l:"http://shouji.jd.com/",n:"\u624b\u673a"},{l:"http://channel.jd.com/digital.html",n:"\u6570\u7801"}],4:[{l:"http://channel.jd.com/computer.html",n:"\u7535\u8111\u3001\u529e\u516c"}],5:[{l:"http://channel.jd.com/home.html",n:"\u5bb6\u5c45"},{l:"http://channel.jd.com/furniture.html",n:"\u5bb6\u5177"},{l:"http://channel.jd.com/decoration.html",n:"\u5bb6\u88c5"},{l:"http://channel.jd.com/kitchenware.html",n:"\u53a8\u5177"}],6:[{l:"http://channel.jd.com/clothing.html",n:"\u670d\u9970\u978b\u5e3d"}],7:[{l:"http://channel.jd.com/beauty.html",n:"\u4e2a\u62a4\u5316\u5986"}],8:[{l:"http://channel.jd.com/bag.html",n:"\u793c\u54c1\u7bb1\u5305"},{l:"http://channel.jd.com/watch.html",n:"\u949f\u8868"},{l:"http://channel.jd.com/jewellery.html",n:"\u73e0\u5b9d"}],9:[{l:"http://channel.jd.com/sports.html",n:"\u8fd0\u52a8\u5065\u5eb7"}],10:[{l:"http://channel.jd.com/auto.html",n:"\u6c7d\u8f66\u7528\u54c1"}],11:[{l:"http://channel.jd.com/baby.html",n:"\u6bcd\u5a74"},{l:"http://channel.jd.com/toys.html",n:"\u73a9\u5177\u4e50\u5668"}],12:[{l:"http://channel.jd.com/food.html",n:"\u98df\u54c1\u996e\u6599\u3001\u4fdd\u5065\u98df\u54c1"}],13:[{l:"http://caipiao.jd.com/",n:"\u5f69\u7968"},{l:"http://trip.jd.com/",n:"\u65c5\u884c"},{l:"http://chongzhi.jd.com/",n:"\u5145\u503c"},{l:"http://game.jd.com/",n:"\u6e38\u620f"}]},TPL_Simple:'{for item in data}		<div class="item fore${parseInt(item_index)}">			<span clstag="homepage|keycount|home2013|06{if parseInt(item_index)+1>9}${parseInt(item_index)+1}{else}0${parseInt(item_index)+1}{/if}a"><h3>			{for sItem in item}{if sItem_index!=0}\u3001{/if}<a href="${sItem.l}">${sItem.n}</a>{/for}			</h3><s></s></span>		</div>		{/for}<div class="extra"><a href="http://www.jd.com/allSort.aspx">\u5168\u90e8\u5546\u54c1\u5206\u7c7b</a></div>',FN_InitSimple:function(){var t,e={};e.data=this.DATA_Simple,t=this.TPL_Simple.process(e),$("#_JD_ALLSORT").html(t)},TPL_Items:'{for item in data}		<div class="item fore${parseInt(item_index)+1}">			<span clstag="homepage|keycount|home2013|0${601+parseInt(item_index)}a"><h3>${item.n}</h3><s></s></span>			<div class="i-mc">				<div onclick="$(this).parent().parent().removeClass(\'hover\')" class="close"></div>				<div class="subitem" clstag="homepage|keycount|home2013|0${601+parseInt(item_index)}b">					{for subitem in item.i}					<dl class="fore${parseInt(subitem_index)+1}">						<dt>							${category.FN_GetLink(1,subitem)}						</dt>						<dd>{for link in subitem.i}<em>${category.FN_GetLink(2,link)}</em>{/for}</dd>					</dl>					{/for}				</div>				<div class="cat-right-con fr" id="JD_sort_${item.t}"><div class="loading-style1"><b></b>\u52a0\u8f7d\u4e2d\uff0c\u8bf7\u7a0d\u5019...</div></div>			</div>		</div>		{/for}<div class="extra"><a clstag="homepage|keycount|home2013|0614a" href="http://www.jd.com/allSort.aspx">\u5168\u90e8\u5546\u54c1\u5206\u7c7b</a></div>',TPL_Brands:'${category.FN_SetLink(id)}		{if p.length!=0}		<dl class="categorys-promotions">			<dt>\u4fc3\u9500\u6d3b\u52a8</dt>			<dd>				<ul>					{for item in p}					<li><a href="${item.u}" target="_blank">						{if item.i}							<img src="${item.i}" width="194" height="70" title="${item.n}" />						{else}							${item.n}						{/if}					</a></li>					{/for}				</ul>			</dd>		</dl>		{/if}		{if b.length!=0}		<dl class="categorys-brands">			{if id==\'k\'}				<dt>\u63a8\u8350\u54c1\u724c\u51fa\u7248\u5546</dt>			{else}				{if id==\'l\'}					<dt>\u63a8\u8350\u4ea7\u54c1</dt>				{else}					<dt>\u63a8\u8350\u54c1\u724c</dt>				{/if}			{/if}			<dd>				<ul>					{for item in b}					<li><a href="${item.u}" target="_blank">${item.n}</a></li>					{/for}				</ul>			</dd>		</dl>		{/if}',FN_GetData:function(){$.getJSONP(this.URL_Serv,category.getDataService)},FN_GetBrands:function(){$.getJSONP(this.URL_BrandsServ,category.getBrandService)},getDataService:function(t){var e=this.TPL_Items.process(t);this.OBJ.attr("load","1").html(e),this.FN_GetBrands(),this.OBJ.find(".item").Jdropdown({delay:200},function(t){var e,i,n=document.documentElement.scrollTop+document.body.scrollTop,r=$("#nav-2013").offset().top+39;r>=n?(i=t.hasClass("fore13")?23:3,n=i):(e=t.offset().top,n=n>e-5?e-r-10:Math.max(3,n-r)),t.find(".i-mc").css({top:n+"px"})})},getBrandService:function(t){var e=this,i=t.data;this.OBJ.attr("load","2"),$.each(i,function(t){var n=e.TPL_Brands.process(i[t],t);$("#JD_sort_"+i[t].id).html(n)}),$(".cat-right-con").each(function(t){$(this).find(".categorys-promotions").attr("clstag","homepage|keycount|home2013|0"+(601+t)+"c"),$(this).find(".categorys-brands").attr("clstag","homepage|keycount|home2013|0"+(601+t)+"d")})},FN_Init:function(){if(this.OBJ.length){this.OBJ.attr("load")||(window.pageConfig&&0!=window.pageConfig.pageId&&this.FN_InitSimple(),$("#categorys").length?$("#categorys").Jdropdown({delay:200}):$("#categorys-2013").Jdropdown({delay:200}));var t=this;this.OBJ.one("mouseover",function(){var e=t.OBJ.attr("load");if(e){if(1!=e)return;t.FN_GetBrands()}else t.FN_GetData()})}}},UC={DATA_Cookie:"aview",TPL_UnRegist:'<div class="prompt">			<span class="fl">\u60a8\u597d\uff0c\u8bf7<a href="javascript:login()" clstag="homepage|keycount|home2013|04a">\u767b\u5f55</a></span>			<span class="fr"></span>		</div>',TPL_Regist:'<div class="prompt">				<span class="fl"><strong>${Name}</strong></span>				<span class="fr"><a href="http://home.jd.com/">\u53bb\u6211\u7684\u4eac\u4e1c\u9996\u9875&nbsp;&gt;</a></span>			</div>',TPL_OList:{placeholder:'<div id="jduc-orderlist"></div>',fragment:'<div class="orderlist">				<div class="smt">					<h4>\u6700\u65b0\u8ba2\u5355\u72b6\u6001\uff1a</h4>					<div class="extra"><a href="http://jd2008.jd.com/JdHome/OrderList.aspx" target="_blank">\u67e5\u770b\u6240\u6709\u8ba2\u5355&nbsp;&gt;</a></div>				</div>				<div class="smc">					<ul>						{for item in orderList}						<li class="fore${parseInt(item_index)+1}">							<div class="p-img fl">								{for image in item.OrderDetail}									{if image_index<2}										<a href="http://www.jd.com/product/${image.ProductId}.html" target="_blank"><img src="${pageConfig.FN_GetImageDomain(image.ProductId)}n5/${image.ImgUrl}" width="50" height="50" alt="${image.ProductName}" /></a>									{/if}								{/for}								{if item.OrderDetail.length>2}									<a href="${item.passKeyUrl}" target="_blank" class="more">\u66f4\u591a</a>								{/if}							</div>							<div class="p-detail fr">								\u8ba2\u5355\u53f7\uff1a${item.OrderId}<br />								\u72b6\u3000\u6001\uff1a<span>${UC.FN_SetState(item.OrderState)}</span><br />								\u3000\u3000\u3000\u3000<a href="${item.passKeyUrl}">\u67e5\u770b\u8be6\u60c5</a>							</div>						</li>						{/for}					</ul>				</div>			</div>'},TPL_UList:'<div class="uclist">				<ul class="fore1 fl">					<li><a target="_blank" clstag="homepage|keycount|home2013|04b" href="http://jd2008.jd.com/JdHome/OrderList.aspx">\u5f85\u5904\u7406\u8ba2\u5355<span id="num-unfinishedorder"></span></a></li>					<li><a target="_blank" clstag="homepage|keycount|home2013|04c" href="http://jd2008.jd.com/user_spzx.aspx">\u54a8\u8be2\u56de\u590d<span id="num-consultation"></span></a></li>					<li><a target="_blank" clstag="homepage|keycount|home2013|04d" href="http://t.jd.com/product/followProductList.action?isSale=ture">\u4fc3\u9500\u5546\u54c1<span id="num-reduction"></span></a></li>					<li><a target="_blank" clstag="homepage|keycount|home2013|04e" href="http://coupon.jd.com/user_quan.aspx">\u4f18\u60e0\u5238<span id="num-ticket"></span></a></li>				</ul>				<ul class="fore2 fl">					<li><a target="_blank" clstag="homepage|keycount|home2013|04f" href="http://jd2008.jd.com/JdHome/OrderList.aspx">\u6211\u7684\u8ba2\u5355&nbsp;&gt;</a></li>					<li><a target="_blank" clstag="homepage|keycount|home2013|04i" href="http://t.jd.com/home/follow">\u6211\u7684\u5173\u6ce8&nbsp;&gt;</a></li>					<li><a target="_blank" clstag="homepage|keycount|home2013|04g" href="http://bankws.jd.com/score/Integral/ScoreExhibit.aspx">\u6211\u7684\u79ef\u5206&nbsp;&gt;</a></li>					<li><a target="_blank" clstag="homepage|keycount|home2013|04h" href="http://my.jd.com/personal/guess.html">\u4e3a\u6211\u63a8\u8350&nbsp;&gt;</a></li>				</ul>			</div>',TPL_VList:{placeholder:'<div class="viewlist">				<div class="smt" clstag="homepage|keycount|home2013|04k">					<h4>\u6700\u8fd1\u6d4f\u89c8\u7684\u5546\u54c1\uff1a</h4>					<div style="float:right;padding-right:9px;"><a style="border:0;color:#005EA7" href="http://my.jd.com/history/list.html" target="_blank">\u67e5\u770b\u6d4f\u89c8\u5386\u53f2&nbsp;&gt;</a></div>				</div>				<div class="smc" id="jduc-viewlist" clstag="homepage|keycount|home2013|04j">					<div class="loading-style1"><b></b>\u52a0\u8f7d\u4e2d\uff0c\u8bf7\u7a0d\u5019...</div>					<ul class="lh hide"></ul>				</div>			</div>',fragment:'{for item in list}<li><a href="http://item.jd.com/${item.wid}.html" target="_blank" title="${item.wname}"><img src="${pageConfig.FN_GetImageDomain(item.wid)}n5/${item.imgUrl}" width="50" height="50" alt="${item.wname}" /></a></li>{/for}'},FN_SetState:function(t){var t=t;return t.length>4&&(t="<span title="+t+">"+t.substr(0,4)+"...</span>"),t},FN_InitNewVList:function(t){for(var e,i=t.split("|"),n=i.length,r=[],a=0;n>a;)r.push(i[a].split(".")[1]),a++;e=r.join(","),$.getJSONP("http://my.jd.com/product/info.html?ids="+e+"&jsoncallback=UC.FN_ShowVList")},FN_InitVList:function(t){for(var e=JSON.parse(t),i=e.length,n=",",r=0;i>r;r++)RegExp(e[r].s).test(n)||(n+=e[r].s+",");n=n.replace(/(^,*)|(,*$)/g,""),$.getJSONP("http://my.jd.com/product/info.html?ids="+n+"&jsoncallback=UC.FN_ShowVList")},FN_ShowVList:function(t){var e=$("#jduc-viewlist").find(".loading-style1");t.length=t.length>5?5:t.length;var i={list:t};e.length>0&&e.hide();var n=this.TPL_VList.fragment.process(i);$("#jduc-viewlist").find("ul").eq(0).html(n).show()},FN_setWords:function(t){var e='<font style="color:{0}">({1})</font>',i="";return i=0==t?"#ccc":"#c00",pageConfig.FN_StringFormat(e,i,t)},FN_InitOList:function(){$.ajax({url:"http://minijd.360buy.com/getOrderList",dataType:"jsonp",success:function(t){if(t&&0==t.error&&t.orderList){var e=UC.TPL_OList.fragment.process(t);$("#jduc-orderlist").html(e)}}}),$.ajax({url:"http://minijd.360buy.com/getHomeCount",dataType:"jsonp",success:function(t){t&&0==t.error&&$("#num-unfinishedorder").html(UC.FN_setWords(t.orderCount))}}),$.ajax({url:"http://comm.360buy.com/index.php?mod=Consultation&action=havingReplyCount",dataType:"jsonp",success:function(t){t&&$("#num-consultation").html(UC.FN_setWords(t.cnt))}}),$.ajax({url:"http://coupon.360buy.com/service.ashx",data:{m:"getcouponcount"},dataType:"jsonp",success:function(t){t&&$("#num-ticket").html(UC.FN_setWords(t.CouponCount))}})}},MCART={DATA_Cookie:"cn",DATA_Amount:readCookie("cn")||"0",URL_Serv:"http://cart.jd.com/cart/miniCartServiceNew.action",TPL_Iframe:'<iframe scrolling="no" frameborder="0" marginheight="0" marginwidth="0" id="settleup-iframe"></iframe>',TPL_NoGoods:'<div class="prompt"><div class="nogoods"><b></b>\u8d2d\u7269\u8f66\u4e2d\u8fd8\u6ca1\u6709\u5546\u54c1\uff0c\u8d76\u7d27\u9009\u8d2d\u5427\uff01</div></div>',TPL_List:{wrap:'<div id="settleup-content"><div class="smt"><h4 class="fl">\u6700\u65b0\u52a0\u5165\u7684\u5546\u54c1</h4></div><div class="smc"></div><div class="smb ar">\u5171<b>${Num}</b>\u4ef6\u5546\u54c1\u3000\u5171\u8ba1<strong>\uffe5 ${TotalPromotionPrice.toFixed(2)}</strong><br><a href="http://cart.jd.com/cart/cart.html?r=${+new Date}" title="\u53bb\u8d2d\u7269\u8f66\u7ed3\u7b97" id="btn-payforgoods">\u53bb\u8d2d\u7269\u8f66\u7ed3\u7b97</a></div></div>',sigle:'<ul id="mcart-sigle">{for list in TheSkus}	<li>		<div class="p-img fl"><a href="http://item.jd.com/${list.Id}.html" target="_blank"><img src="${pageConfig.FN_GetImageDomain(list.Id)}n5/${list.ImgUrl}" width="50" height="50" alt=""></a></div>		<div class="p-name fl"><a href="http://item.jd.com/${list.Id}.html" title="${list.Name}" target="_blank">${list.Name}</a></div>		<div class="p-detail fr ar">			<span class="p-price"><strong>\uffe5${list.PromotionPrice.toFixed(2)}</strong>\u00d7${list.Num}</span>			<br>          {if parseInt(list.FanPrice)>0}			<span class="hl-green">\u8fd4\u73b0\uff1a\uffe5<em>${list.FanPrice}</em></span>			<br>          {/if}          {if parseInt(list.Score)>0}			<span class="hl-orange">\u9001\u79ef\u5206\uff1a<em>${list.Score}</em></span>			<br>          {/if}			<a class="delete" data-id="${list.Id}" data-type="RemoveProduct" href="#delete">\u5220\u9664</a>		</div>      {for jq in list.CouponAD}      <div class="gift-jq">[\u8d60\u5238] \u8d60\u9001${jq.Jing}\u4eac\u5238 ${jq.LimitAd}</a></div>      {/for}	</li>{/for}</ul>',gift:'<ul id="mcart-gift">{for list in TheGifts}	<li>		<div class="p-img fl"><a href="http://item.jd.com/${list.MainSKU.Id}.html" target="_blank"><img src="${pageConfig.FN_GetImageDomain(list.MainSKU.Id)}n5/${list.MainSKU.ImgUrl}" width="50" height="50" alt=""></a></div>		<div class="p-name fl"><a href="http://item.jd.com/${list.MainSKU.Id}.html" title="${list.MainSKU.Name}" target="_blank">${list.MainSKU.Name}</a></div>		<div class="p-detail fr ar">			<span class="p-price"><strong>\uffe5${list.PromotionPrice.toFixed(2)}</strong>\u00d7${list.Num}</span>			<br>          {if parseInt(list.FanPrice)>0}			<span class="hl-green">\u8fd4\u73b0\uff1a\uffe5<em>${list.FanPrice}</em></span>			<br>          {/if}          {if parseInt(list.Score)>0}			<span class="hl-orange">\u9001\u79ef\u5206\uff1a<em>${list.Score}</em></span>			<br>          {/if}			<a class="delete" data-id="${list.MainSKU.Id}" data-type="RemoveProduct" href="#delete">\u5220\u9664</a>		</div>      {for gift in list.Skus}      <div class="gift"><a href="http://item.jd.com/${gift.Id}.html" target="_blank">[{if gift.Type==2}\u8d60\u54c1{/if}{if gift.Type==1}\u9644\u4ef6{/if}] ${gift.Name}</a></div>      {/for}      {for jq in list.CouponAD}      <div class="gift-jq">[\u8d60\u5238] \u8d60\u9001${jq.Jing}\u5143\u4eac\u5238 ${jq.LimitAd}</a></div>      {/for}	</li>  {/for}</ul>',suit:'{for suit in TheSuit}<ul id="mcart-suit">	<li class="dt">		<div class="fl"><span>[\u5957\u88c5]</span> ${suit.Name}</div>		<div class="fr"><em>\u5c0f\u8ba1\uff1a\uffe5${(suit.PromotionPrice*suit.Num).toFixed(2)}</em></div>		<div class="clr"></div>	</li>  {for list in suit.Skus}	<li>		<div class="p-img fl"><a href="http://item.jd.com/${list.Id}.html" target="_blank"><img src="${pageConfig.FN_GetImageDomain(list.Id)}n5/${list.ImgUrl}" width="50" height="50" alt=""></a></div>		<div class="p-name fl"><span></span><a href="http://item.jd.com/${list.Id}.html" title="${list.Name}" target="_blank">${list.Name}</a></div>		<div class="p-detail fr ar">			<span class="p-price"><strong>\uffe5${list.PromotionPrice.toFixed(2)}</strong>\u00d7${list.Num}</span>			<br>          {if parseInt(list.FanPrice)>0}			<span class="hl-green">\u8fd4\u73b0\uff1a\uffe5<em>${list.FanPrice}</em></span>			<br>          {/if}          {if parseInt(list.Score)>0}			<span class="hl-orange">\u9001\u79ef\u5206\uff1a<em>${list.Score}</em></span>			<br>          {/if}			<a class="delete" data-id="${list.Id}|${suit.Id}" data-type="RemoveSuit" href="#delete">\u5220\u9664</a>		</div>      {for gift in list.Gifts}      <div class="gift"><a href="http://item.jd.com/${gift.Id}.html" target="_blank">[{if gift.Type==2}\u8d60\u54c1{/if}{if gift.Type==1}\u9644\u4ef6{/if}] ${gift.Name}</a></div>      {/for}      {for jq in list.CouponAD}      <div class="gift-jq">[\u8d60\u5238] \u8d60\u9001${jq.Jing}\u5143\u4eac\u5238 ${jq.LimitAd}</a></div>      {/for}	</li>  {/for}</ul>{/for}',mj:'{for mj in ManJian}<ul id="mcart-mj">  <li class="dt">      <div class="fl"><span class="hl-green">\u6ee1\u51cf</span>{if mj.ManFlag} \u5df2\u8d2d\u6ee1${mj.ManPrice}\u5143\uff0c\u5df2\u51cf${mj.JianPrice}\u5143{else}\u8d2d\u6ee1${mj.ManPrice}\u5143\uff0c\u5373\u53ef\u4eab\u53d7\u6ee1\u51cf\u4f18\u60e0{/if}</div>      <div class="fr"><em>\u5c0f\u8ba1\uff1a\uffe5${(mj.PromotionPrice*mj.Num).toFixed(2)}</em></div>      <div class="clr"></div>  </li>  {for list in mj.Skus}  <li>      <div class="p-img fl"><a href="http://item.jd.com/${list.Id}.html" target="_blank"><img src="${pageConfig.FN_GetImageDomain(list.Id)}n5/${list.ImgUrl}" width="50" height="50" alt=""></a></div>      <div class="p-name fl"><span></span><a href="http://item.jd.com/${list.Id}.html" title="${list.Name}" target="_blank">${list.Name}</a></div>      <div class="p-detail fr ar">          <span class="p-price"><strong>\uffe5${list.PromotionPrice.toFixed(2)}</strong>\u00d7${list.Num}</span>          <br>          {if parseInt(list.FanPrice)>0}			<span class="hl-green">\u8fd4\u73b0\uff1a\uffe5<em>${list.FanPrice}</em></span>			<br>          {/if}          {if parseInt(list.Score)>0}			<span class="hl-orange">\u9001\u79ef\u5206\uff1a<em>${list.Score}</em></span>			<br>          {/if}			<a class="delete" data-id="${list.Id}|${mj.Id}" data-type="RemoveSuit" href="#delete">\u5220\u9664</a>      </div>      {for gift in list.Gifts}      <div class="gift"><a href="http://item.jd.com/${gift.Id}.html" target="_blank">[{if gift.Type==2}\u8d60\u54c1{/if}{if gift.Type==1}\u9644\u4ef6{/if}] ${gift.Name}</a></div>      {/for}      {for jq in list.CouponAD}      <div class="gift-jq">[\u8d60\u5238] \u8d60\u9001${jq.Jing}\u5143\u4eac\u5238 ${jq.LimitAd}</a></div>      {/for}  </li>  {/for}</ul>{/for}',mz:'{for mz in ManZeng}<ul id="mcart-mz">	<li class="dt">		<div class="fl"><span class="hl-orange">\u6ee1\u8d60</span>          {if mz.ManFlag}              \u5df2\u8d2d\u6ee1${mz.ManPrice}\u5143\uff0c\u60a8{if mz.ManGifts.length>0}\u5df2{else}\u53ef{/if}\u9886\u8d60\u54c1          {else}              \u8d2d\u6ee1${mz.ManPrice}\u5143\uff0c\u5373\u53ef\u9886\u53d6\u8d60\u54c1          {/if}      </div>		<div class="fr"><em>\u5c0f\u8ba1\uff1a\uffe5${(mz.PromotionPrice*mz.Num).toFixed(2)}</em></div>		<div class="clr"></div>	</li>	{for gift in mz.ManGifts}<li class="dt-mz"><a href="${gift.Id}" target="_blank">[\u8d60\u54c1]${gift.Name}</a>\u00d7${gift.Num}</li>{/for}  {for list in mz.Skus}	<li>		<div class="p-img fl"><a href="http://item.jd.com/${list.Id}.html" target="_blank"><img src="${pageConfig.FN_GetImageDomain(list.Id)}n5/${list.ImgUrl}" width="50" height="50" alt=""></a></div>		<div class="p-name fl"><span></span><a href="http://item.jd.com/${list.Id}.html" title="${list.Name}" target="_blank">${list.Name}</a></div>		<div class="p-detail fr ar">			<span class="p-price"><strong>\uffe5${list.PromotionPrice.toFixed(2)}</strong>\u00d7${list.Num}</span>			<br>          {if parseInt(list.FanPrice)>0}			<span class="hl-green">\u8fd4\u73b0\uff1a\uffe5<em>${list.FanPrice}</em></span>			<br>          {/if}          {if parseInt(list.Score)>0}			<span class="hl-orange">\u9001\u79ef\u5206\uff1a<em>${list.Score}</em></span>			<br>          {/if}			<a class="delete" data-id="${list.Id}|${mz.Id}" data-type="RemoveSuit" href="#delete">\u5220\u9664</a>		</div>      {for gift in list.Gifts}      <div class="gift"><a href="http://item.jd.com/${gift.Id}.html" target="_blank">[{if gift.Type==2}\u8d60\u54c1{/if}{if gift.Type==1}\u9644\u4ef6{/if}] ${gift.Name}</a></div>      {/for}      {for jq in list.CouponAD}      <div class="gift-jq">[\u8d60\u5238] \u8d60\u9001${jq.Jing}\u5143\u4eac\u5238 ${jq.LimitAd}</a></div>      {/for}	</li>  {/for}</ul>{/for}'},FN_BindEvents:function(){var t=this;
$("#settleup-content .delete").bind("click",function(){var e=$(this).attr("data-id").split("|"),i=$(this).attr("data-type"),n={method:i,cartId:e[0]};e&&(e.length>1&&e[1]&&(n.targetId=e[1]),$.ajax({url:MCART.URL_Serv,data:n,dataType:"jsonp",success:function(e){e.Result&&t.FN_Refresh()}}))})},FN_Refresh:function(){var t=document.getElementById("settleup")?$("#settleup dl"):$("#settleup-2013 dl"),e=t.find("dd").eq(0),i=function(t){var i=t.Cart,n=i.TheSkus.length+i.TheSuit.length+i.TheGifts.length+i.ManJian.length+i.ManZeng.length,r=MCART.TPL_List.sigle.process(t.Cart),a=MCART.TPL_List.gift.process(t.Cart),o=MCART.TPL_List.suit.process(t.Cart),s=MCART.TPL_List.mz.process(t.Cart),l=MCART.TPL_List.mj.process(t.Cart);if(n>0?(e.html(MCART.TPL_List.wrap.process(t.Cart)),e.find("#settleup-content .smc").html(r+a+o+l+s),$("#settleup-url").attr("href","http://cart.jd.com/cart/cart.html?r="+ +new Date)):e.html(MCART.TPL_NoGoods),$.browser.msie&&6==$.browser.version){var c=$("#settleup-content");c.before(MCART.TPL_Iframe);var d=$("#settleup-iframe");d.height(c.height())}MCART.FN_BindEvents()};$.ajax({url:MCART.URL_Serv,data:{method:"GetCart"},dataType:"jsonp",success:function(t){i(t)}}),MCART.DATA_Amount=readCookie(MCART.DATA_Cookie),null!=MCART.DATA_Amount&&$("#shopping-amount").html(MCART.DATA_Amount).parent().show()}},NotifyPop={_saleNotify:"http://skunotify."+pageConfig.FN_getDomain()+"/pricenotify.html?",_stockNotify:"http://skunotify."+pageConfig.FN_getDomain()+"/storenotify.html?",init:function(t){var e,i=this,n=this.serializeUrl(location.href),r=/from=weibo/.test(location.href)?location.search.replace(/\?/,""):"";/from=weibo/.test(location.href)&&(e=n.param.type,this.setThickBox(e,r)),t.livequery("click",function(){var t=($(this).attr("id"),$(this).attr("data-type")||2);return i.sku=$(this).attr("data-sku"),i.checkLogin(function(e){e.IsAuthenticated?(i._userPin=e.Name,i.setThickBox(t,r)):(jdModelCallCenter.settings.fn=function(){i.checkLogin(function(e){e.IsAuthenticated&&(i._userPin=e.Name,i.setThickBox(t,r))})},jdModelCallCenter.login())}),!1}).attr("href","#none").removeAttr("target")},serializeUrl:function(t){var e,i,n,r,a=t.indexOf("?"),o=t.substr(0,a),s=t.substr(a+1),l=s.split("&"),c=l.length,d={};for(e=0;c>e;e++)i=l[e].split("="),n=i[0],r=i[1],d[n]=r;return{url:o,param:d}},checkLogin:function(t){"function"==typeof t&&$.getJSON("http://passport."+pageConfig.FN_getDomain()+"/loginservice.aspx?method=Login&callback=?",function(e){e.Identity&&t(e.Identity)})},setThickBox:function(t,e){var i,n,r,a={skuId:this.sku,pin:this._userPin,webSite:1,origin:1,source:1},o=this.serializeUrl(location.href);/blogPin/.test(location.href)&&(a.blogPin=o.param.blogPin),1==t&&(i="\u964d\u4ef7\u901a\u77e5",n=this._saleNotify,r=230),2==t&&(i="\u5230\u8d27\u901a\u77e5",n=this._stockNotify,r=180,a.storeAddressId=readCookie("ipLoc-djd")||"0-0-0"),n+=e?e:$.param(a),$.jdThickBox({type:"iframe",source:decodeURIComponent(n)+"&nocache="+ +new Date,width:500,height:r,title:i,_box:"notify_box",_con:"notify_con",_title:"notify_title"})}};(function(){pageConfig.FN_ImgError(document),$("img[data-lazyload]").Jlazyload({type:"image",placeholderClass:"err-product"}),category.FN_Init(),document.getElementById("shortcut")?$("#shortcut .menu").Jdropdown({delay:50}):($("#biz-service").Jdropdown({delay:50},function(){$.ajax({url:"http://www.jd.com/hotwords.aspx?position=new-index-002",dataType:"script",scriptCharset:"gb2312",cache:!0})}),$("#site-nav").Jdropdown({delay:50},function(){$.ajax({url:"http://www.jd.com/hotwords.aspx?position=new-index-003",dataType:"script",scriptCharset:"gb2312",cache:!0})})),document.getElementById("navitems")?$("#navitems li").Jdropdown():$("#navitems-2013 li").Jdropdown(),$.ajax({url:"http://passport."+pageConfig.FN_getDomain()+"/new/helloService.ashx?m=ls",dataType:"jsonp",scriptCharset:"gb2312",success:function(t){t&&t.info&&$("#loginbar").html(t.info),t&&t.sso&&$.each(t.sso,function(){$.getJSON(this)})}}),document.getElementById("settleup")?(null!=MCART.DATA_Amount&&($("#settleup s").eq(0).addClass("shopping"),$("#shopping-amount").html(MCART.DATA_Amount)),$("#settleup dl").Jdropdown({delay:200},function(){MCART.FN_Refresh(),$("#settleup-url").attr("href","http://cart.jd.com/cart/cart.html?r="+ +new Date)})):(null!=MCART.DATA_Amount&&$("#shopping-amount").html(MCART.DATA_Amount),$("#settleup-2013 dl").Jdropdown({delay:200},function(){MCART.FN_Refresh(),$("#settleup-url").attr("href","http://cart.jd.com/cart/cart.html?r="+ +new Date)}));var t=document.getElementById("my360buy")?$("#my360buy"):$("#my360buy-2013");t.find("dl").Jdropdown({delay:100},function(t){t.attr("load")||$.login({automatic:!1,complete:function(e){if(e){var i=t.find("dd").eq(0),n="",r=readCookie(UC.DATA_Cookie);e.IsAuthenticated?(n+=UC.TPL_Regist.process(e),n+=UC.TPL_OList.placeholder,n+=UC.TPL_UList):(n+=UC.TPL_UnRegist,n+=UC.TPL_UList),r&&(n+=UC.TPL_VList.placeholder),i.html(n),t.attr("load","1"),setTimeout(function(){t.removeAttr("load")},6e4),/\[\{/.test(r)?UC.FN_InitVList(r):UC.FN_InitNewVList(r),UC.FN_InitOList()}}})}),document.onkeyup=function(t){var e=document.activeElement.tagName.toLowerCase();if("input"!=e&&"textarea"!=e){var t=t?t:window.event,i=t.keyCode||t.which;switch(i){case 68:window.pageConfig.clientViewTop||(window.pageConfig.clientViewTop=0),window.pageConfig.clientViewTop+=document.documentElement.clientHeight,window.scrollTo(0,pageConfig.clientViewTop);break;case 83:window.scrollTo(0,0),window.pageConfig.clientViewTop=0,document.getElementById("key").focus();break;case 84:window.scrollTo(0,0),window.pageConfig.clientViewTop=0;break;default:}}}})();var $o=function(){function t(){this.length=0,this.index=-1,this.needCreatedItem=!1,this.iLastModified=0,this.uid=readCookie("pin")||""}var e={};e.replace=function(t,e){return t.replace(/#{(.*?)}/g,function(){var t=arguments[1];return e[t]!==void 0?e[t]:arguments[0]})},String.prototype.trim=function(){return this.replace(/^\s*(.*?)\s*$/,"$1")},String.prototype.isEmpty=function(){return 0==this.length?!0:!1};var i='<a style="color:#005AA0" onclick="$o.del(event)">\u5220\u9664</a>',n="\u641c\u7d22\u5386\u53f2",r='<li id="d_#{id}" suggest-pos="#{suggest_pos}" title="#{title}" onclick="$o.clickItem(this)" history="1"><div class="search-item" style="color:#005AA0">#{keyword}</div><div class="search-count">'+n+"</div></li>",a='<li id="d_#{id}" suggest-pos="#{suggest_pos}" title="#{title}" onclick="$o.clickItem(this)"><div class="search-item">#{keyword}</div><div class="search-count">\u7ea6#{amount}\u4e2a\u5546\u54c1</div></li>',o='<div id="d_#{id}" suggest-pos="#{suggest_pos}" class="#{className}" title="#{title}" cid="#{cid}" cLevel="#{cLevel}" onclick="$o.clickItem(this)"><div class="search-item">\u5728<strong>#{cname}</strong>\u5206\u7c7b\u4e2d\u641c\u7d22</div><div class="search-count">\u7ea6#{amount}\u4e2a\u5546\u54c1</div></div>#{categorys}',s='<li class="fore1"><div id="d_#{id}" suggest-pos="#{suggest_pos}" class="fore1" title="#{title}" onclick="$o.clickItem(this)"><div class="search-item">#{keyword}</div><div class="search-count" #{style}>\u7ea6#{amount}\u4e2a\u5546\u54c1</div></div>#{categorys}</li>',l="http://dd.search.jd.com/?key=#{keyword}&uid=#{uid}",c="#FFDFC6",d="#FFF",u=$("#key"),h=$("#shelper");t.prototype.init=function(){this.length=0,this.index=-1,this.needCreatedItem=!1},t.prototype.hideTip=function(){this.init(),h.html("").hide()},t.prototype.clickItem=function(t){var e=t.getAttribute("cid");search.cid=null!=e&&""!=e?e:null;var i=t.getAttribute("cLevel");search.cLevel=null!=i&&""!=i?i:null;var n=t.getAttribute("ev_val");search.ev_val=null==n||n.trim().isEmpty()?null:n;var r=t.getAttribute("title");null==r||r.trim().isEmpty()||u.val(r),search.additinal="&suggest="+t.getAttribute("suggest-pos"),search("key")},t.prototype.mouseenter=function(t){var t=$(t);if(t.attr("history")&&t.find(".search-count").html(i),t.css("background",c),-1!=this.index&&$.trim(t.attr("id"))){var e=t.attr("id").split("_");if(2==e.length){var n=parseInt(e[1],10);n!=this.index&&($("#d_"+this.index).css("background",d),this.index=n)}}this.needCreatedItem=!0},t.prototype.mouseleave=function(t){t.css("background",d),t.attr("history")&&t.find(".search-count").html(n),this.needCreatedItem=!1},t.prototype.selectItemNode=function(t){var e=this,r=$("#d_"+e.index+":visible");r.css("background-color",d),r.attr("history")&&r.find(".search-count").html(n),e.index=(e.length+e.index+t)%e.length;var a=$("#d_"+e.index);if(a.length>0){a.attr("history")&&a.find(".search-count").html(i),a.css("background-color",c);var o=a.attr("title");null==o||o.trim().isEmpty()||u.val(o);var s=a.attr("cid");search.cid=null!=s&&""!=s?s:null;var l=a.attr("cLevel");search.cLevel=null!=l&&""!=l?l:null,search.ev_val=null,search.additinal="&suggest="+a.attr("suggest-pos")}},t.prototype.input=function(){var t=this,i=u.val().trim();if(""==i)return h.html("").hide(),void 0;var n=e.replace(l,{keyword:encodeURIComponent(i),uid:encodeURIComponent(t.uid)});$.ajax({url:n,dataType:"jsonp",scriptCharset:"utf-8",jsonp:"callback",success:function(e){return function(i){t.iLastModified>e||(t.iLastModified=e,t.onloadItems(i))}}((new Date).getTime())})},t.prototype.keydown_up=function(t){var e=this,i=t||window.event;0==u.length&&(u=$("#key")),0==h.length&&(h=$("tie"));var n=i.keyCode;switch(n){case 38:e.selectItemNode(-1);break;case 40:e.selectItemNode(1);break;case 27:e.hideTip();break;case 37:break;case 39:break;default:$.browser.mozilla||e.input()}},t.prototype.onloadItems=function(t){var i=u.val().trim();if(""==i)return h.html("").hide(),void 0;if(0==t.length)return this.hideTip(),void 0;var n=this;n.init();var l="",c=0;window.pageConfig&&window.pageConfig.searchType&&(c=window.pageConfig.searchType);for(var d=0,p="",f=!1,m=0,g=0,v=t.length;v>g;g++){var b=t[g];if(b){var y=u.val().trim(),_=b.keyword.trim(),w=_.toLowerCase().indexOf(y.toLowerCase()),x=_;if(0==w&&(x=y+"<strong>"+_.substring(w+y.length)+"</strong>"),"string"!=typeof b.cid||b.cid.trim().isEmpty()){var k="";p+=0==b.amount?e.replace(r,{id:m,title:b.keyword,keyword:x,amount:b.amount,suggest_pos:d}):e.replace(a,{id:m,title:b.keyword,keyword:x,amount:b.amount,suggest_pos:d,style:k}),m++,d++}else{if(0==f){f=!0;var k='style="visibility:hidden"',T=0;b.oamount&&b.oamount>0&&(T=b.oamount,k=""),p+=e.replace(s,{id:m,title:b.keyword,keyword:x,amount:T,suggest_pos:d,style:k}),m++,d++}if("string"==typeof b.cname&&b.cname.trim().isEmpty())continue;var j=b.level;if(!j)continue;if(0==c){if("string"==typeof j&&/^[1-8]4$/.test(j))continue}else if(5==c){if("string"==typeof j&&!/^[5-8]2$/.test(j))continue}else if(1==c||2==c||3==c||4==c)continue;var C="item1",I=e.replace(o,{id:m,title:b.keyword,cid:b.cid,cLevel:b.level,className:C,cname:b.cname,amount:b.amount,suggest_pos:d-1});p=e.replace(p,{categorys:I}),m++}}}n.length=m,l=e.replace(p,{categorys:""}),""!=l?(l+='<li class="close" onclick="$o.hideTip()">\u5173\u95ed</li>',h.html(l).show(),h.find('[id^="d_"]').bind("mouseleave",function(){n.mouseleave($(this))}).bind("mouseenter",function(){n.mouseenter($(this))})):h.html("").hide()},t.prototype.bind_input=function(){$.browser.mozilla?(u.bind("keydown",function(t){p.keydown_up(t)}),u.bind("input",function(t){p.input(t)})):u.bind("keyup",function(t){p.keydown_up(t)}),u.blur(function(){p.needCreatedItem||p.hideTip()})},t.prototype.del=function(t){t=t?t:window.event,window.event?(t.cancelBubble=!0,t.returnValue=!1):(t.stopPropagation(),t.preventDefault());var e=$(t.srcElement?t.srcElement:t.target),i=e.parent().parent().attr("title");$.ajax({url:"http://search.jd.com/suggest.php?op=del&callback=?&key="+encodeURIComponent(i),dataType:"jsonp",scriptCharset:"utf-8",success:function(){e.parent().parent().hide()}}),u.focus()};var p=new t;return p.bind_input(),p}();pageConfig.FN_InitSidebar=function(){$("#toppanel").length||$(document.body).prepend('<div class="w ld" id="toppanel"></div>'),$("#toppanel").append('<div id="sidepanel" class="hide"></div>');var t=$("#sidepanel");this.scroll=function(){var e=this;$(window).bind("scroll",function(){var e=document.body.scrollTop||document.documentElement.scrollTop;0==e?t.hide():t.show()}),e.initCss(),$(window).bind("resize",function(){e.initCss()})},this.initCss=function(){var e,i=pageConfig.compatible?1210:990;screen.width>=1210&&(e=$.browser.msie&&6>=$.browser.version?{right:"-26px"}:{right:(document.documentElement.clientWidth-i)/2-26+"px"},t.css(e))},this.addCss=function(e){t.css(e)},this.addItem=function(e){t.append(e)},this.setTop=function(){this.addItem("<a href='#' class='gotop' title='\u4f7f\u7528\u5feb\u6377\u952eT\u4e5f\u53ef\u8fd4\u56de\u9876\u90e8\u54e6\uff01'><b></b>\u8fd4\u56de\u9876\u90e8</a>")}},pageConfig.FN_InitContrast=function(t,e,i){var t=t||"_contrast",i=i||"list",e=e||"http://misc.360buyimg.com/contrast/js/contrast.js?ver="+ +new Date,n=readCookie(t+"_status");return pageConfig.isInitContrast?!1:("show"!=n&&"side"!=n||1!=!!readCookie(t)?$(".btn-compare").bind("click",function(){var n=this.getAttribute("skuid");$.getScript(e,function(){Contrast&&Contrast.init(i,t).showPopWin(n)})}):$.getScript(e,function(){Contrast&&Contrast.init(i,t)}),pageConfig.isInitContrast=1,void 0)};

// http://misc.360buyimg.com/product/js/2012/iplocation_server.js
/*##20130301##*/
var locPageHost = pageConfig.FN_getDomain();
/* 图片滚动 */
var scrollVisible_noitem = pageConfig.wideVersion&&pageConfig.compatible ? 5 : 4,
	scrollVisible_itemover = pageConfig.wideVersion&&pageConfig.compatible ? 6 : 4;

(function(a){a.fn.imgScroll=function(b){return this.each(function(){var e=a.extend({evtType:"click",visible:1,showControl:true,showNavItem:false,navItemEvtType:"click",navItemCurrent:"current",showStatus:false,direction:"x",next:".next",prev:".prev",disableClass:"disabled",speed:300,loop:false,step:1,ie6DisableClass:"disableIE6"},b);var l=a(this),q=l.find("ul"),p=q.find("li"),h=e.width||p.outerWidth(),d=e.height||p.outerHeight(),u=p.length,c=e.visible,j=e.step,i=parseInt((u-c)/j),v=0,m=l.css("position")=="absolute"?"absolute":"relative",x=p.css("float")!=="none",t=a('<div class="scroll-nav-wrap"></div>'),f=e.direction=="x"?"left":"top",k=e.direction=="x",r=typeof e.prev=="string"?a(e.prev):e.prev,s=typeof e.next=="string"?a(e.next):e.next,w=a.browser.isIE6?e.ie6DisableClass:"";e.loop=false;function o(){if(!x){p.css("float","left")}q.css({position:"absolute",left:0,top:0});l.css({position:m,width:e.direction=="x"?c*h:p.outerWidth(),height:e.direction=="x"?d:c*d,overflow:"hidden"});r.addClass(e.disableClass+w);if(e.loop){}else{if((u-c)%j!==0&&u>c){var A=j-(u-c)%j;q.append(p.slice(0,A).clone());u=q.find("li").length;i=parseInt((u-c)/j)}}if(k){q.css("width",u*h)}else{q.css("height",u*d)}if(!e.showControl&&u<=c){s.hide();r.hide()}else{s.show();r.show()}if(u<=c){s.addClass(e.disableClass);r.addClass(e.disableClass)}else{r.addClass(e.disableClass);s.removeClass(e.disableClass)}if(e.showNavItem){for(var y=0;y<=i;y++){var z=y==0?e.navItemCurrent:"";t.append('<em class="'+z+'">'+(y+1)+"</em>")}l.after(t);t.find("em").bind(e.navItemEvtType,function(){var B=parseInt(this.innerHTML);g((B-1)*j)})}if(e.showStatus){l.after('<span class="scroll-status">'+1+"/"+(i+1)+"</span>")}}function g(y){if(q.is(":animated")){return false}if(y<0){r.addClass(e.disableClass+w);return false}if(y+c>u){s.addClass(e.disableClass);return false}v=y;q.animate(e.direction=="x"?{left:-((y)*h)}:{top:-((v)*d)},e.speed,function(){if(y>0){r.removeClass(e.disableClass+w)}else{r.addClass(e.disableClass+w)}if(y+c<u){s.removeClass(e.disableClass)}else{s.addClass(e.disableClass)}n(y)})}function n(y){t.find("em").removeClass(e.navItemCurrent).eq(y/j).addClass(e.navItemCurrent);if(e.showStatus){a(".scroll-status").html(((y/j)+1)+"/"+(i+1))}}o();if(u>c){s.click(function(){g(v+j)});r.click(function(){g(v-j)})}})}}(jQuery));


/* ---------- 埋点公用 ---------- */
function log (type1, type2, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10) {
	var data = '';
	for (i = 2; i < arguments.length; i++) {
		data = data + arguments[i] + '|||';
	}
	var pin = decodeURIComponent(escape(getCookie("pin")));
	var loguri = "http://csc.jd.com/log.ashx?type1=$type1$&type2=$type2$&data=$data$&pin=$pin$&referrer=$referrer$&jinfo=$jinfo$&callback=?";
	var url = loguri.replace(/\$type1\$/, escape(type1));
	url = url.replace(/\$type2\$/, escape(type2));
	url = url.replace(/\$data\$/, escape(data));
	url = url.replace(/\$pin\$/, escape(pin));
	url = url.replace(/\$referrer\$/, escape(document.referrer));
	url = url.replace(/\$jinfo\$/, escape(''));
	$.getJSON(url, function() {});
}
/**
 * 新版-点击流统计-页面pv和显示次数
 * wpid 主商品三级分类，没有为空串''
 * psku 主商品sku，没有为空串''，根据它来判断此商品为pop还是非pop
 * markId 推荐位标记，找张斌要
 * op s:显示、p:pv
 */
function clsPVAndShowLog(wpid, psku, markId, op) {
	var key = wpid + "." + markId + "." + skutype(psku) + "." + op;
	log('d', 'o', key);
}
function clsClickLog(wpid, psku, rsku, markId, num, reCookieName) {
	var key = wpid + "." + markId + "." + skutype(psku);
	appendCookie(reCookieName, rsku, key);
	log('d', 'o', key + ".c");
}
function appendCookie(reCookieName, sku, key) {
	var reWidsCookies = eval('(' + getCookie(reCookieName) + ')');
	if (reWidsCookies == null || reWidsCookies == '') {
		reWidsCookies = new Object();
	}
	if (reWidsCookies[key] == null) {
		reWidsCookies[key] = '';
	}
	var pos = reWidsCookies[key].indexOf(sku);
	if (pos < 0) {
		reWidsCookies[key] = reWidsCookies[key] + "," + sku;
	}
	setCookie(reCookieName, $.toJSON(reWidsCookies), 15);
}
function skutype(sku) {
	if (sku) {
		var len = sku.toString().length;
		return len==10 ? 1 : 0;
	}
	return 0;
}
function setCookie(name, value, date) {
	var Days = date;
	var exp = new Date();
	exp.setTime(exp.getTime() + Days * 24 * 60 * 60 * 1000);
	document.cookie = name + "=" + escape(value) + ";expires=" + exp.toGMTString() + ";path=/;domain=."+locPageHost;
}
function getCookie(name) {
	var arr = document.cookie.match(new RegExp("(^| )" + name + "=([^;]*)(;|$)"));
	if (arr != null) return unescape(arr[2]);
	return null;
}
function reClick(type2, pwid, sku, num) {
	name = "reWids" + type2;
	reWids = getCookie(name);
	if (reWids != null) {
		reWids = reWids.toString();
		var pos = reWids.indexOf(sku);
		if (pos < 0) {
			reWids = reWids + "," + sku;
		}
	}
	else {
		reWids = sku;
	}
	setCookie(name, reWids, 15);

	sku = sku.split("#");
	log(3, type2, sku[0]);
	//log('RC', 'CK', type2, pwid, sku[0], num);
}

function readPinCookie(name) {
	//读取cookies函数
	var arr = document.cookie.match(new RegExp("(^| )" + name + "=([^;]*)(;|$)"));
	if (arr != null) return arr[2];
	return '';
}

/**
 * 点击流统计，调用例如：clsLog("3425&special","","174620#988",4,"reWidsBookSpecial")
 * @param type2 三级分类
 * @param pwid  当前商品wid，没有为空串''
 * @param sku   推荐商品wid
 * @param num   位置，从0开始
 * @param reCookieName   cookieName
 */
function clsLog(type2, pwid, sku, num, reCookieName) {
	var reWidsClubCookies = eval('(' + getCookie(reCookieName) + ')');
	if (reWidsClubCookies == null || reWidsClubCookies == '') {
		reWidsClubCookies = new Object();
	}
	if (reWidsClubCookies[type2] == null) {
		reWidsClubCookies[type2] = '';
	}
	var pos = reWidsClubCookies[type2].indexOf(sku);
	if (pos < 0) {
		reWidsClubCookies[type2] = reWidsClubCookies[type2] + "," + sku;
	}
	setCookie(reCookieName, $.toJSON(reWidsClubCookies), 15);
	sku = sku.split("#");
	log(3, type2, sku[0]);
	//log('RC', 'CK', type2, pwid, sku[0], num);
}
function mark(b,a){ log(1,a,b);}

/* ---------- 埋点公用 end ---------- */

var noItemOver = {
	// 无货、下柜页面推荐列表
	init: function( type ) {

		this.type = type || 1;	//3c为1、日百为2


		this.outOfStockTPL = '<div class="w"><div id="out-of-stock" class="m m2">'
		+'	<div class="mt">'
		+'		<h2>其它类似商品</h2>'
		+'	</div>'
		+'	<div class="mc">'
		+'		<div id="noitem-related-list"><div class="noitem-related-list"><div class="iloading">正在加载中，请稍候...</div></div>'
		+'	</div>'
		+'</div></div>';

		var isNoItem = $('#product-intro').hasClass('product-intro-noitem'),
			isOver = $('#product-intro').hasClass('product-intro-itemover');

		if ( !isNoItem && !isOver ) {

			$('#out-of-stock,#noitem-related-list,#itemover-related-list,#itemover1-related-list').remove();
			return false;
		}

		if ( isNoItem ) {
			this.noItem();
		}
		if ( isOver ) {
			this.itemOver();
		}

	},
	noItem: function( isItemOver ) {
		var imgStr = isItemOver ? '<img height="100" width="100" src="${pageConfig.FN_GetImageDomain(list.skuId)}n4/${list.imgUrl}">' : '<img height="130" width="130" src="${pageConfig.FN_GetImageDomain(list.skuId)}n3/${list.imgUrl}">';
		// 无货推荐列表[老服务]
		var noItem_TPL_OLD = '{for list in html}'
			+'<li class="fore fore${list_index}">'
			+'	<div class="p-img">'
			+'		<a target="_blank" href="${list.skuId}.html">'+imgStr+'</a>'
			+'	</div>'
			+'	<div class="p-name">'
			+'		<a target="_blank" title="${list.name}" href="${list.skuId}.html">${list.Name}</a>'
			+'	</div>'
			+'	<div class="p-price">'
			+'		<strong><img src="http://jprice.360buyimg.com/price/gp${list.skuId}-1-1-1.png" onerror="this.src=\'http://misc.360buyimg.com/lib/skin/e/i/error-3.gif\'" /></strong>'
			+'	</div>'
			+'</li>'
			+'{/for}';

		//无货页面推荐列表
		//http://d.360buy.com/nostockrecomm/get?productId=104410&callback=jsonp
		// 老服务var url = 'http://pbss.360buy.com/recomm/getRecommProduct.action?'+ pageConfig.product.skuid,
		// http://d.360buy.com/nostockrecomm/get?productId=104410

		var url = 'http://d.360buy.com/nostockrecomm/get?productId=' + pageConfig.product.skuid,
			_this = this,
			isItemOver = isItemOver || false;

		// if ( isItemOver ) {
		// 	log( pageConfig.product.cat[2] + '&RemovedArk', 'Show' );
		// } else {
		// 	log( pageConfig.product.cat[0] + "&SORecPage", 'Show');

		// }
		log( pageConfig.product.cat[0] + "&SORecPage", 'Show');

	
		$.ajax({
			url: url,
			dataType: 'jsonp',
			data: {
				productId: pageConfig.product.skuid
			},
			success: function( data ) {

				if ( data && (typeof data.html !== 'undefined') && data.html !== null && data.html.length > 0 ) {
					
					if ( isItemOver ) {
						if ( $('#noitem-related-list').length < 1 ) {
							$('#choose').after('<div id="noitem-related-list"><p>其它类似商品</p><div class="noitem-related-list"><div class="iloading">正在加载中，请稍候...</div></div>');
						} else {
							$('#itemover-related-list').show();
						}						
					} else {
						if ( $('#out-of-stock').length < 1 ) {
							$('#product-intro').parent().after(_this.outOfStockTPL);
						} else {
							$('#out-of-stock').show();
						}						
					}


					$('#noitem-related-list .noitem-related-list').html( '<a href="javascript:;" class="spec-control disabled" id="noitem-forward"></a><a href="javascript:;" class="spec-control" id="noitem-backward"></a><div id="noitem-list"><ul>' + noItem_TPL_OLD.process( data ) + '</ul></div>' );
					$('#noitem-related-list').attr('loaded', 'true');


					//图片滚动【无货页面】 
					$('#noitem-list').imgScroll({
						visible: scrollVisible_itemover,
						showControl: true,
						speed: 200,
						step: scrollVisible_itemover,
						loop: false,
						prev: '#noitem-forward',
						next: '#noitem-backward',
						disableClass: 'disabled'
					});

				} else if ( !data || data.html == null || data.html.length < 1 ) {
					_this.noItemNoData(isItemOver);
				}
			}
		});
	},
	itemOver: function() {
		// 浏览了 - 还浏览3c
		var listBrosweBroswe_TPL = '<li onclick="reClick(1, '+pageConfig.product.skuid+',\'${wid}#${wmeprice}\', [#]);">'
			+'	<div class="p-img">'
			+'		<a target="_blank" title="${name}" href="${wid}.html"><img height="100" width="100" alt="${name}" src="${pageConfig.FN_GetImageDomain(wid)}n4/${imgurl}"></a>'
			+'	</div>'
			+'	<div class="p-name">'
			+'		<a target="_blank" title="${name}" href="${wid}.html">${name}</a>'
			+'	</div>'
			+'	<div class="p-price">'
			+'		<strong>'
			+'			<img src="http://jprice.360buyimg.com/price/gp${wid}-1-1-1.png" onerror="this.src=\'http://misc.360buyimg.com/lib/skin/e/i/error-3.gif\'" />'
			+'		</strong>'
			+'	</div>'
			+'</li>';

		var urlRelated = 'http://simigoods.jd.com/SoldOutRecJsonData.aspx?ip='+ getCookie("ipLocation") +'&wids='+ pageConfig.product.skuid;
		var urlBroswerBuy = 'http://simigoods.jd.com/ThreeCCombineBuying/ThreeCBroswerBroswerJsonData.aspx?ip=' + getCookie('ipLocation') + '&wids=' + pageConfig.product.skuid;
		var _this = this;

		_this.noItem( true );



		//下柜页看了还买了
		$.ajax({
			url: urlBroswerBuy,
			dataType: 'jsonp',
			success: function(data) {
				var resHTML = [];
				
				//log('RemovedArk', 'Show');
				log('R1','Show');
				
				if ( data == null ) {
					return false;
				}
				for ( var i = 0; i < data.length; i++ ) {
					resHTML.push( listBrosweBroswe_TPL.process(data[i]).replace('[#]', i) );
				}
				$('#itemover1-related-list').show();
				$('#itemover1-related-list .itemover1-related-list').html( '<a href="javascript:;" class="spec-control disabled" id="itemover1-forward"></a><a href="javascript:;" class="spec-control disabled" id="itemover1-backward"></a><div id="itemover1-list"><ul>' + resHTML.join('') + '</ul></div>' );

				//图片滚动【下柜页面-看了还买了】
				$('#itemover1-list').imgScroll({
					visible: scrollVisible_itemover,
					showControl: false,
					speed: 200,
					step: scrollVisible_itemover,
					loop: false,
					prev: '#itemover1-forward',
					next: '#itemover1-backward',
					disableClass: 'disabled',
					width: 130,
					height:165
				});
			}
		});
	},
	noItemNoData: function( isItemOver ) {
		var imgStr = isItemOver ? '<img height="100" width="100" src="${pageConfig.FN_GetImageDomain(list.wid)}n4/${list.imgurl}">' : '<img height="130" width="130" src="${pageConfig.FN_GetImageDomain(list.wid)}n3/${list.imgurl}">';
		// 无货推荐列表[新服务]
		var noItem_TPL = '{for list in MySoldOut}'
			+'<li class="fore fore${list_index}" onclick="reClick2(\''+pageConfig.product.cat[0]+'&SORec\','+pageConfig.product.skuid+', \'${list.wid}#${list.wmeprice}\', ${list_index})">'
			+'	<div class="p-img">'
			+'		<a target="_blank" href="${list.wid}.html">'+imgStr+'</a>'
			+'	</div>'
			+'	<div class="p-name">'
			+'		<a target="_blank" title="${list.name}" href="${list.wid}.html">${list.name}</a>'
			+'	</div>'
			+'	<div class="p-price">'
			+'		<strong><img src="http://jprice.360buyimg.com/price/gp${list.wid}-1-1-1.png" onerror="this.src=\'http://misc.360buyimg.com/lib/skin/e/i/error-3.gif\'" /></strong>'
			+'	</div>'
			+'</li>'
			+'{/for}';

		// 没有推荐数据时调用新数据接口
		var url = 'http://simigoods.jd.com/SoldOutRecJsonData.aspx?ip='+ getCookie("ipLocation") +'&wids='+ pageConfig.product.skuid,
			_this = this;

		$.ajax({
			url: url,
			dataType: 'jsonp',
			success: function(data) {

				if ( data.MySoldOut !== null && data !== null ) {

					if ( isItemOver ) {
						if ( $('#noitem-related-list').length < 1 ) {
							$('#choose').after('<div id="noitem-related-list"><p>其它类似商品</p><div class="noitem-related-list"><div class="iloading">正在加载中，请稍候...</div></div>');
						}
					} else {
						if ( $('#out-of-stock').length < 1 ) {
							$('#product-intro').parent().after(_this.outOfStockTPL);
						} else {
							$('#out-of-stock').show();
						}
					}

					log(pageConfig.product.cat[0] + "&SORec", 'Show');


					$('#noitem-related-list').attr('iplocation', getCookie("ipLocation"));

					if ( isItemOver ) {
						$('#itemover-related-list').show().find('.itemover-related-list').html('<a href="javascript:;" class="spec-control disabled" id="itemover-forward"></a><a href="javascript:;" class="spec-control disabled" id="itemover-backward"></a><div id="itemover-list"><ul>' + noItem_TPL.process(data) + '</ul></div>');

						//图片滚动【下柜页面-其它类似商品】
						$('#itemover-list').imgScroll({
							visible: scrollVisible_itemover,
							showControl: true,
							speed: 200,
							step: scrollVisible_itemover,
							loop: false,
							prev: '#itemover-forward',
							next: '#itemover-backward',
							disableClass: 'disabled',
							width: 130,
							height:165
						});


					} else {
						$('#noitem-related-list .noitem-related-list').html( '<a href="javascript:;" class="spec-control disabled" id="noitem-forward"></a><a href="javascript:;" class="spec-control" id="noitem-backward"></a><div id="noitem-list"><ul>' + noItem_TPL.process(data) + '</ul></div>' );	
						
						//图片滚动【无货页面】
						$('#noitem-list').imgScroll({
							visible: scrollVisible_noitem,
							showControl: true,
							speed: 200,
							step: scrollVisible_noitem,
							loop: false,
							prev: '#noitem-forward',
							next: '#noitem-backward',
							disableClass: 'disabled'
						});
					}
				}		

			}
		});
	}

};
var iplocation = {"北京": { id: "1", root: 0, djd: 1,c:72 },"上海": { id: "2", root: 1, djd: 1,c:78 },"天津": { id: "3", root: 0, djd: 1,c:51035 },"重庆": { id: "4", root: 3, djd: 1,c:113 },"河北": { id: "5", root: 0, djd: 1,c:142 },"山西": { id: "6", root: 0, djd: 1,c:303 },"河南": { id: "7", root: 0, djd: 1,c:412 },"辽宁": { id: "8", root: 0, djd: 1,c:560 },"吉林": { id: "9", root: 0, djd: 1,c:639 },"黑龙江": { id: "10", root: 0, djd: 1,c:698 },"内蒙古": { id: "11", root: 0, djd: 0,c:799 },"江苏": { id: "12", root: 1, djd: 1,c:904 },"山东": { id: "13", root: 0, djd: 1,c:1000 },"安徽": { id: "14", root: 1, djd: 1,c:1116 },"浙江": { id: "15", root: 1, djd: 1,c:1158 },"福建": { id: "16", root: 2, djd: 1,c:1303 },"湖北": { id: "17", root: 0, djd: 1,c:1381 },"湖南": { id: "18", root: 2, djd: 1,c:1482 },"广东": { id: "19", root: 2, djd: 1,c:1601 },"广西": { id: "20", root: 2, djd: 1,c:1715 },"江西": { id: "21", root: 2, djd: 1,c:1827 },"四川": { id: "22", root: 3, djd: 1,c:1930 },"海南": { id: "23", root: 2, djd: 1,c:2121 },"贵州": { id: "24", root: 3, djd: 1,c:2144 },"云南": { id: "25", root: 3, djd: 1,c:2235 },"西藏": { id: "26", root: 3, djd: 0,c:2951 },"陕西": { id: "27", root: 3, djd: 1,c:2376 },"甘肃": { id: "28", root: 3, djd: 1,c:2487 },"青海": { id: "29", root: 3, djd: 0,c:2580 },"宁夏": { id: "30", root: 3, djd: 1,c:2628 },"新疆": { id: "31", root: 3, djd: 0,c:2652 },"台湾": { id: "32", root: 2, djd: 0,c:2768 },"香港": { id: "42", root: 2, djd: 0,c:2754 },"澳门": { id: "43", root: 2, djd: 0,c:2770 },"钓鱼岛": { id: "84", root: 2, djd: 0,c:84 }};
var provinceCityJson = {"1":[{"id":72,"name":"朝阳区"},{"id":2800,"name":"海淀区"},{"id":2801,"name":"西城区"},{"id":2802,"name":"东城区"},{"id":2803,"name":"崇文区"},{"id":2804,"name":"宣武区"},{"id":2805,"name":"丰台区"},{"id":2806,"name":"石景山区"},{"id":2807,"name":"门头沟"},{"id":2808,"name":"房山区"},{"id":2809,"name":"通州区"},{"id":2810,"name":"大兴区"},{"id":2812,"name":"顺义区"},{"id":2814,"name":"怀柔区"},{"id":2816,"name":"密云区"},{"id":2901,"name":"昌平区"},{"id":2953,"name":"平谷区"},{"id":3065,"name":"延庆县"}],"2":[{"id":2811,"name":"卢湾区"},{"id":2813,"name":"徐汇区"},{"id":2815,"name":"长宁区"},{"id":2817,"name":"静安区"},{"id":2820,"name":"闸北区"},{"id":2822,"name":"虹口区"},{"id":2823,"name":"杨浦区"},{"id":2824,"name":"宝山区"},{"id":2825,"name":"闵行区"},{"id":2826,"name":"嘉定区"},{"id":2830,"name":"浦东新区"},{"id":2833,"name":"青浦区"},{"id":2834,"name":"松江区"},{"id":2835,"name":"金山区"},{"id":2836,"name":"南汇区"},{"id":2837,"name":"奉贤区"},{"id":2841,"name":"普陀区"},{"id":2919,"name":"崇明县"},{"id":78,"name":"黄浦区"}],"3":[{"id":51035,"name":"东丽区"},{"id":51036,"name":"和平区"},{"id":51037,"name":"河北区"},{"id":51038,"name":"河东区"},{"id":51039,"name":"河西区"},{"id":51040,"name":"红桥区"},{"id":51041,"name":"蓟县"},{"id":51042,"name":"静海县"},{"id":51043,"name":"南开区"},{"id":51044,"name":"塘沽区"},{"id":51045,"name":"西青区"},{"id":51046,"name":"武清区"},{"id":51047,"name":"津南区"},{"id":51048,"name":"汉沽区"},{"id":51049,"name":"大港区"},{"id":51050,"name":"北辰区"},{"id":51051,"name":"宝坻区"},{"id":51052,"name":"宁河县"}],"4":[{"id":113,"name":"万州区"},{"id":114,"name":"涪陵区"},{"id":115,"name":"梁平县"},{"id":119,"name":"南川区"},{"id":123,"name":"潼南县"},{"id":126,"name":"大足区"},{"id":128,"name":"黔江区"},{"id":129,"name":"武隆县"},{"id":130,"name":"丰都县"},{"id":131,"name":"奉节县"},{"id":132,"name":"开县"},{"id":133,"name":"云阳县"},{"id":134,"name":"忠县"},{"id":135,"name":"巫溪县"},{"id":136,"name":"巫山县"},{"id":137,"name":"石柱县"},{"id":138,"name":"彭水县"},{"id":139,"name":"垫江县"},{"id":140,"name":"酉阳县"},{"id":141,"name":"秀山县"},{"id":48131,"name":"璧山县"},{"id":48132,"name":"荣昌县"},{"id":48133,"name":"铜梁县"},{"id":48201,"name":"合川区"},{"id":48202,"name":"巴南区"},{"id":48203,"name":"北碚区"},{"id":48204,"name":"江津区"},{"id":48205,"name":"渝北区"},{"id":48206,"name":"长寿区"},{"id":48207,"name":"永川区"},{"id":50950,"name":"江北区"},{"id":50951,"name":"南岸区"},{"id":50952,"name":"九龙坡区"},{"id":50953,"name":"沙坪坝区"},{"id":50954,"name":"大渡口区"},{"id":50995,"name":"綦江区"},{"id":51026,"name":"渝中区"},{"id":51027,"name":"高新区"},{"id":51028,"name":"北部新区"},{"id":4164,"name":"城口县"},{"id":3076,"name":"高新区"}],"5":[{"id":142,"name":"石家庄市"},{"id":148,"name":"邯郸市"},{"id":164,"name":"邢台市"},{"id":199,"name":"保定市"},{"id":224,"name":"张家口市"},{"id":239,"name":"承德市"},{"id":248,"name":"秦皇岛市"},{"id":258,"name":"唐山市"},{"id":264,"name":"沧州市"},{"id":274,"name":"廊坊市"},{"id":275,"name":"衡水市"}],"6":[{"id":303,"name":"太原市"},{"id":309,"name":"大同市"},{"id":318,"name":"阳泉市"},{"id":325,"name":"晋城市"},{"id":330,"name":"朔州市"},{"id":336,"name":"晋中市"},{"id":350,"name":"忻州市"},{"id":368,"name":"吕梁市"},{"id":379,"name":"临汾市"},{"id":398,"name":"运城市"},{"id":3074,"name":"长治市"}],"7":[{"id":412,"name":"郑州市"},{"id":420,"name":"开封市"},{"id":427,"name":"洛阳市"},{"id":438,"name":"平顶山市"},{"id":446,"name":"焦作市"},{"id":454,"name":"鹤壁市"},{"id":458,"name":"新乡市"},{"id":468,"name":"安阳市"},{"id":475,"name":"濮阳市"},{"id":482,"name":"许昌市"},{"id":489,"name":"漯河市"},{"id":495,"name":"三门峡市"},{"id":502,"name":"南阳市"},{"id":517,"name":"商丘市"},{"id":527,"name":"周口市"},{"id":538,"name":"驻马店市"},{"id":549,"name":"信阳市"},{"id":2780,"name":"济源市"}],"8":[{"id":560,"name":"沈阳市"},{"id":573,"name":"大连市"},{"id":579,"name":"鞍山市"},{"id":584,"name":"抚顺市"},{"id":589,"name":"本溪市"},{"id":593,"name":"丹东市"},{"id":598,"name":"锦州市"},{"id":604,"name":"葫芦岛市"},{"id":609,"name":"营口市"},{"id":613,"name":"盘锦市"},{"id":617,"name":"阜新市"},{"id":621,"name":"辽阳市"},{"id":632,"name":"朝阳市"},{"id":6858,"name":"铁岭市"}],"9":[{"id":639,"name":"长春市"},{"id":644,"name":"吉林市"},{"id":651,"name":"四平市"},{"id":2992,"name":"辽源市"},{"id":657,"name":"通化市"},{"id":664,"name":"白山市"},{"id":674,"name":"松原市"},{"id":681,"name":"白城市"},{"id":687,"name":"延边州"}],"10":[{"id":727,"name":"鹤岗市"},{"id":731,"name":"双鸭山市"},{"id":737,"name":"鸡西市"},{"id":742,"name":"大庆市"},{"id":753,"name":"伊春市"},{"id":757,"name":"牡丹江市"},{"id":765,"name":"佳木斯市"},{"id":773,"name":"七台河市"},{"id":776,"name":"黑河市"},{"id":782,"name":"绥化市"},{"id":793,"name":"大兴安岭地区"},{"id":698,"name":"哈尔滨市"},{"id":712,"name":"齐齐哈尔市"}],"11":[{"id":799,"name":"呼和浩特市"},{"id":805,"name":"包头市"},{"id":810,"name":"乌海市"},{"id":812,"name":"赤峰市"},{"id":823,"name":"乌兰察布市"},{"id":835,"name":"锡林郭勒盟"},{"id":848,"name":"呼伦贝尔市"},{"id":870,"name":"鄂尔多斯市"},{"id":880,"name":"巴彦淖尔市"},{"id":891,"name":"阿拉善盟"},{"id":895,"name":"兴安盟"},{"id":902,"name":"通辽市"}],"12":[{"id":904,"name":"南京市"},{"id":911,"name":"徐州市"},{"id":919,"name":"连云港市"},{"id":925,"name":"淮安市"},{"id":933,"name":"宿迁市"},{"id":939,"name":"盐城市"},{"id":951,"name":"扬州市"},{"id":959,"name":"泰州市"},{"id":965,"name":"南通市"},{"id":972,"name":"镇江市"},{"id":978,"name":"常州市"},{"id":984,"name":"无锡市"},{"id":988,"name":"苏州市"}],"13":[{"id":2900,"name":"济宁市"},{"id":1000,"name":"济南市"},{"id":1007,"name":"青岛市"},{"id":1016,"name":"淄博市"},{"id":1022,"name":"枣庄市"},{"id":1025,"name":"东营市"},{"id":1032,"name":"潍坊市"},{"id":1042,"name":"烟台市"},{"id":1053,"name":"威海市"},{"id":1058,"name":"莱芜市"},{"id":1060,"name":"德州市"},{"id":1072,"name":"临沂市"},{"id":1081,"name":"聊城市"},{"id":1090,"name":"滨州市"},{"id":1099,"name":"菏泽市"},{"id":1108,"name":"日照市"},{"id":1112,"name":"泰安市"}],"14":[{"id":1151,"name":"黄山市"},{"id":1159,"name":"滁州市"},{"id":1167,"name":"阜阳市"},{"id":1174,"name":"亳州市"},{"id":1180,"name":"宿州市"},{"id":1201,"name":"池州市"},{"id":1206,"name":"六安市"},{"id":2971,"name":"宣城市"},{"id":1114,"name":"铜陵市"},{"id":1116,"name":"合肥市"},{"id":1121,"name":"淮南市"},{"id":1124,"name":"淮北市"},{"id":1127,"name":"芜湖市"},{"id":1132,"name":"蚌埠市"},{"id":1137,"name":"马鞍山市"},{"id":1140,"name":"安庆市"}],"15":[{"id":1158,"name":"宁波市"},{"id":1273,"name":"衢州市"},{"id":1280,"name":"丽水市"},{"id":1290,"name":"台州市"},{"id":1298,"name":"舟山市"},{"id":1213,"name":"杭州市"},{"id":1233,"name":"温州市"},{"id":1243,"name":"嘉兴市"},{"id":1250,"name":"湖州市"},{"id":1255,"name":"绍兴市"},{"id":1262,"name":"金华市"}],"16":[{"id":1303,"name":"福州市"},{"id":1315,"name":"厦门市"},{"id":1317,"name":"三明市"},{"id":1329,"name":"莆田市"},{"id":1332,"name":"泉州市"},{"id":1341,"name":"漳州市"},{"id":1352,"name":"南平市"},{"id":1362,"name":"龙岩市"},{"id":1370,"name":"宁德市"}],"17":[{"id":1432,"name":"孝感市"},{"id":1441,"name":"黄冈市"},{"id":1458,"name":"咸宁市"},{"id":1466,"name":"恩施州"},{"id":1475,"name":"鄂州市"},{"id":1477,"name":"荆门市"},{"id":1479,"name":"随州市"},{"id":3154,"name":"神农架林区"},{"id":1381,"name":"武汉市"},{"id":1387,"name":"黄石市"},{"id":1396,"name":"襄阳市"},{"id":1405,"name":"十堰市"},{"id":1413,"name":"荆州市"},{"id":1421,"name":"宜昌市"},{"id":2922,"name":"潜江市"},{"id":2980,"name":"天门市"},{"id":2983,"name":"仙桃市"}],"18":[{"id":4250,"name":"耒阳市"},{"id":1482,"name":"长沙市"},{"id":1488,"name":"株洲市"},{"id":1495,"name":"湘潭市"},{"id":1499,"name":"韶山市"},{"id":1501,"name":"衡阳市"},{"id":1511,"name":"邵阳市"},{"id":1522,"name":"岳阳市"},{"id":1530,"name":"常德市"},{"id":1540,"name":"张家界市"},{"id":1544,"name":"郴州市"},{"id":1555,"name":"益阳市"},{"id":1560,"name":"永州市"},{"id":1574,"name":"怀化市"},{"id":1586,"name":"娄底市"},{"id":1592,"name":"湘西州"}],"19":[{"id":1601,"name":"广州市"},{"id":1607,"name":"深圳市"},{"id":1609,"name":"珠海市"},{"id":1611,"name":"汕头市"},{"id":1617,"name":"韶关市"},{"id":1627,"name":"河源市"},{"id":1634,"name":"梅州市"},{"id":1709,"name":"揭阳市"},{"id":1643,"name":"惠州市"},{"id":1650,"name":"汕尾市"},{"id":1655,"name":"东莞市"},{"id":1657,"name":"中山市"},{"id":1659,"name":"江门市"},{"id":1666,"name":"佛山市"},{"id":1672,"name":"阳江市"},{"id":1677,"name":"湛江市"},{"id":1684,"name":"茂名市"},{"id":1690,"name":"肇庆市"},{"id":1698,"name":"云浮市"},{"id":1704,"name":"清远市"},{"id":1705,"name":"潮州市"}],"20":[{"id":3168,"name":"崇左市"},{"id":1715,"name":"南宁市"},{"id":1720,"name":"柳州市"},{"id":1726,"name":"桂林市"},{"id":1740,"name":"梧州市"},{"id":1746,"name":"北海市"},{"id":1749,"name":"防城港市"},{"id":1753,"name":"钦州市"},{"id":1757,"name":"贵港市"},{"id":1761,"name":"玉林市"},{"id":1792,"name":"贺州市"},{"id":1806,"name":"百色市"},{"id":1818,"name":"河池市"},{"id":3044,"name":"来宾市"}],"21":[{"id":1827,"name":"南昌市"},{"id":1832,"name":"景德镇市"},{"id":1836,"name":"萍乡市"},{"id":1842,"name":"新余市"},{"id":1845,"name":"九江市"},{"id":1857,"name":"鹰潭市"},{"id":1861,"name":"上饶市"},{"id":1874,"name":"宜春市"},{"id":1885,"name":"抚州市"},{"id":1898,"name":"吉安市"},{"id":1911,"name":"赣州市"}],"22":[{"id":2103,"name":"凉山州"},{"id":1930,"name":"成都市"},{"id":1946,"name":"自贡市"},{"id":1950,"name":"攀枝花市"},{"id":1954,"name":"泸州市"},{"id":1960,"name":"绵阳市"},{"id":1962,"name":"德阳市"},{"id":1977,"name":"广元市"},{"id":1983,"name":"遂宁市"},{"id":1988,"name":"内江市"},{"id":1993,"name":"乐山市"},{"id":2005,"name":"宜宾市"},{"id":2016,"name":"广安市"},{"id":2022,"name":"南充市"},{"id":2033,"name":"达州市"},{"id":2042,"name":"巴中市"},{"id":2047,"name":"雅安市"},{"id":2058,"name":"眉山市"},{"id":2065,"name":"资阳市"},{"id":2070,"name":"阿坝州"},{"id":2084,"name":"甘孜州"}],"23":[{"id":3690,"name":"三亚市"},{"id":3698,"name":"文昌市"},{"id":3699,"name":"五指山市"},{"id":3701,"name":"临高县"},{"id":3702,"name":"澄迈县"},{"id":3703,"name":"定安县"},{"id":3704,"name":"屯昌县"},{"id":3705,"name":"昌江县"},{"id":3706,"name":"白沙县"},{"id":3707,"name":"琼中县"},{"id":3708,"name":"陵水县"},{"id":3709,"name":"保亭县"},{"id":3710,"name":"乐东县"},{"id":3711,"name":"三沙市"},{"id":2121,"name":"海口市"},{"id":3115,"name":"琼海市"},{"id":3137,"name":"万宁市"},{"id":3173,"name":"东方市"},{"id":3034,"name":"儋州市"}],"24":[{"id":2144,"name":"贵阳市"},{"id":2150,"name":"六盘水市"},{"id":2155,"name":"遵义市"},{"id":2169,"name":"铜仁市"},{"id":2180,"name":"毕节市"},{"id":2189,"name":"安顺市"},{"id":2196,"name":"黔西南州"},{"id":2205,"name":"黔东南州"},{"id":2222,"name":"黔南州"}],"25":[{"id":4108,"name":"迪庆州"},{"id":2235,"name":"昆明市"},{"id":2247,"name":"曲靖市"},{"id":2258,"name":"玉溪市"},{"id":2270,"name":"昭通市"},{"id":2281,"name":"普洱市"},{"id":2291,"name":"临沧市"},{"id":2298,"name":"保山市"},{"id":2304,"name":"丽江市"},{"id":2309,"name":"文山州"},{"id":2318,"name":"红河州"},{"id":2332,"name":"西双版纳州"},{"id":2336,"name":"楚雄州"},{"id":2347,"name":"大理州"},{"id":2360,"name":"德宏州"},{"id":2366,"name":"怒江州"}],"26":[{"id":3970,"name":"阿里地区"},{"id":3971,"name":"林芝地区"},{"id":2951,"name":"拉萨市"},{"id":3107,"name":"那曲地区"},{"id":3129,"name":"山南地区"},{"id":3138,"name":"昌都地区"},{"id":3144,"name":"日喀则地区"}],"27":[{"id":2428,"name":"延安市"},{"id":2442,"name":"汉中市"},{"id":2454,"name":"榆林市"},{"id":2468,"name":"商洛市"},{"id":2476,"name":"安康市"},{"id":2376,"name":"西安市"},{"id":2386,"name":"铜川市"},{"id":2390,"name":"宝鸡市"},{"id":2402,"name":"咸阳市"},{"id":2416,"name":"渭南市"}],"28":[{"id":2525,"name":"庆阳市"},{"id":2534,"name":"陇南市"},{"id":2544,"name":"武威市"},{"id":2549,"name":"张掖市"},{"id":2556,"name":"酒泉市"},{"id":2564,"name":"甘南州"},{"id":2573,"name":"临夏州"},{"id":3080,"name":"定西市"},{"id":2487,"name":"兰州市"},{"id":2492,"name":"金昌市"},{"id":2495,"name":"白银市"},{"id":2501,"name":"天水市"},{"id":2509,"name":"嘉峪关市"},{"id":2518,"name":"平凉市"}],"29":[{"id":2580,"name":"西宁市"},{"id":2585,"name":"海东地区"},{"id":2592,"name":"海北州"},{"id":2597,"name":"黄南州"},{"id":2603,"name":"海南州"},{"id":2605,"name":"果洛州"},{"id":2612,"name":"玉树州"},{"id":2620,"name":"海西州"}],"30":[{"id":2628,"name":"银川市"},{"id":2632,"name":"石嘴山市"},{"id":2637,"name":"吴忠市"},{"id":2644,"name":"固原市"},{"id":3071,"name":"中卫市"}],"31":[{"id":4110,"name":"五家渠市"},{"id":4163,"name":"博尔塔拉蒙古自治州阿拉山口口岸"},{"id":15945,"name":"阿拉尔市"},{"id":15946,"name":"图木舒克市"},{"id":2652,"name":"乌鲁木齐市"},{"id":2654,"name":"克拉玛依市"},{"id":2656,"name":"石河子市"},{"id":2658,"name":"吐鲁番地区"},{"id":2662,"name":"哈密地区"},{"id":2666,"name":"和田地区"},{"id":2675,"name":"阿克苏地区"},{"id":2686,"name":"喀什地区"},{"id":2699,"name":"克孜勒苏州"},{"id":2704,"name":"巴音郭楞州"},{"id":2714,"name":"昌吉州"},{"id":2723,"name":"博尔塔拉州"},{"id":2727,"name":"伊犁州"},{"id":2736,"name":"塔城地区"},{"id":2744,"name":"阿勒泰地区"}],"32":[{"id":2768,"name":"台湾市"}],"42":[{"id":2754,"name":"香港特别行政区"}],"43":[{"id":2770,"name":"澳门市"}],"84":[{"id":1310,"name":"钓鱼岛"}]};
var cName = "ipLocation";
var currentLocation = "北京";
var stockServiceDomain = "http://st.3.cn";
try{if(location.href.indexOf("localtest=true")>0)stockServiceDomain = "http://webstock.jd.com";}catch(e){}
//cookie operate
function getCookie(name) {var arr = document.cookie.match(new RegExp("(^| )" + name + "=([^;]*)(;|$)"));if (arr != null) return unescape(arr[2]);return null;}
function setNewCookie(name,value,expires,path,domain,secure){if(!path){path="/"}if(!domain){domain="jd.com"}if(!secure){secure=false}var today=new Date();today.setTime(today.getTime());if(expires){expires=expires*1000*60*60*24}var expires_date=new Date(today.getTime()+(expires));document.cookie=name+'='+escape(value)+((expires)?';expires='+expires_date.toGMTString():'')+((path)?';path='+path:'')+((domain)?';domain='+domain:'')+((secure)?';secure':'')};function deleteCookie(name,path,domain){if(getCookie(name))document.cookie=name+'='+((path)?';path='+path:'')+((domain)?';domain='+domain:'')+';expires=Thu, 01-Jan-1970 00:00:01 GMT'};
if(warestatus!=1){
	$("#product-intro").attr("class","product-intro-itemover");
	$('#out-of-stock,#noitem-related-list').remove();
}
$.pbuyurl="";
$.haveShow=0;$._ptload=false;$._ptloadcon="";$.easybuy_button=$("#choose-btn-easybuy");$.divide_button=$("#choose-btn-divide");$.notice_button=$("#choose-btn-notice");$.append_button=$("#choose-btn-append .btn-append");
$.getShopUrl=function(r){if(r.url)return r.url;return "http://mall.jd.com/index-"+r.id+".html";};
var openCheck = pageConfig.product.cat[2]==798||pageConfig.product.cat[2]==878||pageConfig.product.cat[2]==880;
$.getDeliver = function(p){
	var r=p.D;
	if(pageConfig.product.skuid<1000000000){
		$("#summary-service").html("").show();
		if (p.PopType==999){
			$("<div class='dt'>服\u3000\u3000务：</div><div class='dd'>由厂家提供和配送。</div>").appendTo("#summary-service");
		}else{
			var upenCheckStr = "";
			if (p.code==1&&openCheck){
				upenCheckStr = "，支持货到付款、开箱验机";
			}
			$("<div class='dt'>服\u3000\u3000务：</div><div class='dd'>由 京东商城 发货并提供售后服务"+upenCheckStr+"。</div>").appendTo("#summary-service");
		}
	}
	if (pageConfig.product.skuid>1000000000){	
		if (pageConfig.product.isChangeSku||($.haveShow==0&&!currentVenderInfoJson)){
			$.haveShow=1;
			$.getJSONP(stockServiceDomain+"/gvi.html?callback=showVenderServiceInfo&type=popdeliver&skuid="+pageConfig.product.skuid);
		}
		else{
			showVenderServiceInfo(currentVenderInfoJson);
		}
	}
};
function getDeliveCash(r){
	if(r){
		if(r.dtype == 0&&new Number(r.dcash)>0){
			$("#store-prompt span").html("，运费："+r.dcash);
		}
		else if(r.dtype == 1&&new Number(r.dcash)>0&&new Number(r.ordermin)>0){
			$("#store-prompt span").html("，店铺单笔订单不满"+r.ordermin+"，收运费："+r.dcash);
		}
	}
}
function showVenderServiceInfo(r){		
	if (r){
		if(!r.deliver)r.deliver=r.vender;
		currentVenderInfoJson = r;
		var unshowtypes = "0,1,2,4,5";
		if (unshowtypes.indexOf(r.type) != -1){
				if($("#summary-service").length==0){$("<li id='summary-service'></li>").insertAfter("#summary-stock");}
				$("#summary-service").html("");
				var key=r.id+"_"+r.type;
				var dfinfo=(r.vid.length!=7&&r.df&&r.df!="null")?("从 "+r.df+" "):"负责";
				if(r.type==0){
					$.getJSONP("http://rms.shop.jd.com/json/pop/dcash.action?venderID="+r.vid+"&areaID="+currentAreaInfo.currentProvinceId+"&callback=getDeliveCash");
					$("<div class='dt'>服\u3000\u3000务：</div><div class='dd'>由<a href='"+$.getShopUrl(r)+"' target='_blank' clstag='shangpin|keycount|product|bbtn' class='hl_red'>"+r.vender+"</a>"+dfinfo+"发货"
					+"，并提供售后服务。</div>").appendTo("#summary-service");
				}
				else if(r.type==1){
					$("<div class='dt'>服\u3000\u3000务：</div><div class='dd'>由 京东商城 发货并提供售后服务。</div>").appendTo("#summary-service");
				}
				else if(r.type==2){
					$("<div class='dt'>服\u3000\u3000务：</div><div class='dd'>由<a href='"+$.getShopUrl(r)+"' target='_blank' clstag='shangpin|keycount|product|bbtn' class='hl_red'>"+r.vender+"</a>"+dfinfo+"发货，京东商城提供售后服务。</div>").appendTo("#summary-service");
				}
				else if(r.type==5){
					$("<div class='dt'>服\u3000\u3000务：</div><div class='dd'>由<a href='"+$.getShopUrl(r)+"' target='_blank' clstag='shangpin|keycount|product|bbtn' class='hl_red'>"+r.vender+"</a>"+dfinfo+"发货，并提供售后服务。</div>").appendTo("#summary-service");
				}
				if(pageConfig.product.yfinfo&&pageConfig.product.yfinfo.service){
					$("<div class='dt'>\u3000\u3000</div><div class='dd'>"+pageConfig.product.yfinfo.service+"</div>").appendTo("#summary-service");
				}
				if(r.type!=4){
					$("#summary-service").show();
					if($("#product-intro .itemover-title button").length==0&&$("#product-intro .itemover-title h3").length>0)$("<button type='button' clstag='shangpin|keycount|product|bbtn'>进入卖家店铺</button>").appendTo("#product-intro .itemover-title h3");
					$("#product-intro .itemover-title button").unbind("click").click(function(){window.location=$.getShopUrl(r);});
				}
		}
	}
}
var areaSurportDelive = true;
function getStockDescWords(state,isPurchase,skuid,skukey,arrivalDate,isNotice,ext,provinceId,rn){
	if (state == -1){
		areaSurportDelive = false;
        pageConfig.product.havestock = false;
		return "<strong>该地区暂不支持配送</strong>";
	}
	var text = "";
	var yfInfo = "";
	areaSurportDelive = true;
	if (skuid<1000000000&&(provinceId==26||provinceId==31)&&(state!=0&&state!=34)&&ext&&ext.indexOf("PianYuanYunFei")>-1)
		yfInfo = "，<span title='钻石级别以上用户不用付运费' style='cursor:pointer'>单件运费：￥10.00</span>";
	if (state == 33){
        pageConfig.product.havestock = true;
			
		if (rn&&rn>0){
			text = "<strong>有货</strong>，仅剩"+rn+"件<span></span>";	
		}
		else{
			text = "<strong>有货</strong><span>，下单后立即发货</span>";		
		}
	}
	else if (state == 34 || state == 0){
        pageConfig.product.havestock = false;
		text = "<strong>无货</strong>，此商品暂时售完"+(isNotice?"，<a href='#none' id='notify-stock' target='_blank'>到货通知</a>":"");
		if (skuid&&skuid.length == 8 && !isPurchase){
			text = "<strong>无货</strong>，此商品不再销售，欢迎选购其它商品";
		}
	}
	else if (state == 39 || state == 40){
        pageConfig.product.havestock = true;
		text = "<strong>有货</strong>，下单后2-6天发货<span></span>";
	}
	else if (state == 36){
        pageConfig.product.havestock = true;
		text = "<strong>预订</strong>，"+(arrivalDate?"预计"+arrivalDate+"日后有货，现在可下单":"商品到货后发货，现在可下单")+"<span></span>";
	}
	text += yfInfo;
	return text;
}
//NO Stock
var reCookieName = "reWidsSORec";
function reClick2(type2, pwid, sku, num) {
	var reWidsClubCookies = eval('(' + getCookie(reCookieName) + ')');
	if (reWidsClubCookies == null || reWidsClubCookies == '') reWidsClubCookies = new Object();
	if (reWidsClubCookies[type2] == null) reWidsClubCookies[type2] = '';
	var pos = reWidsClubCookies[type2].indexOf(sku);
	if (pos < 0) reWidsClubCookies[type2] = reWidsClubCookies[type2] + "," + sku;
	if(!!JSON&&JSON.stringify)setNewCookie(reCookieName, JSON.stringify(reWidsClubCookies), 2, "/", locPageHost, false);
	sku = sku.split("#");
	if (window.log){log(3, type2, sku[0]);log('RC', 'CK', type2, pwid, sku[0], num);}
}
//Notify
function getBuyUrl(skuId){
	var count = $("#buy-num").val();
	if(!count)count=1;
	if(eleSkuIdKey) return "http://gate.jd.com/InitCart.aspx?pid="+skuId+"&pcount="+count+"&ptype=1";
	if($.pbuyurl)return $.pbuyurl;
	if($.append_button.attr("href")!="#none")return $.append_button.attr("href");
	if (pageConfig.product.cat[2] == 4833) return "http://chongzhi.jd.com/order/order_place.action?skuId=" + skuId + "";
	if (pageConfig.product.cat[2] == 4835 || pageConfig.product.cat[2] == 4836) return "http://card.jd.com/order/order_place.action?skuId=" + skuId + "";
	return "http://gate.jd.com/InitCart.aspx?pid="+skuId+"&pcount="+count+"&ptype=1";
}

function chooseType() {
	var shoppingselect = $('#choose-type .item'),
		amount = $('#choose-amount'),
		buyLink = $('#choose-btn-append .btn-append'),
		selectItem = $('#choose-type .selected').eq(0);
	
	if ( !selectItem.attr('data') ) {
		return false;
	}
		
	if ( shoppingselect.length > 0 ) {
		amount.hide();
	}

	shoppingselect.bind('click', function (i) {

		if ( $('#choose-btn-append').hasClass('disabled') ) {
			return false;
		}

		var data = $(this).attr('data').split('|'),
			link = buyLink.attr( 'href' );


		var newlink = data[1].replace(/wid=\d{6,}/, 'wid=' + pageConfig.product.skuid );		

		shoppingselect.removeClass('selected');

		$(this).addClass('selected');
		$('#choose .result').html(data[0]);

		amount.addClass(data[2]);
		buyLink.attr('href', newlink);

	});

	if ( selectItem.length > 0 ) {
		var data = selectItem.attr('data').split('|'),
			newlink = data[1].replace(/wid=\d{6,}/, 'wid=' + pageConfig.product.skuid );
		buyLink.attr('href', newlink);
	}
	if ( shoppingselect.length == 1 && selectItem.length < 1 ) {
		shoppingselect.addClass('selected');
		buyLink.attr( 'href', shoppingselect.attr('data').split('|')[1].replace(/wid=\d{6,}/, 'wid=' + pageConfig.product.skuid ) );
	}
}
function SetNotifyByNoneStock(stockstatus) {
	if (stockstatus!=34&&stockstatus!=0&&warestatus==1){
		if(pageConfig&&pageConfig.product)pageConfig.product.isStock=true;
		$("#choose-btn-append").removeClass("disabled");
		if($("#choose-btn-subsidy .btn-subsidies").length>0)$("#choose-btn-append").addClass("choose-btn-append-lite");
		$("#product-intro").attr("class","");
		$('#out-of-stock,#noitem-related-list').remove();
		if($("#choose-noresult").length>0){$("#choose-noresult").remove();}
		$.easybuy_button.show();
		$.divide_button.show();
		if(pageConfig.product.skuid<1000000000){$.notice_button.hide()}
		if($.append_button.length>0){
			if( $('#choose-type .item').length>0){		
				chooseType();
				$.append_button.attr("onclick","").attr("title","").unbind("click").click(function() {  mark(pageConfig.product.skuid, 2) }); //购物车	
			}
			else{
				$.append_button.attr("href",getBuyUrl(pageConfig.product.skuid)).attr("onclick","").attr("title","").unbind("click").click(function() { /*BuyUrl(pageConfig.product.skuid);*/ mark(pageConfig.product.skuid, 2) }); //购物车
			}
		}
		if($(".nav-minicart-btn").length>0)$(".nav-minicart-btn").show(); //mini购物车
		$("#choose-btn-subsidy").show();
		if(window.noItemOver)noItemOver.init();
		return;
	}
	if(pageConfig&&pageConfig.product)pageConfig.product.isStock=false;
	$("#choose-btn-append").addClass("disabled").removeClass('choose-btn-append-lite');
	$("#product-intro").attr("class","product-intro-noitem");
	if($("#choose-noresult").length==0&&areaSurportDelive){$("<li id='choose-noresult'><div class='dd'><strong>所选地区该商品暂时无货，非常抱歉！</strong></div></li>").insertAfter("#choose-result");}
	else if(!areaSurportDelive){$("#choose-noresult").remove();}
	$.easybuy_button.hide();
	$.divide_button.hide();
	if(pageConfig.product.skuid<1000000000){$.notice_button.show()}else{$.notice_button.hide()}
	if($.append_button.length>0){if($.append_button.attr("href")!="#none"){$.pbuyurl=$.append_button.attr("href")}$.append_button.attr("href","#none").attr("onclick","").attr("title","商品已无货").unbind("click"); }//购物车
	if($(".nav-minicart-btn").length>0)$(".nav-minicart-btn").hide(); //mini购物车
	$("#choose-btn-subsidy").hide();
	if($.notice_button.length==0&&pageConfig.product.skuid<1000000000&&areaSurportDelive){
		$("<div id='choose-btn-notice' class='btn'><a id='notify-btn' class='btn-notice' href='http://notify.home.jd.com/email.action?type=2&id=" + pageConfig.product.skuid + "&key=" + pageConfig.product.skuidkey + "' target='_blank'>到货通知<b></b></a></div>").insertAfter("#choose-btn-append");
		$.notice_button=$("#choose-btn-notice");
	}
	if(window.noItemOver)noItemOver.init(pageConfig.product.type);
};
//stock callback
var currentVenderInfoJson = null;
function cleanKuohao(str){
	if(str&&str.indexOf("(")>0){
		str = str.substring(0,str.indexOf("("));
	}
	if(str&&str.indexOf("（")>0){
		str = str.substring(0,str.indexOf("（"));
	}
	return str;
}
function getProvinceStockCallback(result) {
	var setSer = false;
	if (currentPageLoad.notSet&&currentPageLoad.isLoad){
		setSer = true;
	}
	else if (!currentPageLoad.isLoad){
		setSer = true;
	}
	setCommonCookies(currentAreaInfo.currentProvinceId,currentLocation,currentAreaInfo.currentCityId,currentAreaInfo.currentAreaId,currentAreaInfo.currentTownId,setSer);
	if (currentPageLoad.isLoad)currentPageLoad.isLoad=false;
    pageConfig.product.havestock = true;
	var stockdesc="<strong>现货</strong>";
	if (result.stock) {		
		if(result.stock.D&&result.stock.D.id){
			pageConfig.product.popInfo = result;
		}
		stockdesc = (result.stock.StockStateName=="统计中"|| result.stock.StockStateName=="无货")?"<strong class='store-over'>无货</strong>":("<strong>"+result.stock.StockStateName+"</strong>");
		var address = currentAreaInfo.currentProvinceName+currentAreaInfo.currentCityName+currentAreaInfo.currentAreaName+currentAreaInfo.currentTownName;
		$("#store-selector .text div").html(currentAreaInfo.currentProvinceName+cleanKuohao(currentAreaInfo.currentCityName)+cleanKuohao(currentAreaInfo.currentAreaName)+cleanKuohao(currentAreaInfo.currentTownName)).attr("title",address);
		pageConfig.product.yfinfo={};
		if(result.stock.D&&result.stock.D.prompt){
			var proarray=result.stock.D.prompt.split("|");
			if (proarray[0]&&new Number(proarray[0])>0){
				pageConfig.product.yfinfo={nofree:true,cash:proarray[0]};
			}
			if(proarray[1]){
				pageConfig.product.yfinfo.service=proarray[1];
			}
		}
		$("#store-prompt").html(getStockDescWords(result.stock.code==2?-1:result.stock.StockState,true,pageConfig.product.skuid,pageConfig.product.skuidkey,result.stock.ArrivalDate,true,result.stock.Ext,currentAreaInfo.currentProvinceId,result.stock.rn)
			+(pageConfig.product.yfinfo.nofree?"，<span style='cursor:pointer' title='一个店铺购买多件商品，只收取一次运费'>运费：<span style='color:#f00;'>￥"+pageConfig.product.yfinfo.cash+"</span><span>":""));
		$.getDeliver(result.stock);
		if ( typeof pageConfig.product.onAreaChange === 'function' ) {
			pageConfig.product.onAreaChange(currentAreaInfo.currentProvinceId);
		}
		SetNotifyByNoneStock(result.stock.StockState);
	}
	if (pageConfig.product.skuid>1000000000){
			if(!$._ptload){
				$._ptload=true;
				window._showPopTemplete=function(r){
					if(result.stock.StockState==36){
						if(r&&r.reserveDeliveryDay){
							$._ptloadcon=r.reserveDeliveryDay;
							$("#store-prompt").html(stockdesc+"，"+"此商品为预订商品，下单后在"+$._ptloadcon);
						}
					}
					if(r&&r.wareTemplateContent)$("<div>"+r.wareTemplateContent+"</div>").insertBefore("#product-detail-1 .detail-content:first");
					if(r&&r.wareTemplateBottomContent)$("<div>"+r.wareTemplateBottomContent+"</div>").insertAfter("#product-detail-1 .detail-content:last");
				};
				$.getJSONP("http://rms.shop.jd.com/json/wareTemplate/queryWareTemplateContent.action?skuId="+pageConfig.product.skuid+"&jsoncallback=_showPopTemplete",_showPopTemplete);
			}else{
				if($._ptloadcon)$("#store-prompt").html(stockdesc+"，"+"此商品为预订商品，下单后在"+$._ptloadcon);
			}
	}
}
/**
新地址列表数据及时间绑定
**/
function getAreaList(result,idName,level){
	if (idName && level){
		$("#"+idName).html("");
		var html = "<ul class='area-list'>";
		var longhtml = "";
		var longerhtml = "";
		if (result&&result.length > 0){
			for (var i=0,j=result.length;i<j ;i++ ){
				result[i].name = result[i].name.replace(" ","");
				if(result[i].name.length > 12){
					longerhtml += "<li class='longer-area'><a href='#none' data-value='"+result[i].id+"'>"+result[i].name+"</a></li>";
				}
				else if(result[i].name.length > 5){
					longhtml += "<li class='long-area'><a href='#none' data-value='"+result[i].id+"'>"+result[i].name+"</a></li>";
				}
				else{
					html += "<li><a href='#none' data-value='"+result[i].id+"'>"+result[i].name+"</a></li>";
				}
			}
		}
		else{
			html += "<li><a href='#none' data-value='"+currentAreaInfo.currentFid+"'> </a></li>";
		}
		html +=longhtml+longerhtml+"</ul>";
		$("#"+idName).html(html);
		$("#"+idName).find("a").click(function(){
			resetBindMouseEvent();
			var areaId = $(this).attr("data-value");
			var areaName = $(this).html();
			var level = $(this).parent().parent().parent().attr("data-area");
			JdStockTabs.eq(level).find("a").attr("title",areaName).find("em").html(areaName.length>6?areaName.substring(0,6):areaName);
			level = new Number(level)+1;
			if (level=="2"){
				currentAreaInfo.currentCityId = areaId;
				currentAreaInfo.currentCityName = areaName;
				currentAreaInfo.currentAreaId = 0;
				currentAreaInfo.currentAreaName = "";
				currentAreaInfo.currentTownId = 0;
				currentAreaInfo.currentTownName = "";
			}
			else if (level=="3"){
				if (requestLevel == 4 && currentAreaInfo.currentAreaId != areaId){
					requestLevel = 3;
				}
				currentAreaInfo.currentAreaId = areaId;
				currentAreaInfo.currentAreaName = areaName;
				currentAreaInfo.currentTownId = 0;
				currentAreaInfo.currentTownName = "";
			}
			else if (level=="4"){
				currentAreaInfo.currentTownId = areaId;
				currentAreaInfo.currentTownName = areaName;
			}
			currentLocation = currentAreaInfo.currentProvinceName;
			GetStockInfoOrNextAreas(pageConfig.product.skuidkey,currentAreaInfo.currentProvinceId,currentAreaInfo.currentCityId,currentAreaInfo.currentAreaId,currentAreaInfo.currentTownId,pageConfig .product.cat[2],level);
		});
		//页面初次加载
		if (currentPageLoad.isLoad){
			var tempDom = $("#"+idName+" a[data-value='"+currentPageLoad.areaCookie[level-1]+"']");
			if(currentPageLoad.areaCookie&&currentPageLoad.areaCookie[level-1]&&currentPageLoad.areaCookie[level-1]>0&&tempDom.length>0){
				//本地cookie有该级地区ID
				tempDom.click();
			}
			else{
				$("#"+idName+" a:first").click();
			}
		}
	}
}
/**
下级地址回调方法
**/
function getAreaList_callback(result){
	var level = currentAreaInfo.currentLevel;
	getAreaList(result,getIdNameByLevel(level),level);
}
/**
根据父地址及地址等级获取下级地址列表
**/
function getChildAreaHtml(fid,level){
	var idName = getIdNameByLevel(level);
	if (idName){
		$("#stock_province_item,#stock_city_item,#stock_area_item,#stock_town_item").hide();
		$("#"+idName).show().html("<div class='iloading'>正在加载中，请稍候...</div>");
		JdStockTabs.show().removeClass("curr").eq(level-1).addClass("curr").find("em").html("请选择");
		for (var i=level,j=JdStockTabs.length;i<j ;i++ ){
			JdStockTabs.eq(i).hide();
		}
		currentAreaInfo.currentLevel = level;
		if(level == 2 && provinceCityJson[fid+""]){
			getAreaList_callback(provinceCityJson[fid+""]);
		}
		else{
			currentAreaInfo.currentFid = fid;
			$.getJSONP("http://d.360buy.com/area/get?fid="+fid+"&callback=getAreaList_callback");
		}
	}
}
function getIdNameByLevel(level){
	var idName = "";
	if (level == 1){
		idName = "stock_province_item";
	}
	else if (level == 2){
		idName = "stock_city_item";
	}
	else if (level == 3){
		idName = "stock_area_item";
	}
	else if (level == 4){
		idName = "stock_town_item";
	}
	return idName;
}
//需要的地址层级
var requestLevel = 1;
//是否分区商品
var isAreaProduct = false;
if(!eleRegion) var eleRegion=null;
if(!eleSkuIdKey) var eleSkuIdKey=null;
function initrequestLevel(){
	requestLevel = 3;
	isAreaProduct = false;
	if(eleSkuIdKey){
		requestLevel = 3;
		isAreaProduct = true;
	}
}
//当前地域信息
var currentAreaInfo;
//初始化当前地域信息
function CurrentAreaInfoInit(){
	currentAreaInfo =  {"currentLevel": 1,"currentProvinceId": 1,"currentProvinceName":"北京","currentCityId": 0,"currentCityName":"","currentAreaId": 0,"currentAreaName":"","currentTownId":0,"currentTownName":""};
}
//回调方法
function getStockCallback(result){
	if (result.stock&&(result.stock.code==3||result.stock.code==4)&&result.stock.level>1){
		//需要进一步计算，且需要地区层级大于1
		requestLevel = result.stock.level;
		if (currentAreaInfo.currentRequestLevel<result.stock.level){
			GetStockInfoOrNextAreas(pageConfig.product.skuidkey,currentAreaInfo.currentProvinceId,currentAreaInfo.currentCityId,currentAreaInfo.currentAreaId,currentAreaInfo.currentTownId,pageConfig .product.cat[2],currentAreaInfo.currentRequestLevel);
		}
	}
	else{
		reBindStockEvent();
		for (var i=currentAreaInfo.currentRequestLevel,j=JdStockTabs.length;i<j;i++){
			JdStockTabs.eq(i).hide();
			JdStockContents.eq(i).hide();
		}
		getProvinceStockCallback(result);
	}
}
//设置sku价格
function cnp(r){
	var price = "";
	if (r&&r.length>0){
		if (new Number(r[0].p)>0){	
			price = "￥"+r[0].p;
		}
	}
	if (!price){
		price = "暂无报价";
	}
	$("#summary-price .p-price").html(price);
}
function setPriceData(skuid) {
	$.getJSONP("http://p.3.cn/prices/get?skuid=J_"+skuid+"&type=1&callback=cnp");
}
function getAreaSkuState(skuid){
	if(!eleSkuIdKey) return warestatus;
	for (var i=0,j=eleSkuIdKey.length;i<j;i++){
		if (eleSkuIdKey[i].SkuId == skuid && eleSkuIdKey[i].state != undefined){
			return eleSkuIdKey[i].state;
		}
	}
	return 1;
}
//根据地区变换sku及相应信息
function getSkuId_new(cid,aid){
	if(eleSkuIdKey&&eleSkuIdKey.length>0){
		var areas = null;
		for (var i=0,j=eleSkuIdKey.length;i<j ;i++ ){
			if(eleSkuIdKey[i].area&&eleSkuIdKey[i].area[cid+""]){
				areas = eleSkuIdKey[i].area[cid+""];
				if (areas.length==0||areas[0]+""=="0"){
					return eleSkuIdKey[i].SkuId;
				}
				else if (areas.length>0){
					for(var a=0,b=areas.length;a<b;a++){
						if(areas[a]+""==aid+""){
							return eleSkuIdKey[i].SkuId;
						}
					}
				}
			}
		}
	}
	return 0;
}
function chooseSkuToArea(provinceId,cityId,areaId){
	var currentSkuId = pageConfig.product.skuid;
	var currentSkuKey = pageConfig.product.skuidkey;
	if (isAreaProduct && provinceId > 0 && cityId > 0 && areaId > 0){
		currentSkuId = 0;
		currentSkuKey = "";
		if(eleRegion){
			var provinceCitys = eleRegion[provinceId+""];
			if (provinceCitys && provinceCitys.citys && provinceCitys.citys.length>0){
				for (var i=0,j=provinceCitys.citys.length; i<j; i++){
					if (provinceCitys.citys[i].IdCity == cityId){
						currentSkuId = provinceCitys.citys[i].SkuId;
						break;
					}
				}
			}
		}
		else{
			currentSkuId = getSkuId_new(cityId,areaId);
		}
		if (eleSkuIdKey&&eleSkuIdKey.length>0){
			for (var i=0,j=eleSkuIdKey.length;i<j;i++){
				if (eleSkuIdKey[i].SkuId == currentSkuId){
					currentSkuKey = eleSkuIdKey[i].Key;
					break;
				}
			}
		}
	}
	if (currentSkuId && currentSkuKey){
		if (currentSkuId == pageConfig.product.skuid){
			pageConfig.product.isChangeSku = false;
		}
		else{
			//变换地区后sku不同
			pageConfig.product.isChangeSku = true;
		}
	}
	//设定该商品上下柜状态
	warestatus = getAreaSkuState(currentSkuId);
	//上一次选择的sku
	pageConfig.product.prevSku = pageConfig.product.skuid;
	//变换到对应分区的sku
	pageConfig.product.skuid = currentSkuId;
	pageConfig.product.skuidkey = currentSkuKey;
	//变换sku需要变化广告词及相关信息
	if (pageConfig.product.isChangeSku){
		setPriceData(pageConfig.product.skuid); //改变价格
		setCXAdvertisement(pageConfig.product.skuid,pageConfig.product.skuidkey);//广告词
		initEasyBuy(); //轻松购
		try {
			if(window.Promotions){$("#choose-btn-subsidy").remove();Promotions.init(pageConfig.product.skuid);} //促销信息
			if(window.fq_init)fq_init();
			if($("#Tip_apply").length>0&&fq_serverSite)$("#Tip_apply").attr("href",fq_serverSite + "ShoppingCart_fqInit.aspx?skuId=" + pageConfig.product.skuid + "&skuCount=1");//分期	
			$("#choose-btn-divide").html("");
			if(window.setIM)setIM();
		} catch (e) {
		}
	}	
	return currentSkuKey;
}
//获取配送库存信息或下一级地址
function GetStockInfoOrNextAreas(skuKey,provinceId,cityId,areaId,townId,sortId,curLevel){
		try{
			pageConfig.product.currentProvinceId = provinceId;
			currentAreaInfo.currentProvinceId = provinceId;
			currentAreaInfo.currentCityId = cityId;
			currentAreaInfo.currentAreaId = areaId;
			currentAreaInfo.currentTownId = townId;
			curLevel = new Number(curLevel);
			if (curLevel == requestLevel){
				currentAreaInfo.currentLevel = curLevel; //
				currentAreaInfo.currentRequestLevel = curLevel;  //	
				//分区商品需要找到分区对应的sku
				if (areaId > 0&&townId<=0){
					skuKey = chooseSkuToArea(provinceId,cityId,areaId);
				}
				pageConfig.product.skuidkey = skuKey;
				JdStockTabs.removeClass("curr").eq(curLevel-1).addClass("curr");
				JdStockTabs.find("a").removeClass("hover").eq(curLevel-1).addClass("hover");
				if (skuKey&&provinceId!=84&&warestatus==1){			
					$.getJSONP(stockServiceDomain+"/gds.html?callback=getStockCallback&skuid="+skuKey+"&provinceid="+provinceId+"&cityid="+cityId+"&areaid="+areaId+"&townid="
						+townId+"&sortid1="+pageConfig .product.cat[0]+"&sortid2="+pageConfig .product.cat[1]+"&sortid3="+pageConfig .product.cat[2]+"&cd=1_1_1");			
				}
				else{
					getStockCallback({"stock":{"IsPurchase":false,"ArrivalDate":null,"Ext":"","PopType":0,"StockStateName":"无货","code":1,"StockState":0}});
				}
			}
			else if (curLevel < requestLevel){ //还需要获取下级地址
				currentAreaInfo.currentLevel = curLevel +1;
				JdStockTabs.removeClass("curr").eq(curLevel).addClass("curr");
				JdStockTabs.find("a").removeClass("hover").eq(curLevel).addClass("hover");
				getChildAreaHtml(arguments[curLevel],curLevel +1);
			}
		}catch(err){
		}
}
function setCommonCookies(provinceId,provinceName,cityId,areaId,townId,isWriteAdds){
	setNewCookie("ipLocation", provinceName, 30, "/", locPageHost, false);
	var adds = provinceId+"-"+cityId+"-"+areaId+"-"+townId;
	setNewCookie("ipLoc-djd", adds, 30, "/", locPageHost, false);
	if (!isUseServiceLoc||!isWriteAdds){
	}
	else{
		$.ajax({url:"http://uprofile.jd.com/u/setadds",type:"get",dataType:"jsonp",data:{adds:adds}});
	}
}
//根据省份ID获取名称
function getNameById(provinceId){
	for(var o in iplocation){
		if (iplocation[o]&&iplocation[o].id==provinceId){
			return o;
		}
	}
	return "北京";
}
//初始化
var currentPageLoad = {"isLoad":true,"areaCookie":[1,72,0,0]};
//切换标签控件
var JdStockTabs = null;
var JdStockContents = null;
var provinceHtml = '<div data-widget="tabs" class="m JD-stock" id="JD-stock">'
								+'<div class="mt">'
								+'    <ul class="tab">'
								+'        <li data-index="0" data-widget="tab-item" class="curr"><a href="#none" class="hover"><em>请选择</em><i></i></a></li>'
								+'        <li data-index="1" data-widget="tab-item" style="display:none;"><a href="#none" class=""><em>请选择</em><i></i></a></li>'
								+'        <li data-index="2" data-widget="tab-item" style="display:none;"><a href="#none" class=""><em>请选择</em><i></i></a></li>'
								+'        <li data-index="3" data-widget="tab-item" style="display:none;"><a href="#none" class=""><em>请选择</em><i></i></a></li>'
								+'    </ul>'
								+'    <div class="stock-line"></div>'
								+'</div>'
								+'<div class="mc" data-area="0" data-widget="tab-content" id="stock_province_item">'
								+'    <ul class="area-list">'
								+'       <li><a href="#none" data-value="1">北京</a></li><li><a href="#none" data-value="2">上海</a></li><li><a href="#none" data-value="3">天津</a></li><li><a href="#none" data-value="4">重庆</a></li><li><a href="#none" data-value="5">河北</a></li><li><a href="#none" data-value="6">山西</a></li><li><a href="#none" data-value="7">河南</a></li><li><a href="#none" data-value="8">辽宁</a></li><li><a href="#none" data-value="9">吉林</a></li><li><a href="#none" data-value="10">黑龙江</a></li><li><a href="#none" data-value="11">内蒙古</a></li><li><a href="#none" data-value="12">江苏</a></li><li><a href="#none" data-value="13">山东</a></li><li><a href="#none" data-value="14">安徽</a></li><li><a href="#none" data-value="15">浙江</a></li><li><a href="#none" data-value="16">福建</a></li><li><a href="#none" data-value="17">湖北</a></li><li><a href="#none" data-value="18">湖南</a></li><li><a href="#none" data-value="19">广东</a></li><li><a href="#none" data-value="20">广西</a></li><li><a href="#none" data-value="21">江西</a></li><li><a href="#none" data-value="22">四川</a></li><li><a href="#none" data-value="23">海南</a></li><li><a href="#none" data-value="24">贵州</a></li><li><a href="#none" data-value="25">云南</a></li><li><a href="#none" data-value="26">西藏</a></li><li><a href="#none" data-value="27">陕西</a></li><li><a href="#none" data-value="28">甘肃</a></li><li><a href="#none" data-value="29">青海</a></li><li><a href="#none" data-value="30">宁夏</a></li><li><a href="#none" data-value="31">新疆</a></li><li><a href="#none" data-value="32">台湾</a></li><li><a href="#none" data-value="42">香港</a></li><li><a href="#none" data-value="43">澳门</a></li><li><a href="#none" data-value="84">钓鱼岛</a></li>'
								+'    </ul>'
								+'</div>'
								+'<div class="mc" data-area="1" data-widget="tab-content" id="stock_city_item"></div>'
								+'<div class="mc" data-area="2" data-widget="tab-content" id="stock_area_item"></div>'
								+'<div class="mc" data-area="3" data-widget="tab-content" id="stock_town_item"></div>'
								+'</div>';
var mouseEventChange = false;
function resetBindMouseEvent(){
	if (!mouseEventChange&&!currentPageLoad.isLoad){
		mouseEventChange = true;
		$("#store-selector").unbind("mouseout");
		$("#store-selector").unbind("mouseover").bind("mouseover",function(){
			$("#store-selector").addClass("hover");
		});
	}
}
function reBindStockEvent(){
	$("#store-selector").removeClass("hover");
	//mouseEventChange = false;
	/*$("#store-selector").unbind("mouseout").bind("mouseout",function(){
		$("#store-selector").removeClass("hover");
	});*/
}
function getStockInfoByArea(ipLoc){//获取地区库存
	if(!ipLoc){
		ipLoc = getCookie("ipLoc-djd");
	}
	currentPageLoad.notSet = false;
	if (!ipLoc) {
		currentPageLoad.notSet = true;
	}
	ipLoc = ipLoc?ipLoc.split("-"):[1,72,0,0];
	currentPageLoad.areaCookie = ipLoc;
	currentAreaInfo.currentProvinceName = getNameById(ipLoc[0]);
	currentLocation = currentAreaInfo.currentProvinceName;
	var province = iplocation[currentLocation];
	province = province?province:{ id: "1", root: 0, djd: 1,c:72 };
	currentAreaInfo.currentProvinceId = province.id;
	JdStockTabs.eq(0).find("em").html(currentAreaInfo.currentProvinceName);
	GetStockInfoOrNextAreas(pageConfig.product.skuidkey,province.id,0,0,0,pageConfig .product.cat[2],1);
	//setCommonCookies(ipLoc[0],currentLocation,ipLoc[1],ipLoc[2],ipLoc[3],noSet);
}
var isUseServiceLoc = true; //是否默认使用服务端地址
(function(){
	CurrentAreaInfoInit();
	initrequestLevel();
	//if (pageConfig.product.cat[0]!=737&&pageConfig.product.cat[0]!=652&&pageConfig.product.cat[0]!=9987&&pageConfig.product.cat[0]!=670){
	//isUseServiceLoc = true;
	//}
	$(provinceHtml).insertBefore("#store-selector .content .clr");
	$("#store-selector").mouseover(function(){$(this).addClass("hover");}).mouseout(function(){$(this).removeClass("hover");}); 
	JdStockTabs = $("#JD-stock .tab li");
	JdStockContents = $("#JD-stock div[data-widget='tab-content']");
	JdStockTabs.bind('click',function(){
		var level = $(this).attr("data-index");
		level = new Number(level);
		JdStockTabs.removeClass("curr").eq(level).addClass("curr");
		JdStockTabs.find("a").removeClass("hover").eq(level).addClass("hover");
		JdStockContents.hide().eq(level).show();
	});
	if (isUseServiceLoc){
		try{
			$.ajax({
				url:"http://uprofile.jd.com/u/getadds",
				type:"get",
				dataType:"jsonp",
				timeout:500,
				success:function(r){
					getStockInfoByArea(r.adds&&r.adds!="null"?r.adds:null);
				},
				error:function(XMLHttpRequest, textStatus, errorThrown){
					getStockInfoByArea(null);
				}
			});
		}catch(e){getStockInfoByArea(null);}
	}
	else{
		getStockInfoByArea(null);
	}
	/*JdStockTabs.eq(0).find("em").html(currentAreaInfo.currentProvinceName);
	GetStockInfoOrNextAreas(pageConfig.product.skuidkey,province.id,0,0,0,pageConfig .product.cat[2],1);*/
	$("#stock_province_item a").unbind("click").click(function() {
		currentPageLoad.isLoad = false;
		resetBindMouseEvent();
		try{
			CurrentAreaInfoInit();
			currentAreaInfo.currentProvinceId = $(this).attr("data-value");
			currentAreaInfo.currentProvinceName = $(this).html();
			currentLocation = currentAreaInfo.currentProvinceName;
			JdStockTabs.eq(0).find("em").html(currentAreaInfo.currentProvinceName);
			initrequestLevel();
			GetStockInfoOrNextAreas(pageConfig.product.skuidkey,currentAreaInfo.currentProvinceId,0,0,0,pageConfig .product.cat[2],1);
		}
		catch (err){
		}
	}).end();
	$("#store-selector .close").unbind("click").bind("click",function(){
		reBindStockEvent();
	});
	//服务信息
})();
/*#$%#@!%*/
(function(iplocation){
	var serializeUrlCommon=function(url) {
		var sep = url.indexOf('?'),
			link = url.substr( 0, sep),
			params = url.substr( sep+1 ),
			paramArr = params.split('&'),
			len = paramArr.length,i,
			res = {},curr,key,val;

		for ( i=0; i<len; i++) {
			curr = paramArr[i].split('=');
			key = curr[0];
			val = curr[1];

			res[key] = val;
		}

		return {
			url: link,
			param: res
		}
	};
	if ( /storeAddressId/.test(location.href)) {
			// 拿url上storeAddressId的值，写入cookie
			var url=serializeUrlCommon(location.href);
			if (url.param['storeAddressId']){
				var pca=url.param['storeAddressId'].split('_');
				if(pca){
					var proname="";
					var area="";
					if(pca[0] && parseInt(pca[0]) == pca[0]) {
						for(var o in iplocation){
							if(iplocation[o].id==pca[0]){
								proname=o;
								area=pca[0];
								break;
							}
						}
					}
					if(pca[1] && parseInt(pca[1]) == pca[1] && parseInt(pca[1])>0) {
						area += "-"+pca[1];
					}
					else if(area){
						area += "-0";
					}
					if(pca[2] && parseInt(pca[2]) == pca[2] && parseInt(pca[2])>0) {
						area += "-"+pca[2];
					}
					else if(area){
						area += "-0";
					}
					if(proname){
						setNewCookie("ipLocation", proname, 30, "/", locPageHost, false);
					}
					if(area){
						setNewCookie("ipLoc-djd", area, 30, "/", locPageHost, false);
					}
				}
			}
	}
})(iplocation);
// 标题广告词
function setproductadwords(r){
	if (r&&r.AdWordList&&r.AdWordList.length>0&&r.AdWordList[0]){
		$("#name strong").html(r.AdWordList[0].waretitle?r.AdWordList[0].waretitle:"");
	}
}
function setCXAdvertisement(skuid, skuidkey) {	
	$("#name strong").html("");
	$.getJSONP("http://jprice.jd.com/adslogan/"+skuid+"-setproductadwords.ad");
}
setCXAdvertisement(pageConfig.product.skuid, pageConfig.product.skuidkey);
var DoOrder = function (pid) {

		$.login({
			modal: true,
			complete: function (result) {
				if (result != null && result.IsAuthenticated != null && result.IsAuthenticated) {
					var num = $.trim($("#buy-num").val());
					$.ajax({
						url: "http://buy.jd.com/purchase/flows/easybuy/FlowService.ashx",
						type: "get",
						data: {
							action: "SubmitOrderByDefaultTemplate",
							skuId: pid || pageConfig.product.skuid,
							num: $("#buy-num").val()
						},
						dataType: "jsonp",
						success: function (r) {
							if (r.Flag) {
								window.location = r.Obj;
							}
							else {
								$.easybuy_button.show();
								if (r.Message != null) {
									alert(r.Message);
								}
								else {
									alert("暂时无法提交,请您稍后重试!");
								}
							}
						}
					})
				}
				else {
					$.easybuy_button.show();
				}
			}
		})
	};
function initEasyBuy() {
	var productId = null;
	if ($.append_button.css("display") != "none") {
		productId = parseInt( pageConfig.product.skuid );
		var eb = readCookie("eb");
		if (eb == 1 || eb == null || eb == undefined) {
			$.ajax({
				url: "http://buy.jd.com/purchase/flows/easybuy/FlowService.ashx",
				type: "get",
				data: {
					action: "CanBuy",
					skuId: productId
				},
				dataType: "jsonp",
				success: function (r) {
					$.easybuy_button.html("");
					if (r.Flag) {
						$.easybuy_button.html("<a class='btn-easybuy' href='#'>轻松购<b></b></a>");
						$("#choose-btn-easybuy .btn-easybuy").click(function () {
							$.easybuy_button.hide();
							$.extend(jdModelCallCenter.settings, {
								clstag1: 0,
								clstag2: 0,
								id: productId,
								fn: function () {
									DoOrder(this.id);
								}
							});
							jdModelCallCenter.settings.fn()
						})
					}
				}
			})
		}
	}
};	
initEasyBuy();
//颜色尺码
var choose_color=$("#choose-color a");var choose_colori=$("#choose-color .item");
var choose_version=$("#choose-version .item");
var alert_choose_version=$("#choose-version .dt").html();alert_choose_version=alert_choose_version?alert_choose_version.replace("：",""):"";
var alert_choose_color=$("#choose-color .dt").html();alert_choose_color=alert_choose_color?alert_choose_color.replace("：",""):"";
var alert_choose="所选"+alert_choose_color.replace("选择","")+"该"+alert_choose_version.replace("选择","")+"商品无货";
var csobj={};var scobj={};
if(choose_color.length>0&&choose_version.length>0){
	if(ColorSize&&ColorSize .length>0){
		var cs=null;
		for (var i=0,j=ColorSize.length;i<j;i++){
			cs=ColorSize[i];
			if(!csobj[cs.Color])csobj[cs.Color]={};
			csobj[cs.Color][cs.Size]=cs.SkuId;
			if(!scobj[cs.Size])scobj[cs.Size]={};
			scobj[cs.Size][cs.Color]=cs.SkuId;
		}
	}
	function checkColorSize(c,s){
		if(csobj[c]&&csobj[c][s])
			return csobj[c][s];
		return 0;
	}
	function changeColorSize(flag){
		var cur_color=$("#choose-color .selected a").attr("title");
		if(cur_color&&csobj[cur_color]){
			var version=null;
			var choose_version_obj=null;
			for(var i=0,j=choose_version.length;i<j;i++){
				choose_version_obj=$($(choose_version[i]).find("a")[0]);
				version=choose_version_obj.html();
				if(!(version&&csobj[cur_color][version])){
					$(choose_version[i]).attr("class","item disabled");
					$(choose_version[i]).find("b").hide();
					choose_version_obj.css("cursor","not-allowed").attr("title",alert_choose);
				}
				else{
					if($(choose_version[i]).attr("class")=="item disabled")$(choose_version[i]).attr("class","item");
					$(choose_version[i]).find("b").show();
					choose_version_obj.css("cursor","pointer").attr("title",choose_version_obj.html());
				}
				$(choose_version[i]).find("i").remove();
			}
		}
		var cur_version = $("#choose-version .selected a").html();
		if(cur_version&&scobj[cur_version]){
			var color=null;
			for(var i=0,j=choose_colori.length;i<j;i++){
				color=$($(choose_colori[i]).find("a")[0]).attr("title");
				if(!(color&&scobj[cur_version][color])){
					$(choose_colori[i]).attr("class","item disabled");
					$(choose_colori[i]).find("b").hide();
				}
				else{
					if($(choose_colori[i]).attr("class")=="item disabled")$(choose_colori[i]).attr("class","item");
					$(choose_colori[i]).find("b").show();
				}
			}
		}
		else{
			$("#choose-color .disabled").attr("class","item");
		}
		$("<i></i>").insertBefore("#choose-version .disabled a");
		if(!flag){
			$("#choose-result .dd").html("<em>已选择</em>"+(cur_color?"<strong>“"+cur_color+"”</strong>":"")+(cur_color&&cur_version?"，":"")+(cur_version?"<strong>“"+cur_version+"”</strong>":"")
				+(cur_color?"":"<span class='item-warnning'><s></s>请"+alert_choose_color+"</span>")+(cur_version?"":"<span class='item-warnning'><s></s>请"+alert_choose_version+"</span>"));
			$("#choose-color").attr("class",cur_color?"":"item-hl-bg");
			$("#choose-version").attr("class",cur_version?"":"item-hl-bg");
			if($("#choose-noresult").length>0){$("#choose-noresult").remove();}
			$.easybuy_button.hide();
			$.divide_button.hide();
			$.notice_button.hide();
			if($.append_button.length>0)$.append_button.attr("href","#none").attr("onclick","").unbind("click"); //购物车
			if($(".nav-minicart-btn").length>0)$(".nav-minicart-btn").hide(); //mini购物车
			$("#choose-btn-subsidy").hide();
		}
	}
	changeColorSize(true);
	$("#choose-color a").attr("href","#none").unbind("click").click(function(){
		$("#choose-color .selected").attr("class","item");
		$($(this).parent()).attr("class","item selected");
		var c=$(this).attr("title");
		var s=$("#choose-version .selected a");
		if(s.length>0){s=s.html()}else{s=null}
		var sid=0;
		sid=checkColorSize(c,s);
		if(sid>0){window.location=sid+".html";}else{
			changeColorSize();
		}
	});
	$("#choose-version a").attr("href","#none").unbind("click").click(function(){
		if($($(this).parent()).attr("class")=="item disabled")return;
		var s=$(this).html();
		var c=$("#choose-color .selected a");
		if(c.length>0){c=c.attr("title")}else{c=null}
		var sid=0;
		sid=checkColorSize(c,s);
		if(sid>0){window.location=sid+".html";}else{
			changeColorSize();
		}
	});
}
/******************/
if(true&&pageConfig.product.cat[0]==1316){
var spuServiceUrl = "http://spu.jd.com/json.html?cond=";
var spuPageUrl = "http://spu.jd.com/"+pageConfig.product.skuid+".html";
function showProvinceStockDeliver(r){
	if(!r)return;
	$('<div id="ypds-info"><a href="'+spuPageUrl+'" class="hl_blue" target="_blank">'+r.totalCount+'个卖家在售</a><span class="hl_red">\u3000￥'+(r.minPrice+"")+'</span> 起</div>').insertAfter("#choose"); 
	var spuVenderInfos = '<div class="m fr" id="ypds-list"><div class="mt"><span class="fl">在售卖家</span><span class="extra"><a href="'
										+spuPageUrl+'" class="hl_blue" target="_blank">查看全部</a></span></div><div class="mc"><ul>';
	var topCount = 0;
	for (var i=0,j=r.skuStockVenders.length;i<j;i++){
		if (pageConfig.product.skuid+"" != r.skuStockVenders[i].skuId && topCount < 3){
			spuVenderInfos += '<li id="J_'+r.skuStockVenders[i].skuId+'"><div class="fl"><a href="http://item.jd.com/'+r.skuStockVenders[i].skuId+'.html" target="_blank">'+((r.skuStockVenders[i].venderId&&(r.skuStockVenders[i].skuId+"").length==10)?r.skuStockVenders[i].venderName:'京东商城')+'</a></div><div class="lh hl_red"></div></li>';
			topCount ++;
		}
	}
	spuVenderInfos += '</ul></div></div>';
	if ($("#brand-bar-pop").length > 0){
		$(spuVenderInfos).appendTo("#brand-bar-pop");
	}
	else{
		$(spuVenderInfos).appendTo("#brand-bar");
	}
	var sellerArray = $("#ypds-list li");
	for (var i=0,j=sellerArray.length;i<j;i++){
		$.ajax({
				url:"http://p.3.cn/prices/get?callback=?",
				data:{skuid:sellerArray.eq(i).attr("id"),type:1},
				dataType:"jsonp",
				success:function(r){
					if(r&&r.length>0){
						$("#"+r[0].id+" .hl_red").html(new Number(r[0].p)>0?("￥"+r[0].p):"暂无报价");
					}
				}
			});
	}
}
(function(){
	$.getJSONP(spuServiceUrl+"1_4_1_0_0_0_"+pageConfig.product.skuid+"_1&callback=showProvinceStockDeliver");
})();
}

// http://misc.360buyimg.com/product/js/2012/product.js
/*
 item.jd.com Compressed by uglify 
 Author:keelii 
 Date: 2013-05-28 
 */
function log(e,t){var s="";for(i=2;arguments.length>i;i++)s=s+arguments[i]+"|||";var a=decodeURIComponent(escape(getCookie("pin"))),o="http://csc.360buy.com/log.ashx?type1=$type1$&type2=$type2$&data=$data$&pin=$pin$&referrer=$referrer$&jinfo=$jinfo$&callback=?",n=o.replace(/\$type1\$/,escape(e));n=n.replace(/\$type2\$/,escape(t)),n=n.replace(/\$data\$/,escape(s)),n=n.replace(/\$pin\$/,escape(a)),n=n.replace(/\$referrer\$/,escape(document.referrer)),n=n.replace(/\$jinfo\$/,escape("")),$.getJSON(n,function(){})}function clsPVAndShowLog(e,t,i,s){var a=e+"."+i+"."+skutype(t)+"."+s;log("d","o",a)}function clsClickLog(e,t,i,s,a,o){var n=e+"."+s+"."+skutype(t);appendCookie(o,i,n),log("d","o",n+".c")}function appendCookie(reCookieName,sku,key){var reWidsCookies=eval("("+getCookie(reCookieName)+")");(null==reWidsCookies||""==reWidsCookies)&&(reWidsCookies={}),null==reWidsCookies[key]&&(reWidsCookies[key]="");var pos=reWidsCookies[key].indexOf(sku);0>pos&&(reWidsCookies[key]=reWidsCookies[key]+","+sku),setCookie(reCookieName,$.toJSON(reWidsCookies),15)}function skutype(e){if(e){var t=(""+e).length;return 10==t?1:0}return 0}function setCookie(e,t,i){var s=i,a=new Date;a.setTime(a.getTime()+1e3*60*60*24*s),document.cookie=e+"="+escape(t)+";expires="+a.toGMTString()+";path=/;domain=.jd.com"}function getCookie(e){var t=document.cookie.match(RegExp("(^| )"+e+"=([^;]*)(;|$)"));return null!=t?unescape(t[2]):null}function clsLog(e,t,i,s,a){appendCookie(a,i,e),i=i.split("#")[0],log(3,e,i)}function jdPshowRecommend(e,t){var i=G.name,s=G.sku,a=pageConfig.product.src,o=pageConfig.product.realPrice||"",n="\u6211\u5728@\u4eac\u4e1c \u53d1\u73b0\u4e86\u4e00\u4e2a\u975e\u5e38\u4e0d\u9519\u7684\u5546\u54c1\uff1a"+i+"\uff0c\u4eac\u4e1c\u4ef7\uff1a\uffe5 "+o+"\u3002\u611f\u89c9\u4e0d\u9519\uff0c\u5206\u4eab\u4e00\u4e0b",r=pageConfig.FN_GetImageDomain(s)+"n5/"+a,c="http://item.jd.com/"+s+".html?sid=",d=readCookie("pin")||"";"qzone"==t&&(e=e+"&title="+n+"&pic="+r+"&url="+c+d),"sina"==t&&(e=e+"&title="+encodeURIComponent(n)+"&pic="+encodeURIComponent(r)+"&url="+encodeURIComponent(c)+d,window.open(e,"","height=500, width=600")),"renren"==t&&(e=e+"title="+i+"&content="+n+"&pic="+r+"&url="+c+d),"kaixing"==t&&(e=e+"rtitle="+i+"&rcontent="+n+"&rurl="+c+d),"douban"==t&&(e=e+"title="+i+"&comment="+n+"&url="+c+d),"MSN"==t&&(e=e+"url="+c+d+"&title="+i+"&description="+n+"&screenshot="+r),"sina"!=t&&window.open(encodeURI(e),"","height=500, width=600")}function showTip100(proobj){var TipDivW=$(proobj).width(),TipDivH=$(proobj).height(),TipDiv=$("<div id='c04tip' style='z-index:20000;position:absolute;width:"+eval(TipDivW+5)+"px;height:"+eval(TipDivH+5)+"px;'><div style='position:absolute;margin:5px 0 0 5px;width:"+TipDivW+"px;height:"+TipDivH+"px;background:#BCBEC0;z-index:20001;'></div></div>");fq_returnData&&fq_formatData(fq_returnData),TipDiv.append($(proobj)),$(document.body).prepend(TipDiv),$(proobj).show(),$("#c04tip").css({top:parseInt(document.documentElement.scrollTop+(document.documentElement.clientHeight-$("#c04tip").height())/2)+"px",left:(document.documentElement.clientWidth-$("#c04tip").width())/2+"px"}),$("#Tip_apply,#Tip_continue,.Tip_Close").click(function(){$("#c04tip").remove(),$("#choose-btn-coll").after('<div id="Fqfk_Tip" class="Tip360"></div>')})}function fq_init(){G.sku&&fq_showFq(G.sku)}function fq_showFq(e){var t=document.createElement("script");t.type="text/javascript",t.src=fq_serverSiteService+fq_serverUrl+"?roid="+Math.random()+"&action=getFqInfo&id="+e,document.getElementsByTagName("head")[0].appendChild(t)}function fq_showFq_html(e){if(null!=e){if(0==e.json.length)return;if(0==e.json.length)return;if(null!=e.json[0].error)return;document.getElementById(fq_btnPanel).innerHTML='<a href="javascript:;" class="btn-divide" onclick="showTip100(\'#Fqfk_Tip\')">\u5206\u671f\u4ed8\u6b3e<b></b></a>',fq_returnData=e}}function fq_formatData(){var e=document.getElementById("Fqfk_Tip"),t=$("#InitCartUrl").attr("href");e.style.width="500px";var i="";i+="<div class='Tip_Title'><em><img src='"+fq_serverSite+"skin/images/tip_close.jpg' class='Tip_Close'/></em>\u5206\u671f\u4ed8\u6b3e</div>",i+="<div class='Tip_Content' id='Tip_fq0'></div>",i+='<div style="padding:5px 10px 20px 0;text-align:right;"><a href="'+t+'" style="display:inline-block;width:94px;height:25px;background:url(http://misc.360buyimg.com/product/skin/2012/i/fitting_center.png) 0 -25px no-repeat;*zoom:1;"></a></div>',i+="<div class='Tip_Content' id='Tip_fq1' style='padding:0;'></div>",e.innerHTML=i,$.ajax({url:"http://fa.jd.com/loadFa.js?aid=2_163_3675",dataType:"script",cache:!0})}function getCookie(e){var t=document.cookie.match(RegExp("(^| )"+e+"=([^;]*)(;|$)"));return null!=t?unescape(t[2]):null}function getSuitInfoService(e){null!==e.packResponseList&&e.packResponseList.length>0&&($("#favorable-suit").show(),$("#favorable-suit .mc").html(suit_TPL.tabs.process(e)+suit_TPL.cons.process(e)),$("#favorable-suit .mc").Jtab({event:"click",compatible:!0,currClass:"scurr"},function(e,t){var i=t.attr("packprice"),s=t.attr("packlistprice"),a=t.attr("discount"),o=t.find(".fitting-price"),n=t.find(".orign-price"),r=t.find(".fitting-saving");""!==i&&""!==s&&(o.html(parseFloat(i).toFixed(2)),n.html(parseFloat(s).toFixed(2)),r.html(parseFloat(a).toFixed(2)))}),G.removeLastAdd())}function setSearch(e,t){var i=pageConfig.wideVersion&&pageConfig.compatible?5:4,s=e||s;$.ajax({url:"http://api.search.jd.com/?key="+s+"&pagesize="+i+"&filt_type=wyn,L1M1;wstate,L1M1"+t,dataType:"jsonp",success:function(e){var t=e.Summary.key;null!==e.Product&&e.Product.length>0&&(1>$("#search-result").length&&$("#product-intro").parent().before('<div class="w"><div id="search-result" class="m m2"><div class="mt"></div><div class="mc search-item"></div></div></div>'),$("#search-result").show(),$("#search-result .search-item").html(search_TPL.process(e)),$("#search-result .mt").html('<h2>\u5728\u4eac\u4e1c\u5546\u57ce\u4e2d\u67e5\u770b\u5176\u5b83\u201c<a target="_blank" href="http://search.jd.com/Search?keyword='+t+'">'+t+'</a>\u201d\u7684\u641c\u7d22\u7ed3\u679c\uff1a</h2><div class="extra"><a target="_blank" href="http://search.jd.com/Search?keyword='+t+'">\u67e5\u770b\u66f4\u591a\u641c\u7d22\u7ed3\u679c</a></div>'),$(".search-item dl .p-img a").click(function(){var e=$(this).parents("dl").attr("skuid");$.getScript("http://sstat.jd.com/scslog?args=1^"+encodeURIComponent(t)+"^^1^^"+encodeURIComponent(document.referrer)+"^"+e+"^0^101^^0^0")}),$(".search-item dl .p-name a").click(function(){var e=$(this).parents("dl").attr("skuid");$.getScript("http://sstat.jd.com/scslog?args=1^"+encodeURIComponent(t)+"^^1^^"+encodeURIComponent(document.referrer)+"^"+e+"^0^101^^0^0")}))}})}function onlineService(e,t,i){var s=pageConfig.product.skuid;s||(s=$("ul[id='summary'] span").html().replace("\u5546\u54c1\u7f16\u53f7\uff1a",""));var a=unescape(G.name);a=encodeURIComponent(encodeURIComponent(a));var o=$("#name strong").html();o=encodeURIComponent(encodeURIComponent(o));var n=$("#store-selector .text").text(),r=$("#store-prompt strong").html(),c=n+"\uff08"+r+"\uff09";c=encodeURIComponent(encodeURIComponent(c)),t=encodeURIComponent(encodeURIComponent(t));var d=$("span[class^='star']").attr("class").replace("star sa",""),l=100;try{l=$("a[href='#comment']").html().replace("(\u5df2\u6709","").replace("\u4eba\u8bc4\u4ef7)","")}catch(p){}var m=100;try{m=$("#i-comment .rate strong").text().replace("%","")}catch(p){}var u=encodeURIComponent(encodeURIComponent(pageConfig.product.src)),h=jQuery.cookie("_recent");h||(h="");var f="";try{f=$("strong[class='p-price'] img").attr("src")}catch(p){}f=f?encodeURIComponent(encodeURIComponent(f)):"",i||(i="chat.jd.com");var g="http://"+i+"/index.action?pid="+s+"&price="+f+"&stock="+c+"&score="+d+"&commentNum="+l+"&imgUrl="+u+"&wname="+a+"&advertiseWord="+o+"&seller="+t+"&evaluationRate="+m+"&recent="+h+"&code="+e;open(g,s,"status=no,toolbar=no,menubar=no,location=no,titlebar=no,resizable=no,width=800px,height=590")}function setImButton(e){var t=e||pageConfig.product.skuid;$.ajax({url:"http://chat1.360buy.com/api/checkChat?",data:{pid:t,returnCharset:"gb2312"},dataType:"jsonp",success:function(e){if(e){var i=e.seller,s=e.code;if(i&&""!=i&&(i=i.replace("&qt;","'").replace("&dt;",'"')),1>$("#brand-bar-pop").length&&($("#j-im").length>0&&$("#j-im").remove(),$("#summary-grade .dd #j-im").length>0&&$("#summary-grade .dd #j-im").remove(),(1==s||2==s||3==s||9==s)&&$("#summary-grade .dd").append('<a id="j-im" class="djd-im" href="#none" style="color:#333;margin:-3px 0 0 5px;" clstag="shangpin|keycount|product|imbtn"><b>\u8054\u7cfb\u5ba2\u670d</b></a>')),1==s)$("#online-service").show(),$("#j-im").attr("title",i+" \u5728\u7ebf\u5ba2\u670d"),$("#j-im").click(function(){onlineService(1,i,e.chatDomain)});else if(2==s){$("#online-service").show();var a=t.length>=10?" \u5ba2\u670d\u76ee\u524d\u4e0d\u5728\u7ebf\uff01\u8d2d\u4e70\u4e4b\u524d\uff0c\u5982\u6709\u95ee\u9898\uff0c\u8bf7\u5728\u6b64\u9875\u201c\u5168\u90e8\u8d2d\u4e70\u54a8\u8be2\u201d\u4e2d\u5411\u4eac\u4e1c\u5ba2\u670d\u53d1\u8d77\u54a8\u8be2":" \u5382\u5546\u552e\u524d\u54a8\u8be2\u76ee\u524d\u4e0d\u5728\u7ebf\uff01\u8d2d\u4e70\u4e4b\u524d\uff0c\u5982\u6709\u95ee\u9898\uff0c\u8bf7\u5728\u6b64\u9875\u201c\u5168\u90e8\u8d2d\u4e70\u54a8\u8be2\u201d\u4e2d\u5411\u4eac\u4e1c\u5ba2\u670d\u53d1\u8d77\u54a8\u8be2";$("#j-im").addClass("d-offline").attr("title",i+a).unbind("click")}else(3==s||9==s)&&($("#online-service").show().find("b").html("\u7ed9\u5ba2\u670d\u7559\u8a00"),$("#j-im").addClass("d-offline").html("<b>\u7ed9\u5ba2\u670d\u7559\u8a00</b>").attr("title",i+" \u5728\u7ebf\u5ba2\u670d\u76ee\u524d\u4e0d\u5728\u7ebf\uff0c\u60a8\u53ef\u4ee5\u70b9\u51fb\u6b64\u5904\u7ed9\u5546\u5bb6\u7559\u8a00\uff0c\u5e76\u5728\u3010\u6211\u7684\u4eac\u4e1c->\u6d88\u606f\u7cbe\u7075\u3011\u4e2d\u67e5\u770b\u56de\u590d").click(function(){onlineService(3,i,e.chatDomain)}))}}})}if(G===void 0)var G=window.G={};pageConfig.product.useTag=!0,pageConfig.product.renew=!1,function(e){"object"==typeof pageConfig.product&&(e.sku=pageConfig.product.skuid,e.key=pageConfig.product.skuidkey,e.url=pageConfig.product.href,e.src=pageConfig.product.src,e.name=pageConfig.product.name,e.cat=pageConfig.product.cat,e.orginSku=pageConfig.product.orginSkuid||e.sku,e.isJd=1e9>e.sku,e.isPop=e.sku>1e9,e.isArray=function(e){return"[object Array]"===Object.prototype.toString.call(e)},e.isObject=function(e){return"[object Object]"===Object.prototype.toString.call(e)},e.isEmptyObject=function(e){var t;for(t in e)return!1;return!0},e.isNothing=function(t){return e.isArray(t)?1>t.length:!t}),e.serializeUrl=function(e){var t,i,s,a,o=e.indexOf("?"),n=e.substr(0,o),r=e.substr(o+1),c=r.split("&"),d=c.length,l={};for(t=0;d>t;t++)i=c[t].split("="),s=i[0],a=i[1],l[s]=a;return{url:n,param:l}},e.setScroll=function(e){var t="string"==typeof e?$(e):$("body");t.find(".p-scroll").each(function(){var e=$(this).find(".p-scroll-wrap"),t=$(this).find(".p-scroll-next"),i=$(this).find(".p-scroll-prev");e.find("li").length>4&&e.imgScroll({showControl:!0,width:30,height:30,visible:4,step:1,prev:i,next:t})})},e.thumbnailSwitch=function(e,t,i,s,a){var o=e.find("img"),n=a||"mouseover";o.bind(n,function(){var s=$(this),a=s.attr("src"),o=a.replace(/\/n\d\//,i);t.attr("src",o),e.removeClass("curr"),s.parent().addClass("curr")})},e.getRealPrice=function(e,t){var i=pageConfig.product.realPrice,e=e||pageConfig.product.skuid;return i!==void 0?t(i):(window.getNumPriceService=function(e){var i=e.jdPrice?e.jdPrice.amount:!1;"function"==typeof t&&t(i),e.jdPrice&&pageConfig.product&&(pageConfig.product.realPrice=e.jdPrice.amount);try{delete window.getNumPriceService}catch(s){}},$.ajax({url:"http://jprice.360buyimg.com/price/np"+e+"-TRANSACTION-J.html",dataType:"script",cache:!0}),void 0)},e.getCommentNum=function(e,t){var i=pageConfig.product.commentCount;return i!==void 0?t(i):(window.getCommentCount=function(e){"function"==typeof t&&t(e),e&&pageConfig.product&&(pageConfig.product.commentCount=e);try{delete window.getCommentCount}catch(i){}},$.ajax({url:"http://club.jd.com/ProductPageService.aspx?method=GetCommentSummaryBySkuId&referenceId="+e+"&callback=getCommentCount",dataType:"script",cache:!0}),void 0)},e.getUserLevel=function(e){switch(e){case 50:return"\u6ce8\u518c\u7528\u6237";case 56:return"\u94c1\u724c\u7528\u6237";case 59:return"\u6ce8\u518c\u7528\u6237";case 60:return"\u94dc\u724c\u7528\u6237";case 61:return"\u94f6\u724c\u7528\u6237";case 62:return"\u91d1\u724c\u7528\u6237";case 63:return"\u94bb\u77f3\u7528\u6237";case 64:return"\u7ecf\u9500\u5546";case 65:return"VIP";case 66:return"\u4eac\u4e1c\u5458\u5de5";case-1:return"\u672a\u6ce8\u518c";case 88:return"\u53cc\u94bb\u7528\u6237";case 90:return"\u4f01\u4e1a\u7528\u6237";case 103:return"\u4e09\u94bb\u7528\u6237";case 104:return"\u56db\u94bb\u7528\u6237";case 105:return"\u4e94\u94bb\u7528\u6237"}return"\u672a\u77e5"},e.calculatePrice=function(e,t){for(var i=$(e).parents(t),s=i.find(".master input").attr("wmeprice"),a=i.find("input:checked"),o=a.length,n=i.find(".infos .res-totalprice"),r=i.find(".infos .res-jdprice"),c=0,d=0,l="http://jd2008.jd.com/purchase/OrderFlowService.aspx?action=AddSkus&wids=",p=i.find(".btn-buy"),m=[],u=0;a.length>u;u++)c+=parseFloat(a.eq(u).attr("wmaprice")),d+=parseFloat(a.eq(u).attr("wmeprice")),m.push(a.eq(u).attr("skuid"));""!=s&&0!=parseInt(s)&&(n.text("\uffe5 "+c.toFixed(2)),r.text("\uffe5 "+d.toFixed(2)),p.attr("href",l+m.join(",")),i.find(".infos .p-name span").html(""+(o-1)))},e.sortFitting=function(e,t,i){var s=$(i),a=t,o=s.find(".suits"),n=s.find(".stab li"),r=s.find(".suits .lh"),c=o.find('li[data-cat="'+a+'"]');if("all"==t){var d=parseInt(o.attr("data-count"));o.find("li").show(),r.css("width",166*d),d>4&&o.css("overflow-x","scroll")}else o.find("li").hide(),c.show();if(n.removeClass("scurr"),$(e).addClass("scurr"),1==!!$(e).attr("data-count")){var l=parseInt($(e).attr("data-count"));o.css("overflow-x",4>=l?"hidden":"scroll"),r.css("width",166*l)}o.scrollLeft(0),G.removeLastAdd()},e.removeLastAdd=function(e){var e=e||$(".suits");e.find("li").removeClass("last-item"),e.find("li:visible:last").addClass("last-item")},e.checkLogin=function(e){"function"==typeof e&&$.getJSON("http://passport.jd.com/loginservice.aspx?method=Login&callback=?",function(t){t.Identity&&e(t.Identity)})},e.insertStyles=function(e){var t=document,i=t.getElementsByTagName("head"),s=t.createElement("style"),a=t.createElement("link");if(/\.css$/.test(e))a.rel="stylesheet",a.type="text/css",a.href=e,i.length?i[0].appendChild(a):t.documentElement.appendChild(a);else{if(s.setAttribute("type","text/css"),s.styleSheet)s.styleSheet.cssText=e;else{var o=t.createTextNode(e);s.appendChild(o)}i.length&&i[0].appendChild(s)}}}(G),function(e){e.fn.floatNav=function(t){var i=e.extend({start:null,end:null,fixedClass:"nav-fixed",anchor:null,targetEle:null,range:0,onStart:function(){},onEnd:function(){}},t),s=e(this),a=s.height(),o=s.width(),n=e('<div class="float-nav-wrap"/>');return s.css({height:a,width:o}),s.parent().hasClass("float-nav-wrap")||s.wrap(n.css("height",a)),e(window).bind("scroll",function(){var t=e(document).scrollTop(),a=s.find("a").eq(0).attr("href"),o=i.start||s.parent(".float-nav-wrap").offset().top,n=i.targetEle?e(i.targetEle).offset().top:1e4;t>o&&(i.end||n)-i.range>t?(s.addClass(i.fixedClass),i.anchor&&a!==i.anchor&&s.find("a").attr("href",i.anchor),i.onStart&&i.onStart()):(s.removeClass(i.fixedClass),i.anchor&&s.find("a").attr("href","javascript:;"),i.onEnd&&i.onEnd())}),this}}(jQuery),function(e){var t=function(t,i,s){this.opts=e.extend({content:t.title||"",width:null,oTop:5,oLeft:5,zIndex:1,event:null,position:"top",close:!1},i),this.$obj=e(t),this.callback=s||function(){},this.init()};t.prototype={init:function(){this.insertStyles('.Jtips { position: relative; float:left; } .Jtips-close { position:absolute; color:#ff6600; font:12px "simsun"; cursor:pointer; } .Jtips-top .Jtips-close { right:1px; top:0px; } .Jtips-bottom .Jtips-close { right:1px; top:5px; } .Jtips-left .Jtips-close { right:6px; top:1px; } .Jtips-right .Jtips-close { right:1px; top:1px; } .Jtips-arr { position: absolute; background-image:url(http://misc.360buyimg.com/product/skin/2012/i/arrow.gif); background-repeat:no-repeat; overflow:hidden; } .Jtips-top { padding-bottom: 5px; } .Jtips-top .Jtips-arr { left:10px; bottom:0; width:11px; height:6px; background-position:0 -5px; _bottom:-1px; } .Jtips-bottom { padding-top: 5px; } .Jtips-bottom .Jtips-arr { top:0; left:10px; width:11px; height:6px; background-position:0 0; } .Jtips-left { padding-right: 5px;  } .Jtips-left .Jtips-arr { right:0; top:10px; width:6px; height:11px; background-position:-5px 0;} .Jtips-right {padding-left: 5px; } .Jtips-right .Jtips-arr {top:10px; left:0; width:6px; height:11px; background-position:0 0;  } .Jtips-con { float:left; padding:10px; background:#fffdee; border:1px solid #edd28b; color:#ff6501; -moz-box-shadow: 0 0 2px 2px #eee; -webkit-box-shadow: 0 0 2px 2px #eee; box-shadow: 0 0 2px 2px #eee; } .Jtips-con a,.Jtips-con a:hover,.Jtips-con a:visited { color:#005fab; text-decoration:none; } .Jtips-con a:hover { text-decoration: underline; }'),null===this.opts.event?this.show():this.bindEvent()},insertStyles:function(e){var t=document,i=t.getElementsByTagName("head"),s=t.createElement("style"),a=t.createElement("link");if(/\.css$/.test(e))a.rel="stylesheet",a.type="text/css",a.href=e,i.length?i[0].appendChild(a):t.documentElement.appendChild(a);else{if(s.setAttribute("type","text/css"),s.styleSheet)s.styleSheet.cssText=e;else{var o=t.createTextNode(e);s.appendChild(o)}i.length&&i[0].appendChild(s)}},bindEvent:function(){var e=this;this.$obj.unbind(this.opts.event).bind(this.opts.event,function(){e.show()})},bindClose:function(e){var t=this;e.find(".Jtips-close").bind("click",function(){t.remove()})},getPosition:function(){var e=this.$obj;return{w:e.outerWidth(),h:e.outerHeight(),oTop:e.offset().top,oLeft:e.offset().left}},setPosition:function(t,i){var s=this.getPosition();e("body").eq(0).width(),e("body").eq(0).height(),t.css({position:"absolute","z-index":this.opts.zIndex}),"left"===i&&t.css({top:s.oTop-10+this.opts.oTop,left:s.oLeft-this.tips.outerWidth()-this.opts.oLeft}),"right"===i&&t.css({left:s.oLeft+s.w+this.opts.oLeft,top:s.oTop-10+this.opts.oTop}),"top"===i&&t.css({left:s.oLeft-10+this.opts.oLeft,top:s.oTop-this.tips.outerHeight()-this.opts.oTop}),"bottom"===i&&t.css({left:s.oLeft-10+this.opts.oLeft,top:s.oTop+s.h+this.opts.oTop})},show:function(){var t=this.opts.close?'<div class="Jtips-close">&times;</div>':"",i=e('<div class="Jtips Jtips-'+this.opts.position+'"><div class="Jtips-arr"></div>'+t+'<div class="Jtips-con">'+this.opts.content+"</div></div>"),s=this;this.tips=i,e("body").eq(0).append(i),this.tips.css("width",this.opts.width||i.width()).find(".Jtips-con").css("width",(this.opts.width||i.width())-20),this.setPosition(i,this.opts.position),this.bindClose(i),e(window).resize(function(){s.setPosition(i,s.opts.position)}),"function"==typeof this.callback&&this.callback.apply(this.$obj,[i])},hide:function(){this.tips.hide()},remove:function(){this.tips.remove()}},e.fn.Jtips=function(i,s){return this.each(function(){var a=new t(this,i,s);e(this).data("Jtips",a)})}}(jQuery),function(e){e.fn.jqueryzoom=function(t){var i={xzoom:200,yzoom:200,offset:10,position:"right",lens:1,preload:1};t&&e.extend(i,t);var s="";e(this).hover(function(){function t(e){this.x=e.pageX,this.y=e.pageY}var a=e(this).offset().left,o=e(this).offset().top,n=e(this).find("img").get(0).offsetWidth,r=e(this).find("img").get(0).offsetHeight;s=e(this).find("img").attr("alt");var c=e(this).find("img").attr("jqimg");e(this).find("img").attr("alt",""),0==e("div.zoomdiv").get().length&&(e(this).after("<div class='zoomdiv'><img class='bigimg' src='"+c+"'/></div>"),e(this).append("<div class='jqZoomPup'>&nbsp;</div>")),e("div.zoomdiv").width(i.xzoom),e("div.zoomdiv").height(i.yzoom),e("div.zoomdiv").show(),i.lens||e(this).css("cursor","crosshair"),e(document.body).mousemove(function(s){mouse=new t(s);var c=e(".bigimg").get(0).offsetWidth,d=e(".bigimg").get(0).offsetHeight,l="x",p="y";if(isNaN(p)|isNaN(l)){var p=c/n,l=d/r;e("div.jqZoomPup").width(i.xzoom/(1*p)),e("div.jqZoomPup").height(i.yzoom/(1*l)),i.lens&&e("div.jqZoomPup").css("visibility","visible")}xpos=mouse.x-e("div.jqZoomPup").width()/2-a,ypos=mouse.y-e("div.jqZoomPup").height()/2-o,i.lens&&(xpos=a>mouse.x-e("div.jqZoomPup").width()/2?0:mouse.x+e("div.jqZoomPup").width()/2>n+a?n-e("div.jqZoomPup").width()-2:xpos,ypos=o>mouse.y-e("div.jqZoomPup").height()/2?0:mouse.y+e("div.jqZoomPup").height()/2>r+o?r-e("div.jqZoomPup").height()-2:ypos),i.lens&&e("div.jqZoomPup").css({top:ypos,left:xpos}),scrolly=ypos,e("div.zoomdiv").get(0).scrollTop=scrolly*l,scrollx=xpos,e("div.zoomdiv").get(0).scrollLeft=scrollx*p})},function(){e(this).children("img").attr("alt",s),e(document.body).unbind("mousemove"),i.lens&&e("div.jqZoomPup").remove(),e("div.zoomdiv").remove()}),count=0,i.preload&&(e("body").append("<div style='display:none;' class='jqPreload"+count+"'>360buy</div>"),e(this).each(function(){var t=e(this).children("img").attr("jqimg"),i=jQuery("div.jqPreload"+count).html();jQuery("div.jqPreload"+count).html(i+'<img src="'+t+'">')}))}}(jQuery);var mdPerfix=1==pageConfig.product.type?"CR":"GR",mbPerfix=1==pageConfig.product.type?"3C":"GM",skuid=pageConfig.product.skuid,suit_TPL={tabs:'<ul class="stab lh">{for item in packResponseList}<li class="fore${parseInt(item_index)+1}{if item_index==0} scurr{/if}" data-widget="tab-item" data-cat="${item.packId}" data-suit="${item.packName}">\u4f18\u60e0\u5957\u88c5${parseInt(item_index)+1}</li>{/for}</ul>',cons:'{for item in packResponseList}<div data-widget="tab-content" packPrice="${item.packPrice.amount}" packListPrice="${item.packListPrice.amount}" discount="${item.discount.amount}" data-cat="${item.packId}" class="stabcon{if parseInt(item_index) !== 0} none{/if}"><div class="master">    <s></s>    <div class="p-img">        <a href="http://item.jd.com/'+G.sku+'.html" target="_blank"><img src="${pageConfig.FN_GetImageDomain('+G.sku+")}n4/"+pageConfig.product.src+'" height="100" width="100"></a>'+"    </div>"+'    <div class="p-name">'+'        <a href="http://item.jd.com/'+G.sku+'.html" target="_blank">'+unescape(G.name)+"</a>"+"    </div>"+"</div>"+'<div class="suits">'+'    <ul class="lh" style="width:${(item.productList.length-1)*165}px">'+"{for itemList in item.productList}"+"{if itemList.skuId == G.sku}"+"{else}"+"        <li>"+"            <s></s>"+'            <div class="p-img">'+'                <a href="http://item.jd.com/${itemList.skuId}.html" target="_blank"><img src="${pageConfig.FN_GetImageDomain(itemList.skuId)}n4/${itemList.skuPicUrl}" alt="" height="100" width="100"></a>'+"            </div>"+'            <div class="p-name">'+'                <a href="http://item.jd.com/${itemList.skuId}.html" target="_blank">${itemList.skuName}</a>'+"            </div>"+"        </li>"+"{/if}"+"{/for}"+"    </ul>"+"</div>"+'<div class="infos">'+"    <s></s>"+'    <div class="p-name">'+'        <a href="http://www.jd.com/suite/${item.packId}-${skuId}.html">${item.packName}</a>'+"    </div>"+'    <div class="p-price">\u5957&nbsp;&nbsp;\u88c5&nbsp;&nbsp;\u4ef7\uff1a'+'        <strong class="fitting-price">${parseFloat(item.packPrice.amount).toFixed(2)}</strong>'+"    </div>"+'    <div class="p-price">\u539f\u3000\u3000\u4ef7\uff1a'+'        <del class="orign-price">${parseFloat(item.packListPrice.amount).toFixed(2)}</del>'+"    </div>"+'    <div class="p-saving">\u7acb\u5373\u8282\u7701\uff1a'+'        <span class="fitting-saving">${parseFloat(item.discount.amount).toFixed(2)}</span>'+"    </div>"+'    <div class="btns">'+'        <a class="btn-buy" href="http://jd2008.jd.com/purchase/initcart.aspx?pId=${item.packId}&pCount=1&pType=2" clstag="shangpin|keycount|product|{if G.isPop}popbuysuit{else}zybuysuit{/if}">\u8d2d\u4e70\u5957\u88c5</a>'+"    </div>"+"</div>"+"</div>"+"{/for}"},recoFittings_TPL={tabs:'<li class="fore scurr" onclick="G.sortFitting(this, \'all\', \'#tab-reco\')">\u5168\u90e8\u914d\u4ef6</li>{for item in fittingType}<li class="fore${parseInt(item_index)+1}" data-count="${item.number}" data-cat="${item.sort}" onclick="G.sortFitting(this, ${item.sort}, \'#tab-reco\')">${item.name}(${item.number})</li>{/for}',cons:'<div class="master">    <s></s>    <div class="p-img">        <a href="http://item.jd.com/${master.skuid}.html" target="_blank"><img src="${pageConfig.FN_GetImageDomain(master.skuid)}n4/${master.pic}" height="100" width="100"></a>    </div>    <div class="p-name">        <a href="http://item.jd.com/${master.skuid}.html" target="_blank">${master.name}</a>    </div>    <div class="p-price"><input type="checkbox" onclick="return false;" onchange="return false" wmeprice="{if master.price==""}0.00{else}${master.price}{/if}" wmaprice="${master.discount}" skuid="${master.skuid}" checked/> ${master.price}</div></div><div class="suits" data-count="${fittings.length}" style="overflow-x:{if parseInt(fittings.length)>(pageConfig.wideVersion&&pageConfig.compatible ? 4:3)}scroll{else}hidden{/if}">    <ul class="lh" style="width:${parseInt(fittings.length)*165}px">        {for item in fittings}        <li data-cat="${item.sort}">            <s></s>            <div class="p-img">                <a href="http://item.jd.com/${item.skuid}.html" target="_blank"><img src="${pageConfig.FN_GetImageDomain(item.skuid)}n4/${item.pic}" alt="" height="100" skuidth="100"></a>            </div>            <div class="p-name">                <a href="http://item.jd.com/${item.skuid}.html" target="_blank">${item.name}</a>            </div>            <div class="choose">                <input type="checkbox" id="inp_${item.skuid}" onclick="G.calculatePrice(this, \'#tab-reco\')" wmaprice="${item.discount}" wmeprice="${item.price}" skuid="${item.skuid}" />                <label for="inp_${item.skuid}" class="p-price">                    <strong><img src="http://jprice.360buyimg.com/price/gp${item.skuid}-1-1-1.png" onerror="this.src=\'http://misc.360buyimg.com/lib/skin/e/i/error-3.gif\'" /></strong>                </label>            </div>        </li>        {/for}    </ul></div><div class="infos">    <s></s>    <div class="p-name">        <em>\u5df2\u9009\u62e9<span>0</span>\u4e2a\u914d\u4ef6</em>    </div>    <div class="p-price">\u642d&nbsp;&nbsp;\u914d&nbsp;&nbsp;\u4ef7\uff1a        <strong class="res-jdprice">{if master.price==""}\u6682\u65e0\u62a5\u4ef7{else}\uffe5 ${master.price}{/if}</strong>    </div>    <div class="p-saving">\u83b7\u5f97\u4f18\u60e0\uff1a        <span class="res-totalprice">\uffe5 ${master.discount}</span>    </div>    <div class="btns">        <a class="btn-buy" href="http://jd2008.jd.com/purchase/OrderFlowService.aspx?action=AddSkus&wids=${master.skuid}">\u7acb\u5373\u8d2d\u4e70</a>    </div></div>'},suitRecommend_TPL='<div class="stabcon"><div class="master">    <s></s>    <div class="p-img">        <a href="http://item.jd.com/${master.wid}.html" target="_blank"><img src="${pageConfig.FN_GetImageDomain(master.wid)}n4/${master.imgurl}" height="100" width="100"></a>    </div>    <div class="p-name">        <a href="http://item.jd.com/${master.wid}.html" target="_blank">${master.name}</a>    </div>    <div class="p-price none"><input type="checkbox" id="inp_${master.wid}" onclick="return false;" onchange="return false" wmaprice="${master.wmaprice}" wmeprice="${master.wmeprice}" skuid="${master.wid}" checked/> ${master.wmeprice}</div></div><div class="suits" style="overflow-x:{if parseInt(recoList.length)>(pageConfig.wideVersion&&pageConfig.compatible ? 4:3)}scroll{else}hidden{/if}">    <ul class="lh" style="width:${parseInt(recoList.length)*165}px">        {for item in recoList}        <li onclick="reClick(\''+mdPerfix+"3', '${master.wid}', '${item.wid}#${item.wmeprice}', '${item_index}');\">"+"            <s></s>"+'            <div class="p-img">'+'                <a href="http://item.jd.com/${item.wid}.html" target="_blank"><img src="${pageConfig.FN_GetImageDomain(item.wid)}n4/${item.imgurl}" alt="" height="100" width="100"></a>'+"            </div>"+'            <div class="p-name">'+'                <a href="http://item.jd.com/${item.wid}.html" target="_blank">${item.name}</a>'+"            </div>"+'            <div class="choose">'+'                <input type="checkbox" id="inp_${item.wid}" onclick="G.calculatePrice(this, \'#tab-hot\')" wmaprice="${item.wmaprice}" wmeprice="${item.wmeprice}" skuid="${item.wid}" />'+'                <label for="inp_${item.wid}" class="p-price">'+'                    <strong><img src="http://jprice.360buyimg.com/price/gp${item.wid}-1-1-1.png" onerror="this.src=\'http://misc.360buyimg.com/lib/skin/e/i/error-3.gif\'" /></strong>'+"                </label>"+"            </div>"+"        </li>"+"        {/for}"+"    </ul>"+"</div>"+'<div class="infos" onclick="{for item in recoList}reClick(\''+mdPerfix+"3', '${master.wid}', '${item.wid}#${item.wmeprice}', '${item_index}');{/for}\">"+"    <s></s>"+'    <div class="p-name">'+"        <a onclick=\"log('"+mbPerfix+"PopularBuy','click')\" href=\"http://jd2008.jd.com/purchase/OrderFlowService.aspx?action=AddSkus&wids=${master.wid}\">\u8d2d\u4e70\u4eba\u6c14\u7ec4\u5408</a>"+"    </div>"+'    <div class="p-price">\u603b\u4eac\u4e1c\u4ef7\uff1a'+'        <strong class="res-jdprice">\uffe5 ${master.wmeprice}</strong>'+"    </div>"+'    <div class="p-saving">\u603b\u53c2\u8003\u4ef7\uff1a'+'        <del class="res-totalprice">\uffe5 ${master.wmaprice}</del>'+"    </div>"+'    <div class="btns">'+"        <a onclick=\"log('"+mbPerfix+'PopularBuy\',\'click\')" class="btn-buy" href="http://jd2008.jd.com/purchase/OrderFlowService.aspx?action=AddSkus&wids=${master.wid}">\u8d2d\u4e70\u7ec4\u5408</a>'+"    </div>"+'</div><div class="clb"></div>'+"</div>",listBuyBuy_TPL='<div class="p-img">        <a target="_blank" title="${Wname}" href="${WidStr}"><img height="100" width="100" alt="" src="${ImageUrl}"></a>    </div>    <div class="p-name">        <a target="_blank" title="${Wname}" href="${WidStr}">${Wname}</a>    </div>    <div class="p-price">        <strong>            <img src="http://jprice.360buyimg.com/price/gp${Wid}-1-1-1.png" onerror="this.src=\'http://misc.360buyimg.com/lib/skin/e/i/error-3.gif\'" />        </strong>    </div>',listBrosweBroswe_TPL='<li onclick="reClick(1,\'\',\'${wid}\',${arguments[2]});" class="fore${parseInt(arguments[2])+1}">    <div class="p-img">        <a target="_blank" title="${name}" href="http://item.jd.com/${wid}.html"><img height="100" width="100" alt="${name}" src="${pageConfig.FN_GetImageDomain(wid)}n4/${imgurl}"></a>    </div>    <div class="p-name">        <a target="_blank" title="${name}" href="http://item.jd.com/${wid}.html">${name}</a>    </div>    <div class="p-price">        <strong>            <img src="http://jprice.360buyimg.com/price/gp${wid}-1-1-1.png" onerror="this.src=\'http://misc.360buyimg.com/lib/skin/e/i/error-3.gif\'" />        </strong>    </div></li>',listBrosweBuy_TPL='<div class="p-img">        <a target="_blank" title="${Wname}" href="http://item.jd.com/${Wid}.html"><img height="100" width="100" alt="${Wname}" src="${ImageUrl}"></a>    </div>    <div class="p-name">    {if Count>0}        <strong>${Count}%\u4f1a\u4e70\uff1a</strong>    {/if}        <a target="_blank" title="${Wname}" href="http://item.jd.com/${Wid}.html">${Wname}</a>    </div>    <div class="p-price">        <strong>            <img src="http://jprice.360buyimg.com/price/gp${Wid}-1-1-1.png" onerror="this.src=\'http://misc.360buyimg.com/lib/skin/e/i/error-3.gif\'" />        </strong>    </div>',newCommentRate_TPL='<div id="i-comment">    <div class="rate">        <strong>${productCommentSummary.goodRateShow}<span>%</span></strong>        <br> <span>\u597d\u8bc4\u5ea6</span>     </div>     <div class="percent">        <dl>             <dt>\u597d\u8bc4<span>(${productCommentSummary.goodRateShow}%)</span></dt>             <dd> <div style="width: ${productCommentSummary.goodRateShow}px;"></div></dd>         </dl>         <dl>             <dt>\u4e2d\u8bc4<span>(${productCommentSummary.generalRateShow}%)</span></dt>             <dd class="d1"><div style="width: ${productCommentSummary.generalRateShow}%;"> </div></dd>         </dl>         <dl>             <dt>\u5dee\u8bc4<span>(${productCommentSummary.poorRateShow}%)</span></dt>            <dd class="d1">             <div style="width: ${productCommentSummary.poorRateShow}%;"> </div></dd>         </dl>     </div>     {if typeof hotCommentTagStatistics!="undefined" && hotCommentTagStatistics.length>0 && pageConfig.product.useTag}    <div class="actor-new">        <dl>            <dt>\u4e70\u5bb6\u5370\u8c61\uff1a</dt>            <dd class="p-bfc">                {for tag in hotCommentTagStatistics}<q class="comm-tags"><span>${tag.name}</span><em></em></q>{/for}            </dd>        </dl>        <div class="clr"></div> <b></b>    </div>    {elseif typeof topFiveCommentVos!="undefined"}    <div class="actor">         <em>\u53d1\u8868\u8bc4\u4ef7\u5373\u53ef\u83b7\u5f97\u79ef\u5206\uff0c\u524d\u4e94\u4f4d\u8bc4\u4ef7\u7528\u6237\u53ef\u83b7\u5f97\u53cc\u500d\u79ef\u5206\uff1a</em><a href="http://help.jd.com/help/question-58.html" target="_blank">\u8be6\u89c1\u79ef\u5206\u89c4\u5219</a>        <ul>            {for User in topFiveCommentVos}             <li><span>+{if User.integral==null}0{else}${User.integral}{/if}</span><div class="u-name">${parseInt(User_index)+1}. <a href="http://club.jd.com/userreview/${User.uid}-1-1.html" target="_blank">${User.nickname}</a></div></li>            {/for}         </ul>        <div class="clr"></div>         <b></b>    </div>    {/if}    <div class="btns">         <div>\u60a8\u53ef\u5bf9\u5df2\u8d2d\u5546\u54c1\u8fdb\u884c\u8bc4\u4ef7</div>         <a href="http://club.jd.com/mycomments.aspx?pid=${productCommentSummary.productId}" class="btn-comment" target="_blank">\u53d1\u8bc4\u4ef7\u62ff\u79ef\u5206</a>        <div><em class="hl_red">\u524d\u4e94\u540d\u53ef\u83b7\u53cc\u500d\u79ef\u5206</em><a href="http://help.jd.com/help/question-58.html" target="_blank">[\u89c4\u5219]</a></div>    </div></div>',newCommentList_TPL='{for list in comments}<div class="item">  <div class="user">      <div class="u-icon"> <a title="\u67e5\u770bTA\u7684\u5168\u90e8\u8bc4\u4ef7" href="http://club.jd.com/userreview/${list.uid}-1-1.html" target="_blank"> <img height="50" width="50" upin="achen0212" src="http://misc.360buyimg.com/lib/img/u/${list.userLevelId}.gif" alt="${list.nickname}"/> </a>      </div>      <div class="u-name"> <a href="http://club.jd.com/userreview/${list.uid}-1-1.html" target="_blank">{if !G.isNothing(list.nickname)}${list.nickname}{else}${list.pin}{/if}</a>      </div> <span class="u-level"><span style="color:{if !G.isNothing(list.userLevelColor)}${list.userLevelColor}{/if}"> ${list.userLevelName}</span> {if !G.isNothing(list.userProvince)}<span class="u-address">${list.userProvince}</span>{/if}</span>  </div>  <div class="i-item" data-guid="${list.guid}">      <div class="o-topic">           {if list.top}<strong class="topic topic-best">\u7cbe\u534e</strong>{/if}          <strong class="topic"><a href="http://club.jd.com/repay/${list.referenceId}_${list.guid}_1.html" target="_blank">${list.title}</a></strong>          <span class="star sa${list.score}"></span><span><a class="date-comment" title="\u67e5\u770b\u8bc4\u4ef7\u8be6\u60c5" href="http://club.jd.com/repay/${list.referenceId}_${list.guid}_1.html" target="_blank">${list.creationTime.replace(/:[0-9][0-9]$/, "")}</a><em class="fr">${list.userClientShow}</em></span>      </div>      <div class="comment-content">          {if !G.isNothing(list.commentTags)&&pageConfig.product.useTag}          <dl>              <dt>\u6807&#12288;&#12288;\u7b7e\uff1a</dt>              <dd>                  {for tag in list.commentTags}                  <q data-tid="${tag.id}" class="comm-tags" href="#none"><span>${tag.name}</span><em></em></q>                  {/for}              </dd>          </dl>          {/if}          {if !G.isNothing(list.pros)}          <dl>              <dt>\u4f18\u70b9\uff1a</dt>               <dd> ${list.pros}</dd>          </dl>          {/if}           {if !G.isNothing(list.cons)}          <dl>              <dt>\u4e0d\u8db3\uff1a</dt>               <dd> ${list.cons}</dd>          </dl>          {/if}           {if !G.isNothing(list.content)}           <dl>              <dt>\u5fc3\u5f97\uff1a</dt>               <dd> ${list.content}</dd>          </dl>          {/if}            {if list.mergeOrderStatus>0&&!G.isNothing(list.images)}            <dl> <dt>\u7528\u6237\u6652\u5355\uff1a</dt>            <dd>                <div class="comment-show-pic">                                  <table cellspacing="10"><tr>                  {for image in list.images}                      {if parseInt(image_index)<3}                      <td><a class="comment-show-pic-wrap" href="http://club.jd.com/bbsDetail/${list.showOrderComment.referenceId}_${list.showOrderComment.guid}_1.html" target="_blank" clstag="shangpin|keycount|product|shaipic"><img alt="" src="${image.imgUrl}" alt="${list.nickname} \u7684\u6652\u5355\u56fe\u7247" /></a></td>                      {/if}                  {/for}                  </tr></table>                                <span clstag="shangpin|keycount|product|shaitext"><em class="fl" style="color:#9C9A9C;margin-right:5px;">\u5171${list.images.length}\u5f20\u56fe\u7247</em><a href="http://club.jd.com/bbsDetail/${list.showOrderComment.referenceId}_${list.showOrderComment.guid}_1.html" target="_blank" class="p-simsun">\u67e5\u770b\u6652\u5355&gt;</a></span>                </div>            </dd>            {/if}          <div class="dl-extra">              {if !G.isNothing(list.productColor)}              <dl>                  <dt>\u989c\u8272\uff1a</dt>                  <dd>${list.productColor}</dd>              </dl>              {/if}              {if !G.isNothing(list.productSize)}              <dl>                  <dt>\u578b\u53f7\uff1a</dt>                  <dd>${list.productSize}</dd>              </dl>              {/if}              {for attr in productAttr}                  {if !G.isNothing(list[attr.key])}                  <dl>                      <dt>${attr.name}\uff1a</dt>                      <dd>${list[attr.key]}${attr.unit}</dd>                  </dl>                  {/if}              {/for}          </div><s class="clr"></s>          {if typeof list.referenceTime !=="undefined"}          <dl>              <dt>\u8d2d\u4e70\u65e5\u671f\uff1a</dt>              <dd>${list.referenceTime.split(" ")[0]}</dd>          </dl>          {/if}      </div>      <div class="btns">          <a class="btn-reply btn-toggle fr" data-id="${list.id}" href="#none">\u56de\u590d(<em>${list.replyCount}</em>)</a>          <div class="useful fr" id="${list.guid}">              <a name="agree" class="btn-agree" title="${list.usefulVoteCount}" href="#none">\u6709\u7528(${list.usefulVoteCount})</a>              <!--<a name="oppose" class="btn-oppose" title="${list.uselessVoteCount}" href="#none">\u6ca1\u7528(${list.uselessVoteCount})</a>-->          </div>      </div>      <div class="item-reply reply-lz" data-name="{if !G.isNothing(list.nickname)}${list.nickname}{else}${list.pin}{/if}" data-uid="{list.uid}">          <strong></strong>          <div class="reply-list">               <div id="btn-toggle-${_type}-${list.id}" class="replay-form none">                   <div class="arrow"> <em>\u25c6</em><span>\u25c6</span></div>                   <div class="reply-wrap">                       <p><em>\u56de\u590d</em>  <span class="u-name">${list.nickname}\uff1a</span></p>                       <div class="reply-input">                           <div class="fl"><input type="text"></div>                           <a href="#none" class="reply-btn btn-gray p-bfc reply-btn-lz" data-nick="${list.nickname}" data-guid="${list.guid}" data-replyId="${list.id}">\u56de\u590d</a>                           <div class="clr"></div>                       </div>                   </div>               </div>          </div>      </div>      {for reply in list.replies}      <div class="item-reply" data-index="${list.replyCount-parseInt(reply_index)}" data-name="${reply.nickname}" data-uid="${reply.uid}">          <strong>${list.replyCount-parseInt(reply_index)}</strong>          <div class="reply-list">              <div class="reply-con">                  <span class="u-name">                      <a target="_blank" href="http://club.jd.com/userreview/${reply.uid}-1-1.html">${reply.nickname}{if reply.userClient==99}<b></b>{/if}</a>                      {if parseInt(reply.parentId, 10)>0}                      <em>\u56de\u590d</em>                      {if !G.isNothing(reply.parent)}<a target="_blank" href="http://club.jd.com/userreview/${reply.parent.uid}-1-1.html">{if parseInt(reply.parentId, 10)<0}${list.nickname}{else}${reply.parent.nickname}{if reply.parent.userClient==99}<b></b>{/if}{/if}</a>{/if}{/if}\uff1a                  </span>                  <span class="u-con">${reply.content}</span>              </div>              <div class="reply-meta">                  <span class="reply-left fl">${reply.creationTimeString.replace(/:[0-9][0-9]$/, "")}</span>                  <a class="p-bfc btn-toggle hl_blue" data-id="${reply.id}" href="#none">\u56de\u590d</a>              </div>              <div id="btn-toggle-${_type}-${reply.id}" class="replay-form none">                  <div class="arrow">                      <em>\u25c6</em><span>\u25c6</span>                  </div>                  <div class="reply-wrap">                      <p><em>\u56de\u590d</em> <span class="u-name">${reply.nickname}\uff1a</span></p>                      <div class="reply-input">                          <div class="fl"><input type="text" /></div>                          <a href="#none" class="reply-btn btn-gray p-bfc" data-nick="${reply.nickname}" data-guid="${list.guid}" data-replyId="${reply.id}">\u56de\u590d</a>                          <div class="clr"></div>                      </div>                  </div>              </div>          </div>      </div>      {/for}      {if list.replyCount > 5}      <div class="ac">           <a class="hl_blue" href="http://club.jd.com/repay/${productCommentSummary.productId}_${list.guid}_1.html" title="\u67e5\u770b\u5168\u90e8\u56de\u590d" target="_blank">\u67e5\u770b\u5168\u90e8\u56de\u590d&gt;&gt;</a>      </div>      {/if}   </div>  <div class="corner tl"></div></div>{forelse}    {if score == 0}     <div class="norecode">         \u6682\u65e0\u5546\u54c1\u8bc4\u4ef7\uff01<span style="hl-red">\u4e89\u62a2\u4ea7\u54c1\u8bc4\u4ef7\u524d5\u540d\uff0c\u524d5\u4f4d\u8bc4\u4ef7\u7528\u6237\u53ef\u83b7\u5f97\u591a\u500d\u79ef\u5206\u54e6\uff01</span>\uff08<a href="http://help.jd.com/help/question-58.html" target="_blank">\u8be6\u89c1\u79ef\u5206\u89c4\u5219</a>\uff09\uff01    </div>    <div class="extra clearfix">        <div class="join">            \u53ea\u6709\u8d2d\u4e70\u8fc7\u8be5\u5546\u54c1\u7684\u7528\u6237\u624d\u80fd\u8fdb\u884c\u8bc4\u4ef7\u3002&nbsp;&nbsp;<a target="_blank" href="http://club.jd.com/Simplereview/${productCommentSummary.productId}.html" name="http://club.jd.com/Simplereview/${productCommentSummary.productId}.html" id="A1">[\u53d1\u8868\u8bc4\u4ef7]</a>&nbsp;&nbsp;<a target="_blank" href="http://club.jd.com/allreview/1-1.html">[\u6700\u65b0\u8bc4\u4ef7]</a>        </div>    </div>     {elseif score == 3}         <div class="norecode"> \u6682\u65e0\u597d\u8bc4\uff01</div>     {elseif score == 2}         <div class="norecode"> \u6682\u65e0\u4e2d\u8bc4\uff01</div>     {elseif score == 1}         <div class="norecode"> \u6682\u65e0\u5dee\u8bc4\uff01</div>     {elseif score == 4}         <div class="norecode"> \u6682\u65e0\u6652\u5355\u8bc4\u4ef7\uff01</div>    {/if}{/for}<div class="clearfix">    {if productCommentSummary.commentCount}<div class="fl" style="padding:8px 0 0 120px;"><a href="http://club.jd.com/review/${productCommentSummary.productId}-0-1-0.html" target="_blank" class="hl_blue">[\u67e5\u770b\u5168\u90e8\u8bc4\u4ef7]</a></div>{/if}    <div class="pagin fr" clstag="shangpin|keycount|product|fanye" id="commentsPage${score}">    </div></div>',discuss_TPL='<table width="100%" cellspacing="0" cellpadding="0" border="0">    <tbody>        <tr>            <th class="col1">\u4e3b\u9898</th>            <th class="col2">\u56de\u590d/\u6d4f\u89c8</th>            <th class="col3">\u4f5c\u8005</th>            <th class="col4">\u65f6\u95f4</th>        </tr>        {for comment in discussComments.Comments}        <tr>            <td class="col1">                <div class="topic">                    {if comment.referenceType == "Order"}                    <b class="icon shai"></b>                    {elseif comment.referenceType == "User"}                    <b class="icon lun"></b>                    {elseif comment.referenceType == "Question"}                    <b class="icon wen"></b>                    {elseif comment.referenceType == "Friend"}                    <b class="icon quan"></b>                    {/if}                    <a href="http://club.jd.com/bbsDetail/${comment.referenceId}_${comment.id}_1.html" target="_blank">${comment.title}</a>                </div>            </td>            <td class="col2">${comment.replyCount}/${comment.viewCount}</td>            <td class="col3">                <div class="u-name">                    <a target="_blank" title="${comment.uRemark}" href="http://club.jd.com/userdiscuss/${comment.uid}-1.html">{if comment.uRemark}${comment.uRemark}{else}${comment.userId}{/if}</a>                </div>            </td>            <td class="col4">${comment.creationTime}</td>        </tr>        {/for}    </tbody></table>{if discussComments.CommentCount <= 0}    {if parseInt(ReferenceType) == 1}        <div class="norecode">\u6682\u65e0\u8ba8\u8bba\u5e16\uff01</div>    {elseif parseInt(ReferenceType) == 2}        <div class="norecode">\u6682\u65e0\u95ee\u7b54\u5e16\uff01</div>    {elseif parseInt(ReferenceType) == 3}        <div class="norecode">\u6682\u65e0\u5708\u5b50\u8d34\uff01</div>    {elseif parseInt(ReferenceType) == 4}        <div class="norecode">\u6682\u65e0\u6652\u5355\u5e16\uff01</div>    {else}        <div class="norecode">\u6682\u65e0\u7f51\u53cb\u8ba8\u8bba\uff01</div>    {/if}{/if}<div class="extra clearfix">    <div class="total">          <span>\u5171${discussComments.CommentCount}\u4e2a\u8bdd\u9898</span>&nbsp;&nbsp;           <a target="_blank" href="http://club.jd.com/bbs/${referenceId}-1-0-${ReferenceType}.html">\u6d4f\u89c8\u5168\u90e8\u8bdd\u9898&gt;&gt;</a>    </div>    <div class="contact">        \u6709\u95ee\u9898\u8981\u4e0e\u5176\u4ed6\u7528\u6237\u8ba8\u8bba\uff1f<a target="_blank" href="http://club.jd.com/bbs/${referenceId}-1.html" name="http://club.jd.com/bbs/${referenceId}-1.html" id="userComment${ReferenceType}">[\u53d1\u8868\u8bdd\u9898]</a>    </div></div>',consult_TPL='{if Consultations.length > 0}    {for Consultation in Consultations}    <div class="item{if Consultation_index% 2 == 1} odd{/if}">        <div class="user">            <span class="u-name">\u7f51\u3000\u3000\u53cb\uff1a${Consultation.UNickNme}</span>             <!--<span class="u-level" name="${Consultation.UserId}"></span>-->             <span class="u-level" ><font style="color:${Consultation.UserLevelColor}"> ${Consultation.UserLevelName} </font></span>             <span class="date-ask">${Consultation.CreationTime}</span>        </div>        <dl class="ask">            <dt><b></b>\u54a8\u8be2\u5185\u5bb9\uff1a</dt>            <dd><a target="_blank" href="http://club.jd.com/consultation/${Consultation.ProductId}-${Consultation.Id}.html">${Consultation.Content}</a></dd>        </dl>        <dl class="answer">            {for Reply in Consultation.Replies}            <dt>                <b></b>                {if Reply.sst == 2}\u5356\u5bb6\u56de\u590d\uff1a {else}\u4eac\u4e1c\u56de\u590d\uff1a{/if}             </dt>            <dd>                <div class="content">${Reply.sword}</div>                <div class="date-answer">${Reply.sinsdate}</div>            </dd>            {/for}        </dl>    </div>    {/for} {else}    <div class="norecode">\u6682\u65e0\u8be5\u7c7b\u54a8\u8be2\uff01</div>{/if}<div class="extra clearfix">    <div class="total">        \u5171<strong>${SearchParameter.Count}</strong>\u6761&nbsp;&nbsp;         <a href="http://club.jd.com/allconsultations/${SearchParameter.ProductId}-1-1.html" target="_blank">\u6d4f\u89c8\u6240\u6709\u54a8\u8be2\u4fe1\u606f&gt;&gt;</a>     </div>    <div class="join">        \u8d2d\u4e70\u4e4b\u524d\uff0c\u5982\u6709\u95ee\u9898\uff0c\u8bf7\u5411\u4eac\u4e1c\u54a8\u8be2\u3002&nbsp;&nbsp;        <a id="consultation" href="http://club.jd.com/allconsultations/${SearchParameter.ProductId}-1-1.html#form1">[\u53d1\u8868\u54a8\u8be2]</a>    </div></div>',consult_search_TPL='{for item in list}<div class="item search-result-item">    <div class="user">        <span class="u-name">\u7f51\u3000\u3000\u53cb\uff1a${item.nickname}</span>        <span class="date-ask">${item.sindate}</span>    </div>    <dl class="ask">        <dt><b></b>\u54a8\u8be2\u5185\u5bb9\uff1a</dt>        <dd>${item.sword}</dd>    </dl>    <dl class="answer">        <dt><b></b>\u4eac\u4e1c\u56de\u590d\uff1a</dt>        <dd>{if item.sword!==""}${item.sword2}{/if}</dd>    </dl>    <div id="${item.sid}" class="useful">\u60a8\u5bf9\u6211\u4eec\u7684\u56de\u590d\uff1a        <a name="2" href="#none" class="btn-pleased">\u6ee1\u610f</a>        (<span>${item.zantong}</span>)\u3000        <a name="2" href="#none" class="btn-unpleased">\u4e0d\u6ee1\u610f</a>        (<span>${item.fd}</span>)    </div></div>{/for}',search_TPL='{for list in Product}<dl skuid="${list.wareid}">    <dt class="p-img"><a target="_blank" href="http://item.jd.com/${list.wareid}.html"><img width="50" height="50" src="${pageConfig.FN_GetImageDomain(list.wareid)}n5/${list.Content.imageurl}" alt=""></a></dt>    <dd class="p-name"><a target="_blank" href="http://item.jd.com/${list.wareid}.html">${list.Content.warename}</a></dd>    <dd class="p-price">        <img src="http://jprice.360buyimg.com/price/gp${list.wareid}-1-1-1.png" onerror="this.src=\'http://misc.360buyimg.com/lib/skin/e/i/error-3.gif\'" />    </dd></dl>{/for}',setAmount={min:1,max:999,count:1,countEl:$("#buy-num"),buyLink:$("#choose-btn-append .btn-append"),targetLink:$("#choose-btn-append .btn-append"),matchCountKey:["pcount","pCount","num"],add:function(){return this.count>999?(alert("\u5546\u54c1\u6570\u91cf\u6700\u591a\u4e3a"+this.max),!1):(this.count++,this.countEl.val(this.count),this.setBuyLink(),void 0)
},reduce:function(){return 1>=this.count?(alert("\u5546\u54c1\u6570\u91cf\u6700\u5c11\u4e3a"+this.min),!1):(this.count--,this.countEl.val(this.count),this.setBuyLink(),void 0)},modify:function(){var e=parseInt(this.countEl.val(),10);return isNaN(e)||1>=e||e>999?(alert("\u5546\u54c1\u6570\u91cf\u5e94\u8be5\u5728"+this.min+"-"+this.max+"\u4e4b\u95f4"),this.countEl.val(this.count),!1):(this.count=e,this.setBuyLink(),void 0)},setBuyLink:function(){var e=this;e.targetLink.each(function(){var t,i,s=$(this),a=s.attr("href"),o=a.split("?")[1];(function(){for(var n=0;e.matchCountKey.length>n;n++)if(i=RegExp(e.matchCountKey[n]+"=\\d+"),i.test(o))return t=a.replace(i,e.matchCountKey[n]+"="+e.count),s.attr("href",t),!1})()})}};(function(){var e=$("#choose-color .selected a,#choose-version .selected a"),t=$("#choose-result .dd"),i=[];1>e.length||$("#product-intro").hasClass("product-intro-noitem")?$("#choose-result").hide():(e.each(function(){1==!!$(this).attr("title")&&i.push("<strong>\u201c"+$(this).attr("title")+"\u201d</strong>")}),i.length>0&&(t.prepend("<em>\u5df2\u9009\u62e9</em>"+i.join("\uff0c")),$("#choose-result").show()))})(),function(){var e="4835-4836-4833",t=G.cat[2];RegExp(t).test(e)&&$("#choose-amount").hide(),(4835==t||4836==t)&&(setAmount.urlPerfix="http://card.jd.com/order/order_place.action?",setAmount.data=null,setAmount.data={skuId:G.sku}),4833==t&&(setAmount.urlPerfix="http://chongzhi.jd.com/order/order_place.action?",setAmount.data=null,setAmount.data={skuId:G.sku})}();var fq_serverSite="http://jd2008.jd.com/purchase/",fq_serverSiteService="http://jd2008.jd.com/purchaseservice/",fq_serverUrl="ajaxServer/ForMiniCart_fq.aspx",fq_btnPanel="choose-btn-divide",fq_skuId="",fq_TipHtml="",isFqOpen=!0,isYbOpen=!0,fq_returnData=null,isIe=window.ActiveXObject?!0:!1;if(isFqOpen)if(isIe)fq_init();else try{fq_init()}catch(e){document.addEventListener("DOMContentLoaded",fq_init,null)}var buyBtnLink,fittingsAuto={init:function(e,t){this.sku=e,this.catId=t,this.get()},get:function(){var e=this;$.ajax({url:"http://rs.jd.com/carAccessorie/thirdTypeMatchScheme/"+this.catId+"/"+this.sku+".jsonp",dataType:"jsonp",scriptCharset:"utf-8",success:function(t){e.set(t)}})},set:function(e){var t={tabs:'<div class="tab-cat stab">      <ul>          <li id="tab-cat-0" class="fl scurr" data-widget="tab-item" data-cat="\u914d\u4ef6\u9009\u8d2d\u4e2d\u5fc3|3">\u7cbe\u9009\u914d\u4ef6</li>          {for tab in list}          {if parseInt(tab.carAccessoryShows.length)>0}          <li id="tab-cat-${parseInt(tab_index)+1}" class="fl" data-widget="tab-item" data-cat="${tab.typeName}|${tab.carAccessoryShows[0].secondType}|${tab.carAccessoryShows[0].thirdType}">${tab.typeName}</li>          {/if}          {/for}      </ul></div>',cons:'<div id="newFittign-tab" data-widget="tabs"><div class="master">    <s></s>    <div class="p-img">        <a href="http://item.jd.com/${G.sku}.html" target="_blank"><img src="${pageConfig.FN_GetImageDomain(G.sku)}n4/${G.src}" height="100" width="100"></a>    </div>    <div class="p-name">        <a href="http://item.jd.com/${G.sku}.html" target="_blank">${G.name}</a>    </div>    <div class="p-price"><input type="checkbox" onclick="return false;" onchange="return false" wmeprice="{if mainProduct.wMeprice==""}0.00{else}${mainProduct.wMeprice}{/if}" wmaprice="${mainProduct.wMaprice}" skuid="${mainProduct.wid}" checked/> ${mainProduct.wMeprice}</div></div><div class="suits" style="width:${pageConfig.wideVersion&&pageConfig.compatible?(4*165-40):(3*128)}px;overflow-x:auto;overflow-y:hidden;">    {for tab in list}    {if parseInt(tab.carAccessoryShows.length)>0}    <ul id="newFitting-${parseInt(tab_index)+1}" data-cat="${tab.typeName}" style="width:${parseInt(tab.carAccessoryShows.length)*165}px;" class="lh hide" data-widget="tab-content">      <div class="iloading">\u52a0\u8f7d\u4e2d...</div>    </ul>    {/if}    {/for}</div><div class="infos">    <div id="more-fitting-link"><a class="hl_link" href="http://rs.jd.com/carAccessorie/requestCarCenter" target="_blank">\u8fdb\u5165\u914d\u4ef6\u9009\u8d2d\u4e2d\u5fc3</a><span>&gt;<b></b></span></div>    <s></s>    <div class="p-name">        <em>\u5df2\u9009\u62e9<span>0</span>\u4e2a\u914d\u4ef6</em>    </div>    <div class="p-price">\u642d&nbsp;&nbsp;\u914d&nbsp;&nbsp;\u4ef7\uff1a        <strong class="res-jdprice">{if mainProduct.wMeprice==""}\u6682\u65e0\u62a5\u4ef7{else}\uffe5 ${parseInt(mainProduct.wMeprice,10).toFixed(2)}{/if}</strong>    </div>    <div class="p-saving">\u53c2&nbsp;&nbsp;\u8003&nbsp;&nbsp;\u4ef7\uff1a        <span class="res-totalprice">\uffe5 ${parseInt(mainProduct.wMaprice,10).toFixed(2)}</span>    </div>    <div class="btns">        <a class="btn-buy" href="http://jd2008.jd.com/purchase/OrderFlowService.aspx?action=AddSkus&wids=${G.sku}">\u7acb\u5373\u8d2d\u4e70</a>    </div></div></div>',item:'{for item in carAccessoryShows}<li {if (parseInt(item_index)+1)==carAccessoryShows.length} class="last_item"{/if} onclick=\'clsClickLog("655", "${G.sku}", "${item.wid}", 34, "${item_index}", "rodGlobalTrack");\'>    <s></s>    <div class="p-img">        <a href="http://item.jd.com/${item.wid}.html" target="_blank"><img src="${pageConfig.FN_GetImageDomain(item.wid)}n4/${item.imageUrl}" alt="" height="100" height="100"></a>    </div>    <div class="p-name">        <a href="http://item.jd.com/${item.wid}.html" target="_blank">${item.wName}</a>    </div>    <div class="choose">        <input type="checkbox" id="inp_${item.wid}" onclick="G.calculatePrice(this, \'#tab-reco\')" wmaprice="${item.wMaprice}" wmeprice="${item.wMeprice}" skuid="${item.wid}" />        <label for="inp_${item.wid}" class="p-price">            <strong><img src="http://jprice.360buyimg.com/price/gp${item.wid}-1-1-1.png" /></strong>        </label>    </div>    <div class="p-more{if typeof allList=="undefined"&&parseInt(item_index)+1!=parseInt(carAccessoryShows.length)} hide{/if}"><a class="hl_link" href="http://rs.jd.com/carAccessorie/requestCarCenter?tTypeId=${item.thirdType}&sTypeId=${item.secondType}&from=singlePage" target="_blank">\u66f4\u591a{if typeof item.typeName!=="undefined"}${item.typeName}{else}${typeName}{/if}</a></div></li>{/for}'},i={carAccessoryShows:[],allList:!0};if(e&&e.list&&e.list.length>0){$("#tab-reco").attr("loaded","true").html(t.cons.process(e));for(var s=0;e.list.length>s;s++)if(void 0!==typeof e.list[s].carAccessoryShows&&e.list[s].carAccessoryShows.length>0&&e.list[s].carAccessoryShows){if(e.list[s].carAccessoryShows[0]){var a=e.list[s].carAccessoryShows[0];a.typeName=e.list[s].typeName,i.carAccessoryShows.push(a)}$("#newFitting-"+(s+1)).html(t.item.process(e.list[s]))}$("#newFittign-tab .suits").prepend('<ul id="newFitting-0" class="lh" data-widget="tab-content" style="width:'+165*i.carAccessoryShows.length+'px">'+t.item.process(i)+"</ul>"),$("#newFittign-tab").prepend(t.tabs.process(e)),$("#newFittign-tab").Jtab({event:"click",compatible:!0,currClass:"scurr"},function(e,t,i){var s=$("#tab-cat-"+i),a=s.attr("data-cat").split("|")[1],o=s.attr("data-cat").split("|")[2],n=$("#tab-cat-"+i).attr("data-cat").split("|")[0],r=$("#more-fitting-link a");r.attr("href","http://rs.jd.com/carAccessorie/requestCarCenter?tTypeId="+o+"&sTypeId="+a+"&from=singlePage").html("\u8fdb\u5165"+n)}),clsPVAndShowLog("655",G.sku,34,"s"),Recommend.switchTab("#th-fitting"),$("#tab-reco .suits ul").each(function(){G.removeLastAdd($(this))})}}},Recommend={init:function(e){this.type=e,this.renderHTML(),this.renderRecoFittingsHTML()},renderRecoFittingsHTML:function(){var e=G.sku;655==G.cat[2]?$.ajax({url:"http://rs.jd.com/accessorie/newServiceWhite.jsonp?sku="+G.sku+"&callback=Recommend.cbNewFittings",dataType:"script",cache:!0,scriptCharset:"utf-8"}):6728==G.cat[0]&&G.isJd?fittingsAuto.init(pageConfig.product.skuid,pageConfig.product.cat[2]):$.getJSONP("http://d.360buy.com/fittingInfo/get?skuId="+e+"&callback=Recommend.cbRecoFittings")},cbNewFittings:function(e){var t={accessoryList:[]},i={tabs:'<div class="tab-cat stab"><ul><li id="tab-cat-0" class="fl scurr" data-widget="tab-item" data-cat="\u914d\u4ef6\u9009\u8d2d\u4e2d\u5fc3|3">\u7cbe\u9009\u914d\u4ef6</li>{for tab in accessoryList}<li id="tab-cat-${parseInt(tab_index)+1}" class="fl" data-widget="tab-item" data-cat="${tab.thirdName}|${tab.thirdTypeId}">${tab.thirdName}</li>{/for}</ul></div>',cons:'<div id="newFittign-tab"  data-widget="tabs"><div class="master">    <s></s>    <div class="p-img">        <a href="http://item.jd.com/${mainproduct.sku}.html" target="_blank"><img src="${pageConfig.FN_GetImageDomain(mainproduct.sku)}n4/${mainproduct.imageUrl}" height="100" width="100"></a>    </div>    <div class="p-name">        <a href="http://item.jd.com/${mainproduct.sku}.html" target="_blank">${mainproduct.name}</a>    </div>    <div class="p-price"><input type="checkbox" onclick="return false;" onchange="return false" wmeprice="{if mainproduct.price==""}0.00{else}${mainproduct.price}{/if}" wmaprice="${mainproduct.maPrice}" skuid="${mainproduct.sku}" checked/> ${mainproduct.price}</div></div><div class="suits" style="width:${pageConfig.wideVersion&&pageConfig.compatible?(4*165-40):(3*128)}px;overflow-x:auto;overflow-y:hidden;">      {for tab in accessoryList}    <ul id="newFitting-${parseInt(tab_index)+1}" data-cat="${tab.thirdName}" style="width:660px;" class="lh hide" data-widget="tab-content">      <div class="iloading">\u52a0\u8f7d\u4e2d...</div>    </ul>      {/for}</div><div class="infos">    <div id="more-fitting-link"><a class="hl_link" href="http://rs.jd.com/accessorie/center.html?sku=${G.sku}&thirdTypeId=3" target="_blank">\u8fdb\u5165\u914d\u4ef6\u9009\u8d2d\u4e2d\u5fc3</a><span>&gt;<b></b></span></div>    <s></s>    <div class="p-name">        <em>\u5df2\u9009\u62e9<span>0</span>\u4e2a\u914d\u4ef6</em>    </div>    <div class="p-price">\u642d&nbsp;&nbsp;\u914d&nbsp;&nbsp;\u4ef7\uff1a        <strong class="res-jdprice">{if mainproduct.price==""}\u6682\u65e0\u62a5\u4ef7{else}\uffe5 ${mainproduct.price.toFixed(2)}{/if}</strong>    </div>    <div class="p-saving">\u53c2&nbsp;&nbsp;\u8003&nbsp;&nbsp;\u4ef7\uff1a        <span class="res-totalprice">\uffe5 ${mainproduct.maPrice.toFixed(2)}</span>    </div>    <div class="btns">        <a class="btn-buy" href="http://jd2008.jd.com/purchase/OrderFlowService.aspx?action=AddSkus&wids=${mainproduct.sku}">\u7acb\u5373\u8d2d\u4e70</a>    </div></div></div>',item:'{for item in accessoryList}<li {if (parseInt(item_index)+1)==accessoryList.length} class="last_item"{/if} onclick=\'clsClickLog("655", "${G.sku}", "${item.sku}", 34, "${item_index}", "rodGlobalTrack");\'>    <s></s>    <div class="p-img">        <a href="http://item.jd.com/${item.sku}.html" target="_blank"><img src="${pageConfig.FN_GetImageDomain(item.sku)}n4/${item.imageUrl}" alt="" height="100" skuidth="100"></a>    </div>    <div class="p-name">        <a href="http://item.jd.com/${item.sku}.html" target="_blank">${item.name}</a>    </div>    <div class="choose">        <input type="checkbox" id="inp_${item.sku}" onclick="G.calculatePrice(this, \'#tab-reco\')" wmaprice="${item.maPrice}" wmeprice="${item.price}" skuid="${item.sku}" />        <label for="inp_${item.skuid}" class="p-price">            <strong><img src="http://jprice.360buyimg.com/price/gp${item.sku}-1-1-1.png" onerror="this.src=\'http://misc.360buyimg.com/lib/skin/e/i/error-3.gif\'" /></strong>        </label>    </div>    {if isExtra==true}    <div class="p-more{if (parseInt(item_index)+1)!==accessoryList.length} hide{/if}"><a class="hl_link" href="http://rs.jd.com/accessorie/center.html?sku=${G.sku}&thirdTypeId=${item.thirdType}" target="_blank"></a></div>    {else}    <div class="p-more"><a class="hl_link" href="http://rs.jd.com/accessorie/center.html?sku=${G.sku}&thirdTypeId=${item.thirdType}" target="_blank">\u66f4\u591a${item.thirdName}</a></div>    {/if}</li>{/for}'};if(clsPVAndShowLog("655",G.sku,34,"p"),e&&e.accessoryList&&e.accessoryList.length>0){$("#tab-reco").attr("loaded","true").html(i.cons.process(e));for(var s=0;e.accessoryList.length>s;s++)e.accessoryList[s].accessoryList.length=4,e.accessoryList[s].accessoryList[0].thirdType=e.accessoryList[s].thirdTypeId,e.accessoryList[s].accessoryList[0].thirdName=e.accessoryList[s].thirdName,t.accessoryList.push(e.accessoryList[s].accessoryList[0]),t.isExtra=!1;$("#newFittign-tab .suits").prepend('<ul id="newFitting-0" class="lh" data-widget="tab-content" style="width:'+165*t.accessoryList.length+'px">'+i.item.process(t)+"</ul>"),$("#newFittign-tab").prepend(i.tabs.process(e)).Jtab({event:"click",compatible:!0,currClass:"scurr"},function(e,t,s){var a=$("#tab-cat-"+s).attr("data-cat").split("|")[1],o=$("#tab-cat-"+s).attr("data-cat").split("|")[0],n=$("#more-fitting-link a");if(n.attr("href","http://rs.jd.com/accessorie/center.html?sku="+G.sku+"&thirdTypeId="+a).html("\u8fdb\u5165"+o),0!==s){if("1"==$("#newFitting-"+s).attr("loaded"))return;window.fetchJSON_fittingExtra=function(e){e.isExtra=!0,$("#newFitting-"+s).html(i.item.process(e)).attr("loaded","1"),$("#newFitting-"+s).find(".hl_link").html("\u66f4\u591a"+$("#tab-cat-"+s).html());try{delete window.fetchJSON_fittingExtra}catch(t){}},$.ajax({url:"http://rs.jd.com/accessorie/newServiceList.jsonp?sku="+G.sku+"&thirdTypeId="+a+"&callback=fetchJSON_fittingExtra",dataType:"script",cache:"true",scriptCharset:"utf-8"}),$("#newFittign-tab .suits").removeAttr("style").css({width:pageConfig.wideVersion&&pageConfig.compatible?620:384,overflow:pageConfig.wideVersion&&pageConfig.compatible?"hidden":"auto"})}else $("#newFittign-tab .suits").removeAttr("style").css({width:pageConfig.wideVersion&&pageConfig.compatible?620:384,overflowX:"auto"})}),clsPVAndShowLog("655",G.sku,34,"s"),this.switchTab("#th-fitting"),G.removeLastAdd()}},renderHTML:function(){switch($.getJSONP("http://jprice.jd.com/suit/"+G.sku+"-1-1.html"),$.getJSONP("http://simigoods.jd.com/desgoods.aspx?ip="+getCookie("ipLocation")+"&wids="+G.sku+"&callback=Recommend.cbBroswerBroswer"),this.type){case 1:$.getJSONP("http://simigoods.jd.com/ThreeCCombineBuying/ThreeCBuyBuy.aspx?ip="+getCookie("ipLocation")+"&wids="+G.sku+"&callback=Recommend.cbCBuyBuy",Recommend.cbCBuyBuy),$.getJSONP("http://simigoods.jd.com/ThreeCCombineBuying/ThreeCBroswerBuy.aspx?ip="+getCookie("ipLocation")+"&wids="+G.sku+"&callback=Recommend.cbBroswerBuy",Recommend.cbBroswerBuy),$.getJSONP("http://simigoods.jd.com/ThreeCCombineBuying/CombineBuyJsonData.aspx?ip="+getCookie("ipLocation")+"&wids="+G.sku+"&callback=Recommend.cbCombineBuying",Recommend.cbCombineBuying);break;case 2:$.getJSONP("http://simigoods.jd.com/Electronic/EBuyToBuy.aspx?ip="+getCookie("ipLocation")+"&wids="+G.sku+"&callback=Recommend.cbCBuyBuy",Recommend.cbCBuyBuy),$.getJSONP("http://simigoods.jd.com/Electronic/EBrowserBuy.aspx?ip="+getCookie("ipLocation")+"&wids="+G.sku+"&callback=Recommend.cbBroswerBuy",Recommend.cbBroswerBuy),1315==G.cat[0]?$.getJSONP("http://simigoods.jd.com/Pop/PopCombinebuyingColor.aspx?ip="+getCookie("ipLocation")+"&wids="+G.sku+"&callback=Recommend.cbCombineBuyingPop"):$.getJSONP("http://simigoods.jd.com/Electronic/GCombineBuyJsonData.aspx?ip="+getCookie("ipLocation")+"&wids="+G.sku+"&callback=Recommend.cbCombineBuying");break;default:}},switchTab:function(e){var t=$(e),i=$("#recommend"),s=$('#recommend .mc[loaded="true"]'),a=s.length>0;i.show(),t.show(),"#th-service"!=e?t.trigger("click"):a||t.trigger("click")},cbRecoFittings:function(e){e&&e.fittings&&e.fittings.length>0&&($("#tab-reco").attr("loaded","true").html('<ul class="stab lh">'+recoFittings_TPL.tabs.process(e)+'</ul><div class="stabcon">'+recoFittings_TPL.cons.process(e)+"</div>"),this.switchTab("#th-fitting"),G.removeLastAdd())},cbCombineBuying:function(e){1==!!e.master.wid&&e.recoList.length>0&&($("#tab-hot").attr("loaded","true").html(suitRecommend_TPL.process(e)),log(mdPerfix+"3","Show"),this.switchTab("#th-hot")),G.removeLastAdd()},cbCombineBuyingPop:function(e){function t(e){if(e){var t=$("#pop-box .p-scroll-wrap"),i=$("#pop-box .p-scroll-next"),s=$("#pop-box .p-scroll-prev");t.find("li").length>4&&t.imgScroll({showControl:!0,width:30,height:30,visible:4,step:1,prev:s,next:i})}else G.setScroll("#stabcon_pop")}function i(t,i){var t=t;if(i)var s=i.split("|"),l=s[1],p=s[2];$("#pop-box").length>0&&$("#pop-box").attr("data-ind",t),n.clear().show(t,function(){var i=$("#pop-list-"+t),s=i.attr("data-sku"),n=i.find("a.curr").attr("title");d(t),a.del(),c.get(t),o(t,l||null,e),r.get(s,l||n,t,p)})}var s={set:function(e,t){1>$("#p-selected-"+e).length?$("#pop-list-"+e).find(".p-scroll").hide().before('<div id="p-selected-'+e+'" class="p-selected">\u5df2\u9009\u62e9\uff1a'+t.split("|")[1]+"\uff0c"+t.split("|")[2]+' <a data-ind="'+e+'" class="p-modify" href="#none">\u4fee\u6539</a></div>'):$("#p-selected-"+e).html("\u5df2\u9009\u62e9\uff1a"+t.split("|")[1]+"\uff0c"+t.split("|")[2]+' <a data-ind="'+e+'" class="p-modify" href="#none">\u4fee\u6539</a>'),$(".p-modify").unbind("click").bind("click",function(){i(parseInt(this.getAttribute("data-ind")),t)}),$("#p-selected-"+e).attr("data-res",t)}},a={set:function(e){var t=e||$("#stabcon_pop .pop-list");t.find(".p-scroll").each(function(){var e=$(this),t=e.prev(".p-img").find("img"),i=e.find(".p-scroll-wrap a");G.thumbnailSwitch(i,t,"/n2/","curr")})},del:function(e){var t=e||$("#stabcon_pop .pop-list");t.find(".p-scroll").each(function(){$(this).find(".p-scroll-wrap img").unbind("mouseover")})}},o=function(e,t){var i=$("#p-scroll .p-scroll-wrap a"),s=$("#pop-list-"+e).find(".p-img img"),a=$("#pop-list-"+e).attr("data-sku");i.unbind("click").bind("click",function(){var t=($(this),$(this).find("img").attr("src")),o=$(this).attr("title");r.get(a,o,e,null),i.removeClass("curr"),$(this).addClass("curr"),s.attr("src",t.replace("/n5/","/n2/")),$("#pop-list-"+e).attr("data-res")&&$("#pop-list-"+e).removeAttr("data-res")}),t&&i.each(function(){$(this).attr("title")==t&&$(this).trigger("click")})},n={show:function(e,t){$("#pop-box").css({left:e*$("#stabcon_pop .pop-list").outerWidth()-$("#stabcon_pop .suits").scrollLeft(),visibility:"visible"}),"function"==typeof t&&t(e)},hide:function(){return $("#pop-box").css("visibility","hidden"),this},clear:function(){var e=($("#pop-box"),$("#p-scroll,#p-size,#p-tips"));return e.html(""),this.isClear=!0,a&&a.set(),this}},r={sClick:function(e,t){var i=$("#p-size a"),s=$("#pop-list-"+e),a=this;i.click(function(){var e=$(this).attr("data-resku"),t=$("#p-scroll .p-scroll-wrap .curr").attr("title"),o=$(this).attr("title"),n=$(this).attr("wmaprice"),r=$(this).attr("wmeprice");i.removeClass("selected"),$(this).addClass("selected"),a.clearTips("#p-noselected"),s.attr("data-res",[e,t,o,n,r].join("|"))}),t&&$("#p-size a").each(function(){$(this).attr("title")==t&&$(this).trigger("click")})},noSize:function(e,t){$("#p-size").addClass("nosizes").html(""),$("#pop-list-"+e).attr("data-res",[t.Subcodesku[0].Sku,$("#pop-box .curr").attr("title"),"\u65e0\u5c3a\u7801",t.Subcodesku[0].WMeprice,t.Subcodesku[0].WMaprice].join("|"))},get:function(e,t,i,s,a){var o=this,n={ip:getCookie("ipLocation"),sku:e,color:encodeURI(t)};$("#pop-list-"+i).find(".no-scroll").length>0&&(n={ip:getCookie("ipLocation"),sku:e}),window.fetchJSON_sizeList=function(t){1>t.Subcodesku.length?(o.setTips('<p id="p-nostock">\u8be5\u5546\u54c1\u5df2\u4e0b\u67b6\u6216\u65e0\u8d27</p>'),$("#p-size").html("")):1==t.Subcodesku.length&&0==!!t.Subcodesku[0].sizename||"\u65e0"==t.Subcodesku[0].sizename?(o.noSize(i,t),o.clearTips("#p-nostock")):(o.set(t,e,i,s),o.clearTips("#p-nostock")),"function"==typeof a&&a(t)},$.ajax({url:"http://simigoods.jd.com/Pop/CodeServiceSize.aspx?callback=fetchJSON_sizeList",dataType:"script",cache:!0,data:n})},set:function(e,t,i,s){var a='{for list in Subcodesku}<a href="#none" data-resku="${list.Sku}" wmaprice="${list.WMaprice}" wmeprice="${list.WMeprice}" title="${list.sizename}">${list.sizename}</a>{/for}';$("#p-size").html(a.process(e)),this.sClick(i,s)},setTips:function(e){""==$("#p-tips").html()&&$("#p-tips").html(e)},clearTips:function(e){$("#pop-box").find(e).remove()}},c={get:function(e){$("#p-scroll").append($("#pop-list-"+e).find(".p-scroll").clone().show()),this.set(e)},set:function(){t(!0)}},d=function(e){var e=e;$("#p-selected-ok").unbind("click").bind("click",function(){var t=$("#pop-box");if(t.find("#p-scroll .curr").attr("title"),1>$("#pop-box .curr").length)r.setTips('<p id="p-noselected">\u8bf7\u9009\u62e9\u989c\u8272</p>');else if(1>$("#pop-box .selected").length&&!$("#p-size").hasClass("nosizes"))r.setTips('<p id="p-noselected">\u8bf7\u9009\u62e9\u5c3a\u7801</p>');else{s.set(e,$("#pop-list-"+e).attr("data-res")),n.hide().clear();var i=$("#pop-list-"+e),a=i.attr("data-res").split("|"),o=a[0],c=a[3],d=a[4],l=i.find(".p-price img"),p=l.attr("src");l.attr("src",p.replace(/\d{10}/,o)),i.find("input:checkbox").attr({skuid:o,wmaprice:c,wmeprice:d,checked:!0}),G.calculatePrice($("#pop-list-"+e).find("input:checkbox")[0],"#tab-hot")}}),$("#p-selected-cancel").click(function(){n.hide().clear(),1>$("#p-selected-"+e).length&&$("#pop-list-"+e).find("input:checkbox").attr("checked",!1)})};if(e.master.wid&&e.recoList.length>0){var l='<div id="stabcon_pop" class="stabcon stabcon_big"><div class="master">    <s></s>    <div class="p-img">        <a href="http://item.jd.com/${master.wid}.html" target="_blank"><img src="${pageConfig.FN_GetImageDomain(master.wid)}n2/${master.imgurl}" height="160" width="160"></a>    </div>    <div class="p-name">        <a href="http://item.jd.com/${master.wid}.html" target="_blank">${master.name}</a>    </div>    <div class="p-price none"><input type="checkbox" id="inp_${master.wid}" onclick="return false;" onchange="return false" wmaprice="${master.wmaprice}" wmeprice="${master.wmeprice}" skuid="${master.wid}" checked/> ${master.wmeprice}</div></div><div class="pop-wrap"><div id="pop-box" class="">    <div id="p-scroll"></div>    <div id="p-size"></div>    <div id="p-tips"></div>    <div id="p-size-btn">        <a href="#none" id="p-selected-ok">\u786e\u5b9a</a><a id="p-selected-cancel" href="#none">\u53d6\u6d88</a>    </div></div><div class="suits" style="overflow-x:{if parseInt(recoList.length)>(pageConfig.wideVersion&&pageConfig.compatible ? 3:2)}scroll;{else}hidden;{/if}">    <ul class="lh" style="width:${parseInt(recoList.length)*200+20}px">        {for item in recoList}        <li class="pop-list {if parseInt(item_index)+1==parseInt(recoList.length)} last-item{/if}" id="pop-list-${item_index}" data-sku="${item.wid}" data-ind="${item_index}" onclick="reClick(\''+mdPerfix+"3', '${master.wid}', '${item.wid}#${item.wmeprice}', '${item_index}');\">"+"            <s></s>"+'            <div class="p-img">'+'                <a href="http://item.jd.com/${item.wid}.html" target="_blank"><img src="${pageConfig.FN_GetImageDomain(item.wid)}n2/${item.imgurl}" alt="" height="160" width="160"></a>'+"            </div>"+'            <div class="p-scroll">'+'                <a href="javascript:;" class="p-scroll-btn p-scroll-prev">&lt;</a>'+'                <div class="p-scroll-wrap">'+"                    <ul>"+"                    {for color in item.colorlist}"+'                        <li><a href="javascript:;" class="{if parseInt(color_index)==0}curr{/if}" data-sku="${item.wid}" title="${color.colorname}"><img data-img="1" width="25" height="25" alt="" src="${pageConfig.FN_GetImageDomain(item.wid)}n5/${color.imgurl}" data-img="1"></a></li>'+"                    {forelse}"+'                        <li><a href="javascript:;" class="no-scroll curr" title="\u65e0"><img data-img="1" width="25" height="25" alt="" src="${pageConfig.FN_GetImageDomain(item.wid)}n5/${item.imgurl}"></a></li>'+"                    {/for}"+"                    </ul>"+"                </div>"+'                <a href="javascript:;" class="p-scroll-btn p-scroll-next">&gt;</a>'+"            </div>"+'            <div class="p-name">'+'                <a href="http://item.jd.com/${item.wid}.html" target="_blank">${item.name}</a>'+"            </div>"+'            <div class="choose">'+'                <input type="checkbox" data-nocolor="${item.colorlist.length<1}" id="inp_${item.wid}" class="{if parseInt(item.colorlist.length)==0}no-pop-win{/if}" wmaprice="${item.wmaprice}" wmeprice="${item.wmeprice}" skuid="${item.wid}" />'+'                <label for="inp_${item.wid}" class="p-price">'+'                    <strong><img src="http://jprice.360buyimg.com/price/gp${item.wid}-1-1-1.png" onerror="this.src=\'http://misc.360buyimg.com/lib/skin/e/i/error-3.gif\'" /></strong>'+"                </label>"+"            </div>"+"        </li>"+"        {/for}"+"    </ul>"+"</div>"+"</div>"+'<div class="infos" onclick="{for item in recoList}reClick(\''+mdPerfix+"3', '${master.wid}', '${item.wid}#${item.wmeprice}', '${item_index}');{/for}\">"+"    <s></s>"+'    <div class="p-name">'+"        <a onclick=\"log('"+mbPerfix+"PopularBuy','click')\" href=\"http://jd2008.jd.com/purchase/OrderFlowService.aspx?action=AddSkus&wids=${master.wid}\">\u8d2d\u4e70\u4eba\u6c14\u7ec4\u5408</a>"+"    </div>"+'    <div class="p-price">\u603b\u4eac\u4e1c\u4ef7\uff1a'+'        <strong class="res-jdprice">\uffe5 ${master.wmeprice}</strong>'+"    </div>"+'    <div class="p-saving">\u603b\u53c2\u8003\u4ef7\uff1a'+'        <del class="res-totalprice">\uffe5 ${master.wmaprice}</del>'+"    </div>"+'    <div class="btns">'+"        <a onclick=\"log('"+mbPerfix+'PopularBuy\',\'click\')" class="btn-buy" href="http://jd2008.jd.com/purchase/OrderFlowService.aspx?action=AddSkus&wids=${master.wid}">\u8d2d\u4e70\u7ec4\u5408</a>'+"    </div>"+'</div><div class="clb"></div>'+"</div>";$("#tab-hot").attr("loaded","true").html(l.process(e)),pageConfig.FN_ImgError($("#tab-hot")[0]),$("#stabcon_pop .suits").scroll(function(){if("visible"==$("#pop-box").css("visibility")){var e=parseInt($("#pop-box").attr("data-ind"));$("#pop-list-"+e).find("input:checkbox").attr("checked",!1),n.clear().hide()}}),a.set(),t(!1),$("#stabcon_pop ul input:checkbox").click(function(){var e=$(this),t=e.attr("data-nocolor"),s=e.parents(".pop-list"),o=s.attr("data-ind");if("visible"==$("#pop-box").css("visibility")){var r=parseInt($("#pop-box").attr("data-ind"));$("#pop-list-"+r).find("input:checkbox").attr("checked",!1),n.clear().hide()}"true"==t?G.calculatePrice(e[0],"#tab-hot"):1==$(this).attr("checked")?i(o):($("#p-selected-"+o)&&($("#p-selected-"+o).remove(),$("#pop-list-"+o).find(".p-scroll").show(),a.set($("#pop-list-"+o))),G.calculatePrice(e[0],"#tab-hot"))}),log(mdPerfix+"3","Show"),this.switchTab("#th-hot")}},cbCBuyBuy:function(e){var t=$("#buy-buy"),i=[];if(e&&e.length>0){log(mdPerfix+"2","Show");for(var s=0;e.length>s;s++)i.push('<li class="fore'+(s+1)+'" onclick="reClick(\''+mdPerfix+"2',"+G.sku+",'"+e[s].Wid+"#"+e[s].WMeprice+"',"+s+');">'+listBuyBuy_TPL.process(e[s])+"</li>");t.show().find("ul").html(i.join(""))}},cbBroswerBroswer:function(e){var t=$("#browse-browse"),i=($("#recent-view"),[]);if(e){for(var s=0;e.length>s;s++)i.push(listBrosweBroswe_TPL.process(e[s],s));t.length>0?t.show().find("ul").html(i.join("")):$("#browse-browse").show().find("ul").html(i.join(""))}},cbBroswerBuy:function(e){var t=$("#view-buy"),i=[];if(null!==e&&e.length>0){t.show(),log(mdPerfix+"1","Show");for(var s=0;e.length>s;s++)i.push('<li class="fore'+(s+1)+'" onclick="reClick(\''+mdPerfix+"1',"+G.sku+",'"+e[s].Wid+"#"+e[s].WMeprice+"',"+s+');">'+listBrosweBuy_TPL.process(e[s])+"</li>");t.show().find("ul").html(i.join("")).after('<div class="extra"><a target="_blank" title="\u67e5\u770b\u66f4\u591a" href="http://my.jd.com/product/likes.html?id='+G.sku+'">\u67e5\u770b\u66f4\u591a\u63a8\u8350</a></div>')}}};$.extend(jdModelCallCenter,{usefulComment:function(e){$.login({modal:!0,complete:function(t){if(t.IsAuthenticated){var i=e.parent().attr("id"),s="agree"==e.attr("name");"true"!=e.attr("enabled")?$.ajax({type:"GET",url:"http://club.jd.com/index.php",data:{mod:"ProductComment",action:"saveCommentUserfulVote",commentId:i,isUseful:s},dataType:"jsonp",success:function(t){if(e.attr("enabled","true"),1==t.status){var i=parseInt(e.attr("title"))+1;e.attr("title",i),s?e.html("\u6709\u7528("+i+")"):e.html("\u6ca1\u7528("+i+")")}else alert("\u4e00\u4e2a\u8bc4\u4ef7\u53ea\u80fd\u70b9\u4e00\u6b21\u5466")}}):alert("\u4e00\u4e2a\u8bc4\u4ef7\u53ea\u80fd\u70b9\u4e00\u6b21\u5466")}}}),mark(G.sku,5)}}),$(".btn-agree,.btn-oppose").livequery("click",function(){var e=$(this);$.extend(jdModelCallCenter.settings,{object:e,fn:function(){jdModelCallCenter.usefulComment(this.object)}}),jdModelCallCenter.settings.fn()});var consultationServiceUrl="http://club.jd.com/newconsultationservice.aspx?callback=?";$("#btnReferSearch").livequery("click",function(){Consult.search(G.sku,$("#txbReferSearch").val(),1,6)}),$("#txbReferSearch").livequery("keydown",function(e){13==e.keyCode&&Consult.search(G.sku,$("#txbReferSearch").val(),1,6)}),$("#backConsultations").livequery("click",function(){$("#consult .tab li.curr").trigger("click")}),$("#consultation").livequery("click",function(){$.login({returnUrl:$(this).attr("name"),complete:function(e){e.IsAuthenticated&&(location.href=this.returnUrl)}})}),$("#login").livequery("click",function(){$.login()}),$(".btn-pleased,.btn-unpleased").livequery("click",function(){var e=$(this);$.login({complete:function(t){if(null!=t.IsAuthenticated&&t.IsAuthenticated){var i=parseInt($.query.get("id"));if(isNaN(i)||0==i){var t=location.href.match(/(\d+)(.html)/);null!=t&&(i=parseInt(t[1]))}var s=$(e).parent().attr("id"),a=parseInt($(e).attr("name"));i>0&&$.getJSON(consultationServiceUrl,{method:"VoteForConsultation",productId:i,consultationId:s,score:a},function(t){t.Result?($(e).text("\u5df2\u6295\u7968"),$(e).next("span").text(parseInt($(e).next("span").text())+1)):$(e).text("\u5df2\u6295\u7968")})}}}),mark(location.href.match(/(\d+).html/)[1],5)});var CommentListNew={loadFirstPage:!1,init:function(e){var t=$("#comments-list").find(".mt"),i='<div id="comment-sort" class="extra"> <select > <option value="3">\u70ed\u5ea6\u6392\u5e8f</option> <option value="1">\u65f6\u95f4\u6392\u5e8f</option> </select> </div>';1>$("#comment-sort").length&&t.append(i),this.commList=$("#comments-list"),this.commRate=$("#comment"),this.wrap=$("#comment-0"),this.sku=e||G.sku,this.sort=3,this.bindSelect(t),this.commList.find(".tab li em").html("(0)")},bindSelect:function(e){var t=this;e.find("select").change(function(){var e=parseInt($(this).val(),10);t.sort!==e&&(t.sort=e,t.getData(t.wrap,t.type,t.page))})},bindHover:function(){this.commList.find(".item-reply").hover(function(){$(this).find(".reply-meta a").css("visibility","visible")},function(){"none"===$(this).find(".replay-form").css("display")&&$(this).find(".reply-meta a").css("visibility","hidden")})},bindReply:function(){var e=this;$(document).unbind("click"),this.commList.find(".btn-toggle").livequery("click",function(t){var i=$(t.target),s=i.attr("data-id");i.hasClass("btn-toggle")&&$("#btn-toggle-"+e.type+"-"+s).toggle().find("input")[0].focus()}),this.bindHover(),this.commList.find(".reply-btn").livequery("click",function(t){var i=$(t.target),s=i.attr("data-guid"),a=i.attr("data-replyId"),o=i.attr("data-nickname"),n=i.parents(".reply-input").find("input").val(),r={};if(i.hasClass("reply-btn"))return e.currReply=i,n=n.replace(/</g,"<").replace(/>/g,">"),a=i.hasClass("reply-btn-lz")?"":a,r={guid:s,content:n,replyId:a,nickname:o},""===n.replace(/\s+/,"")?(alert("\u8bf7\u8f93\u5165\u56de\u590d\u5185\u5bb9"),void 0):(G.checkLogin(function(t){t.IsAuthenticated?e.reply(r):(jdModelCallCenter.settings.fn=function(){G.checkLogin(function(t){t.IsAuthenticated&&e.reply(r)})},jdModelCallCenter.login())}),void 0)})},reply:function(e){var t=this,i={mod:"Club2013.ProductCommentReply",action:"saveProductCommentReply",commentId:e.guid,content:e.content,parentId:e.replyId},s=e.content.replace(/[\u4e00-\u9fa5]/g,"XX");return""===e.content.replace(/\s+/,"")?(alert("\u8bf7\u8f93\u5165\u56de\u590d\u5185\u5bb9"),!1):1>s.length||s.length>800?(alert("\u56de\u590d\u5185\u5bb9\u5e94\u57281~400\u4e2a\u5b57\u4ee5\u5185"),!1):($.ajax({url:"http://club.jd.com/index.php?",data:i,dataType:"jsonp",success:function(i){1===i.status?(i.data.nickname=e.nickname,t.setReplyItem(i.data)):i.info&&alert(i.info)
}}),void 0)},setReplyItem:function(e){var t,i=this,s=i.currReply.parents(".i-item").eq(0),a=s.find(".reply-lz"),o=this.currReply.parents(".item-reply").eq(0),n=a.next();e._type=this.type,e.commentReply.guid=s.attr("data-guid"),e.commentReply.index=t=n.length>0?parseInt(n.attr("data-index"),10)+1:1,e.toname=o.attr("data-name"),e.touid=o.attr("data-uid");var r='<div class="item-reply none" data-index="${commentReply.index}" data-name="${commentReply.nickname}" data-uid="${commentReply.uid}">			<strong>${commentReply.index}</strong>			<div class="reply-list">				<div class="reply-con">					<span class="u-name">						<a href="http://club.jd.com/userreview/${commentReply.uid}-1-1.html" target="_blank">${commentReply.nickname}{if commentReply.userClient==99}<b></b>{/if}</a>                      {if parseInt(commentReply.parentId, 10)>0}						<em>\u56de\u590d</em>                      <a target="_blank" href="http://club.jd.com/userreview/${touid}-1-1.html">{if parseInt(commentReply.parentId, 10)<0}{else}${toname}{/if}</a>{/if}\uff1a					</span>					<span class="u-con">${commentReply.content}</span>				</div>				<div class="reply-meta">					<span class="reply-left fl">${commentReply.creationTimeString.replace(/:[0-9][0-9]$/, "")}</span>					<a class="btn-toggle p-bfc" data-id="${commentReply.id}" href="#none">\u56de\u590d</a>				</div>				<div id="btn-toggle-${_type}-${commentReply.id}" class="replay-form none">					<div class="arrow">						<em>\u25c6</em><span>\u25c6</span>					</div>					<div class="reply-wrap">						<p><em>\u56de\u590d</em> <span class="u-name">${commentReply.nickname}\uff1a</span></p>						<div class="reply-input">							<div class="fl"><input type="text" /></div>							<a href="#none" class="reply-btn btn-gray p-bfc" data-guid="${commentReply.guid}" data-replyId="${commentReply.id}">\u56de\u590d</a>							<div class="clr"></div>						</div>					</div>				</div>			</div>		</div>';a.after($(r.process(e)).fadeIn()),this.commList.find(".btn-reply em").html(t),this.currReply.parents(".replay-form").eq(0).hide(),this.currReply.parents(".reply-input").find("input").val(""),this.bindReply()},getData:function(e,t,i){var s=this;this.wrap=e,this.type=t,this.page=i,this.commRateLoaded=!1,this.url="http://club.jd.com/productpage/p-{skuId}-s-{commType}-t-{sortType}-p-{currPage}.html",this.url=this.url.replace("{skuId}",this.sku).replace("{commType}",this.type).replace("{sortType}",this.sort).replace("{currPage}",this.page),$.ajax({url:this.url,dataType:"jsonp",success:function(e){s.setData(e)}})},setData:function(e){return e||(this.wrap.html("\u3000\u6682\u65e0\u8bc4\u8bba"),this.commRate.find(".mc").html("\u3000\u6682\u65e0\u8bc4\u8bba")),e.comments===void 0?(this.wrap.html('<div class="norecode"> \u6682\u65e0\u5546\u54c1\u8bc4\u4ef7\uff01</div>'),void 0):(this.commRateLoaded===!1&&this.setCommRate($("#comment"),e),e._type=this.type,this.setCommentCount(e),this.wrap.html(newCommentList_TPL.process(e)),this.bindReply(),this.setPageNav(e),this.loadFirstPage=!0,void 0)},setPageNav:function(e){var t=this,i="";switch(this.type){case 0:i="commentCount";break;case 1:i="poorCount";break;case 2:i="generalCount";break;case 3:i="goodCount";break;case 4:i="showCount";break;default:i="commentCount"}$("#commentsPage"+e.score).pagination(e.productCommentSummary[i],{items_per_page:10,num_display_entries:5,current_page:t.page,num_edge_entries:2,link_to:"#comments-list",prev_text:"\u4e0a\u4e00\u9875",next_text:"\u4e0b\u4e00\u9875",ellipse_text:"...",prev_show_always:!1,next_show_always:!1,callback:function(i){t.getData(t.wrap,e.score,i)}})},setCommentCount:function(e){var t=this.commList.find(".tab li em"),i=e.productCommentSummary;t.eq(0).html("("+i.commentCount+")"),t.eq(1).html("("+i.goodCount+")"),t.eq(2).html("("+i.generalCount+")"),t.eq(3).html("("+i.poorCount+")"),t.eq(4).html("("+i.showCount+")")},setCommRate:function(e,t){e.find(".mc").html(newCommentRate_TPL.process(t)),this.commRateLoaded=!0,this.commRate.show()}},Discuss={getData:function(e,t){var i="http://club.jd.com/clubservice/newcomment-",s="",t=t;switch(e){case 0:s="Club";break;case 1:s="Order";break;case 2:s="User";break;case 3:s="Question";break;case 4:s="Friend"}window.fetchJSON_Discuss=function(e){t.html(discuss_TPL.process(e))},$.getJSONP(i+s+"-"+G.orginSku+".html?callback=fetchJSON_Discuss")},setItem:function(){}},Consult={getData:function(e,t){window.fetchJSON_Consult=function(e){t.html(consult_TPL.process(e))},$.getJSONP("http://club.jd.com/clubservice/newconsulation-"+G.orginSku+"-"+(e+1)+".html?callback=fetchJSON_Consult")},setExtraData:function(e,t){$.jmsajax({url:"/newsserver.asmx",method:"PayExplain",data:{id:"A-product-0"+(e-3)},success:function(e){null!=e&&t.html(e)}})},search:function(e,t,i){var s="http://search.jd.com/sayword?",i=i||0,e=e||G.orginSku,a=this;$.ajax({url:s,dataType:"jsonp",data:{wid:e,keyword:encodeURI(t),page:i,ps:5},success:function(e){var t='<div class="clb"><div id="ReferPagenation" class="pagin fr none"></div></div>';if(e.length>0){var s=0>=e[0].list.length||0>=e[0].total?"\uff0c\u8bd5\u8bd5\u66f4\u7b80\u77ed\u7684\u5173\u952e\u8bcd\u6216\u66f4\u6362\u5173\u952e\u8bcd":"",o='<div id="consult-result" class="result clearfix"><div class="fl">\u5171\u641c\u7d22\u5230<strong>'+e[0].total+"</strong>\u6761\u76f8\u5173\u54a8\u8be2"+s+'\u3000<a id="backConsultations" href="#none">\u8fd4\u56de</a></div><div class="fr"><em>\u58f0\u660e\uff1a\u4ee5\u4e0b\u56de\u590d\u4ec5\u5bf9\u63d0\u95ee\u80053\u5929\u5185\u6709\u6548\uff0c\u5176\u4ed6\u7f51\u53cb\u4ec5\u4f9b\u53c2\u8003\uff01</em></div></div>';if($("#consult .tabcon:visible").html(o+""+consult_search_TPL.process(e[0])+t),0>=e[0].list.length||0>=e[0].total)return!1;$("#ReferPagenation").show().pagination(e[0].total,{items_per_page:5,num_display_entries:5,current_page:i-1,num_edge_entries:0,link_to:"#consult",prev_text:"\u4e0a\u4e00\u9875",next_text:"\u4e0b\u4e00\u9875",ellipse_text:"...",prev_show_always:!1,next_show_always:!1,callback:function(e){a.search(G.orginSku,$("#txbReferSearch").val(),e+1,6)}})}}})}},ProductTrack=function(e,t,i){this.sRecent=e,this.sGuess=t,this.isBook=i||!1,$(this.sGuess).find("h2").html("\u6839\u636e\u6d4f\u89c8\u4e3a\u6211\u63a8\u8350")};ProductTrack.prototype={hide:function(){$(this.sRecent).hide(),$(this.sGuess).hide()},getCommentData:function(e){var t=this;$.ajax({url:"http://club.jd.com/clubservice.aspx?method=GetCommentsCount&referenceIds="+e,dataType:"jsonp",success:function(e){t.setCommentData(e)}})},setCommentData:function(e){for(var t=e.CommentsCount.length,i=0;t>i;i++)$("#g"+e.CommentsCount[i].SkuId).find(".star").removeClass("sa5").addClass("sa"+e.CommentsCount[i].AverageScore),$("#g"+e.CommentsCount[i].SkuId).find(".p-comm a").html("(\u5df2\u6709"+e.CommentsCount[i].CommentCount+"\u4eba\u8bc4\u4ef7)")},getData:function(e){var e=e||"http://my."+pageConfig.FN_getDomain()+"/global/track.action?jsoncallback=?";return _this=this,$.ajax({url:e,dataType:"json",success:function(e){_this.setContent(e)},error:function(){_this.hide()}}),this},setContent:function(e,t,i){var s=" onclick=\"clsClickLog('', '', '${list.wid}', 3, ${list_index}, 'rodGlobalHis');\"",a=" onclick=\"clsClickLog('', '', '${list.wid}', 2, ${list_index}, 'rodGlobalTrack');\"";this.isBook&&(s=" onclick=\"clsLog('${list.topNum}&HomeHis', '', '${list.wid}#${list.wMeprice}', ${list_index}, 'reWidsBookHis');\"",a=" onclick=\"clsLog('${list.topNum}&HomeTrack', '', '${list.wid}#${list.wMeprice}', ${list_index}, 'reWidsBookTrack');\"");var o='<ul data-update="new">	{for list in history}    <li'+s+">"+'        <div class="p-img">'+'            <a href="${list.productUrl}"><img src="${pageConfig.FN_GetImageDomain(list.wid)}n5/${list.imageUrl}" /></a>'+"        </div>"+'        <div class="p-name">'+'            <a href="${list.productUrl}">${list.wname}</a>'+"        </div>"+'        <div class="p-price">'+'            <img src="http://jprice.360buyimg.com/price/gp${list.wid}-1-1-1.png" onerror="this.src=\'http://misc.360buyimg.com/lib/skin/e/i/error-3.gif\'" />'+"        </div>"+"    </li>"+"    {/for}"+'	  <li class="all-recent" style="text-align:right;padding:5px 0;"><a href="http://my.'+pageConfig.FN_getDomain()+'/history/list.html" target="_blank" style="color:#005ea7;">\u5168\u90e8\u6d4f\u89c8\u5386\u53f2 <span style="font-family:simsun;">&gt;</span></a></li>'+"</ul>",n='<span class="guess-control" id="guess-forward">&lt;</span><span class="guess-control" id="guess-backward">&gt;</span><div id="guess-scroll"><ul class="lh">{for list in guessyou}<li'+a+' id="g${list.wid}">'+'	<div class="p-img">'+'		<a target="_blank" title="${list.wname}" href="${list.productUrl}"><img height="130" width="130" alt="${list.wname}" src="${pageConfig.FN_GetImageDomain(list.wid)}n3/${list.imageUrl}"></a>'+"	</div>"+'	<div class="p-name">'+'		<a target="_blank" title="${list.wname}" href="${list.productUrl}">${list.wname}</a>'+"	</div>"+'	<div class="p-comm">'+'		<span class="star sa5"></span><br/>'+'		<a target="_blank" href="http://club.jd.com/review/${list.wid}-1-1.html">(\u5df2\u67090\u4eba\u8bc4\u4ef7)</a>'+"	</div>"+'	<div class="p-price">'+'			<img src="http://jprice.360buyimg.com/price/gp${list.wid}-1-1-1.png" onerror="this.src=\'http://misc.360buyimg.com/lib/skin/e/i/error-3.gif\'" />'+"	</div>"+"</li>"+"{/for}"+"</ul></div>",r=t||o;if(null!==e.history&&e.history.length>0?($(this.sRecent).find(".mc").html(r.process(e)),$(this.sRecent).find(".mt").append('<div class="extra"><a href="http://my.'+pageConfig.FN_getDomain()+'/history/list.html" target="_blank">\u66f4\u591a</a></div>'),this.isBook?log("BOOK&HomeHis","Show"):clsPVAndShowLog("","",3,"s")):($(this.sGuess).find("h2").html("\u672c\u5468\u70ed\u9500"),$(this.sRecent).find(".mc").html('<div class="no-track"><h4>\u60a8\u8fd8\u672a\u5728\u4eac\u4e1c\u7559\u4e0b\u8db3\u8ff9</h4><p>\u5728\u60a8\u7684\u8d2d\u7269\u65c5\u7a0b\u4e2d\uff0c\u60a8\u53ef\u4ee5\u968f\u65f6\u901a\u8fc7\u8fd9\u91cc\u67e5\u770b\u60a8\u4e4b\u524d\u7684\u6d4f\u89c8\u8bb0\u5f55\uff0c\u4ee5\u4fbf\u5feb\u6377\u8fd4\u56de\u60a8\u66fe\u7ecf\u611f\u5174\u8da3\u7684\u9875\u9762\u3002</p></div>')),null!==e.guessyou&&e.guessyou.length>0){$(this.sGuess).find(".mc").html(n.process(e)),$(this.sGuess).find(".mt .extra").html('<a href="http://my.'+pageConfig.FN_getDomain()+'/personal/guess.html" target="_blank">\u66f4\u591a\u63a8\u8350</a>');var c=pageConfig.wideVersion&&pageConfig.compatible?5:4;$("#guess-scroll").imgScroll({visible:c,step:c,prev:"#guess-forward",next:"#guess-backward"}),this.isBook?log("BOOK&HomeTrack","Show"):clsPVAndShowLog("","",2,"s");var d=[];$("#guess-scroll ul li").each(function(){d.push($(this).attr("id"))}),this.getCommentData(d.join(",").replace(/g/g,""))}else $(this.sGuess).find(".mc").html('<div class="nothing">\u6682\u65e0\u63a8\u8350</div>')}};var Repository={init:function(e){var e=e||G.sku;this.t=null,this.getKeywords(),this.content=$(".detail-content").eq(0),this.tab=$("#product-detail .tab li").eq(5),this.tabCon=$("#product-detail-6"),this.tabCon.html('<div class="iloading">\u6b63\u5728\u52a0\u8f7d\u4e2d\uff0c\u8bf7\u7a0d\u5019...</div>'),this.getPracticalGuide(e)},setKeywords:function(e){var t=(this.content.html(),$("body").eq(0)),i='<b class="wiki-arr">\u25c7</b><div class="wiki-inner">  <dl><dt>${keyword}</dt>      <dd>${description}</dd>  </dl>  <div class="wiki-more"><a href="${href}" clstag="shangpin|keycount|product|xxjs" target="_blank">\u67e5\u770b\u8be6\u7ec6\u4ecb\u7ecd</a></div></div>',s="";if(null!==e&&e.length>0){for(var a=0;e.length>a;a++)e[a].id="wiki-keyword-"+a,this.content.html($(".detail-content").eq(0).html().replace(RegExp(e[a].keyword),'<span data-id="'+e[a].knid+'" class="wiki-words" id="'+"wiki-keyword-"+a+'" style="border-bottom:1px dotted;padding-bottom:2px;">'+e[a].keyword+"</span>")),s=i.process(e[a]),t.append($('<div class="wiki-pop hide" id="des-wiki-keyword-'+a+'">'+s+"</div>"));$("img[data-lazyload]").Jlazyload({type:"image",placeholderClass:"err-product"}),this.keyWordHover()}},log:function(e){$.ajax({url:"http://wiki.jd.com/statistics/termFloat.action?",data:{id:e,t:+new Date},dataType:"script",cache:!0})},keyWordHover:function(){var e=this,t=$(".detail-content .wiki-words");$(".wiki-pop dl"),t.each(function(){var t=this.id,i=$(this).attr("data-id"),s=$(this);s.hover(function(){var s=$("#product-detail"),a=s.offset().left,o=s.outerWidth(),n=$(this).offset().left,r=n-a>o/2?310:110,c=n-a>o/2?n-300:n-100,d=$(this).offset().top,l=$(this).outerHeight();$("#des-"+t).length>0&&($("#des-"+t).show().css({left:c,top:d+l-1}),$("#des-"+t).find("b").css({marginLeft:r})),e.t=setTimeout(function(){e.log(i)},500)},function(t){var i=this.id,s=t.relatedTarget;return s.id=="des-"+i?!1:($("#des-"+i).hide(),clearTimeout(e.t),void 0)}),$("#des-"+t).hover(function(){},function(e){var i=e.relatedTarget;return i.id=="des-"+t?!1:($(this).hide(),void 0)})})},getKeywords:function(){var e=this;$.ajax({url:"http://wiki.jd.com/product/"+G.sku+"/keywords.html",dataType:"jsonp",success:function(t){e.setKeywords(t)}})},getPracticalGuide:function(){var e=this;$.ajax({url:"http://wiki.jd.com/product/"+G.sku+"/guide.html",dataType:"jsonp",success:function(t){null!==t&&t.length>0?e.setPracticalGuide(t):(e.tab.hide(),e.tabCon.html('<div class="tc p10">\u8be5\u5546\u54c1\u7684\u5b9e\u7528\u6307\u5357\uff0c\u7a0d\u540e\u652f\u6301\u3002</div>'))}})},setPracticalGuide:function(e){var t={};t.resList=e;var i=' <div id="practical-guide" class="item-detail" data-widget="tabs">    <ul class="tab-sub">        {for item in resList}        <li data-widget="tab-item" clstag="shangpin|keycount|product|citiao" class="fore{if item_index==0} curr{/if}">${item.groupName}</li>        {/for}    </ul>    {for item in resList}    <ul data-widget="tab-content" class="tabcon-sub{if item_index!=0} hide{/if}">        {for list in item.pgList}        <li clstag="shangpin|keycount|product|citiao">\u00b7<span>[${item.groupName}]</span><a href="${list.url}" target="_blank">${list.name}</a></li>        {/for}    </ul>    {/for}</div>';this.tabCon.html(i.process(t)),$("#practical-guide").Jtab({event:"click",compatible:!0})}};if(function(){var e=function(){var e="";try{e=window.top.document.referrer}catch(t){if(window.parent)try{e=window.parent.document.referrer}catch(i){e=""}}return""===e&&(e=document.referrer),e};JDS=window.JDS||{},JDS.strpos=function(e,t,i){var s=(e+"").indexOf(t,i||0);return-1===s?!1:s},JDS.uri=function(e){this.components={},this.options={strictMode:!1,key:["source","protocol","authority","userInfo","user","password","host","port","relative","path","directory","file","query","anchor"],q:{name:"queryKey",parser:/(?:^|&)([^&=]*)=?([^&]*)/g},parser:{strict:/^(?:([^:\/?#]+):)?(?:\/\/((?:(([^:@]*)(?::([^:@]*))?)?@)?([^:\/?#]*)(?::(\d*))?))?((((?:[^?#\/]*\/)*)([^?#]*))(?:\?([^#]*))?(?:#(.*))?)/,loose:/^(?:(?![^:@]+:[^:@\/]*@)([^:\/?#.]+):)?(?:\/\/)?((?:(([^:@]*)(?::([^:@]*))?)?@)?([^:\/?#]*)(?::(\d*))?)(((\/(?:[^?#](?![^?#\/]*\.[^?#\/.]+(?:[?#]|$)))*\/?)?([^?#\/]*))(?:\?([^#]*))?(?:#(.*))?)/}},e&&(this.components=this.parseUri(e))},JDS.uri.prototype={parseUri:function(e){for(var t=this.options,i=t.parser[t.strictMode?"strict":"loose"].exec(e),s={},a=14;a--;)s[t.key[a]]=i[a]||"";return s[t.q.name]={},s[t.key[12]].replace(t.q.parser,function(e,i,a){i&&(s[t.q.name][i]=a)}),s},getHost:function(){return this.components.hasOwnProperty("host")?this.components.host:void 0},getQueryParam:function(e){return this.components.hasOwnProperty("queryKey")&&this.components.queryKey.hasOwnProperty(e)?this.components.queryKey[e]:void 0},isQueryParam:function(e){return this.components.hasOwnProperty("queryKey")&&this.components.queryKey.hasOwnProperty(e)?!0:!1}};var t=[{d:"baidu",q:"wd"},{d:"google",q:"q"},{d:"images.google",q:"q"},{d:"images.search.yahoo.com",q:"p"},{d:"sogou",q:"query"},{d:"soso",q:"w"},{d:"bing",q:"q"},{d:"youdao",q:"q"},{d:"114so",q:"kw"},{d:"zhongsou",q:"w"},{d:"yisou",q:"q"},{d:"lycos",q:"query"},{d:"lycos",q:"word"},{d:"yahoo",q:"q"},{d:"yahoo",q:"p"},{d:"search",q:"q"},{d:"live",q:"q"},{d:"aol",q:"query"},{d:"aol",q:"encquery"},{d:"aol",q:"q"},{d:"ask",q:"q"},{d:"cnn",q:"query"},{d:"teoma",q:"q"},{d:"yandex",q:"text"}],i=function(e){for(var i=0,s=t.length;s>i;i++){var a=t[i].d,o=t[i].q,n=e.getHost(),r=e.getQueryParam(o);if(!JDS.strpos(n,"360buy")&&JDS.strpos(n,a)&&e.isQueryParam(o))return{d:a,q:o,k:r}}};window.jdSref=e(),window.jdSuri=new JDS.uri(window.jdSref),window.searchEngineSource=i(window.jdSuri)}(),jdSref&&searchEngineSource){var charset="&encode=utf-8";if("baidu"==searchEngineSource.d){var refer=document.referrer;charset=/ie=utf-8/.test(refer)?"&encode=utf-8":"&encode=gbk"}else charset=RegExp(searchEngineSource.d).test("soso#sogou")?"&encode=gbk":"&encode=utf-8";setSearch(searchEngineSource.k,charset)}var shopInfo={get:function(e,t){pageConfig.product.popInfo?t(pageConfig.product.popInfo):(window.fetchShopInfo=function(e){var i={stock:{D:e}};"function"==typeof t&&t(i)},$.getJSONP("http://st.3.cn/gvi.html?callback=fetchShopInfo&type=popdeliver&skuid="+e))}},EvaluateGrade={init:function(){var e=this;1>$("#brand-bar-pop").length||shopInfo.get(G.sku,function(t){null!=t.stock.D&&(e.popInfo=t,t.stock.D&&t.stock.D.vid&&(e.getGradeDetail(t.stock.D.vid),e.getAddress(t.stock.D.vid)),e.setShopInfo(t),e.setGlobalBuy(t))})},bindEvent:function(){return $("#evaluate s").click(function(){$(this).toggleClass("fold"),$("#evaluate-detail").toggle()}),this},getAddress:function(e){$.getJSONP("http://rms.shop.jd.com/json/pop/popcompany.action?callback=EvaluateGrade.setAddress&venderID="+e)},setAddress:function(e){var t=$("#online-service");e&&(e.companyName||e.firstAddr||e.secAddr)&&(t.after('<dl id="pop-company"><dt>\u516c\u53f8\u540d\u79f0\uff1a</dt><dd></dd></dl><dl id="pop-address"><dt>\u6240&nbsp;\u5728&nbsp;\u5730\uff1a</dt><dd></dd></dl>'),$("#pop-company dd").html(e.companyName),$("#pop-address dd").html(e.firstAddr+"&nbsp;"+e.secAddr),$("#online-service dt").css("margin-bottom",10))},setGlobalBuy:function(e){var t=$("#brand-bar-pop");e.stock.D.id&&7==(""+e.stock.D.id).length&&e.stock.D.vid&&7==(""+e.stock.D.vid).length&&t.prepend('<div id="global-buy"><em><img src="http://misc.360buyimg.com/product/skin/2012/i/global-buy.png" alt="\u73af\u7403UBY\u8ba4\u8bc1\u5546\u5bb6" /></em></div>')},getGrade:function(){var e=$(".evaluate-grade"),t=$(".heart-red");return window.fetchJSON_Eva=function(i){t.removeClass("h4").addClass("h"+Math.round(parseFloat(i.result))),e.html(parseFloat(i.result)+"\u5206")},$.getJSONP("http://club.jd.com/clubservice/merchantcomment/"+G.sku+".html?callback=fetchJSON_Eva"),this},getGradeDetail:function(e){$.getJSONP("http://rms.shop.jd.com/json/popscore/newscore.action?callback=EvaluateGrade.setGradeDetail&venderID="+e)},setGradeDetail:function(e){function t(){return e.resDescScore=0==e.avgDescScore?0:Math.abs(100*((e.descScore-e.avgDescScore)/e.avgDescScore)),e.resExpressScore=0==e.avgExpressScore?0:Math.abs(100*((e.expressScore-e.avgExpressScore)/e.avgExpressScore)),e.resQualityScore=0==e.avgQualityScore?0:Math.abs(100*((e.qualityScore-e.avgQualityScore)/e.avgQualityScore)),e.resAfsScore=0==e.avgAfsScore?0:Math.abs(100*((e.afsScore-e.avgAfsScore)/e.avgAfsScore)),e.descScore>e.avgDescScore?e.descScoreTrends=0==e.avgDescScore?"eva-eq":"eva-up":e.descScore==e.avgDescScore?e.descScoreTrends="eva-eq":e.descScore<e.avgDescScore&&(e.descScoreTrends="eva-down"),e.expressScore>e.avgExpressScore?e.expressScoreTrends=0==e.avgExpressScore?"eva-eq":"eva-up":e.expressScore==e.avgExpressScore?e.expressScoreTrends="eva-eq":e.expressScore<e.avgExpressScore&&(e.expressScoreTrends="eva-down"),e.qualityScore>e.avgQualityScore?e.qualityScoreTrends=0==e.avgQualityScore?"eva-eq":"eva-up":e.qualityScore==e.avgQualityScore?e.qualityScoreTrends="eva-eq":e.qualityScore<e.avgQualityScore&&(e.qualityScoreTrends="eva-down"),e.afsScore>e.avgAfsScore?e.afsScoreTrends=0==e.avgAfsScore?"eva-eq":"eva-up":e.afsScore==e.avgAfsScore?e.afsScoreTrends="eva-eq":e.afsScore<e.avgAfsScore&&(e.afsScoreTrends="eva-down"),e.title="\u8ba1\u7b97\u89c4\u5219\uff1a(\u5546\u5bb6\u5f97\u5206-\u540c\u884c\u4e1a\u5e73\u5747\u5206)/\u540c\u884c\u4e1a\u5e73\u5747\u5206",e}var i='<div id="evaluate-detail" class="m">      {if parseInt(totalScore)<1}      <div style="padding-bottom:10px">\u5356\u5bb6\u6682\u672a\u6536\u5230\u4efb\u4f55\u8bc4\u4ef7</div><style type="text/css">#brand-bar-pop #online-service{border-top:1px solid #ddd;}</style>      {else}    <div class="mt"><style type="text/css">#brand-bar-pop #evaluate{display:block;}</style>        <div class="fl">\u8bc4\u5206\u660e\u7ec6</div>        <div class="p-bfc" title="${title}">\u4e0e\u884c\u4e1a\u76f8\u6bd4</div>    </div>    <div class="mc">        <dl>            <dt>\u63cf\u8ff0\u76f8\u7b26\uff1a</dt>            <dd>                <span class="eva-grade" title="${descScore.toFixed(4)}">${descScore.toFixed(4).substr(0,4)}<b>\u5206</b></span>                <span class="eva-percent ${descScoreTrends}"  title="${title}"><s></s>{if descScoreTrends=="eva-eq"}-----{else}${resDescScore.toFixed(2)}%{/if}</span>            </dd>        </dl>        <dl>            <dt>\u9001\u8d27\u901f\u5ea6\uff1a</dt>            <dd>                <span class="eva-grade" title="${expressScore.toFixed(4)}">${expressScore.toFixed(4).substr(0,4)}<b>\u5206</b></span>                <span class="eva-percent ${expressScoreTrends}"  title="${title}"><s></s>{if expressScoreTrends=="eva-eq"}-----{else}${resExpressScore.toFixed(2)}%{/if}</span>            </dd>        </dl>        <dl>            <dt>\u5546\u54c1\u8d28\u91cf\uff1a</dt>            <dd>                <span class="eva-grade" title="${qualityScore.toFixed(4)}">${qualityScore.toFixed(4).substr(0,4)}<b>\u5206</b></span>                <span class="eva-percent ${qualityScoreTrends}"  title="${title}"><s></s>{if qualityScoreTrends=="eva-eq"}-----{else}${resQualityScore.toFixed(2)}%{/if}</span>            </dd>        </dl>        <dl class="evaluate-item-last">            <dt>\u552e\u540e\u670d\u52a1\uff1a</dt>            <dd>                <span class="eva-grade" title="${afsScore.toFixed(4)}">${afsScore.toFixed(4).substr(0,4)}<b>\u5206</b></span>                <span class="eva-percent ${afsScoreTrends}"  title="${title}"><s></s>{if afsScoreTrends=="eva-eq"}-----{else}${(resAfsScore).toFixed(2)}%{/if}</span>            </dd>        </dl><div class="line"></div>    </div>      {/if}</div>';if(null!==e){1>$("#evaluate s").length&&$("#evaluate").append("<s></s>"),this.bindEvent();var s=t(),a=this.popInfo.stock&&this.popInfo.stock.D?"http://mall.jd.com/shopLevel-"+this.popInfo.stock.D.id+".html":"#none";$(".evaluate-grade strong").html('<a href="'+a+'" target="_blank">'+(e.totalScore+"").substr(0,3)+"</a>").attr("title",e.totalScore.toFixed(4)),$(".heart-red").removeClass("h5").addClass("h"+e.totalScore.toFixed(0)),$("#evaluate").after(i.process(s))}},setShopInfo:function(e){e.stock.D.vender&&e.stock.D.url&&$("#seller dd a").html(e.stock.D.vender).attr({href:e.stock.D.url,title:e.stock.D.vender}),$("#enter-shop a").attr("href",e.stock.D.url),e.stock.D.linkphone&&""==$("#hotline dd").html()&&($("#hotline dd").html(e.stock.D.linkphone),$("#hotline").show())}},JdService={init:function(e,t,i){this.sku=e,this.resObj={},this.currSku=null,this.obj=t||$("#choose-service .dd"),this.fn=i||function(){},this.url="",this.typeMap={t2:"ycbs",t3:"ycbs",t4:"ycbs",t6:"ywbh",t7:"ywbh",t9:"yhdx"},this.TPL='<div class="service-type-yb">    {for item in list}    <div class="item">        <b></b><i class="yb-ico-t${item.sortId}"></i>        <a href="#none" id="yb-pid-${item.platformPid}" data-type="${item.sortId}" data-sku="${item.platformPid}" title="${item.sortName} \uffe5${item.price}">${item.sortName} \uffe5${item.price}</a>    </div>    {/for}</div>',this.get()},bindEvent:function(){var e=this;this.obj.find(".service-type-yb .item a").bind("click",function(){var t=$(this),i=t.attr("data-sku"),s=(t.attr("data-type"),t.parent(".item"));s.hasClass("selected")?(e.removeItem(i),e.removeCurrStyle(t)):(e.addItem(i),e.addCurrStyle(t)),e.currSku=i,e.currEl=t,e.calResult()})},addCurrStyle:function(e){var t=e.parents(".service-type").eq(0),i=t.find(".item");i.removeClass("selected"),e.parent(".item").eq(0).addClass("selected")},removeCurrStyle:function(e){e.parent(".item").eq(0).removeClass("selected")},get:function(){var e=this;$.ajax({url:"http://d.360buy.com/yanbao2/get?skuId="+this.sku,dataType:"jsonp",success:function(t){t&&e.set(t)}})},set:function(e){var t={list:e};t.list.length>0?(this.obj.html(this.TPL.process(t)).parent().show(),pageConfig.product.hasYbInfo=!0):this.obj.parent().hide(),this.bindEvent(),this.itemCount=t.list.length,this.insertMore()},insertMore:function(){var e=this.obj.find(".service-type-yb"),t=pageConfig.wideVersion&&pageConfig.compatible?3:2;return 2*t>=this.itemCount?!1:(e.after('<a class="more-services" href="#none">\u66f4\u591a\u4eac\u4e1c\u670d\u52a1<s></s></a>'),this.obj.find(".more-services").bind("click",function(){"yes"!==e.attr("data-more")?(e.addClass("open"),e.attr("data-more","yes"),$(this).find("s").addClass("fold")):(e.removeClass("open"),e.removeAttr("data-more"),$(this).find("s").removeClass("fold"))}),void 0)},addItem:function(e){this.resObj["p"+e]=e},removeItem:function(e){this.resObj["p"+e]=null},calResult:function(){var e=this.resObj,t=[],i=[];for(var s in e)e[s]&&(t.push(e[s]),i.push(e[s]));return"function"==typeof this.fn?this.fn.apply(this,[t,this.currSku,this.currEl]):void 0}},NotifyPop={_saleNotify:"http://skunotify."+pageConfig.FN_getDomain()+"/pricenotify.html?",_stockNotify:"http://skunotify."+pageConfig.FN_getDomain()+"/storenotify.html?",init:function(e,t,i){var s,a=this,o=G.serializeUrl(location.href),n=/from=weibo/.test(location.href)?location.search.replace(/\?/,""):"";/from=weibo/.test(location.href)&&(s=o.param.type,this.setThickBox(s,n)),$(e+","+t+","+i).livequery("click",function(){var e,t=$(this).attr("id");return e="notify-btn"==t||"notify-stock"==t?2:1,G.checkLogin(function(t){t.IsAuthenticated?(a._userPin=t.Name,a.setThickBox(e,n)):(jdModelCallCenter.settings.fn=function(){G.checkLogin(function(t){t.IsAuthenticated&&(a._userPin=t.Name,a.setThickBox(e,n))})},jdModelCallCenter.login())}),!1}).attr("href","#none").removeAttr("target")},setThickBox:function(e,t){var i,s,a,o={skuId:pageConfig.product.skuid,pin:this._userPin,webSite:1,origin:1,source:1},n=G.serializeUrl(location.href);/blogPin/.test(location.href)&&(o.blogPin=n.param.blogPin),1==e&&(i="\u964d\u4ef7\u901a\u77e5",s=this._saleNotify,a=230),2==e&&(i="\u5230\u8d27\u901a\u77e5",s=this._stockNotify,a=180,o.storeAddressId=readCookie("ipLoc-djd")),s+=t?t:$.param(o),$.jdThickBox({type:"iframe",source:decodeURIComponent(s)+"&nocache="+ +new Date,width:500,height:a,title:i,_box:"notify_box",_con:"notify_con",_title:"notify_title"})}};if($(function(){var e=$("#recommend .tab");e.find("li").eq(0).attr("id","th-fitting"),e.find("li").eq(1).attr("id","th-hot"),e.find("li").eq(2).attr("id","th-service").hide(),$("#th-fitting a").eq(0).text("\u63a8\u8350\u914d\u4ef6"),1>$("#th-suits").length&&($("#th-fitting").after('<li data-widget="tab-item" class="none" id="th-suits"><a href="javascript:;">\u4f18\u60e0\u5957\u88c5</a></li>'),$("#tab-reco").after('<div id="tab-suits" class="mc none" data-widget="tab-content"> <div class="iloading">\u6b63\u5728\u52a0\u8f7d\u4e2d\uff0c\u8bf7\u7a0d\u5019...</div> </div>')),$("#j-im").addClass("djd-im").attr("href","#none"),$("#btnReferSearch").attr("clstag","shangpin|keycount|product|consult9"),$("#consult .tab li").each(function(e){$(this).attr("clstag","shangpin|keycount|product|consult0"+(e+1))}),$("#summary-stock .dt").html("\u914d&nbsp;\u9001&nbsp;\u81f3\uff1a"),$("#view-bigimg").after('<div id="compare"><a class="btn-compare btn-compare-s" href="#none" id="comp_{sku}" skuid="{sku}"><span>\u5bf9\u6bd4</span></a></div>'.replace(/{sku}/g,G.sku)),pageConfig.FN_InitContrast(),G.getCommentNum(G.orginSku,function(e){var t=$("#summary-grade .star"),i=$("#summary-grade .dd>a").eq(0);e&&e.CommentCount!==void 0?(t.removeClass("sa0").addClass("sa"+e.AverageScore),i.html("(\u5df2\u6709"+e.CommentCount+"\u4eba\u8bc4\u4ef7)").css("float","left")):(t.removeClass("sa0").addClass("sa5"),i.html("(\u5df2\u67090\u4eba\u8bc4\u4ef7)").css("float","left"))}),function(){$("#choose-result").length>0?$("#choose-result").before('<li id="choose-service" class="hide"><div class="dt">\u4eac\u4e1c\u670d\u52a1\uff1a</div><div class="dd"></div></li>'):$("#choose-btns").length>0&&$("#choose-btns").before('<li id="choose-service" class="hide"><div class="dt">\u4eac\u4e1c\u670d\u52a1\uff1a</div><div class="dd"></div></li>');var e=$("#choose-btn-append a"),t=e.attr("href"),i=$("#choose-result .dd"),s=$("#choose-result .dd").html();JdService.init(G.sku,$("#choose-service .dd"),function(a){var o="&ybId="+a.join(","),n=$("#buy-num").val(),r=[];if(a.length>0){if(e.attr("href",t.replace(/pcount=\d+/,"pcount="+n)+o),"none"!==i.css("display")){for(var c=0;a.length>c;c++)r.push("<strong>\u201c"+$("#yb-pid-"+a[c]).text()+"\u201d</strong>");i.html(s+"\uff0c"+r.join("\uff0c"))}}else e.attr("href",t.replace(/pcount=\d+/,"pcount="+n)),i.html(s)})}(),$(".jqzoom").jqueryzoom({xzoom:400,yzoom:400,offset:10,position:"left",preload:1,lens:1}),$("#summary-grade .dd").click(function(){var e=$("#comment");"true"!==$("#comment").attr("nodata")?e.show():$(document).scrollTop($("#comments-list").offset().top+$("#comments-list .mt").height())}),$("#spec-list li").mouseover(function(){var e=$(this).find("img"),t=e.attr("src"),i=$("#spec-list li").index($(this)),s=$(this).attr("data-video"),a="http://cloud.letv.com/bcloud.html?uu=abcde12345&vu={V}&pu=12345abcde&auto_play=0&width=352&height=352";$("#spec-list img").removeClass("img-hover"),e.addClass("img-hover"),1===i&&s?1>$("#le-video").length?$("#preview").append('<iframe id="le-video" src="'+a.replace("{V}",s)+'" frameborder="0" scrolling="no" style="display:block; width:352px; height:352px; position:absolute; left:0; top:0; "></iframe>'):$("#le-video").show():($("#spec-n1 img").eq(0).attr({src:t.replace("/n5/","/n1/"),jqimg:t.replace("/n5/","/n0/")}),$("#le-video").length>0&&$("#le-video").hide())}),CommentListNew.init(G.sku),Recommend.init(pageConfig.product.type),Repository.init(G.sku),EvaluateGrade.init(),NotifyPop.init("#summary-price .dd a","#notify-stock",".btn-notice"),$(".spec-items").imgScroll({visible:5,speed:200,step:1,loop:!1,prev:"#spec-forward",next:"#spec-backward",disableClass:"disabled"}),$("#recommend").Jtab({event:"click",compatible:!0}),$("#product-detail").Jtab({event:"click",compatible:!0},function(e,t,i){$("#product-detail .mt").removeClass("nav-fixed"),$("#product-detail .mt").removeClass("nav-fixed").floatNav({fixedClass:"nav-fixed",targetEle:"#consult",anchor:"#product-detail",range:30,onStart:function(){$("#nav-minicart").show()}}),3==i?(t.css("height",5).html("<div>a</div>"),$("#promises,#state").hide(),Consult.getData(0,$("#consult-0")),CommentListNew.loadFirstPage||CommentListNew.getData($("#comment-0"),0,0),$("#product-detail .mt").floatNav({fixedClass:"nav-fixed",targetEle:"#consult",anchor:"#product-detail",range:0,onStart:function(){$("#nav-minicart").show()}})):$("#promises,#state").show()}),$("#comments-list").Jtab({event:"click",compatible:!0},function(e,t,i){var s=0;s=1===i?3:3===i?1:i,CommentListNew.getData(t,s,0)}),$("#discuss").Jtab({event:"click",compatible:!0},function(e,t,i){Discuss.getData(i,t)}),$("#consult").Jtab({event:"click",compatible:!0},function(e,t,i){4>=i?Consult.getData(i,t):Consult.setExtraData(i,t)}),mlazyload({defObj:"#consult",defHeight:0,fn:function(){Consult.getData(0,$("#consult-0"))}}),mlazyload({defObj:"#comments-list",defHeight:0,fn:function(){CommentListNew.loadFirstPage||CommentListNew.getData($("#comment-0"),0,0)}}),mlazyload({defObj:"#discuss",defHeight:0,fn:function(){Discuss.getData(0,$("#discuss-1"))}}),mlazyload({defObj:"#comments",defHeight:0,fn:function(){CommentListNew.loadFirstPage||CommentListNew.getData($("#comment-0"),0,0)
}}),$("#ranklist .mc").Jtab({compatible:!0}),$("#product-detail .mt").floatNav({fixedClass:"nav-fixed",targetEle:"#consult",anchor:"#product-detail",range:30,onStart:function(){var e=$(".nav-minicart-buynow");e.length>0&&e.find("a").html("\u7acb\u5373\u8d2d\u4e70"),$("#nav-minicart").show()}}),$("#nav-minicart").Jdropdown(function(e){var t=pageConfig.product.priceImg||"http://jprice.360buyimg.com/price/gp"+G.sku+"-1-1-1.png";e.find(".nav-minicart-btn a").attr("href",$("#choose-btn-append .btn-append").attr("href")),e.find(".p-img img").attr("src",pageConfig.FN_GetImageDomain(G.sku)+"n4/"+pageConfig.product.src),e.find(".p-name").html(G.name),e.find(".p-price img").attr("src",t)}),$("#store-selector").Jdropdown(),$(".share-ft").click(function(){$(this).toggleClass("share-ft-open"),$(this).parents("#share-list").toggleClass("share-list-open"),$(".share-list-item").toggleClass("share-list-item-all")}),$("#comments-list .tab").append('<li class="tab-last"></li>'),pageConfig.product.renew&&$.ajax({url:"http://d.360buy.com/oldfornew/get?skuId="+pageConfig.product.skuid,dataType:"jsonp",success:function(e){var t='<div class="renew-arrgrment" style="line-height:200%;height:190px;overflow-y:auto;">    <p>\u5c0a\u656c\u7684\u5ba2\u6237\uff1a</p>    <p>\u60a8\u597d\uff01\u6b22\u8fce\u60a8\u53c2\u52a0\u4eac\u4e1c\u5546\u57ce\u201c\u7535\u8111\u4ee5\u65e7\u6362\u65b0\u201d\u6d3b\u52a8\u3002\u4e3a\u4e86\u4fdd\u8bc1\u60a8\u80fd\u591f\u6b63\u5e38\u4eab\u53d7\u4ee5\u65e7\u6362\u65b0\u6d3b\u52a8\u4f18\u60e0\uff0c\u8bf7\u60a8\u4ed4\u7ec6\u9605\u8bfb\u4ee5\u4e0b\u6d3b\u52a8\u7ec6\u5219\uff0c\u786e\u8ba4\u65e0\u8bef\u540e\u518d\u63d0\u4ea4\u4ee5\u65e7\u6362\u65b0\u8ba2\u5355\u3002</p>     <ul>        <li>1. \u6d3b\u52a8\u53c2\u4e0e\u5730\u533a\uff1a\u6240\u6709\u4eac\u4e1c\u81ea\u8425\u914d\u9001\u8986\u76d6\u8303\u56f4\uff0c\u5177\u4f53\u8303\u56f4\u8bf7\u67e5\u770b\u4eac\u4e1c\u5e2e\u52a9\u4e2d\u5fc3\uff1b</li>        <li>2. \u4eac\u4e1c\u5546\u57ce\u53c2\u52a0\u6d3b\u52a8\u4ea7\u54c1\uff1a\u4ee5\u4ea7\u54c1\u9875\u9762\u4fe1\u606f\u663e\u793a\u4e3a\u51c6\uff1b</li>        <li>3. \u60a8\u53c2\u52a0\u4ee5\u65e7\u6362\u65b0\u7535\u8111\u8981\u6c42\uff1a\u4efb\u4f55\u54c1\u724c\uff0c\u53ef\u4ee5\u6b63\u5e38\u5f00\u673a\u7684\u7b14\u8bb0\u672c\u7535\u8111\uff1b\u4e0d\u7b26\u5408\u6b64\u6807\u51c6\u7684\u65e7\u7535\u8111\uff0c\u4e0d\u80fd\u53c2\u4e0e\u201c\u4ee5\u65e7\u6362\u65b0\u201d\u6d3b\u52a8\uff1b</li>        <li>4. \u5177\u4f53\u6d3b\u52a8\u89c4\u5219\uff1a\u4ee5\u4eac\u4e1c\u5546\u57ce\u7f51\u7ad9\u9875\u9762\u516c\u793a\u4e3a\u51c6\uff1b</li>        <li>5. \u7b7e\u7f72\u6587\u4ef6\uff1a\u4eac\u4e1c\u5546\u57ce\u7535\u8111\u4ee5\u65e7\u6362\u65b0\u89c4\u5219\u7b7e\u6536\u5355\uff0c\u60a8\u9700\u4e0e\u4ea7\u54c1\u7b7e\u6536\u5355\u4e00\u5e76\u7b7e\u6536\uff1b</li>        <li>6. \u9000\u6362\u8d27\u6d41\u7a0b\uff1a\u53c2\u52a0\u6b64\u201c\u4ee5\u65e7\u6362\u65b0\u201d\u65b9\u5f0f\u8d2d\u4e70\u7684\u7b14\u8bb0\u672c\u7535\u8111\u5982\u7533\u8bf7\u9000\u8d27\uff0c\u4eac\u4e1c\u4ec5\u6309\u7167\u6d88\u8d39\u8005\u5b9e\u9645\u652f\u4ed8\u91d1\u989d\u9000\u6b3e\uff0c\u4eac\u4e1c\u4e0d\u518d\u5411\u6d88\u8d39\u8005\u8fd4\u8fd8\u65e7\u7b14\u8bb0\u672c\u7535\u8111\u3002</li>    </ul></div><div class="renew-btn">    <a href="#none" class="css3-btn">\u540c\u610f\u534f\u8bae\u5e76\u52a0\u5165\u8d2d\u7269\u8f66</a></div>';e&&e.isOldForNew&&($("#choose-btns").prepend('<div id="choose-btn-renew" class="btn"><a href="javascript:;" class="btn-renew">\u53c2\u52a0\u4ee5\u65e7\u6362\u65b0<b></b></a></div>'),$("#choose-btn-renew").jdThickBox({type:"text",width:570,height:240,title:"\u4ee5\u65e7\u6362\u65b0\u534f\u8bae",_title:"renew_agreement_title",source:t,_con:"renew_aggrement",_close:"close_me"},function(){$(".renew-btn .css3-btn").attr("href","http://trade.jd.com/order/getOrderInfo.action?pid="+pageConfig.product.skuid+"&pcount="+$("#buy-num").val()+"&rid="+ +new Date)}))}}),/from=email/.test(location.href)&&$.getScript("http://misc.360buyimg.com/product/js/2012/notify.js",function(){Notify&&Notify.init("#summary-price .dd a","#notify-stock")}),$("#preview").hover(function(){$(".Jtips").hide()},function(){$(".Jtips").show()}),mark(G.sku,1),clsPVAndShowLog("","",3,"p"),clsPVAndShowLog("","",2,"p"),function(){var e="";G.isJd&&6980!==G.cat[2]&&(e+='<div id="feature-service-extra" class="i-mc"></div>'),(655==G.cat[2]||762==G.cat[2]||828==G.cat[1])&&(e+='<div class="i-mc"><b>\u97f3\u4e50\u4e0b\u8f7d\u670d\u52a1</b> - \u6d77\u91cf\u6b63\u7248\u97f3\u4e50\uff0c\u9876\u7ea7\u97f3\u4e50\u4eab\u53d7\uff01<a href="http://music.jd.com/" target="_blank">\u67e5\u770b&gt;&gt;</a></div>'),""!=e&&$("#tab-services").html(e)}(),function(){var e,t=[],i=window.location.href+"?sid=";i=readCookie("pin")?i+readCookie("pin"):i,t.push('<div class="model-prompt model-partake"><div class="form"><label>\u5546\u54c1\u94fe\u63a5\uff1a</label><input type="text" class="text" value=\''),t.push(i),t.push("'/></div>"),$.browser.msie?(t.push('<div class="ac"><input type="button" class="btn-copy" value="\u590d\u5236\u5e76\u53d1\u7ed9\u6211\u7684\u597d\u53cb" onclick="window.clipboardData.setData(\'Text\',\''+i+"');$('.model-partake').html('\u5546\u54c1\u94fe\u63a5\u5730\u5740\u5df2\u7ecf\u590d\u5236\uff0c\u60a8\u53ef\u4ee5\u7c98\u8d34\u5230QQ\u3001MSN\u6216\u90ae\u4ef6\u4e2d\u53d1\u9001\u7ed9\u597d\u53cb\u4e86!')\"></div>"),e=90):(t.push('<div class="i-con">\u60a8\u7684\u6d4f\u89c8\u5668\u4e0d\u652f\u6301\u81ea\u52a8\u590d\u5236\u529f\u80fd\u3002\u60a8\u53ef\u4ee5\u6309\u4f4fCtrl+C\uff0c\u5c06\u5546\u54c1\u94fe\u63a5\u5730\u5740\u590d\u5236\u4e0b\u6765\u3002</div>'),e=110),t.push("</div>"),t=t.join(""),$("#site-qq").jdThickBox({type:"text",width:400,height:e,source:t,_fastClose:!0}),$("#site-qqmsn").jdThickBox({type:"text",width:400,height:e,source:t,_fastClose:!0}),$(".share-list-item a").click(function(){var e=this.id;if(pageConfig.product.realPrice)switch(e){case"site-sina":jdPshowRecommend("http://v.t.sina.com.cn/share/share.php?appkey=2445336821","sina");break;case"site-qzone":jdPshowRecommend("http://v.t.qq.com/share/share.php?source=1000002&site=http://www.jd.com","qzone");break;case"site-renren":jdPshowRecommend("http://share.renren.com/share/buttonshare/post/1004?","renren");break;case"site-kaixing":jdPshowRecommend("http://www.kaixin001.com/repaste/share.php?","kaixing");break;case"site-douban":jdPshowRecommend("http://www.douban.com/recommend/?","douban");break;case"site-msn":jdPshowRecommend("http://profile.live.com/badge/?","MSN");break;case"site-email":window.open("http://club.jd.com/jdFriend/tjyl.aspx?product="+G.sku)}else window.getNumPriceService=function(t){switch(t.jdPrice.amount&&(pageConfig.product.realPrice=t.jdPrice.amount),e){case"site-sina":jdPshowRecommend("http://v.t.sina.com.cn/share/share.php?appkey=2445336821","sina");break;case"site-qzone":jdPshowRecommend("http://v.t.qq.com/share/share.php?source=1000002&site=http://www.jd.com","qzone");break;case"site-renren":jdPshowRecommend("http://share.renren.com/share/buttonshare/post/1004?","renren");break;case"site-kaixing":jdPshowRecommend("http://www.kaixin001.com/repaste/share.php?","kaixing");break;case"site-douban":jdPshowRecommend("http://www.douban.com/recommend/?","douban");break;case"site-msn":jdPshowRecommend("http://profile.live.com/badge/?","MSN");break;case"site-email":window.open("http://club.jd.com/jdFriend/tjyl.aspx?product="+G.sku)}},$.ajax({url:"http://jprice.jd.com/price/np"+G.sku+"-TRANSACTION-J.html",dataType:"jsonp"})})}(),function(){var e=$(".detail-correction"),t=e.find("a").eq(0).attr("href"),i="";if(t)var i=t.replace(/skuid=\d+/,"skuid="+G.sku);e.length>0&&e.html('<div class="detail-correction"> <b></b>\u5982\u679c\u60a8\u53d1\u73b0\u5546\u54c1\u4fe1\u606f\u4e0d\u51c6\u786e\uff0c<a href="'+i+'" target="_blank">\u6b22\u8fce\u7ea0\u9519</a></div>')}()}),setImButton(),window.pageConfig){var sidePanle=new pageConfig.FN_InitSidebar;sidePanle.addItem("<a class='research' target='_blank' href='http://market.jd.com/jdvote/vote2.aspx?voteId=168'><b></b>\u8c03\u67e5\u95ee\u5377</a>"),sidePanle.setTop(),sidePanle.scroll()}if(function(){$.ajax({url:"http://fa.jd.com/loadFa_toJson.js?aid=2_163_817-2_163_818-2_232_3431-2_163_3743",dataType:"script",cache:!0}),1315===G.cat[0]&&$("#Ad2_100_2272").length>0&&$.ajax({url:"http://fa.jd.com/loadFa.js?aid=2_100_2272",dataType:"script",cache:!0}),$.ajax({url:"http://counter.360buy.com/aclk.aspx?key=p"+G.sku,dataType:"script",cache:!0})}(),1467!==G.cat[1]){var _mvq=_mvq||[];_mvq.push(["$setAccount","m-9-1"]),_mvq.push(["$setGeneral","goodsdetail","","",""]),_mvq.push(["$addGoods","","","",G.sku+""]),_mvq.push(["$logData"])}




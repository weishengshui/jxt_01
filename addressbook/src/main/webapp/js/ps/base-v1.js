window.pageConfig = window.pageConfig || {};
pageConfig.wideVersion = (function() {
    return (screen.width >= 1210)
})();
if (pageConfig.wideVersion && pageConfig.compatible) {
    document.getElementsByTagName("body")[0].className = "root61"
}
pageConfig.FN_getDomain = function() {
    var a = location.hostname;
    return (/360buy.com/.test(a)) ? "360buy.com": "jd.com"
};
pageConfig.FN_GetUrl = function(a, b) {
    if (typeof a == "string") {
        return a
    } else {
        return pageConfig.FN_GetDomain(a) + b + ".html"
    }
};
pageConfig.FN_StringFormat = function() {
    var e = arguments[0],
    f = arguments.length;
    if (f > 0) {
        for (var d = 0; d < f; d++) {
            e = e.replace(new RegExp("\\{" + d + "\\}", "g"), arguments[d + 1])
        }
    }
    return e
};
pageConfig.FN_GetDomain = function(b, c) {
    var a = "http://{0}.jd.com/{1}";
    switch (b) {
    case 1:
        a = this.FN_StringFormat(a, "item", "");
        break;
    case 2:
        a = this.FN_StringFormat(a, "book", "");
        break;
    case 3:
        a = this.FN_StringFormat(a, "mvd", "");
        break;
    case 4:
        a = this.FN_StringFormat(a, "e", "");
        break;
    case 7:
        a = this.FN_StringFormat(a, "music", "");
        break;
    default:
        break
    }
    return a
};
pageConfig.FN_GetImageDomain = function(d) {
    var c, d = String(d);
    switch (d.match(/(\d)$/)[1] % 5) {
    case 0:
        c = 10;
        break;
    case 1:
        c = 11;
        break;
    case 2:
        c = 12;
        break;
    case 3:
        c = 13;
        break;
    case 4:
        c = 14;
        break;
    default:
        c = 10
    }
    return "http://img{0}.360buyimg.com/".replace("{0}", c)
};
pageConfig.FN_ImgError = function(b) {
    var c = b.getElementsByTagName("img");
    for (var a = 0; a < c.length; a++) {
        c[a].onerror = function() {
            var d = "",
            e = this.getAttribute("data-img");
            if (!e) {
                return
            }
            switch (e) {
            case "1":
                d = "err-product";
                break;
            case "2":
                d = "err-poster";
                break;
            case "3":
                d = "err-price";
                break;
            default:
                return
            }
            this.src = "http://misc.360buyimg.com/lib/img/e/blank.gif";
            this.className = d
        }
    }
};
pageConfig.FN_SetPromotion = function(b) {
    if (b == 0) {
        return
    }
    var e = "\u9650\u91cf,\u6e05\u4ed3,\u9996\u53d1,\u6ee1\u51cf,\u6ee1\u8d60,\u76f4\u964d,\u65b0\u54c1,\u72ec\u5bb6,\u4eba\u6c14,\u70ed\u5356",
    d = e.split(",")[parseInt(b) - 1],
    c = "<b class='pi{0}'>{1}</b>";
    switch (d.length) {
    case 1:
        c = c.replace("{0}", " pix1 pif1");
        break;
    case 2:
        c = c.replace("{0}", " pix1");
        break;
    case 4:
        c = c.replace("{0}", " pix1 pif4");
        break
    }
    return c.replace("{1}", d)
};
pageConfig.FN_GetRandomData = function(c) {
    var b = 0,
    f = 0,
    a, e = [];
    for (var d = 0; d < c.length; d++) {
        a = c[d].weight ? parseInt(c[d].weight) : 1;
        e[d] = [];
        e[d].push(b);
        b += a;
        e[d].push(b)
    }
    f = Math.ceil(b * Math.random());
    for (var d = 0; d < e.length; d++) {
        if (f > e[d][0] && f <= e[d][1]) {
            return c[d]
        }
    }
};
pageConfig.FN_GetCompatibleData = function(b) {
    var a = (screen.width < 1210);
    if (a) {
        b.width = b.widthB ? b.widthB: b.width;
        b.height = b.heightB ? b.heightB: b.height;
        b.src = b.srcB ? b.srcB: b.src
    }
    return b
};
pageConfig.FN_InitSlider = function(c, g) {
    var b = function(j, i) {
        return j.group - i.group
    };
    g.sort(b);
    var h = g[0].data,
    f = [],
    e = (h.length == 3) ? "style2": "style1",
    a;
    f.push('<div class="slide-itemswrap"><ul class="slide-items"><li class="');
    f.push(e);
    f.push('" data-tag="');
    f.push(g[0].aid);
    f.push('">');
    for (var d = 0; d < h.length; d++) {
        a = this.FN_GetCompatibleData(h[d]);
        f.push('<div class="fore');
        f.push(d + 1);
        f.push('" width="');
        f.push(a.width);
        f.push('" height="');
        f.push(a.height);
        f.push('"><a target="_blank" href="');
        f.push(a.href);
        f.push('" title="');
        f.push(a.alt);
        f.push('"><img src="');
        if (d == 0) {
            f.push(a.src)
        } else {
            f.push('http://misc.360buyimg.com/lib/img/e/blank.gif" style="background:url(');
            f.push(a.src);
            f.push(") no-repeat center 0;")
        }
        f.push('" width="');
        f.push(a.width);
        f.push('" height="');
        f.push(a.height);
        f.push('" /></a></div>')
    }
    f.push('</li></ul></div><div class="slide-controls"><span class="curr">1</span></div>');
    document.getElementById(c).innerHTML = f.join("")
};
function login() {
    location.href = "https://passport.jd.com/new/login.aspx?ReturnUrl=" + escape(location.href).replace(/\//g, "%2F");
    return false
}
function regist() {
    location.href = "https://passport.jd.com/new/registpersonal.aspx?ReturnUrl=" + escape(location.href);
    return false
}
function createCookie(c, d, f, e) {
    var e = (e) ? e: "/";
    if (f) {
        var b = new Date();
        b.setTime(b.getTime() + (f * 24 * 60 * 60 * 1000));
        var a = "; expires=" + b.toGMTString()
    } else {
        var a = ""
    }
    document.cookie = c + "=" + d + a + "; path=" + e
}
function readCookie(b) {
    var e = b + "=";
    var a = document.cookie.split(";");
    for (var d = 0; d < a.length; d++) {
        var f = a[d];
        while (f.charAt(0) == " ") {
            f = f.substring(1, f.length)
        }
        if (f.indexOf(e) == 0) {
            return f.substring(e.length, f.length)
        }
    }
    return null
}
function addToFavorite() {
    var d = "http://www.jd.com/";
    var c = "\u4eac\u4e1cJD.COM-\u7f51\u8d2d\u4e0a\u4eac\u4e1c\uff0c\u7701\u94b1\u53c8\u653e\u5fc3";
    if (document.all) {
        window.external.AddFavorite(d, c)
    } else {
        if (window.sidebar) {
            window.sidebar.addPanel(c, d, "")
        } else {
            alert("\u5bf9\u4e0d\u8d77\uff0c\u60a8\u7684\u6d4f\u89c8\u5668\u4e0d\u652f\u6301\u6b64\u64cd\u4f5c!\n\u8bf7\u60a8\u4f7f\u7528\u83dc\u5355\u680f\u6216Ctrl+D\u6536\u85cf\u672c\u7ad9\u3002")
        }
    }
    createCookie("_fv", "1", 30, "/;domain=jd.com")
}
var CookieUtil = {};
CookieUtil.setASCIICookie = function(e, f, b, c, a, d) {
    if ("string" == typeof(e) && "string" == typeof(f)) {
        f = escape(f);
        CookieUtil.setCookie(e, f, b, c, a, d)
    }
};
CookieUtil.setUnicodeCookie = function(e, f, b, c, a, d) {
    if ("string" == typeof(e) && "string" == typeof(f)) {
        f = encodeURIComponent(f);
        CookieUtil.setCookie(e, f, b, c, a, d)
    }
};
CookieUtil.setCookie = function(f, g, b, c, a, e) {
    if ("string" == typeof(f) && "string" == typeof(g)) {
        var d = f + "=" + g;
        if (b) {
            d += "; expires=" + b.toGMTString()
        }
        if (c) {
            d += "; path=" + c
        }
        if (a) {
            d += "; domain=" + a
        }
        if (e) {
            d += "; secure"
        }
        document.cookie = d
    }
};
CookieUtil.getUnicodeCookie = function(b) {
    var d = getCookie(b);
    if ("string" == typeof(b)) {
        var c = getCookie(b);
        if (null == c) {
            return null
        } else {
            return decodeURIComponent(c)
        }
    } else {
        var a = document.cookie;
        return a
    }
};
CookieUtil.getASCIICookie = function(b) {
    var d = getCookie(b);
    if ("string" == typeof(b)) {
        var c = getCookie(b);
        if (null == c) {
            return null
        } else {
            return unescape(c)
        }
    } else {
        var a = document.cookie;
        return a
    }
};
CookieUtil.getCookie = function(d) {
    var a = document.cookie;
    if ("string" == typeof(d)) {
        var c = "(?:; )?" + d + "=([^;]*);?";
        var b = new RegExp(c);
        if (b.test(a)) {
            return RegExp["$1"]
        } else {
            return null
        }
    } else {
        return a
    }
};
CookieUtil.deleteCookie = function(c, b, a) {
    CookieUtil.setCookie(c, "", new Date(0), b, a)
};
var searchlog = (function() {
    var f = "http://sstat." + pageConfig.FN_getDomain() + "/scslog?args=";
    var e = "{keyword}^#psort#^#page#^#cid#^" + encodeURIComponent(document.referrer);
    var d = "2";
    var c = "";
    var a = "";
    var b = function b() {
        var j = "";
        var h = "";
        var l = "";
        var m = "0";
        if (arguments.length > 0) {
            if (arguments[0] == 0) {
                j = f + d + "^" + e + "^^^58^^" + a + "^" + c
            } else {
                if (arguments[0] == 1) {
                    if (d != 10) {
                        j = f + "1^" + e + "^"
                    } else {
                        j = f + "11^" + e + "^"
                    }
                    for (var k = 1; k < arguments.length; k++) {
                        j += encodeURI(arguments[k]) + "^"
                    }
                    if (arguments.length > 3 && arguments[3] == "51") {
                        h = arguments[1]
                    }
                    if (arguments.length > 3 && arguments[3] == "55") {
                        l = arguments[1]
                    }
                    if (arguments.length > 3 && arguments[3] == "56") {
                        m = arguments[1]
                    }
                    for (var k = 0,
                    g = 5 - arguments.length; k < g; k++) {
                        j += "^"
                    }
                    j += a + "^" + c
                }
            }
        }
        j = j.replace("#cid#", h);
        j = j.replace("#psort#", l);
        j = j.replace("#page#", m);
        $.getScript(j)
    };
    return b
})();
function search(h) {
    var p = "http://search.jd.com/Search?keyword={keyword}&enc={enc}{additional}{area}";
    var b = search.additinal || "";
    var o = document.getElementById(h);
    var g = o.value;
    g = g.replace(/^\s*(.*?)\s*$/, "$1");
    if (g.length > 100) {
        g = g.substring(0, 100)
    }
    if ("" == g) {
        window.location.href = window.location.href;
        return
    }
    var i = 0;
    if ("undefined" != typeof(window.pageConfig) && "undefined" != typeof(window.pageConfig.searchType)) {
        i = window.pageConfig.searchType
    }
    var n = "&cid{level}={cid}";
    var s = ("string" == typeof(search.cid) ? search.cid: "");
    var f = ("string" == typeof(search.cLevel) ? search.cLevel: "");
    var j = ("string" == typeof(search.ev_val) ? search.ev_val: "");
    var l = false;
    switch (i) {
    case 0:
        l = true;
        break;
    case 1:
        l = true;
        f = "-1";
        b += "&book=y";
        break;
    case 2:
        f = "-1";
        b += "&mvd=music";
        break;
    case 3:
        f = "-1";
        b += "&mvd=movie";
        break;
    case 4:
        f = "-1";
        b += "&mvd=education";
        break;
    case 5:
        var k = "&other_filters=%3Bcid1%2CL{cid1}M{cid1}[cid2]";
        switch (f) {
        case "51":
            n = k.replace(/\[cid2]/, "");
            n = n.replace(/\{cid1}/g, "5272");
            break;
        case "52":
            n = k.replace(/\{cid1}/g, "5272");
            n = n.replace(/\[cid2]/, "%3Bcid2%2CL{cid}M{cid}");
            break;
        case "61":
            n = k.replace(/\[cid2]/, "");
            n = n.replace(/\{cid1}/g, "5273");
            break;
        case "62":
            n = k.replace(/\{cid1}/g, "5273");
            n = n.replace(/\[cid2]/, "%3Bcid2%2CL{cid}M{cid}");
            break;
        case "71":
            n = k.replace(/\[cid2]/, "");
            n = n.replace(/\{cid1}/g, "5274");
            break;
        case "72":
            n = k.replace(/\{cid1}/g, "5274");
            n = n.replace(/\[cid2]/, "%3Bcid2%2CL{cid}M{cid}");
            break;
        case "81":
            n = k.replace(/\[cid2]/, "");
            n = n.replace(/\{cid1}/g, "5275");
            break;
        case "82":
            n = k.replace(/\{cid1}/g, "5275");
            n = n.replace(/\[cid2]/, "%3Bcid2%2CL{cid}M{cid}");
            break;
        default:
            break
        }
        p = "http://search.e.jd.com/searchDigitalBook?ajaxSearch=0&enc=utf-8&key={keyword}&page=1{additional}";
        break;
    case 6:
        f = "-1";
        p = "http://music." + pageConfig.FN_getDomain() + "/8_0_desc_0_0_1_15.html?key={keyword}";
        break;
    default:
        break
    }
    if ("string" == typeof(s) && "" != s && "string" == typeof(f)) {
        var m = /^(?:[1-8])?([1-3])$/;
        if ("-1" == f) {
            f = ""
        } else {
            if (m.test(f)) {
                f = RegExp.$1
            } else {
                f = ""
            }
        }
        var d = n.replace(/\{level}/, f);
        d = d.replace(/\{cid}/g, s);
        b += d
    }
    if ("string" == typeof(j) && "" != j) {
        b += "&ev=" + j
    }
    var r = "";
    if (l) {
        var u = CookieUtil.getCookie("ipLoc-djd");
        if (null != u) {
            var q = u.split("-");
            if (q.length > 0) {
                var t = q[0];
                r = "&area=" + t
            }
        }
    }
    g = encodeURIComponent(g);
    sUrl = p.replace(/\{keyword}/, g);
    sUrl = sUrl.replace(/\{enc}/, "utf-8");
    sUrl = sUrl.replace(/\{additional}/, b);
    sUrl = sUrl.replace(/\{area}/, r);
    if ("undefined" == typeof(search.isSubmitted) || false == search.isSubmitted) {
        setTimeout(function() {
            window.location.href = sUrl
        },
        10);
        search.isSubmitted = true
    }
};
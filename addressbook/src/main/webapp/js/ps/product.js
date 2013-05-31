/*
 item.jd.com Compressed by uglify 
 Author:keelii 
 Date: 2013-05-30 
 */
function log(t, e) {
    var s = "";
    for (i = 2; arguments.length > i; i++) s = s + arguments[i] + "|||";
    var a = decodeURIComponent(escape(getCookie("pin"))),
    o = "http://csc.360buy.com/log.ashx?type1=$type1$&type2=$type2$&data=$data$&pin=$pin$&referrer=$referrer$&jinfo=$jinfo$&callback=?",
    n = o.replace(/\$type1\$/, escape(t));
    n = n.replace(/\$type2\$/, escape(e)),
    n = n.replace(/\$data\$/, escape(s)),
    n = n.replace(/\$pin\$/, escape(a)),
    n = n.replace(/\$referrer\$/, escape(document.referrer)),
    n = n.replace(/\$jinfo\$/, escape("")),
    $.getJSON(n,
    function() {})
}
function clsPVAndShowLog(t, e, i, s) {
    var a = t + "." + i + "." + skutype(e) + "." + s;
    
}
function clsClickLog(t, e, i, s, a, o) {
    var n = t + "." + s + "." + skutype(e);
    appendCookie(o, i, n),
    log("d", "o", n + ".c")
}
function appendCookie(reCookieName, sku, key) {
    var reWidsCookies = eval("(" + getCookie(reCookieName) + ")"); (null == reWidsCookies || "" == reWidsCookies) && (reWidsCookies = {}),
    null == reWidsCookies[key] && (reWidsCookies[key] = "");
    var pos = reWidsCookies[key].indexOf(sku);
    0 > pos && (reWidsCookies[key] = reWidsCookies[key] + "," + sku),
    setCookie(reCookieName, $.toJSON(reWidsCookies), 15)
}
function skutype(t) {
    if (t) {
        var e = ("" + t).length;
        return 10 == e ? 1 : 0
    }
    return 0
}
function setCookie(t, e, i) {
    var s = i,
    a = new Date;
    a.setTime(a.getTime() + 1e3 * 60 * 60 * 24 * s),
    document.cookie = t + "=" + escape(e) + ";expires=" + a.toGMTString() + ";path=/;domain=.jd.com"
}
function getCookie(t) {
    var e = document.cookie.match(RegExp("(^| )" + t + "=([^;]*)(;|$)"));
    return null != e ? unescape(e[2]) : null
}
function clsLog(t, e, i, s, a) {
    appendCookie(a, i, t),
    i = i.split("#")[0],
    log(3, t, i)
}
function jdPshowRecommend(t, e) {
    var i = G.name,
    s = G.sku,
    a = pageConfig.product.src,
    o = pageConfig.product.realPrice || "",
    n = "\u6211\u5728@\u4eac\u4e1c \u53d1\u73b0\u4e86\u4e00\u4e2a\u975e\u5e38\u4e0d\u9519\u7684\u5546\u54c1\uff1a" + i + "\uff0c\u4eac\u4e1c\u4ef7\uff1a\uffe5 " + o + "\u3002\u611f\u89c9\u4e0d\u9519\uff0c\u5206\u4eab\u4e00\u4e0b",
    r = pageConfig.FN_GetImageDomain(s) + "n5/" + a,
    c = "http://item.jd.com/" + s + ".html?sid=",
    d = readCookie("pin") || "";
    "qzone" == e && (t = t + "&title=" + n + "&pic=" + r + "&url=" + c + d),
    "sina" == e && (t = t + "&title=" + encodeURIComponent(n) + "&pic=" + encodeURIComponent(r) + "&url=" + encodeURIComponent(c) + d, window.open(t, "", "height=500, width=600")),
    "renren" == e && (t = t + "title=" + i + "&content=" + n + "&pic=" + r + "&url=" + c + d),
    "kaixing" == e && (t = t + "rtitle=" + i + "&rcontent=" + n + "&rurl=" + c + d),
    "douban" == e && (t = t + "title=" + i + "&comment=" + n + "&url=" + c + d),
    "MSN" == e && (t = t + "url=" + c + d + "&title=" + i + "&description=" + n + "&screenshot=" + r),
    "sina" != e && window.open(encodeURI(t), "", "height=500, width=600")
}

function fq_init() {
    G.sku && fq_showFq(G.sku)
}
function fq_showFq(t) {
    var e = document.createElement("script");
    e.type = "text/javascript",
    e.src = fq_serverSiteService + fq_serverUrl + "?roid=" + Math.random() + "&action=getFqInfo&id=" + t,
    document.getElementsByTagName("head")[0].appendChild(e)
}
function fq_showFq_html(t) {
    if (null != t) {
        if (0 == t.json.length) return;
        if (0 == t.json.length) return;
        if (null != t.json[0].error) return;
        fq_returnData = t
    }
}

function getCookie(t) {
    var e = document.cookie.match(RegExp("(^| )" + t + "=([^;]*)(;|$)"));
    return null != e ? unescape(e[2]) : null
}
function getSuitInfoService(t) {
    null !== t.packResponseList && t.packResponseList.length > 0 && ($("#favorable-suit").show(), $("#favorable-suit .mc").html(suit_TPL.tabs.process(t) + suit_TPL.cons.process(t)), $("#favorable-suit .mc").Jtab({
        event: "click",
        compatible: !0,
        currClass: "scurr"
    },
    function(t, e) {
        var i = e.attr("packprice"),
        s = e.attr("packlistprice"),
        a = e.attr("discount"),
        o = e.find(".fitting-price"),
        n = e.find(".orign-price"),
        r = e.find(".fitting-saving");
        "" !== i && "" !== s && (o.html(parseFloat(i).toFixed(2)), n.html(parseFloat(s).toFixed(2)), r.html(parseFloat(a).toFixed(2)))
    }), G.removeLastAdd())
}


function setImButton(t) {
    var e = t || pageConfig.product.skuid;
    $.ajax({
        url: "http://chat1.360buy.com/api/checkChat?",
        data: {
            pid: e,
            returnCharset: "gb2312"
        },
        dataType: "jsonp",
        success: function(t) {
            if (t) {
                var i = t.seller,
                s = t.code;
                if (i && "" != i && (i = i.replace("&qt;", "'").replace("&dt;", '"')), 1 > $("#brand-bar-pop").length && ($("#j-im").length > 0 && $("#j-im").remove(), $("#summary-grade .dd #j-im").length > 0 && $("#summary-grade .dd #j-im").remove(), (1 == s || 2 == s || 3 == s || 9 == s) && $("#summary-grade .dd").append('<a id="j-im" class="djd-im" href="#none" style="color:#333;margin:-3px 0 0 5px;" clstag="shangpin|keycount|product|imbtn"><b>\u8054\u7cfb\u5ba2\u670d</b></a>')), 1 == s) $("#online-service").show(),
                $("#j-im").attr("title", i + " \u5728\u7ebf\u5ba2\u670d"),
                $("#j-im").click(function() {
                    // onlineService(1, i, t.chatDomain)
                });
                else if (2 == s) {
                    $("#online-service").show();
                    var a = e.length >= 10 ? " \u5ba2\u670d\u76ee\u524d\u4e0d\u5728\u7ebf\uff01\u8d2d\u4e70\u4e4b\u524d\uff0c\u5982\u6709\u95ee\u9898\uff0c\u8bf7\u5728\u6b64\u9875\u201c\u5168\u90e8\u8d2d\u4e70\u54a8\u8be2\u201d\u4e2d\u5411\u4eac\u4e1c\u5ba2\u670d\u53d1\u8d77\u54a8\u8be2": " \u5382\u5546\u552e\u524d\u54a8\u8be2\u76ee\u524d\u4e0d\u5728\u7ebf\uff01\u8d2d\u4e70\u4e4b\u524d\uff0c\u5982\u6709\u95ee\u9898\uff0c\u8bf7\u5728\u6b64\u9875\u201c\u5168\u90e8\u8d2d\u4e70\u54a8\u8be2\u201d\u4e2d\u5411\u4eac\u4e1c\u5ba2\u670d\u53d1\u8d77\u54a8\u8be2";
                    $("#j-im").addClass("d-offline").attr("title", i + a).unbind("click")
                } else(3 == s || 9 == s) && ($("#online-service").show().find("b").html("\u7ed9\u5ba2\u670d\u7559\u8a00"), $("#j-im").addClass("d-offline").html("<b>\u7ed9\u5ba2\u670d\u7559\u8a00</b>").attr("title", i + " \u5728\u7ebf\u5ba2\u670d\u76ee\u524d\u4e0d\u5728\u7ebf\uff0c\u60a8\u53ef\u4ee5\u70b9\u51fb\u6b64\u5904\u7ed9\u5546\u5bb6\u7559\u8a00\uff0c\u5e76\u5728\u3010\u6211\u7684\u4eac\u4e1c->\u6d88\u606f\u7cbe\u7075\u3011\u4e2d\u67e5\u770b\u56de\u590d").click(function() {
                    // onlineService(3, i, t.chatDomain)
                }))
            }
        }
    })
}
if (G === void 0) var G = window.G = {};
pageConfig.product.useTag = !0,
pageConfig.product.renew = !1,
function(t) {
    "object" == typeof pageConfig.product && (t.sku = pageConfig.product.skuid, t.key = pageConfig.product.skuidkey, t.url = pageConfig.product.href, t.src = pageConfig.product.src, t.name = pageConfig.product.name, t.cat = pageConfig.product.cat, t.orginSku = pageConfig.product.orginSkuid || t.sku, t.isJd = 1e9 > t.sku, t.isPop = t.sku > 1e9, t.isArray = function(t) {
        return "[object Array]" === Object.prototype.toString.call(t)
    },
    t.isObject = function(t) {
        return "[object Object]" === Object.prototype.toString.call(t)
    },
    t.isEmptyObject = function(t) {
        var e;
        for (e in t) return ! 1;
        return ! 0
    },
    t.isNothing = function(e) {
        return t.isArray(e) ? 1 > e.length: !e
    }),
    t.serializeUrl = function(t) {
        var e, i, s, a, o = t.indexOf("?"),
        n = t.substr(0, o),
        r = t.substr(o + 1),
        c = r.split("&"),
        d = c.length,
        l = {};
        for (e = 0; d > e; e++) i = c[e].split("="),
        s = i[0],
        a = i[1],
        l[s] = a;
        return {
            url: n,
            param: l
        }
    },
    t.setScroll = function(t) {
        var e = "string" == typeof t ? $(t) : $("body");
        e.find(".p-scroll").each(function() {
            var t = $(this).find(".p-scroll-wrap"),
            e = $(this).find(".p-scroll-next"),
            i = $(this).find(".p-scroll-prev");
            t.find("li").length > 4 && t.imgScroll({
                showControl: !0,
                width: 30,
                height: 30,
                visible: 4,
                step: 1,
                prev: i,
                next: e
            })
        })
    },
    t.thumbnailSwitch = function(t, e, i, s, a) {
        var o = t.find("img"),
        n = a || "mouseover";
        o.bind(n,
        function() {
            var s = $(this),
            a = s.attr("src"),
            o = a.replace(/\/n\d\//, i);
            e.attr("src", o),
            t.removeClass("curr")
        })
    },
    t.getRealPrice = function(t, e) {
        var i = pageConfig.product.realPrice,
        t = t || pageConfig.product.skuid;
        return i !== void 0 ? e(i) : (window.getNumPriceService = function(t) {
            var i = t.jdPrice ? t.jdPrice.amount: !1;
            "function" == typeof e && e(i),
            t.jdPrice && pageConfig.product && (pageConfig.product.realPrice = t.jdPrice.amount);
            try {
                delete window.getNumPriceService
            } catch(s) {}
        },
        $.ajax({
            url: "http://jprice.360buyimg.com/price/np" + t + "-TRANSACTION-J.html",
            dataType: "script",
            cache: !0
        }), void 0)
    },
    t.getCommentNum = function(t, e) {
        var i = pageConfig.product.commentCount;
        return i !== void 0 ? e(i) : (window.getCommentCount = function(t) {
            "function" == typeof e && e(t),
            t && pageConfig.product && (pageConfig.product.commentCount = t);
            try {
                delete window.getCommentCount
            } catch(i) {}
        },
        $.ajax({
            url: "http://club.jd.com/ProductPageService.aspx?method=GetCommentSummaryBySkuId&referenceId=" + t + "&callback=getCommentCount",
            dataType: "script",
            cache: !0
        }), void 0)
    },
    t.getUserLevel = function(t) {
        switch (t) {
        case 50:
            return "\u6ce8\u518c\u7528\u6237";
        case 56:
            return "\u94c1\u724c\u7528\u6237";
        case 59:
            return "\u6ce8\u518c\u7528\u6237";
        case 60:
            return "\u94dc\u724c\u7528\u6237";
        case 61:
            return "\u94f6\u724c\u7528\u6237";
        case 62:
            return "\u91d1\u724c\u7528\u6237";
        case 63:
            return "\u94bb\u77f3\u7528\u6237";
        case 64:
            return "\u7ecf\u9500\u5546";
        case 65:
            return "VIP";
        case 66:
            return "\u4eac\u4e1c\u5458\u5de5";
        case - 1 : return "\u672a\u6ce8\u518c";
        case 88:
            return "\u53cc\u94bb\u7528\u6237";
        case 90:
            return "\u4f01\u4e1a\u7528\u6237";
        case 103:
            return "\u4e09\u94bb\u7528\u6237";
        case 104:
            return "\u56db\u94bb\u7528\u6237";
        case 105:
            return "\u4e94\u94bb\u7528\u6237"
        }
        return "\u672a\u77e5"
    },
    t.calculatePrice = function(t, e) {
        for (var i = $(t).parents(e), s = i.find(".master input").attr("wmeprice"), a = i.find("input:checked"), o = a.length, n = i.find(".infos .res-totalprice"), r = i.find(".infos .res-jdprice"), c = 0, d = 0, l = "http://jd2008.jd.com/purchase/OrderFlowService.aspx?action=AddSkus&wids=", p = i.find(".btn-buy"), m = [], u = 0; a.length > u; u++) c += parseFloat(a.eq(u).attr("wmaprice")),
        d += parseFloat(a.eq(u).attr("wmeprice")),
        m.push(a.eq(u).attr("skuid"));
        "" != s && 0 != parseInt(s) && (n.text("\uffe5 " + c.toFixed(2)), r.text("\uffe5 " + d.toFixed(2)), p.attr("href", l + m.join(",")), i.find(".infos .p-name span").html("" + (o - 1)))
    },
    t.sortFitting = function(t, e, i) {
        var s = $(i),
        a = e,
        o = s.find(".suits"),
        n = s.find(".stab li"),
        r = s.find(".suits .lh"),
        c = o.find('li[data-cat="' + a + '"]');
        if ("all" == e) {
            var d = parseInt(o.attr("data-count"));
            o.find("li").show(),
            r.css("width", 166 * d),
            d > 4 && o.css("overflow-x", "scroll")
        } else o.find("li").hide(),
        c.show();
        if (n.removeClass("scurr"), $(t).addClass("scurr"), 1 == !!$(t).attr("data-count")) {
            var l = parseInt($(t).attr("data-count"));
            o.css("overflow-x", 4 >= l ? "hidden": "scroll"),
            r.css("width", 166 * l)
        }
        o.scrollLeft(0),
        G.removeLastAdd()
    },
    t.removeLastAdd = function(t) {
        var t = t || $(".suits");
        t.find("li").removeClass("last-item"),
        t.find("li:visible:last").addClass("last-item")
    },
    t.checkLogin = function(t) {
        "function" == typeof t && $.getJSON("http://passport.jd.com/loginservice.aspx?method=Login&callback=?",
        function(e) {
            e.Identity && t(e.Identity)
        })
    },
    t.insertStyles = function(t) {
        var e = document,
        i = e.getElementsByTagName("head"),
        s = e.createElement("style"),
        a = e.createElement("link");
        if (/\.css$/.test(t)) a.rel = "stylesheet",
        a.type = "text/css",
        a.href = t,
        i.length ? i[0].appendChild(a) : e.documentElement.appendChild(a);
        else {
            if (s.setAttribute("type", "text/css"), s.styleSheet) s.styleSheet.cssText = t;
            else {
                var o = e.createTextNode(t);
                s.appendChild(o)
            }
            i.length && i[0].appendChild(s)
        }
    }
} (G),
function(t) {
    t.fn.floatNav = function(e) {
        var i = t.extend({
            start: null,
            end: null,
            fixedClass: "nav-fixed",
            anchor: null,
            targetEle: null,
            range: 0,
            onStart: function() {},
            onEnd: function() {}
        },
        e),
        s = t(this),
        a = s.height(),
        o = s.width(),
        n = t('<div class="float-nav-wrap"/>');
        return s.css({
            height: a,
            width: o
        }),
        t(window).bind("scroll",
        function() {
            var e = t(document).scrollTop(),
            a = s.find("a").eq(0).attr("href"),
            o = i.start,
            n = i.targetEle;
            e > o && (i.end || n) - i.range > e ? (s.addClass(i.fixedClass), i.anchor && a !== i.anchor && s.find("a").attr("href", i.anchor), i.onStart && i.onStart()) : (s.removeClass(i.fixedClass), i.anchor && s.find("a").attr("href", "javascript:;"), i.onEnd && i.onEnd())
        }),
        this
    }
} (jQuery),
function(t) {
    var e = function(e, i, s) {
        this.opts = t.extend({
            content: e.title || "",
            width: null,
            oTop: 5,
            oLeft: 5,
            zIndex: 1,
            event: null,
            position: "top",
            close: !1
        },
        i),
        this.$obj = t(e),
        this.callback = s ||
        function() {},
        this.init()
    };
    e.prototype = {
        init: function() {
            this.insertStyles('.Jtips { position: relative; float:left; } .Jtips-close { position:absolute; color:#ff6600; font:12px "simsun"; cursor:pointer; } .Jtips-top .Jtips-close { right:1px; top:0px; } .Jtips-bottom .Jtips-close { right:1px; top:5px; } .Jtips-left .Jtips-close { right:6px; top:1px; } .Jtips-right .Jtips-close { right:1px; top:1px; } .Jtips-arr { position: absolute; background-image:url(http://misc.360buyimg.com/product/skin/2012/i/arrow.gif); background-repeat:no-repeat; overflow:hidden; } .Jtips-top { padding-bottom: 5px; } .Jtips-top .Jtips-arr { left:10px; bottom:0; width:11px; height:6px; background-position:0 -5px; _bottom:-1px; } .Jtips-bottom { padding-top: 5px; } .Jtips-bottom .Jtips-arr { top:0; left:10px; width:11px; height:6px; background-position:0 0; } .Jtips-left { padding-right: 5px;  } .Jtips-left .Jtips-arr { right:0; top:10px; width:6px; height:11px; background-position:-5px 0;} .Jtips-right {padding-left: 5px; } .Jtips-right .Jtips-arr {top:10px; left:0; width:6px; height:11px; background-position:0 0;  } .Jtips-con { float:left; padding:10px; background:#fffdee; border:1px solid #edd28b; color:#ff6501; -moz-box-shadow: 0 0 2px 2px #eee; -webkit-box-shadow: 0 0 2px 2px #eee; box-shadow: 0 0 2px 2px #eee; } .Jtips-con a,.Jtips-con a:hover,.Jtips-con a:visited { color:#005fab; text-decoration:none; } .Jtips-con a:hover { text-decoration: underline; }'),
            null === this.opts.event ? this.show() : this.bindEvent()
        },
        insertStyles: function(t) {
            var e = document,
            i = e.getElementsByTagName("head"),
            s = e.createElement("style"),
            a = e.createElement("link");
            if (/\.css$/.test(t)) a.rel = "stylesheet",
            a.type = "text/css",
            a.href = t,
            i.length ? i[0].appendChild(a) : e.documentElement.appendChild(a);
            else {
                if (s.setAttribute("type", "text/css"), s.styleSheet) s.styleSheet.cssText = t;
                else {
                    var o = e.createTextNode(t);
                    s.appendChild(o)
                }
                i.length && i[0].appendChild(s)
            }
        },
        bindEvent: function() {
            var t = this;
            this.$obj.unbind(this.opts.event).bind(this.opts.event,
            function() {
                t.show()
            })
        },
        bindClose: function(t) {
            var e = this;
            t.find(".Jtips-close").bind("click",
            function() {
                e.remove()
            })
        },
        getPosition: function() {
            var t = this.$obj;
            return {
                w: t.outerWidth(),
                h: t.outerHeight(),
                oTop: t.offset().top,
                oLeft: t.offset().left
            }
        },
        setPosition: function(e, i) {
            var s = this.getPosition();
            t("body").eq(0).width(),
            t("body").eq(0).height(),
            e.css({
                position: "absolute",
                "z-index": this.opts.zIndex
            }),
            "left" === i && e.css({
                top: s.oTop - 10 + this.opts.oTop,
                left: s.oLeft - this.tips.outerWidth() - this.opts.oLeft
            }),
            "right" === i && e.css({
                left: s.oLeft + s.w + this.opts.oLeft,
                top: s.oTop - 10 + this.opts.oTop
            }),
            "top" === i && e.css({
                left: s.oLeft - 10 + this.opts.oLeft,
                top: s.oTop - this.tips.outerHeight() - this.opts.oTop
            }),
            "bottom" === i && e.css({
                left: s.oLeft - 10 + this.opts.oLeft,
                top: s.oTop + s.h + this.opts.oTop
            })
        },
        show: function() {
            var e = this.opts.close ? '<div class="Jtips-close">&times;</div>': "",
            i = t('<div class="Jtips Jtips-' + this.opts.position + '"><div class="Jtips-arr"></div>' + e + '<div class="Jtips-con">' + this.opts.content + "</div></div>"),
            s = this;
            this.tips = i,
            t("body").eq(0).append(i),
            this.tips.css("width", this.opts.width || i.width()).find(".Jtips-con").css("width", (this.opts.width || i.width()) - 20),
            this.setPosition(i, this.opts.position),
            this.bindClose(i),
            t(window).resize(function() {
                s.setPosition(i, s.opts.position)
            }),
            "function" == typeof this.callback && this.callback.apply(this.$obj, [i])
        },
        hide: function() {
            this.tips.hide()
        },
        remove: function() {
            this.tips.remove()
        }
    },
    t.fn.Jtips = function(i, s) {
        return this.each(function() {
            var a = new e(this, i, s);
            t(this).data("Jtips", a)
        })
    }
} (jQuery),
function(t) {
    t.fn.jqueryzoom = function(e) {
        var i = {
            xzoom: 200,
            yzoom: 200,
            offset: 10,
            position: "right",
            lens: 1,
            preload: 1
        };
        e && t.extend(i, e);
        var s = "";
        t(this).hover(function() {
            function e(t) {
                this.x = t.pageX,
                this.y = t.pageY
            }
            var a = t(this).offset().left,
            o = t(this).offset().top,
            n = t(this).find("img").get(0).offsetWidth,
            r = t(this).find("img").get(0).offsetHeight;
            s = t(this).find("img").attr("alt");
            var c = t(this).find("img").attr("jqimg");
            t(this).find("img").attr("alt", ""),
            0 == t("div.zoomdiv").get().length && (t(this).after("<div class='zoomdiv'><img class='bigimg' src='" + c + "'/></div>"), t(this).append("<div class='jqZoomPup'>&nbsp;</div>")),
            t("div.zoomdiv").width(i.xzoom),
            t("div.zoomdiv").height(i.yzoom),
            t("div.zoomdiv").show(),
            i.lens || t(this).css("cursor", "crosshair"),
            t(document.body).mousemove(function(s) {
                mouse = new e(s);
                var c = t(".bigimg").get(0).offsetWidth,
                d = t(".bigimg").get(0).offsetHeight,
                l = "x",
                p = "y";
                if (isNaN(p) | isNaN(l)) {
                    var p = c / n,
                    l = d / r;
                    t("div.jqZoomPup").width(i.xzoom / (1 * p)),
                    t("div.jqZoomPup").height(i.yzoom / (1 * l)),
                    i.lens && t("div.jqZoomPup").css("visibility", "visible")
                }
                xpos = mouse.x - t("div.jqZoomPup").width() / 2 - a,
                ypos = mouse.y - t("div.jqZoomPup").height() / 2 - o,
                i.lens && (xpos = a > mouse.x - t("div.jqZoomPup").width() / 2 ? 0 : mouse.x + t("div.jqZoomPup").width() / 2 > n + a ? n - t("div.jqZoomPup").width() - 2 : xpos, ypos = o > mouse.y - t("div.jqZoomPup").height() / 2 ? 0 : mouse.y + t("div.jqZoomPup").height() / 2 > r + o ? r - t("div.jqZoomPup").height() - 2 : ypos),
                i.lens && t("div.jqZoomPup").css({
                    top: ypos,
                    left: xpos
                }),
                scrolly = ypos,
                t("div.zoomdiv").get(0).scrollTop = scrolly * l,
                scrollx = xpos,
                t("div.zoomdiv").get(0).scrollLeft = scrollx * p
            })
        },
        function() {
            t(this).children("img").attr("alt", s),
            t(document.body).unbind("mousemove"),
            i.lens && t("div.jqZoomPup").remove(),
            t("div.zoomdiv").remove()
        }),
        count = 0,
        i.preload && (t("body").append("<div style='display:none;' class='jqPreload" + count + "'>360buy</div>"), t(this).each(function() {
            var e = t(this).children("img").attr("jqimg"),
            i = jQuery("div.jqPreload" + count).html();
            jQuery("div.jqPreload" + count).html(i + '<img src="' + e + '">')
        }))
    }
} (jQuery);
var mdPerfix = 1 == pageConfig.product.type ? "CR": "GR",
mbPerfix = 1 == pageConfig.product.type ? "3C": "GM",
skuid = pageConfig.product.skuid,
suit_TPL = {
    tabs: '<ul class="stab lh">{for item in packResponseList}<li class="fore${parseInt(item_index)+1}{if item_index==0} scurr{/if}" data-widget="tab-item" data-cat="${item.packId}" data-suit="${item.packName}">\u4f18\u60e0\u5957\u88c5${parseInt(item_index)+1}</li>{/for}</ul>',
    cons: '{for item in packResponseList}<div data-widget="tab-content" packPrice="${item.packPrice.amount}" packListPrice="${item.packListPrice.amount}" discount="${item.discount.amount}" data-cat="${item.packId}" class="stabcon{if parseInt(item_index) !== 0} none{/if}"><div class="master">    <s></s>    <div class="p-img">        <a href="http://item.jd.com/' + G.sku + '.html" target="_blank"><img src="${pageConfig.FN_GetImageDomain(' + G.sku + ")}n4/" + pageConfig.product.src + '" height="100" width="100"></a>' + "    </div>" + '    <div class="p-name">' + '        <a href="http://item.jd.com/' + G.sku + '.html" target="_blank">' + unescape(G.name) + "</a>" + "    </div>" + "</div>" + '<div class="suits">' + '    <ul class="lh" style="width:${(item.productList.length-1)*165}px">' + "{for itemList in item.productList}" + "{if itemList.skuId == G.sku}" + "{else}" + "        <li>" + "            <s></s>" + '            <div class="p-img">' + '                <a href="http://item.jd.com/${itemList.skuId}.html" target="_blank"><img src="${pageConfig.FN_GetImageDomain(itemList.skuId)}n4/${itemList.skuPicUrl}" alt="" height="100" width="100"></a>' + "            </div>" + '            <div class="p-name">' + '                <a href="http://item.jd.com/${itemList.skuId}.html" target="_blank">${itemList.skuName}</a>' + "            </div>" + "        </li>" + "{/if}" + "{/for}" + "    </ul>" + "</div>" + '<div class="infos">' + "    <s></s>" + '    <div class="p-name">' + '        <a href="http://www.jd.com/suite/${item.packId}-${skuId}.html">${item.packName}</a>' + "    </div>" + '    <div class="p-price">\u5957&nbsp;&nbsp;\u88c5&nbsp;&nbsp;\u4ef7\uff1a' + '        <strong class="fitting-price">${parseFloat(item.packPrice.amount).toFixed(2)}</strong>' + "    </div>" + '    <div class="p-price">\u539f\u3000\u3000\u4ef7\uff1a' + '        <del class="orign-price">${parseFloat(item.packListPrice.amount).toFixed(2)}</del>' + "    </div>" + '    <div class="p-saving">\u7acb\u5373\u8282\u7701\uff1a' + '        <span class="fitting-saving">${parseFloat(item.discount.amount).toFixed(2)}</span>' + "    </div>" + '    <div class="btns">' + '        <a class="btn-buy" href="http://jd2008.jd.com/purchase/initcart.aspx?pId=${item.packId}&pCount=1&pType=2" clstag="shangpin|keycount|product|{if G.isPop}popbuysuit{else}zybuysuit{/if}">\u8d2d\u4e70\u5957\u88c5</a>' + "    </div>" + "</div>" + "</div>" + "{/for}"
},
recoFittings_TPL = {
    tabs: '<li class="fore scurr" onclick="G.sortFitting(this, \'all\', \'#tab-reco\')">\u5168\u90e8\u914d\u4ef6</li>{for item in fittingType}<li class="fore${parseInt(item_index)+1}" data-count="${item.number}" data-cat="${item.sort}" onclick="G.sortFitting(this, ${item.sort}, \'#tab-reco\')">${item.name}(${item.number})</li>{/for}',
    cons: '<div class="master">    <s></s>    <div class="p-img">        <a href="http://item.jd.com/${master.skuid}.html" target="_blank"><img src="${pageConfig.FN_GetImageDomain(master.skuid)}n4/${master.pic}" height="100" width="100"></a>    </div>    <div class="p-name">        <a href="http://item.jd.com/${master.skuid}.html" target="_blank">${master.name}</a>    </div>    <div class="p-price"><input type="checkbox" onclick="return false;" onchange="return false" wmeprice="{if master.price==""}0.00{else}${master.price}{/if}" wmaprice="${master.discount}" skuid="${master.skuid}" checked/> ${master.price}</div></div><div class="suits" data-count="${fittings.length}" style="overflow-x:{if parseInt(fittings.length)>(pageConfig.wideVersion&&pageConfig.compatible ? 4:3)}scroll{else}hidden{/if}">    <ul class="lh" style="width:${parseInt(fittings.length)*165}px">        {for item in fittings}        <li data-cat="${item.sort}">            <s></s>            <div class="p-img">                <a href="http://item.jd.com/${item.skuid}.html" target="_blank"><img src="${pageConfig.FN_GetImageDomain(item.skuid)}n4/${item.pic}" alt="" height="100" skuidth="100"></a>            </div>            <div class="p-name">                <a href="http://item.jd.com/${item.skuid}.html" target="_blank">${item.name}</a>            </div>            <div class="choose">                <input type="checkbox" id="inp_${item.skuid}" onclick="G.calculatePrice(this, \'#tab-reco\')" wmaprice="${item.discount}" wmeprice="${item.price}" skuid="${item.skuid}" />                <label for="inp_${item.skuid}" class="p-price">                    <strong><img src="http://jprice.360buyimg.com/price/gp${item.skuid}-1-1-1.png" onerror="this.src=\'http://misc.360buyimg.com/lib/skin/e/i/error-3.gif\'" /></strong>                </label>            </div>        </li>        {/for}    </ul></div><div class="infos">    <s></s>    <div class="p-name">        <em>\u5df2\u9009\u62e9<span>0</span>\u4e2a\u914d\u4ef6</em>    </div>    <div class="p-price">\u642d&nbsp;&nbsp;\u914d&nbsp;&nbsp;\u4ef7\uff1a        <strong class="res-jdprice">{if master.price==""}\u6682\u65e0\u62a5\u4ef7{else}\uffe5 ${master.price}{/if}</strong>    </div>    <div class="p-saving">\u83b7\u5f97\u4f18\u60e0\uff1a        <span class="res-totalprice">\uffe5 ${master.discount}</span>    </div>    <div class="btns">        <a class="btn-buy" href="http://jd2008.jd.com/purchase/OrderFlowService.aspx?action=AddSkus&wids=${master.skuid}">\u7acb\u5373\u8d2d\u4e70</a>    </div></div>'
},
suitRecommend_TPL = '<div class="stabcon"><div class="master">    <s></s>    <div class="p-img">        <a href="http://item.jd.com/${master.wid}.html" target="_blank"><img src="${pageConfig.FN_GetImageDomain(master.wid)}n4/${master.imgurl}" height="100" width="100"></a>    </div>    <div class="p-name">        <a href="http://item.jd.com/${master.wid}.html" target="_blank">${master.name}</a>    </div>    <div class="p-price none"><input type="checkbox" id="inp_${master.wid}" onclick="return false;" onchange="return false" wmaprice="${master.wmaprice}" wmeprice="${master.wmeprice}" skuid="${master.wid}" checked/> ${master.wmeprice}</div></div><div class="suits" style="overflow-x:{if parseInt(recoList.length)>(pageConfig.wideVersion&&pageConfig.compatible ? 4:3)}scroll{else}hidden{/if}">    <ul class="lh" style="width:${parseInt(recoList.length)*165}px">        {for item in recoList}        <li onclick="reClick(\'' + mdPerfix + "3', '${master.wid}', '${item.wid}#${item.wmeprice}', '${item_index}');\">" + "            <s></s>" + '            <div class="p-img">' + '                <a href="http://item.jd.com/${item.wid}.html" target="_blank"><img src="${pageConfig.FN_GetImageDomain(item.wid)}n4/${item.imgurl}" alt="" height="100" width="100"></a>' + "            </div>" + '            <div class="p-name">' + '                <a href="http://item.jd.com/${item.wid}.html" target="_blank">${item.name}</a>' + "            </div>" + '            <div class="choose">' + '                <input type="checkbox" id="inp_${item.wid}" onclick="G.calculatePrice(this, \'#tab-hot\')" wmaprice="${item.wmaprice}" wmeprice="${item.wmeprice}" skuid="${item.wid}" />' + '                <label for="inp_${item.wid}" class="p-price">' + '                    <strong><img src="http://jprice.360buyimg.com/price/gp${item.wid}-1-1-1.png" onerror="this.src=\'http://misc.360buyimg.com/lib/skin/e/i/error-3.gif\'" /></strong>' + "                </label>" + "            </div>" + "        </li>" + "        {/for}" + "    </ul>" + "</div>" + '<div class="infos" onclick="{for item in recoList}reClick(\'' + mdPerfix + "3', '${master.wid}', '${item.wid}#${item.wmeprice}', '${item_index}');{/for}\">" + "    <s></s>" + '    <div class="p-name">' + "        <a onclick=\"log('" + mbPerfix + "PopularBuy','click')\" href=\"http://jd2008.jd.com/purchase/OrderFlowService.aspx?action=AddSkus&wids=${master.wid}\">\u8d2d\u4e70\u4eba\u6c14\u7ec4\u5408</a>" + "    </div>" + '    <div class="p-price">\u603b\u4eac\u4e1c\u4ef7\uff1a' + '        <strong class="res-jdprice">\uffe5 ${master.wmeprice}</strong>' + "    </div>" + '    <div class="p-saving">\u603b\u53c2\u8003\u4ef7\uff1a' + '        <del class="res-totalprice">\uffe5 ${master.wmaprice}</del>' + "    </div>" + '    <div class="btns">' + "        <a onclick=\"log('" + mbPerfix + 'PopularBuy\',\'click\')" class="btn-buy" href="http://jd2008.jd.com/purchase/OrderFlowService.aspx?action=AddSkus&wids=${master.wid}">\u8d2d\u4e70\u7ec4\u5408</a>' + "    </div>" + '</div><div class="clb"></div>' + "</div>",
listBuyBuy_TPL = '<div class="p-img">        <a target="_blank" title="${Wname}" href="${WidStr}"><img height="100" width="100" alt="" src="${ImageUrl}"></a>    </div>    <div class="p-name">        <a target="_blank" title="${Wname}" href="${WidStr}">${Wname}</a>    </div>    <div class="p-price">        <strong>            <img src="http://jprice.360buyimg.com/price/gp${Wid}-1-1-1.png" onerror="this.src=\'http://misc.360buyimg.com/lib/skin/e/i/error-3.gif\'" />        </strong>    </div>',
listBrosweBroswe_TPL = '<li onclick="reClick(1,\'\',\'${wid}\',${arguments[2]});" class="fore${parseInt(arguments[2])+1}">    <div class="p-img">        <a target="_blank" title="${name}" href="http://item.jd.com/${wid}.html"><img height="100" width="100" alt="${name}" src="${pageConfig.FN_GetImageDomain(wid)}n4/${imgurl}"></a>    </div>    <div class="p-name">        <a target="_blank" title="${name}" href="http://item.jd.com/${wid}.html">${name}</a>    </div>    <div class="p-price">        <strong>            <img src="http://jprice.360buyimg.com/price/gp${wid}-1-1-1.png" onerror="this.src=\'http://misc.360buyimg.com/lib/skin/e/i/error-3.gif\'" />        </strong>    </div></li>',
listBrosweBuy_TPL = '<div class="p-img">        <a target="_blank" title="${Wname}" href="http://item.jd.com/${Wid}.html"><img height="100" width="100" alt="${Wname}" src="${ImageUrl}"></a>    </div>    <div class="p-name">    {if Count>0}        <strong>${Count}%\u4f1a\u4e70\uff1a</strong>    {/if}        <a target="_blank" title="${Wname}" href="http://item.jd.com/${Wid}.html">${Wname}</a>    </div>    <div class="p-price">        <strong>            <img src="http://jprice.360buyimg.com/price/gp${Wid}-1-1-1.png" onerror="this.src=\'http://misc.360buyimg.com/lib/skin/e/i/error-3.gif\'" />        </strong>    </div>',
newCommentRate_TPL = '<div id="i-comment">    <div class="rate">        <strong>${productCommentSummary.goodRateShow}<span>%</span></strong>        <br> <span>\u597d\u8bc4\u5ea6</span>     </div>     <div class="percent">        <dl>             <dt>\u597d\u8bc4<span>(${productCommentSummary.goodRateShow}%)</span></dt>             <dd> <div style="width: ${productCommentSummary.goodRateShow}px;"></div></dd>         </dl>         <dl>             <dt>\u4e2d\u8bc4<span>(${productCommentSummary.generalRateShow}%)</span></dt>             <dd class="d1"><div style="width: ${productCommentSummary.generalRateShow}%;"> </div></dd>         </dl>         <dl>             <dt>\u5dee\u8bc4<span>(${productCommentSummary.poorRateShow}%)</span></dt>            <dd class="d1">             <div style="width: ${productCommentSummary.poorRateShow}%;"> </div></dd>         </dl>     </div>     {if typeof hotCommentTagStatistics!="undefined" && hotCommentTagStatistics.length>0}    <div class="actor-new">        <dl>            <dt>\u4e70\u5bb6\u5370\u8c61\uff1a</dt>            <dd class="p-bfc">                {for tag in hotCommentTagStatistics}<q class="comm-tags"><span>${tag.name}</span><em></em></q>{/for}            </dd>        </dl>        <div class="clr"></div> <b></b>    </div>    {elseif typeof topFiveCommentVos!="undefined"}    <div class="actor">         <em>\u53d1\u8868\u8bc4\u4ef7\u5373\u53ef\u83b7\u5f97\u79ef\u5206\uff0c\u524d\u4e94\u4f4d\u8bc4\u4ef7\u7528\u6237\u53ef\u83b7\u5f97\u53cc\u500d\u79ef\u5206\uff1a</em><a href="http://help.jd.com/help/question-58.html" target="_blank">\u8be6\u89c1\u79ef\u5206\u89c4\u5219</a>        <ul>            {for User in topFiveCommentVos}             <li><span>+{if User.integral==null}0{else}${User.integral}{/if}</span><div class="u-name">${parseInt(User_index)+1}. <a href="http://club.jd.com/userreview/${User.uid}-1-1.html" target="_blank">${User.nickname}</a></div></li>            {/for}         </ul>        <div class="clr"></div>         <b></b>    </div>    {/if}    <div class="btns">         <div>\u60a8\u53ef\u5bf9\u5df2\u8d2d\u5546\u54c1\u8fdb\u884c\u8bc4\u4ef7</div>         <a href="http://club.jd.com/mycomments.aspx?pid=${productCommentSummary.productId}" class="btn-comment" target="_blank">\u53d1\u8bc4\u4ef7\u62ff\u79ef\u5206</a>        <div><em class="hl_red">\u524d\u4e94\u540d\u53ef\u83b7\u53cc\u500d\u79ef\u5206</em><a href="http://help.jd.com/help/question-58.html" target="_blank">[\u89c4\u5219]</a></div>    </div></div>',
newCommentList_TPL = '{for list in comments}<div class="item">  <div class="user">      <div class="u-icon"> <a title="\u67e5\u770bTA\u7684\u5168\u90e8\u8bc4\u4ef7" href="http://club.jd.com/userreview/${list.uid}-1-1.html" target="_blank"> <img height="50" width="50" upin="achen0212" src="http://misc.360buyimg.com/lib/img/u/${list.userLevelId}.gif" alt="${list.nickname}"/> </a>      </div>      <div class="u-name"> <a href="http://club.jd.com/userreview/${list.uid}-1-1.html" target="_blank">{if !G.isNothing(list.nickname)}${list.nickname}{else}${list.pin}{/if}</a>      </div> <span class="u-level"><span style="color:{if !G.isNothing(list.userLevelColor)}${list.userLevelColor}{/if}"> ${list.userLevelName}</span> {if !G.isNothing(list.userProvince)}<span class="u-address">${list.userProvince}</span>{/if}</span>  </div>  <div class="i-item" data-guid="${list.guid}">      <div class="o-topic">           {if list.top}<strong class="topic topic-best">\u7cbe\u534e</strong>{/if}          <strong class="topic"><a href="http://club.jd.com/repay/${list.referenceId}_${list.guid}_1.html" target="_blank">${list.title}</a></strong>          <span class="star sa${list.score}"></span><span><a class="date-comment" title="\u67e5\u770b\u8bc4\u4ef7\u8be6\u60c5" href="http://club.jd.com/repay/${list.referenceId}_${list.guid}_1.html" target="_blank">${list.creationTime.replace(/:[0-9][0-9]$/, "")}</a><em class="fr">${list.userClientShow}</em></span>      </div>      <div class="comment-content">          {if !G.isNothing(list.commentTags)}          <dl>              <dt>\u6807&#12288;&#12288;\u7b7e\uff1a</dt>              <dd>                  {for tag in list.commentTags}                  <q data-tid="${tag.id}" class="comm-tags" href="#none"><span>${tag.name}</span><em></em></q>                  {/for}              </dd>          </dl>          {/if}          {if !G.isNothing(list.pros)}          <dl>              <dt>\u4f18\u70b9\uff1a</dt>               <dd> ${list.pros}</dd>          </dl>          {/if}           {if !G.isNothing(list.cons)}          <dl>              <dt>\u4e0d\u8db3\uff1a</dt>               <dd> ${list.cons}</dd>          </dl>          {/if}           {if !G.isNothing(list.content)}           <dl>              <dt>\u5fc3\u5f97\uff1a</dt>               <dd> ${list.content}</dd>          </dl>          {/if}            {if list.mergeOrderStatus>0&&!G.isNothing(list.images)}            <dl> <dt>\u7528\u6237\u6652\u5355\uff1a</dt>            <dd>                <div class="comment-show-pic">                                  <table cellspacing="10"><tr>                  {for image in list.images}                      {if parseInt(image_index)<3}                      <td><a class="comment-show-pic-wrap" href="http://club.jd.com/bbsDetail/${list.showOrderComment.referenceId}_${list.showOrderComment.guid}_1.html" target="_blank" clstag="shangpin|keycount|product|shaipic"><img alt="" src="${image.imgUrl}" alt="${list.nickname} \u7684\u6652\u5355\u56fe\u7247" /></a></td>                      {/if}                  {/for}                  </tr></table>                                <span clstag="shangpin|keycount|product|shaitext"><em class="fl" style="color:#9C9A9C;margin-right:5px;">\u5171${list.images.length}\u5f20\u56fe\u7247</em><a href="http://club.jd.com/bbsDetail/${list.showOrderComment.referenceId}_${list.showOrderComment.guid}_1.html" target="_blank" class="p-simsun">\u67e5\u770b\u6652\u5355&gt;</a></span>                </div>            </dd>            {/if}          <div class="dl-extra">              {if !G.isNothing(list.productColor)}              <dl>                  <dt>\u989c\u8272\uff1a</dt>                  <dd>${list.productColor}</dd>              </dl>              {/if}              {if !G.isNothing(list.productSize)}              <dl>                  <dt>\u578b\u53f7\uff1a</dt>                  <dd>${list.productSize}</dd>              </dl>              {/if}              {for attr in productAttr}                  {if !G.isNothing(list[attr.key])}                  <dl>                      <dt>${attr.name}\uff1a</dt>                      <dd>${list[attr.key]}${attr.unit}</dd>                  </dl>                  {/if}              {/for}          </div><s class="clr"></s>          {if typeof list.referenceTime !=="undefined"}          <dl>              <dt>\u8d2d\u4e70\u65e5\u671f\uff1a</dt>              <dd>${list.referenceTime.split(" ")[0]}</dd>          </dl>          {/if}      </div>      <div class="btns">          <a class="btn-reply btn-toggle fr" data-id="${list.id}" href="#none">\u56de\u590d(<em>${list.replyCount}</em>)</a>          <div class="useful fr" id="${list.guid}">              <a name="agree" class="btn-agree" title="${list.usefulVoteCount}" href="#none">\u6709\u7528(${list.usefulVoteCount})</a>              <!--<a name="oppose" class="btn-oppose" title="${list.uselessVoteCount}" href="#none">\u6ca1\u7528(${list.uselessVoteCount})</a>-->          </div>      </div>      <div class="item-reply reply-lz" data-name="{if !G.isNothing(list.nickname)}${list.nickname}{else}${list.pin}{/if}" data-uid="{list.uid}">          <strong></strong>          <div class="reply-list">               <div id="btn-toggle-${_type}-${list.id}" class="replay-form none">                   <div class="arrow"> <em>\u25c6</em><span>\u25c6</span></div>                   <div class="reply-wrap">                       <p><em>\u56de\u590d</em>  <span class="u-name">${list.nickname}\uff1a</span></p>                       <div class="reply-input">                           <div class="fl"><input type="text"></div>                           <a href="#none" class="reply-btn btn-gray p-bfc reply-btn-lz" data-nick="${list.nickname}" data-guid="${list.guid}" data-replyId="${list.id}">\u56de\u590d</a>                           <div class="clr"></div>                       </div>                   </div>               </div>          </div>      </div>      {for reply in list.replies}      <div class="item-reply" data-index="${list.replyCount-parseInt(reply_index)}" data-name="${reply.nickname}" data-uid="${reply.uid}">          <strong>${list.replyCount-parseInt(reply_index)}</strong>          <div class="reply-list">              <div class="reply-con">                  <span class="u-name">                      <a target="_blank" href="http://club.jd.com/userreview/${reply.uid}-1-1.html">${reply.nickname}{if reply.userClient==99}<b></b>{/if}</a>                      {if parseInt(reply.parentId, 10)>0}                      <em>\u56de\u590d</em>                      {if !G.isNothing(reply.parent)}<a target="_blank" href="http://club.jd.com/userreview/${reply.parent.uid}-1-1.html">{if parseInt(reply.parentId, 10)<0}${list.nickname}{else}${reply.parent.nickname}{if reply.parent.userClient==99}<b></b>{/if}{/if}</a>{/if}{/if}\uff1a                  </span>                  <span class="u-con">${reply.content}</span>              </div>              <div class="reply-meta">                  <span class="reply-left fl">${reply.creationTimeString.replace(/:[0-9][0-9]$/, "")}</span>                  <a class="p-bfc btn-toggle hl_blue" data-id="${reply.id}" href="#none">\u56de\u590d</a>              </div>              <div id="btn-toggle-${_type}-${reply.id}" class="replay-form none">                  <div class="arrow">                      <em>\u25c6</em><span>\u25c6</span>                  </div>                  <div class="reply-wrap">                      <p><em>\u56de\u590d</em> <span class="u-name">${reply.nickname}\uff1a</span></p>                      <div class="reply-input">                          <div class="fl"><input type="text" /></div>                          <a href="#none" class="reply-btn btn-gray p-bfc" data-nick="${reply.nickname}" data-guid="${list.guid}" data-replyId="${reply.id}">\u56de\u590d</a>                          <div class="clr"></div>                      </div>                  </div>              </div>          </div>      </div>      {/for}      {if list.replyCount > 5}      <div class="ac">           <a class="hl_blue" href="http://club.jd.com/repay/${productCommentSummary.productId}_${list.guid}_1.html" title="\u67e5\u770b\u5168\u90e8\u56de\u590d" target="_blank">\u67e5\u770b\u5168\u90e8\u56de\u590d&gt;&gt;</a>      </div>      {/if}   </div>  <div class="corner tl"></div></div>{forelse}    {if score == 0}     <div class="norecode">         \u6682\u65e0\u5546\u54c1\u8bc4\u4ef7\uff01<span style="hl-red">\u4e89\u62a2\u4ea7\u54c1\u8bc4\u4ef7\u524d5\u540d\uff0c\u524d5\u4f4d\u8bc4\u4ef7\u7528\u6237\u53ef\u83b7\u5f97\u591a\u500d\u79ef\u5206\u54e6\uff01</span>\uff08<a href="http://help.jd.com/help/question-58.html" target="_blank">\u8be6\u89c1\u79ef\u5206\u89c4\u5219</a>\uff09\uff01    </div>    <div class="extra clearfix">        <div class="join">            \u53ea\u6709\u8d2d\u4e70\u8fc7\u8be5\u5546\u54c1\u7684\u7528\u6237\u624d\u80fd\u8fdb\u884c\u8bc4\u4ef7\u3002&nbsp;&nbsp;<a target="_blank" href="http://club.jd.com/Simplereview/${productCommentSummary.productId}.html" name="http://club.jd.com/Simplereview/${productCommentSummary.productId}.html" id="A1">[\u53d1\u8868\u8bc4\u4ef7]</a>&nbsp;&nbsp;<a target="_blank" href="http://club.jd.com/allreview/1-1.html">[\u6700\u65b0\u8bc4\u4ef7]</a>        </div>    </div>     {elseif score == 3}         <div class="norecode"> \u6682\u65e0\u597d\u8bc4\uff01</div>     {elseif score == 2}         <div class="norecode"> \u6682\u65e0\u4e2d\u8bc4\uff01</div>     {elseif score == 1}         <div class="norecode"> \u6682\u65e0\u5dee\u8bc4\uff01</div>     {elseif score == 4}         <div class="norecode"> \u6682\u65e0\u6652\u5355\u8bc4\u4ef7\uff01</div>    {/if}{/for}<div class="clearfix">    {if productCommentSummary.commentCount}<div class="fl" style="padding:8px 0 0 120px;"><a href="http://club.jd.com/review/${productCommentSummary.productId}-0-1-0.html" target="_blank" class="hl_blue">[\u67e5\u770b\u5168\u90e8\u8bc4\u4ef7]</a></div>{/if}    <div class="pagin fr" clstag="shangpin|keycount|product|fanye" id="commentsPage${score}">    </div></div>',
discuss_TPL = '<table width="100%" cellspacing="0" cellpadding="0" border="0">    <tbody>        <tr>            <th class="col1">\u4e3b\u9898</th>            <th class="col2">\u56de\u590d/\u6d4f\u89c8</th>            <th class="col3">\u4f5c\u8005</th>            <th class="col4">\u65f6\u95f4</th>        </tr>        {for comment in discussComments.Comments}        <tr>            <td class="col1">                <div class="topic">                    {if comment.referenceType == "Order"}                    <b class="icon shai"></b>                    {elseif comment.referenceType == "User"}                    <b class="icon lun"></b>                    {elseif comment.referenceType == "Question"}                    <b class="icon wen"></b>                    {elseif comment.referenceType == "Friend"}                    <b class="icon quan"></b>                    {/if}                    <a href="http://club.jd.com/bbsDetail/${comment.referenceId}_${comment.id}_1.html" target="_blank">${comment.title}</a>                </div>            </td>            <td class="col2">${comment.replyCount}/${comment.viewCount}</td>            <td class="col3">                <div class="u-name">                    <a target="_blank" title="${comment.uRemark}" href="http://club.jd.com/userdiscuss/${comment.uid}-1.html">{if comment.uRemark}${comment.uRemark}{else}${comment.userId}{/if}</a>                </div>            </td>            <td class="col4">${comment.creationTime}</td>        </tr>        {/for}    </tbody></table>{if discussComments.CommentCount <= 0}    {if parseInt(ReferenceType) == 1}        <div class="norecode">\u6682\u65e0\u8ba8\u8bba\u5e16\uff01</div>    {elseif parseInt(ReferenceType) == 2}        <div class="norecode">\u6682\u65e0\u95ee\u7b54\u5e16\uff01</div>    {elseif parseInt(ReferenceType) == 3}        <div class="norecode">\u6682\u65e0\u5708\u5b50\u8d34\uff01</div>    {elseif parseInt(ReferenceType) == 4}        <div class="norecode">\u6682\u65e0\u6652\u5355\u5e16\uff01</div>    {else}        <div class="norecode">\u6682\u65e0\u7f51\u53cb\u8ba8\u8bba\uff01</div>    {/if}{/if}<div class="extra clearfix">    <div class="total">          <span>\u5171${discussComments.CommentCount}\u4e2a\u8bdd\u9898</span>&nbsp;&nbsp;           <a target="_blank" href="http://club.jd.com/bbs/${referenceId}-1-0-${ReferenceType}.html">\u6d4f\u89c8\u5168\u90e8\u8bdd\u9898&gt;&gt;</a>    </div>    <div class="contact">        \u6709\u95ee\u9898\u8981\u4e0e\u5176\u4ed6\u7528\u6237\u8ba8\u8bba\uff1f<a target="_blank" href="http://club.jd.com/bbs/${referenceId}-1.html" name="http://club.jd.com/bbs/${referenceId}-1.html" id="userComment${ReferenceType}">[\u53d1\u8868\u8bdd\u9898]</a>    </div></div>',
consult_TPL = '{if Consultations.length > 0}    {for Consultation in Consultations}    <div class="item{if Consultation_index% 2 == 1} odd{/if}">        <div class="user">            <span class="u-name">\u7f51\u3000\u3000\u53cb\uff1a${Consultation.UNickNme}</span>             <!--<span class="u-level" name="${Consultation.UserId}"></span>-->             <span class="u-level" ><font style="color:${Consultation.UserLevelColor}"> ${Consultation.UserLevelName} </font></span>             <span class="date-ask">${Consultation.CreationTime}</span>        </div>        <dl class="ask">            <dt><b></b>\u54a8\u8be2\u5185\u5bb9\uff1a</dt>            <dd><a target="_blank" href="http://club.jd.com/consultation/${Consultation.ProductId}-${Consultation.Id}.html">${Consultation.Content}</a></dd>        </dl>        <dl class="answer">            {for Reply in Consultation.Replies}            <dt>                <b></b>                {if Reply.sst == 2}\u5356\u5bb6\u56de\u590d\uff1a {else}\u4eac\u4e1c\u56de\u590d\uff1a{/if}             </dt>            <dd>                <div class="content">${Reply.sword}</div>                <div class="date-answer">${Reply.sinsdate}</div>            </dd>            {/for}        </dl>    </div>    {/for} {else}    <div class="norecode">\u6682\u65e0\u8be5\u7c7b\u54a8\u8be2\uff01</div>{/if}<div class="extra clearfix">    <div class="total">        \u5171<strong>${SearchParameter.Count}</strong>\u6761&nbsp;&nbsp;         <a href="http://club.jd.com/allconsultations/${SearchParameter.ProductId}-1-1.html" target="_blank">\u6d4f\u89c8\u6240\u6709\u54a8\u8be2\u4fe1\u606f&gt;&gt;</a>     </div>    <div class="join">        \u8d2d\u4e70\u4e4b\u524d\uff0c\u5982\u6709\u95ee\u9898\uff0c\u8bf7\u5411\u4eac\u4e1c\u54a8\u8be2\u3002&nbsp;&nbsp;        <a id="consultation" href="http://club.jd.com/allconsultations/${SearchParameter.ProductId}-1-1.html#form1">[\u53d1\u8868\u54a8\u8be2]</a>    </div></div>',
consult_search_TPL = '{for item in list}<div class="item search-result-item">    <div class="user">        <span class="u-name">\u7f51\u3000\u3000\u53cb\uff1a${item.nickname}</span>        <span class="date-ask">${item.sindate}</span>    </div>    <dl class="ask">        <dt><b></b>\u54a8\u8be2\u5185\u5bb9\uff1a</dt>        <dd>${item.sword}</dd>    </dl>    <dl class="answer">        <dt><b></b>\u4eac\u4e1c\u56de\u590d\uff1a</dt>        <dd>{if item.sword!==""}${item.sword2}{/if}</dd>    </dl>    <div id="${item.sid}" class="useful">\u60a8\u5bf9\u6211\u4eec\u7684\u56de\u590d\uff1a        <a name="2" href="#none" class="btn-pleased">\u6ee1\u610f</a>        (<span>${item.zantong}</span>)\u3000        <a name="2" href="#none" class="btn-unpleased">\u4e0d\u6ee1\u610f</a>        (<span>${item.fd}</span>)    </div></div>{/for}',
search_TPL = '{for list in Product}<dl skuid="${list.wareid}">    <dt class="p-img"><a target="_blank" href="http://item.jd.com/${list.wareid}.html"><img width="50" height="50" src="${pageConfig.FN_GetImageDomain(list.wareid)}n5/${list.Content.imageurl}" alt=""></a></dt>    <dd class="p-name"><a target="_blank" href="http://item.jd.com/${list.wareid}.html">${list.Content.warename}</a></dd>    <dd class="p-price">        <img src="http://jprice.360buyimg.com/price/gp${list.wareid}-1-1-1.png" onerror="this.src=\'http://misc.360buyimg.com/lib/skin/e/i/error-3.gif\'" />    </dd></dl>{/for}',
setAmount = {
    min: 1,
    max: 999,
    count: 1,
    countEl: $("#buy-num"),
    buyLink: $("#choose-btn-append .btn-append"),
    targetLink: $("#choose-btn-append .btn-append"),
    matchCountKey: ["pcount", "pCount", "num"],
    add: function() {
        return this.count > 999 ? (alert("\u5546\u54c1\u6570\u91cf\u6700\u591a\u4e3a" + this.max), !1) : (this.count++, this.countEl.val(this.count), this.setBuyLink(), void 0)
    },
    reduce: function() {
        return 1 >= this.count ? (alert("\u5546\u54c1\u6570\u91cf\u6700\u5c11\u4e3a" + this.min), !1) : (this.count--, this.countEl.val(this.count), this.setBuyLink(), void 0)
    },
    modify: function() {
        var t = parseInt(this.countEl.val(), 10);
        return isNaN(t) || 1 >= t || t > 999 ? (alert("\u5546\u54c1\u6570\u91cf\u5e94\u8be5\u5728" + this.min + "-" + this.max + "\u4e4b\u95f4"), this.countEl.val(this.count), !1) : (this.count = t, this.setBuyLink(), void 0)
    },
    setBuyLink: function() {
        var t = this;
        t.targetLink.each(function() {
            var e, i, s = $(this),
            a = s.attr("href"),
            o = a.split("?")[1]; (function() {
                for (var n = 0; t.matchCountKey.length > n; n++) if (i = RegExp(t.matchCountKey[n] + "=\\d+"), i.test(o)) return e = a.replace(i, t.matchCountKey[n] + "=" + t.count),
                s.attr("href", e),
                !1
            })()
        })
    }
}; (function() {
    var t = $("#choose-color .selected a,#choose-version .selected a"),
    e = $("#choose-result .dd"),
    i = [];
    1 > t.length || $("#product-intro").hasClass("product-intro-noitem") ? $("#choose-result").hide() : (t.each(function() {
        1 == !!$(this).attr("title") && i.push("<strong>\u201c" + $(this).attr("title") + "\u201d</strong>")
    }), i.length > 0 && (e.prepend("<em>\u5df2\u9009\u62e9</em>" + i.join("\uff0c")), $("#choose-result").show()))
})(),
function() {
    var t = "4835-4836-4833",
    e = G.cat[2];
    RegExp(e).test(t) && $("#choose-amount").hide(),
    (4835 == e || 4836 == e) && (setAmount.urlPerfix = "http://card.jd.com/order/order_place.action?", setAmount.data = null, setAmount.data = {
        skuId: G.sku
    }),
    4833 == e && (setAmount.urlPerfix = "http://chongzhi.jd.com/order/order_place.action?", setAmount.data = null, setAmount.data = {
        skuId: G.sku
    })
} ();
var fq_serverSite = "http://jd2008.jd.com/purchase/",
fq_serverSiteService = "http://jd2008.jd.com/purchaseservice/",
fq_serverUrl = "ajaxServer/ForMiniCart_fq.aspx",
fq_btnPanel = "choose-btn-divide",
fq_skuId = "",
fq_TipHtml = "",
isFqOpen = !0,
isYbOpen = !0,
fq_returnData = null,
isIe = window.ActiveXObject ? !0 : !1;
if (isFqOpen) if (isIe) fq_init();
else try {
    fq_init()
} catch(e) {
    document.addEventListener("DOMContentLoaded", fq_init, null)
}
var buyBtnLink, fittingsAuto = {
    init: function(t, e) {
        this.sku = t,
        this.catId = e,
        this.get()
    },
    get: function() {
        var t = this;
        $.ajax({
            url: "http://rs.jd.com/carAccessorie/thirdTypeMatchScheme/" + this.catId + "/" + this.sku + ".jsonp",
            dataType: "jsonp",
            scriptCharset: "utf-8",
            success: function(e) {
                t.set(e)
            }
        })
    },
    set: function(t) {
        var e = {
            tabs: '<div class="tab-cat stab">      <ul>          <li id="tab-cat-0" class="fl scurr" data-widget="tab-item" data-cat="\u914d\u4ef6\u9009\u8d2d\u4e2d\u5fc3|3">\u7cbe\u9009\u914d\u4ef6</li>          {for tab in list}          {if parseInt(tab.carAccessoryShows.length)>0}          <li id="tab-cat-${parseInt(tab_index)+1}" class="fl" data-widget="tab-item" data-cat="${tab.typeName}|${tab.carAccessoryShows[0].secondType}|${tab.carAccessoryShows[0].thirdType}">${tab.typeName}</li>          {/if}          {/for}      </ul></div>',
            cons: '<div id="newFittign-tab" data-widget="tabs"><div class="master">    <s></s>    <div class="p-img">        <a href="http://item.jd.com/${G.sku}.html" target="_blank"><img src="${pageConfig.FN_GetImageDomain(G.sku)}n4/${G.src}" height="100" width="100"></a>    </div>    <div class="p-name">        <a href="http://item.jd.com/${G.sku}.html" target="_blank">${G.name}</a>    </div>    <div class="p-price"><input type="checkbox" onclick="return false;" onchange="return false" wmeprice="{if mainProduct.wMeprice==""}0.00{else}${mainProduct.wMeprice}{/if}" wmaprice="${mainProduct.wMaprice}" skuid="${mainProduct.wid}" checked/> ${mainProduct.wMeprice}</div></div><div class="suits" style="width:${pageConfig.wideVersion&&pageConfig.compatible?(4*165-40):(3*128)}px;overflow-x:auto;overflow-y:hidden;">    {for tab in list}    {if parseInt(tab.carAccessoryShows.length)>0}    <ul id="newFitting-${parseInt(tab_index)+1}" data-cat="${tab.typeName}" style="width:${parseInt(tab.carAccessoryShows.length)*165}px;" class="lh hide" data-widget="tab-content">      <div class="iloading">\u52a0\u8f7d\u4e2d...</div>    </ul>    {/if}    {/for}</div><div class="infos">    <div id="more-fitting-link"><a class="hl_link" href="http://rs.jd.com/carAccessorie/requestCarCenter" target="_blank">\u8fdb\u5165\u914d\u4ef6\u9009\u8d2d\u4e2d\u5fc3</a><span>&gt;<b></b></span></div>    <s></s>    <div class="p-name">        <em>\u5df2\u9009\u62e9<span>0</span>\u4e2a\u914d\u4ef6</em>    </div>    <div class="p-price">\u642d&nbsp;&nbsp;\u914d&nbsp;&nbsp;\u4ef7\uff1a        <strong class="res-jdprice">{if mainProduct.wMeprice==""}\u6682\u65e0\u62a5\u4ef7{else}\uffe5 ${parseInt(mainProduct.wMeprice,10).toFixed(2)}{/if}</strong>    </div>    <div class="p-saving">\u53c2&nbsp;&nbsp;\u8003&nbsp;&nbsp;\u4ef7\uff1a        <span class="res-totalprice">\uffe5 ${parseInt(mainProduct.wMaprice,10).toFixed(2)}</span>    </div>    <div class="btns">        <a class="btn-buy" href="http://jd2008.jd.com/purchase/OrderFlowService.aspx?action=AddSkus&wids=${G.sku}">\u7acb\u5373\u8d2d\u4e70</a>    </div></div></div>',
            item: '{for item in carAccessoryShows}<li {if (parseInt(item_index)+1)==carAccessoryShows.length} class="last_item"{/if} onclick=\'clsClickLog("655", "${G.sku}", "${item.wid}", 34, "${item_index}", "rodGlobalTrack");\'>    <s></s>    <div class="p-img">        <a href="http://item.jd.com/${item.wid}.html" target="_blank"><img src="${pageConfig.FN_GetImageDomain(item.wid)}n4/${item.imageUrl}" alt="" height="100" height="100"></a>    </div>    <div class="p-name">        <a href="http://item.jd.com/${item.wid}.html" target="_blank">${item.wName}</a>    </div>    <div class="choose">        <input type="checkbox" id="inp_${item.wid}" onclick="G.calculatePrice(this, \'#tab-reco\')" wmaprice="${item.wMaprice}" wmeprice="${item.wMeprice}" skuid="${item.wid}" />        <label for="inp_${item.wid}" class="p-price">            <strong><img src="http://jprice.360buyimg.com/price/gp${item.wid}-1-1-1.png" /></strong>        </label>    </div>    <div class="p-more{if typeof allList=="undefined"&&parseInt(item_index)+1!=parseInt(carAccessoryShows.length)} hide{/if}"><a class="hl_link" href="http://rs.jd.com/carAccessorie/requestCarCenter?tTypeId=${item.thirdType}&sTypeId=${item.secondType}&from=singlePage" target="_blank">\u66f4\u591a{if typeof item.typeName!=="undefined"}${item.typeName}{else}${typeName}{/if}</a></div></li>{/for}'
        },
        i = {
            carAccessoryShows: [],
            allList: !0
        };
        if (t && t.list && t.list.length > 0) {
            $("#tab-reco").attr("loaded", "true").html(e.cons.process(t));
            for (var s = 0; t.list.length > s; s++) if (void 0 !== typeof t.list[s].carAccessoryShows && t.list[s].carAccessoryShows.length > 0 && t.list[s].carAccessoryShows) {
                if (t.list[s].carAccessoryShows[0]) {
                    var a = t.list[s].carAccessoryShows[0];
                    a.typeName = t.list[s].typeName,
                    i.carAccessoryShows.push(a)
                }
                $("#newFitting-" + (s + 1)).html(e.item.process(t.list[s]))
            }
            $("#newFittign-tab .suits").prepend('<ul id="newFitting-0" class="lh" data-widget="tab-content" style="width:' + 165 * i.carAccessoryShows.length + 'px">' + e.item.process(i) + "</ul>"),
            $("#newFittign-tab").prepend(e.tabs.process(t)),
            $("#newFittign-tab").Jtab({
                event: "click",
                compatible: !0,
                currClass: "scurr"
            },
            function(t, e, i) {
                var s = $("#tab-cat-" + i),
                a = s.attr("data-cat").split("|")[1],
                o = s.attr("data-cat").split("|")[2],
                n = $("#tab-cat-" + i).attr("data-cat").split("|")[0],
                r = $("#more-fitting-link a");
                r.attr("href", "http://rs.jd.com/carAccessorie/requestCarCenter?tTypeId=" + o + "&sTypeId=" + a + "&from=singlePage").html("\u8fdb\u5165" + n)
            }),
            clsPVAndShowLog("655", G.sku, 34, "s"),
            Recommend.switchTab("#th-fitting"),
            $("#tab-reco .suits ul").each(function() {
                G.removeLastAdd($(this))
            })
        }
    }
},
Recommend = {
    init: function(t) {
        this.type = t,
        this.renderHTML(),
        this.renderRecoFittingsHTML(),
        this.getSuits()
    },
    getSuits: function() {
        G.isPop ? $.ajax({
            url: "http://misc.360buyimg.com/product/js/2012/suits.js",
            dataType: "script",
            scriptCharset: "utf-8",
            success: function() {
                "undefined" != typeof Suits && Suits.init(G.sku)
            }
        }) : $.getJSONP("http://jprice.jd.com/suit/" + G.sku + "-1-1.html")
    },
    renderRecoFittingsHTML: function() {
        var t = G.sku;
        655 == G.cat[2] ? $.ajax({
            url: "http://rs.jd.com/accessorie/newServiceWhite.jsonp?sku=" + G.sku + "&callback=Recommend.cbNewFittings",
            dataType: "script",
            cache: !0,
            scriptCharset: "utf-8"
        }) : 6728 == G.cat[0] && G.isJd ? fittingsAuto.init(pageConfig.product.skuid, pageConfig.product.cat[2]) : $.getJSONP("http://d.360buy.com/fittingInfo/get?skuId=" + t + "&callback=Recommend.cbRecoFittings")
    },
    cbNewFittings: function(t) {
        var e = {
            accessoryList: []
        },
        i = {
            tabs: '<div class="tab-cat stab"><ul><li id="tab-cat-0" class="fl scurr" data-widget="tab-item" data-cat="\u914d\u4ef6\u9009\u8d2d\u4e2d\u5fc3|3">\u7cbe\u9009\u914d\u4ef6</li>{for tab in accessoryList}<li id="tab-cat-${parseInt(tab_index)+1}" class="fl" data-widget="tab-item" data-cat="${tab.thirdName}|${tab.thirdTypeId}">${tab.thirdName}</li>{/for}</ul></div>',
            cons: '<div id="newFittign-tab"  data-widget="tabs"><div class="master">    <s></s>    <div class="p-img">        <a href="http://item.jd.com/${mainproduct.sku}.html" target="_blank"><img src="${pageConfig.FN_GetImageDomain(mainproduct.sku)}n4/${mainproduct.imageUrl}" height="100" width="100"></a>    </div>    <div class="p-name">        <a href="http://item.jd.com/${mainproduct.sku}.html" target="_blank">${mainproduct.name}</a>    </div>    <div class="p-price"><input type="checkbox" onclick="return false;" onchange="return false" wmeprice="{if mainproduct.price==""}0.00{else}${mainproduct.price}{/if}" wmaprice="${mainproduct.maPrice}" skuid="${mainproduct.sku}" checked/> ${mainproduct.price}</div></div><div class="suits" style="width:${pageConfig.wideVersion&&pageConfig.compatible?(4*165-40):(3*128)}px;overflow-x:auto;overflow-y:hidden;">      {for tab in accessoryList}    <ul id="newFitting-${parseInt(tab_index)+1}" data-cat="${tab.thirdName}" style="width:660px;" class="lh hide" data-widget="tab-content">      <div class="iloading">\u52a0\u8f7d\u4e2d...</div>    </ul>      {/for}</div><div class="infos">    <div id="more-fitting-link"><a class="hl_link" href="http://rs.jd.com/accessorie/center.html?sku=${G.sku}&thirdTypeId=3" target="_blank">\u8fdb\u5165\u914d\u4ef6\u9009\u8d2d\u4e2d\u5fc3</a><span>&gt;<b></b></span></div>    <s></s>    <div class="p-name">        <em>\u5df2\u9009\u62e9<span>0</span>\u4e2a\u914d\u4ef6</em>    </div>    <div class="p-price">\u642d&nbsp;&nbsp;\u914d&nbsp;&nbsp;\u4ef7\uff1a        <strong class="res-jdprice">{if mainproduct.price==""}\u6682\u65e0\u62a5\u4ef7{else}\uffe5 ${mainproduct.price.toFixed(2)}{/if}</strong>    </div>    <div class="p-saving">\u53c2&nbsp;&nbsp;\u8003&nbsp;&nbsp;\u4ef7\uff1a        <span class="res-totalprice">\uffe5 ${mainproduct.maPrice.toFixed(2)}</span>    </div>    <div class="btns">        <a class="btn-buy" href="http://jd2008.jd.com/purchase/OrderFlowService.aspx?action=AddSkus&wids=${mainproduct.sku}">\u7acb\u5373\u8d2d\u4e70</a>    </div></div></div>',
            item: '{for item in accessoryList}<li {if (parseInt(item_index)+1)==accessoryList.length} class="last_item"{/if} onclick=\'clsClickLog("655", "${G.sku}", "${item.sku}", 34, "${item_index}", "rodGlobalTrack");\'>    <s></s>    <div class="p-img">        <a href="http://item.jd.com/${item.sku}.html" target="_blank"><img src="${pageConfig.FN_GetImageDomain(item.sku)}n4/${item.imageUrl}" alt="" height="100" skuidth="100"></a>    </div>    <div class="p-name">        <a href="http://item.jd.com/${item.sku}.html" target="_blank">${item.name}</a>    </div>    <div class="choose">        <input type="checkbox" id="inp_${item.sku}" onclick="G.calculatePrice(this, \'#tab-reco\')" wmaprice="${item.maPrice}" wmeprice="${item.price}" skuid="${item.sku}" />        <label for="inp_${item.skuid}" class="p-price">            <strong><img src="http://jprice.360buyimg.com/price/gp${item.sku}-1-1-1.png" onerror="this.src=\'http://misc.360buyimg.com/lib/skin/e/i/error-3.gif\'" /></strong>        </label>    </div>    {if isExtra==true}    <div class="p-more{if (parseInt(item_index)+1)!==accessoryList.length} hide{/if}"><a class="hl_link" href="http://rs.jd.com/accessorie/center.html?sku=${G.sku}&thirdTypeId=${item.thirdType}" target="_blank"></a></div>    {else}    <div class="p-more"><a class="hl_link" href="http://rs.jd.com/accessorie/center.html?sku=${G.sku}&thirdTypeId=${item.thirdType}" target="_blank">\u66f4\u591a${item.thirdName}</a></div>    {/if}</li>{/for}'
        };
        if (clsPVAndShowLog("655", G.sku, 34, "p"), t && t.accessoryList && t.accessoryList.length > 0) {
            $("#tab-reco").attr("loaded", "true").html(i.cons.process(t));
            for (var s = 0; t.accessoryList.length > s; s++) t.accessoryList[s].accessoryList.length = 4,
            t.accessoryList[s].accessoryList[0].thirdType = t.accessoryList[s].thirdTypeId,
            t.accessoryList[s].accessoryList[0].thirdName = t.accessoryList[s].thirdName,
            e.accessoryList.push(t.accessoryList[s].accessoryList[0]),
            e.isExtra = !1;
            $("#newFittign-tab .suits").prepend('<ul id="newFitting-0" class="lh" data-widget="tab-content" style="width:' + 165 * e.accessoryList.length + 'px">' + i.item.process(e) + "</ul>"),
            $("#newFittign-tab").prepend(i.tabs.process(t)).Jtab({
                event: "click",
                compatible: !0,
                currClass: "scurr"
            },
            function(t, e, s) {
                var a = $("#tab-cat-" + s).attr("data-cat").split("|")[1],
                o = $("#tab-cat-" + s).attr("data-cat").split("|")[0],
                n = $("#more-fitting-link a");
                if (n.attr("href", "http://rs.jd.com/accessorie/center.html?sku=" + G.sku + "&thirdTypeId=" + a).html("\u8fdb\u5165" + o), 0 !== s) {
                    if ("1" == $("#newFitting-" + s).attr("loaded")) return;
                    window.fetchJSON_fittingExtra = function(t) {
                        t.isExtra = !0,
                        $("#newFitting-" + s).html(i.item.process(t)).attr("loaded", "1"),
                        $("#newFitting-" + s).find(".hl_link").html("\u66f4\u591a" + $("#tab-cat-" + s).html());
                        try {
                            delete window.fetchJSON_fittingExtra
                        } catch(e) {}
                    },
                    $.ajax({
                        url: "http://rs.jd.com/accessorie/newServiceList.jsonp?sku=" + G.sku + "&thirdTypeId=" + a + "&callback=fetchJSON_fittingExtra",
                        dataType: "script",
                        cache: "true",
                        scriptCharset: "utf-8"
                    }),
                    $("#newFittign-tab .suits").removeAttr("style").css({
                        width: pageConfig.wideVersion && pageConfig.compatible ? 620 : 384,
                        overflow: pageConfig.wideVersion && pageConfig.compatible ? "hidden": "auto"
                    })
                } else $("#newFittign-tab .suits").removeAttr("style").css({
                    width: pageConfig.wideVersion && pageConfig.compatible ? 620 : 384,
                    overflowX: "auto"
                })
            }),
            clsPVAndShowLog("655", G.sku, 34, "s"),
            this.switchTab("#th-fitting"),
            G.removeLastAdd()
        }
    },
    renderHTML: function() {
        switch ($.getJSONP("http://simigoods.jd.com/desgoods.aspx?ip=" + getCookie("ipLocation") + "&wids=" + G.sku + "&callback=Recommend.cbBroswerBroswer"), this.type) {
        case 1:
            $.getJSONP("http://simigoods.jd.com/ThreeCCombineBuying/ThreeCBuyBuy.aspx?ip=" + getCookie("ipLocation") + "&wids=" + G.sku + "&callback=Recommend.cbCBuyBuy", Recommend.cbCBuyBuy),
            $.getJSONP("http://simigoods.jd.com/ThreeCCombineBuying/ThreeCBroswerBuy.aspx?ip=" + getCookie("ipLocation") + "&wids=" + G.sku + "&callback=Recommend.cbBroswerBuy", Recommend.cbBroswerBuy),
            $.getJSONP("http://simigoods.jd.com/ThreeCCombineBuying/CombineBuyJsonData.aspx?ip=" + getCookie("ipLocation") + "&wids=" + G.sku + "&callback=Recommend.cbCombineBuying", Recommend.cbCombineBuying);
            break;
        case 2:
            $.getJSONP("http://simigoods.jd.com/Electronic/EBuyToBuy.aspx?ip=" + getCookie("ipLocation") + "&wids=" + G.sku + "&callback=Recommend.cbCBuyBuy", Recommend.cbCBuyBuy),
            $.getJSONP("http://simigoods.jd.com/Electronic/EBrowserBuy.aspx?ip=" + getCookie("ipLocation") + "&wids=" + G.sku + "&callback=Recommend.cbBroswerBuy", Recommend.cbBroswerBuy),
            1315 == G.cat[0] ? $.getJSONP("http://simigoods.jd.com/Pop/PopCombinebuyingColor.aspx?ip=" + getCookie("ipLocation") + "&wids=" + G.sku + "&callback=Recommend.cbCombineBuyingPop") : $.getJSONP("http://simigoods.jd.com/Electronic/GCombineBuyJsonData.aspx?ip=" + getCookie("ipLocation") + "&wids=" + G.sku + "&callback=Recommend.cbCombineBuying");
            break;
        default:
        }
    },
    switchTab: function(t) {
        var e = $(t),
        i = $("#recommend"),
        s = $('#recommend .mc[loaded="true"]'),
        a = s.length > 0;
        i.show(),
        e.show(),
        "#th-service" != t ? e.trigger("click") : a || e.trigger("click")
    },
    cbRecoFittings: function(t) {
        t && t.fittings && t.fittings.length > 0 && ($("#tab-reco").attr("loaded", "true").html('<ul class="stab lh">' + recoFittings_TPL.tabs.process(t) + '</ul><div class="stabcon">' + recoFittings_TPL.cons.process(t) + "</div>"), this.switchTab("#th-fitting"), G.removeLastAdd())
    },
    cbCombineBuying: function(t) {
        1 == !!t.master.wid && t.recoList.length > 0 && ($("#tab-hot").attr("loaded", "true").html(suitRecommend_TPL.process(t)), log(mdPerfix + "3", "Show"), this.switchTab("#th-hot")),
        G.removeLastAdd()
    },
    cbCombineBuyingPop: function(t) {
        function e(t) {
            if (t) {
                var e = $("#pop-box .p-scroll-wrap"),
                i = $("#pop-box .p-scroll-next"),
                s = $("#pop-box .p-scroll-prev");
                e.find("li").length > 4 && e.imgScroll({
                    showControl: !0,
                    width: 30,
                    height: 30,
                    visible: 4,
                    step: 1,
                    prev: s,
                    next: i
                })
            } else G.setScroll("#stabcon_pop")
        }
        function i(e, i) {
            var e = e;
            if (i) var s = i.split("|"),
            l = s[1],
            p = s[2];
            $("#pop-box").length > 0 && $("#pop-box").attr("data-ind", e),
            n.clear().show(e,
            function() {
                var i = $("#pop-list-" + e),
                s = i.attr("data-sku"),
                n = i.find("a.curr").attr("title");
                d(e),
                a.del(),
                c.get(e),
                o(e, l || null, t),
                r.get(s, l || n, e, p)
            })
        }
        var s = {
            set: function(t, e) {
                1 > $("#p-selected-" + t).length ? $("#pop-list-" + t).find(".p-scroll").hide().before('<div id="p-selected-' + t + '" class="p-selected">\u5df2\u9009\u62e9\uff1a' + e.split("|")[1] + "\uff0c" + e.split("|")[2] + ' <a data-ind="' + t + '" class="p-modify" href="#none">\u4fee\u6539</a></div>') : $("#p-selected-" + t).html("\u5df2\u9009\u62e9\uff1a" + e.split("|")[1] + "\uff0c" + e.split("|")[2] + ' <a data-ind="' + t + '" class="p-modify" href="#none">\u4fee\u6539</a>'),
                $(".p-modify").unbind("click").bind("click",
                function() {
                    i(parseInt(this.getAttribute("data-ind")), e)
                }),
                $("#p-selected-" + t).attr("data-res", e)
            }
        },
        a = {
            set: function(t) {
                var e = t || $("#stabcon_pop .pop-list");
                e.find(".p-scroll").each(function() {
                    var t = $(this),
                    e = t.prev(".p-img").find("img"),
                    i = t.find(".p-scroll-wrap a");
                    G.thumbnailSwitch(i, e, "/n2/", "curr")
                })
            },
            del: function(t) {
                var e = t || $("#stabcon_pop .pop-list");
                e.find(".p-scroll").each(function() {
                    $(this).find(".p-scroll-wrap img").unbind("mouseover")
                })
            }
        },
        o = function(t, e) {
            var i = $("#p-scroll .p-scroll-wrap a"),
            s = $("#pop-list-" + t).find(".p-img img"),
            a = $("#pop-list-" + t).attr("data-sku");
            i.unbind("click").bind("click",
            function() {
                var e = ($(this), $(this).find("img").attr("src")),
                o = $(this).attr("title");
                r.get(a, o, t, null),
                i.removeClass("curr"),
                $(this).addClass("curr"),
                s.attr("src", e.replace("/n5/", "/n2/")),
                $("#pop-list-" + t).attr("data-res") && $("#pop-list-" + t).removeAttr("data-res")
            }),
            e && i.each(function() {
                $(this).attr("title") == e && $(this).trigger("click")
            })
        },
        n = {
            show: function(t, e) {
                $("#pop-box").css({
                    left: t * $("#stabcon_pop .pop-list").outerWidth() - $("#stabcon_pop .suits").scrollLeft(),
                    visibility: "visible"
                }),
                "function" == typeof e && e(t)
            },
            hide: function() {
                return $("#pop-box").css("visibility", "hidden"),
                this
            },
            clear: function() {
                var t = ($("#pop-box"), $("#p-scroll,#p-size,#p-tips"));
                return t.html(""),
                this.isClear = !0,
                a && a.set(),
                this
            }
        },
        r = {
            sClick: function(t, e) {
                var i = $("#p-size a"),
                s = $("#pop-list-" + t),
                a = this;
                i.click(function() {
                    var t = $(this).attr("data-resku"),
                    e = $("#p-scroll .p-scroll-wrap .curr").attr("title"),
                    o = $(this).attr("title"),
                    n = $(this).attr("wmaprice"),
                    r = $(this).attr("wmeprice");
                    i.removeClass("selected"),
                    $(this).addClass("selected"),
                    a.clearTips("#p-noselected"),
                    s.attr("data-res", [t, e, o, n, r].join("|"))
                }),
                e && $("#p-size a").each(function() {
                    $(this).attr("title") == e && $(this).trigger("click")
                })
            },
            noSize: function(t, e) {
                $("#p-size").addClass("nosizes").html(""),
                $("#pop-list-" + t).attr("data-res", [e.Subcodesku[0].Sku, $("#pop-box .curr").attr("title"), "\u65e0\u5c3a\u7801", e.Subcodesku[0].WMeprice, e.Subcodesku[0].WMaprice].join("|"))
            },
            get: function(t, e, i, s, a) {
                var o = this,
                n = {
                    ip: getCookie("ipLocation"),
                    sku: t,
                    color: encodeURI(e)
                };
                $("#pop-list-" + i).find(".no-scroll").length > 0 && (n = {
                    ip: getCookie("ipLocation"),
                    sku: t
                }),
                window.fetchJSON_sizeList = function(e) {
                    1 > e.Subcodesku.length ? (o.setTips('<p id="p-nostock">\u8be5\u5546\u54c1\u5df2\u4e0b\u67b6\u6216\u65e0\u8d27</p>'), $("#p-size").html("")) : 1 == e.Subcodesku.length && 0 == !!e.Subcodesku[0].sizename || "\u65e0" == e.Subcodesku[0].sizename ? (o.noSize(i, e), o.clearTips("#p-nostock")) : (o.set(e, t, i, s), o.clearTips("#p-nostock")),
                    "function" == typeof a && a(e)
                },
                $.ajax({
                    url: "http://simigoods.jd.com/Pop/CodeServiceSize.aspx?callback=fetchJSON_sizeList",
                    dataType: "script",
                    cache: !0,
                    data: n
                })
            },
            set: function(t, e, i, s) {
                var a = '{for list in Subcodesku}<a href="#none" data-resku="${list.Sku}" wmaprice="${list.WMaprice}" wmeprice="${list.WMeprice}" title="${list.sizename}">${list.sizename}</a>{/for}';
                $("#p-size").html(a.process(t)),
                this.sClick(i, s)
            },
            setTips: function(t) {
                "" == $("#p-tips").html() && $("#p-tips").html(t)
            },
            clearTips: function(t) {
                $("#pop-box").find(t).remove()
            }
        },
        c = {
            get: function(t) {
                $("#p-scroll").append($("#pop-list-" + t).find(".p-scroll").clone().show()),
                this.set(t)
            },
            set: function() {
                e(!0)
            }
        },
        d = function(t) {
            var t = t;
            $("#p-selected-ok").unbind("click").bind("click",
            function() {
                var e = $("#pop-box");
                if (e.find("#p-scroll .curr").attr("title"), 1 > $("#pop-box .curr").length) r.setTips('<p id="p-noselected">\u8bf7\u9009\u62e9\u989c\u8272</p>');
                else if (1 > $("#pop-box .selected").length && !$("#p-size").hasClass("nosizes")) r.setTips('<p id="p-noselected">\u8bf7\u9009\u62e9\u5c3a\u7801</p>');
                else {
                    s.set(t, $("#pop-list-" + t).attr("data-res")),
                    n.hide().clear();
                    var i = $("#pop-list-" + t),
                    a = i.attr("data-res").split("|"),
                    o = a[0],
                    c = a[3],
                    d = a[4],
                    l = i.find(".p-price img"),
                    p = l.attr("src");
                    l.attr("src", p.replace(/\d{10}/, o)),
                    i.find("input:checkbox").attr({
                        skuid: o,
                        wmaprice: c,
                        wmeprice: d,
                        checked: !0
                    }),
                    G.calculatePrice($("#pop-list-" + t).find("input:checkbox")[0], "#tab-hot")
                }
            }),
            $("#p-selected-cancel").click(function() {
                n.hide().clear(),
                1 > $("#p-selected-" + t).length && $("#pop-list-" + t).find("input:checkbox").attr("checked", !1)
            })
        };
        if (t.master.wid && t.recoList.length > 0) {
            var l = '<div id="stabcon_pop" class="stabcon stabcon_big"><div class="master">    <s></s>    <div class="p-img">        <a href="http://item.jd.com/${master.wid}.html" target="_blank"><img src="${pageConfig.FN_GetImageDomain(master.wid)}n2/${master.imgurl}" height="160" width="160"></a>    </div>    <div class="p-name">        <a href="http://item.jd.com/${master.wid}.html" target="_blank">${master.name}</a>    </div>    <div class="p-price none"><input type="checkbox" id="inp_${master.wid}" onclick="return false;" onchange="return false" wmaprice="${master.wmaprice}" wmeprice="${master.wmeprice}" skuid="${master.wid}" checked/> ${master.wmeprice}</div></div><div class="pop-wrap"><div id="pop-box" class="">    <div id="p-scroll"></div>    <div id="p-size"></div>    <div id="p-tips"></div>    <div id="p-size-btn">        <a href="#none" id="p-selected-ok">\u786e\u5b9a</a><a id="p-selected-cancel" href="#none">\u53d6\u6d88</a>    </div></div><div class="suits" style="overflow-x:{if parseInt(recoList.length)>(pageConfig.wideVersion&&pageConfig.compatible ? 3:2)}scroll;{else}hidden;{/if}">    <ul class="lh" style="width:${parseInt(recoList.length)*200+20}px">        {for item in recoList}        <li class="pop-list {if parseInt(item_index)+1==parseInt(recoList.length)} last-item{/if}" id="pop-list-${item_index}" data-sku="${item.wid}" data-ind="${item_index}" onclick="reClick(\'' + mdPerfix + "3', '${master.wid}', '${item.wid}#${item.wmeprice}', '${item_index}');\">" + "            <s></s>" + '            <div class="p-img">' + '                <a href="http://item.jd.com/${item.wid}.html" target="_blank"><img src="${pageConfig.FN_GetImageDomain(item.wid)}n2/${item.imgurl}" alt="" height="160" width="160"></a>' + "            </div>" + '            <div class="p-scroll">' + '                <a href="javascript:;" class="p-scroll-btn p-scroll-prev">&lt;</a>' + '                <div class="p-scroll-wrap">' + "                    <ul>" + "                    {for color in item.colorlist}" + '                        <li><a href="javascript:;" class="{if parseInt(color_index)==0}curr{/if}" data-sku="${item.wid}" title="${color.colorname}"><img data-img="1" width="25" height="25" alt="" src="${pageConfig.FN_GetImageDomain(item.wid)}n5/${color.imgurl}" data-img="1"></a></li>' + "                    {forelse}" + '                        <li><a href="javascript:;" class="no-scroll curr" title="\u65e0"><img data-img="1" width="25" height="25" alt="" src="${pageConfig.FN_GetImageDomain(item.wid)}n5/${item.imgurl}"></a></li>' + "                    {/for}" + "                    </ul>" + "                </div>" + '                <a href="javascript:;" class="p-scroll-btn p-scroll-next">&gt;</a>' + "            </div>" + '            <div class="p-name">' + '                <a href="http://item.jd.com/${item.wid}.html" target="_blank">${item.name}</a>' + "            </div>" + '            <div class="choose">' + '                <input type="checkbox" data-nocolor="${item.colorlist.length<1}" id="inp_${item.wid}" class="{if parseInt(item.colorlist.length)==0}no-pop-win{/if}" wmaprice="${item.wmaprice}" wmeprice="${item.wmeprice}" skuid="${item.wid}" />' + '                <label for="inp_${item.wid}" class="p-price">' + '                    <strong><img src="http://jprice.360buyimg.com/price/gp${item.wid}-1-1-1.png" onerror="this.src=\'http://misc.360buyimg.com/lib/skin/e/i/error-3.gif\'" /></strong>' + "                </label>" + "            </div>" + "        </li>" + "        {/for}" + "    </ul>" + "</div>" + "</div>" + '<div class="infos" onclick="{for item in recoList}reClick(\'' + mdPerfix + "3', '${master.wid}', '${item.wid}#${item.wmeprice}', '${item_index}');{/for}\">" + "    <s></s>" + '    <div class="p-name">' + "        <a onclick=\"log('" + mbPerfix + "PopularBuy','click')\" href=\"http://jd2008.jd.com/purchase/OrderFlowService.aspx?action=AddSkus&wids=${master.wid}\">\u8d2d\u4e70\u4eba\u6c14\u7ec4\u5408</a>" + "    </div>" + '    <div class="p-price">\u603b\u4eac\u4e1c\u4ef7\uff1a' + '        <strong class="res-jdprice">\uffe5 ${master.wmeprice}</strong>' + "    </div>" + '    <div class="p-saving">\u603b\u53c2\u8003\u4ef7\uff1a' + '        <del class="res-totalprice">\uffe5 ${master.wmaprice}</del>' + "    </div>" + '    <div class="btns">' + "        <a onclick=\"log('" + mbPerfix + 'PopularBuy\',\'click\')" class="btn-buy" href="http://jd2008.jd.com/purchase/OrderFlowService.aspx?action=AddSkus&wids=${master.wid}">\u8d2d\u4e70\u7ec4\u5408</a>' + "    </div>" + '</div><div class="clb"></div>' + "</div>";
            $("#tab-hot").attr("loaded", "true").html(l.process(t)),
            pageConfig.FN_ImgError($("#tab-hot")[0]),
            $("#stabcon_pop .suits").scroll(function() {
                if ("visible" == $("#pop-box").css("visibility")) {
                    var t = parseInt($("#pop-box").attr("data-ind"));
                    $("#pop-list-" + t).find("input:checkbox").attr("checked", !1),
                    n.clear().hide()
                }
            }),
            a.set(),
            e(!1),
            $("#stabcon_pop ul input:checkbox").click(function() {
                var t = $(this),
                e = t.attr("data-nocolor"),
                s = t.parents(".pop-list"),
                o = s.attr("data-ind");
                if ("visible" == $("#pop-box").css("visibility")) {
                    var r = parseInt($("#pop-box").attr("data-ind"));
                    $("#pop-list-" + r).find("input:checkbox").attr("checked", !1),
                    n.clear().hide()
                }
                "true" == e ? G.calculatePrice(t[0], "#tab-hot") : 1 == $(this).attr("checked") ? i(o) : ($("#p-selected-" + o) && ($("#p-selected-" + o).remove(), $("#pop-list-" + o).find(".p-scroll").show(), a.set($("#pop-list-" + o))), G.calculatePrice(t[0], "#tab-hot"))
            }),
            log(mdPerfix + "3", "Show"),
            this.switchTab("#th-hot")
        }
    },
    cbCBuyBuy: function(t) {
        var e = $("#buy-buy"),
        i = [];
        if (t && t.length > 0) {
            log(mdPerfix + "2", "Show");
            for (var s = 0; t.length > s; s++) i.push('<li class="fore' + (s + 1) + '" onclick="reClick(\'' + mdPerfix + "2'," + G.sku + ",'" + t[s].Wid + "#" + t[s].WMeprice + "'," + s + ');">' + listBuyBuy_TPL.process(t[s]) + "</li>");
            e.show().find("ul").html(i.join(""))
        }
    },
    cbBroswerBroswer: function(t) {
        var e = $("#browse-browse"),
        i = ($("#recent-view"), []);
        if (t) {
            for (var s = 0; t.length > s; s++) i.push(listBrosweBroswe_TPL.process(t[s], s));
            e.length > 0 ? e.show().find("ul").html(i.join("")) : $("#browse-browse").show().find("ul").html(i.join(""))
        }
    },
    cbBroswerBuy: function(t) {
        var e = $("#view-buy"),
        i = [];
        if (null !== t && t.length > 0) {
            e.show(),
            log(mdPerfix + "1", "Show");
            for (var s = 0; t.length > s; s++) i.push('<li class="fore' + (s + 1) + '" onclick="reClick(\'' + mdPerfix + "1'," + G.sku + ",'" + t[s].Wid + "#" + t[s].WMeprice + "'," + s + ');">' + listBrosweBuy_TPL.process(t[s]) + "</li>");
            e.show().find("ul").html(i.join("")).after('<div class="extra"><a target="_blank" title="\u67e5\u770b\u66f4\u591a" href="http://my.jd.com/product/likes.html?id=' + G.sku + '">\u67e5\u770b\u66f4\u591a\u63a8\u8350</a></div>')
        }
    }
};
$.extend(jdModelCallCenter, {
    usefulComment: function(t) {
        $.login({
            modal: !0,
            complete: function(e) {
                if (e.IsAuthenticated) {
                    var i = t.parent().attr("id"),
                    s = "agree" == t.attr("name");
                    "true" != t.attr("enabled") ? $.ajax({
                        type: "GET",
                        url: "http://club.jd.com/index.php",
                        data: {
                            mod: "ProductComment",
                            action: "saveCommentUserfulVote",
                            commentId: i,
                            isUseful: s
                        },
                        dataType: "jsonp",
                        success: function(e) {
                            if (t.attr("enabled", "true"), 1 == e.status) {
                                var i = parseInt(t.attr("title")) + 1;
                                t.attr("title", i),
                                s ? t.html("\u6709\u7528(" + i + ")") : t.html("\u6ca1\u7528(" + i + ")")
                            } else alert("\u4e00\u4e2a\u8bc4\u4ef7\u53ea\u80fd\u70b9\u4e00\u6b21\u5466")
                        }
                    }) : alert("\u4e00\u4e2a\u8bc4\u4ef7\u53ea\u80fd\u70b9\u4e00\u6b21\u5466")
                }
            }
        }),
        mark(G.sku, 5)
    }
}),
$(".btn-agree,.btn-oppose").livequery("click",
function() {
    var t = $(this);
    $.extend(jdModelCallCenter.settings, {
        object: t,
        fn: function() {
            jdModelCallCenter.usefulComment(this.object)
        }
    }),
    jdModelCallCenter.settings.fn()
});
var consultationServiceUrl = "http://club.jd.com/newconsultationservice.aspx?callback=?";
$("#btnReferSearch").livequery("click",
function() {
    Consult.search(G.sku, $("#txbReferSearch").val(), 1, 6)
}),
$("#txbReferSearch").livequery("keydown",
function(t) {
    13 == t.keyCode && Consult.search(G.sku, $("#txbReferSearch").val(), 1, 6)
}),
$("#backConsultations").livequery("click",
function() {
    $("#consult .tab li.curr").trigger("click")
}),
$("#consultation").livequery("click",
function() {
    $.login({
        returnUrl: $(this).attr("name"),
        complete: function(t) {
            t.IsAuthenticated && (location.href = this.returnUrl)
        }
    })
}),
$("#login").livequery("click",
function() {
    $.login()
}),
$(".btn-pleased,.btn-unpleased").livequery("click",
function() {
    var t = $(this);
    $.login({
        complete: function(e) {
            if (null != e.IsAuthenticated && e.IsAuthenticated) {
                var i = parseInt($.query.get("id"));
                if (isNaN(i) || 0 == i) {
                    var e = location.href.match(/(\d+)(.html)/);
                    null != e && (i = parseInt(e[1]))
                }
                var s = $(t).parent().attr("id"),
                a = parseInt($(t).attr("name"));
                i > 0 && $.getJSON(consultationServiceUrl, {
                    method: "VoteForConsultation",
                    productId: i,
                    consultationId: s,
                    score: a
                },
                function(e) {
                    e.Result ? ($(t).text("\u5df2\u6295\u7968"), $(t).next("span").text(parseInt($(t).next("span").text()) + 1)) : $(t).text("\u5df2\u6295\u7968")
                })
            }
        }
    }),
    mark(location.href.match(/(\d+).html/)[1], 5)
});
var CommentListNew = {
    loadFirstPage: !1,
    init: function(t) {
        var e = $("#comments-list").find(".mt"),
        i = '<div id="comment-sort" class="extra"> <select > <option value="3">\u70ed\u5ea6\u6392\u5e8f</option> <option value="1">\u65f6\u95f4\u6392\u5e8f</option> </select> </div>';
        1 > $("#comment-sort").length && e.append(i),
        this.commList = $("#comments-list"),
        this.commRate = $("#comment"),
        this.wrap = $("#comment-0"),
        this.sku = t || G.sku,
        this.sort = 3,
        this.bindSelect(e),
        this.commList.find(".tab li em").html("(0)")
    },
    bindSelect: function(t) {
        var e = this;
        t.find("select").change(function() {
            var t = parseInt($(this).val(), 10);
            e.sort !== t && (e.sort = t, e.getData(e.wrap, e.type, e.page))
        })
    },
    bindHover: function() {
        this.commList.find(".item-reply").hover(function() {
            $(this).find(".reply-meta a").css("visibility", "visible")
        },
        function() {
            "none" === $(this).find(".replay-form").css("display") && $(this).find(".reply-meta a").css("visibility", "hidden")
        })
    },
    bindReply: function() {
        var t = this;
        $(document).unbind("click"),
        this.commList.find(".btn-toggle").livequery("click",
        function(e) {
            var i = $(e.target),
            s = i.attr("data-id");
            i.hasClass("btn-toggle") && $("#btn-toggle-" + t.type + "-" + s).toggle().find("input")[0].focus()
        }),
        this.bindHover(),
        this.commList.find(".reply-btn").livequery("click",
        function(e) {
            var i = $(e.target),
            s = i.attr("data-guid"),
            a = i.attr("data-replyId"),
            o = i.attr("data-nickname"),
            n = i.parents(".reply-input").find("input").val(),
            r = {};
            if (i.hasClass("reply-btn")) return t.currReply = i,
            n = n.replace(/</g, "<").replace(/>/g, ">"),
            a = i.hasClass("reply-btn-lz") ? "": a,
            r = {
                guid: s,
                content: n,
                replyId: a,
                nickname: o
            },
            "" === n.replace(/\s+/, "") ? (alert("\u8bf7\u8f93\u5165\u56de\u590d\u5185\u5bb9"), void 0) : (G.checkLogin(function(e) {
                e.IsAuthenticated ? t.reply(r) : (jdModelCallCenter.settings.fn = function() {
                    G.checkLogin(function(e) {
                        e.IsAuthenticated && t.reply(r)
                    })
                },
                jdModelCallCenter.login())
            }), void 0)
        })
    },
    reply: function(t) {
        var e = this,
        i = {
            mod: "Club2013.ProductCommentReply",
            action: "saveProductCommentReply",
            commentId: t.guid,
            content: t.content,
            parentId: t.replyId
        },
        s = t.content.replace(/[\u4e00-\u9fa5]/g, "XX");
        return "" === t.content.replace(/\s+/, "") ? (alert("\u8bf7\u8f93\u5165\u56de\u590d\u5185\u5bb9"), !1) : 1 > s.length || s.length > 800 ? (alert("\u56de\u590d\u5185\u5bb9\u5e94\u57281~400\u4e2a\u5b57\u4ee5\u5185"), !1) : ($.ajax({
            url: "http://club.jd.com/index.php?",
            data: i,
            dataType: "jsonp",
            success: function(i) {
                1 === i.status ? (i.data.nickname = t.nickname, e.setReplyItem(i.data)) : i.info && alert(i.info)
            }
        }), void 0)
    },
    setReplyItem: function(t) {
        var e, i = this,
        s = i.currReply.parents(".i-item").eq(0),
        a = s.find(".reply-lz"),
        o = this.currReply.parents(".item-reply").eq(0),
        n = a.next();
        t._type = this.type,
        t.commentReply.guid = s.attr("data-guid"),
        t.commentReply.index = e = n.length > 0 ? parseInt(n.attr("data-index"), 10) + 1 : 1,
        t.toname = o.attr("data-name"),
        t.touid = o.attr("data-uid");
        var r = '<div class="item-reply none" data-index="${commentReply.index}" data-name="${commentReply.nickname}" data-uid="${commentReply.uid}">			<strong>${commentReply.index}</strong>			<div class="reply-list">				<div class="reply-con">					<span class="u-name">						<a href="http://club.jd.com/userreview/${commentReply.uid}-1-1.html" target="_blank">${commentReply.nickname}{if commentReply.userClient==99}<b></b>{/if}</a>                      {if parseInt(commentReply.parentId, 10)>0}						<em>\u56de\u590d</em>                      <a target="_blank" href="http://club.jd.com/userreview/${touid}-1-1.html">{if parseInt(commentReply.parentId, 10)<0}{else}${toname}{/if}</a>{/if}\uff1a					</span>					<span class="u-con">${commentReply.content}</span>				</div>				<div class="reply-meta">					<span class="reply-left fl">${commentReply.creationTimeString.replace(/:[0-9][0-9]$/, "")}</span>					<a class="btn-toggle p-bfc" data-id="${commentReply.id}" href="#none">\u56de\u590d</a>				</div>				<div id="btn-toggle-${_type}-${commentReply.id}" class="replay-form none">					<div class="arrow">						<em>\u25c6</em><span>\u25c6</span>					</div>					<div class="reply-wrap">						<p><em>\u56de\u590d</em> <span class="u-name">${commentReply.nickname}\uff1a</span></p>						<div class="reply-input">							<div class="fl"><input type="text" /></div>							<a href="#none" class="reply-btn btn-gray p-bfc" data-guid="${commentReply.guid}" data-replyId="${commentReply.id}">\u56de\u590d</a>							<div class="clr"></div>						</div>					</div>				</div>			</div>		</div>';
        a.after($(r.process(t)).fadeIn()),
        this.commList.find(".btn-reply em").html(e),
        this.currReply.parents(".replay-form").eq(0).hide(),
        this.currReply.parents(".reply-input").find("input").val(""),
        this.bindReply()
    },
    getData: function(t, e, i) {
        var s = this;
        this.wrap = t,
        this.type = e,
        this.page = i,
        this.commRateLoaded = !1,
        this.url = "http://club.jd.com/productpage/p-{skuId}-s-{commType}-t-{sortType}-p-{currPage}.html",
        this.url = this.url.replace("{skuId}", this.sku).replace("{commType}", this.type).replace("{sortType}", this.sort).replace("{currPage}", this.page),
        $.ajax({
            url: this.url,
            dataType: "jsonp",
            success: function(t) {
                s.setData(t)
            }
        })
    },
    setData: function(t) {
        return t || (this.wrap.html("\u3000\u6682\u65e0\u8bc4\u8bba"), this.commRate.find(".mc").html("\u3000\u6682\u65e0\u8bc4\u8bba")),
        t.comments === void 0 ? (this.wrap.html('<div class="norecode"> \u6682\u65e0\u5546\u54c1\u8bc4\u4ef7\uff01</div>'), void 0) : (this.commRateLoaded === !1 && this.setCommRate($("#comment"), t), t._type = this.type, this.setCommentCount(t), this.wrap.html(newCommentList_TPL.process(t)), this.bindReply(), this.setPageNav(t), this.loadFirstPage = !0, void 0)
    },
    setPageNav: function(t) {
        var e = this,
        i = "";
        switch (this.type) {
        case 0:
            i = "commentCount";
            break;
        case 1:
            i = "poorCount";
            break;
        case 2:
            i = "generalCount";
            break;
        case 3:
            i = "goodCount";
            break;
        case 4:
            i = "showCount";
            break;
        default:
            i = "commentCount"
        }
        $("#commentsPage" + t.score).pagination(t.productCommentSummary[i], {
            items_per_page: 10,
            num_display_entries: 5,
            current_page: e.page,
            num_edge_entries: 2,
            link_to: "#comments-list",
            prev_text: "\u4e0a\u4e00\u9875",
            next_text: "\u4e0b\u4e00\u9875",
            ellipse_text: "...",
            prev_show_always: !1,
            next_show_always: !1,
            callback: function(i) {
                e.getData(e.wrap, t.score, i)
            }
        })
    },
    setCommentCount: function(t) {
        var e = this.commList.find(".tab li em"),
        i = t.productCommentSummary;
        e.eq(0).html("(" + i.commentCount + ")"),
        e.eq(1).html("(" + i.goodCount + ")"),
        e.eq(2).html("(" + i.generalCount + ")"),
        e.eq(3).html("(" + i.poorCount + ")"),
        e.eq(4).html("(" + i.showCount + ")")
    },
    setCommRate: function(t, e) {
        t.find(".mc").html(newCommentRate_TPL.process(e)),
        this.commRateLoaded = !0,
        this.commRate.show()
    }
},
Discuss = {
    getData: function(t, e) {
        var i = "http://club.jd.com/clubservice/newcomment-",
        s = "",
        e = e;
        switch (t) {
        case 0:
            s = "Club";
            break;
        case 1:
            s = "Order";
            break;
        case 2:
            s = "User";
            break;
        case 3:
            s = "Question";
            break;
        case 4:
            s = "Friend"
        }
        window.fetchJSON_Discuss = function(t) {
            e.html(discuss_TPL.process(t))
        },
        $.getJSONP(i + s + "-" + G.orginSku + ".html?callback=fetchJSON_Discuss")
    },
    setItem: function() {}
},
Consult = {
    getData: function(t, e) {
        window.fetchJSON_Consult = function(t) {
            e.html(consult_TPL.process(t))
        },
        $.getJSONP("http://club.jd.com/clubservice/newconsulation-" + G.orginSku + "-" + (t + 1) + ".html?callback=fetchJSON_Consult")
    },
    setExtraData: function(t, e) {
        $.jmsajax({
            url: "/newsserver.asmx",
            method: "PayExplain",
            data: {
                id: "A-product-0" + (t - 3)
            },
            success: function(t) {
                null != t && e.html(t)
            }
        })
    },
    search: function(t, e, i) {
        var s = "http://search.jd.com/sayword?",
        i = i || 0,
        t = t || G.orginSku,
        a = this;
        $.ajax({
            url: s,
            dataType: "jsonp",
            data: {
                wid: t,
                keyword: encodeURI(e),
                page: i,
                ps: 5
            },
            success: function(t) {
                var e = '<div class="clb"><div id="ReferPagenation" class="pagin fr none"></div></div>';
                if (t.length > 0) {
                    var s = 0 >= t[0].list.length || 0 >= t[0].total ? "\uff0c\u8bd5\u8bd5\u66f4\u7b80\u77ed\u7684\u5173\u952e\u8bcd\u6216\u66f4\u6362\u5173\u952e\u8bcd": "",
                    o = '<div id="consult-result" class="result clearfix"><div class="fl">\u5171\u641c\u7d22\u5230<strong>' + t[0].total + "</strong>\u6761\u76f8\u5173\u54a8\u8be2" + s + '\u3000<a id="backConsultations" href="#none">\u8fd4\u56de</a></div><div class="fr"><em>\u58f0\u660e\uff1a\u4ee5\u4e0b\u56de\u590d\u4ec5\u5bf9\u63d0\u95ee\u80053\u5929\u5185\u6709\u6548\uff0c\u5176\u4ed6\u7f51\u53cb\u4ec5\u4f9b\u53c2\u8003\uff01</em></div></div>';
                    if ($("#consult .tabcon:visible").html(o + "" + consult_search_TPL.process(t[0]) + e), 0 >= t[0].list.length || 0 >= t[0].total) return ! 1;
                    $("#ReferPagenation").show().pagination(t[0].total, {
                        items_per_page: 5,
                        num_display_entries: 5,
                        current_page: i - 1,
                        num_edge_entries: 0,
                        link_to: "#consult",
                        prev_text: "\u4e0a\u4e00\u9875",
                        next_text: "\u4e0b\u4e00\u9875",
                        ellipse_text: "...",
                        prev_show_always: !1,
                        next_show_always: !1,
                        callback: function(t) {
                            a.search(G.orginSku, $("#txbReferSearch").val(), t + 1, 6)
                        }
                    })
                }
            }
        })
    }
},
ProductTrack = function(t, e, i) {
    this.sRecent = t,
    this.sGuess = e,
    this.isBook = i || !1,
    $(this.sGuess).find("h2").html("\u6839\u636e\u6d4f\u89c8\u4e3a\u6211\u63a8\u8350")
};
ProductTrack.prototype = {
    hide: function() {
        $(this.sRecent).hide(),
        $(this.sGuess).hide()
    },
    getCommentData: function(t) {
        var e = this;
        $.ajax({
            url: "http://club.jd.com/clubservice.aspx?method=GetCommentsCount&referenceIds=" + t,
            dataType: "jsonp",
            success: function(t) {
                e.setCommentData(t)
            }
        })
    },
    setCommentData: function(t) {
        for (var e = t.CommentsCount.length,
        i = 0; e > i; i++) $("#g" + t.CommentsCount[i].SkuId).find(".star").removeClass("sa5").addClass("sa" + t.CommentsCount[i].AverageScore),
        $("#g" + t.CommentsCount[i].SkuId).find(".p-comm a").html("(\u5df2\u6709" + t.CommentsCount[i].CommentCount + "\u4eba\u8bc4\u4ef7)")
    },
    getData: function(t) {
        var t = t || "http://my." + pageConfig.FN_getDomain() + "/global/track.action?jsoncallback=?";
        return _this = this,
        $.ajax({
            url: t,
            dataType: "json",
            success: function(t) {
                _this.setContent(t)
            },
            error: function() {
                _this.hide()
            }
        }),
        this
    },
    setContent: function(t, e, i) {
        var s = " onclick=\"clsClickLog('', '', '${list.wid}', 3, ${list_index}, 'rodGlobalHis');\"",
        a = " onclick=\"clsClickLog('', '', '${list.wid}', 2, ${list_index}, 'rodGlobalTrack');\"";
        this.isBook && (s = " onclick=\"clsLog('${list.topNum}&HomeHis', '', '${list.wid}#${list.wMeprice}', ${list_index}, 'reWidsBookHis');\"", a = " onclick=\"clsLog('${list.topNum}&HomeTrack', '', '${list.wid}#${list.wMeprice}', ${list_index}, 'reWidsBookTrack');\"");
        var o = '<ul data-update="new">	{for list in history}    <li' + s + ">" + '        <div class="p-img">' + '            <a href="${list.productUrl}"><img src="${pageConfig.FN_GetImageDomain(list.wid)}n5/${list.imageUrl}" /></a>' + "        </div>" + '        <div class="p-name">' + '            <a href="${list.productUrl}">${list.wname}</a>' + "        </div>" + '        <div class="p-price">' + '            <img src="http://jprice.360buyimg.com/price/gp${list.wid}-1-1-1.png" onerror="this.src=\'http://misc.360buyimg.com/lib/skin/e/i/error-3.gif\'" />' + "        </div>" + "    </li>" + "    {/for}" + '	  <li class="all-recent" style="text-align:right;padding:5px 0;"><a href="http://my.' + pageConfig.FN_getDomain() + '/history/list.html" target="_blank" style="color:#005ea7;">\u5168\u90e8\u6d4f\u89c8\u5386\u53f2 <span style="font-family:simsun;">&gt;</span></a></li>' + "</ul>",
        n = '<span class="guess-control" id="guess-forward">&lt;</span><span class="guess-control" id="guess-backward">&gt;</span><div id="guess-scroll"><ul class="lh">{for list in guessyou}<li' + a + ' id="g${list.wid}">' + '	<div class="p-img">' + '		<a target="_blank" title="${list.wname}" href="${list.productUrl}"><img height="130" width="130" alt="${list.wname}" src="${pageConfig.FN_GetImageDomain(list.wid)}n3/${list.imageUrl}"></a>' + "	</div>" + '	<div class="p-name">' + '		<a target="_blank" title="${list.wname}" href="${list.productUrl}">${list.wname}</a>' + "	</div>" + '	<div class="p-comm">' + '		<span class="star sa5"></span><br/>' + '		<a target="_blank" href="http://club.jd.com/review/${list.wid}-1-1.html">(\u5df2\u67090\u4eba\u8bc4\u4ef7)</a>' + "	</div>" + '	<div class="p-price">' + '			<img src="http://jprice.360buyimg.com/price/gp${list.wid}-1-1-1.png" onerror="this.src=\'http://misc.360buyimg.com/lib/skin/e/i/error-3.gif\'" />' + "	</div>" + "</li>" + "{/for}" + "</ul></div>",
        r = e || o;
        if (null !== t.history && t.history.length > 0 ? ($(this.sRecent).find(".mc").html(r.process(t)), $(this.sRecent).find(".mt").append('<div class="extra"><a href="http://my.' + pageConfig.FN_getDomain() + '/history/list.html" target="_blank">\u66f4\u591a</a></div>'), this.isBook ? log("BOOK&HomeHis", "Show") : clsPVAndShowLog("", "", 3, "s")) : ($(this.sGuess).find("h2").html("\u672c\u5468\u70ed\u9500"), $(this.sRecent).find(".mc").html('<div class="no-track"><h4>\u60a8\u8fd8\u672a\u5728\u4eac\u4e1c\u7559\u4e0b\u8db3\u8ff9</h4><p>\u5728\u60a8\u7684\u8d2d\u7269\u65c5\u7a0b\u4e2d\uff0c\u60a8\u53ef\u4ee5\u968f\u65f6\u901a\u8fc7\u8fd9\u91cc\u67e5\u770b\u60a8\u4e4b\u524d\u7684\u6d4f\u89c8\u8bb0\u5f55\uff0c\u4ee5\u4fbf\u5feb\u6377\u8fd4\u56de\u60a8\u66fe\u7ecf\u611f\u5174\u8da3\u7684\u9875\u9762\u3002</p></div>')), null !== t.guessyou && t.guessyou.length > 0) {
            $(this.sGuess).find(".mc").html(n.process(t)),
            $(this.sGuess).find(".mt .extra").html('<a href="http://my.' + pageConfig.FN_getDomain() + '/personal/guess.html" target="_blank">\u66f4\u591a\u63a8\u8350</a>');
            var c = pageConfig.wideVersion && pageConfig.compatible ? 5 : 4;
            $("#guess-scroll").imgScroll({
                visible: c,
                step: c,
                prev: "#guess-forward",
                next: "#guess-backward"
            }),
            this.isBook ? log("BOOK&HomeTrack", "Show") : clsPVAndShowLog("", "", 2, "s");
            var d = [];
            $("#guess-scroll ul li").each(function() {
                d.push($(this).attr("id"))
            }),
            this.getCommentData(d.join(",").replace(/g/g, ""))
        } else $(this.sGuess).find(".mc").html('<div class="nothing">\u6682\u65e0\u63a8\u8350</div>')
    }
};
var Repository = {
    init: function(t) {
        var t = t || G.sku;
        this.t = null,
        this.getKeywords(),
        this.content = $(".detail-content").eq(0),
        this.tab = $("#product-detail .tab li").eq(5),
        this.tabCon = $("#product-detail-6"),
        this.tabCon.html('<div class="iloading">\u6b63\u5728\u52a0\u8f7d\u4e2d\uff0c\u8bf7\u7a0d\u5019...</div>'),
        this.getPracticalGuide(t)
    },
    setKeywords: function(t) {
        var e = (this.content.html(), $("body").eq(0)),
        i = '<b class="wiki-arr">\u25c7</b><div class="wiki-inner">  <dl><dt>${keyword}</dt>      <dd>${description}</dd>  </dl>  <div class="wiki-more"><a href="${href}" clstag="shangpin|keycount|product|xxjs" target="_blank">\u67e5\u770b\u8be6\u7ec6\u4ecb\u7ecd</a></div></div>',
        s = "";
        if (null !== t && t.length > 0) {
            for (var a = 0; t.length > a; a++) t[a].id = "wiki-keyword-" + a,
            this.content.html($(".detail-content").eq(0).html().replace(RegExp(t[a].keyword), '<span data-id="' + t[a].knid + '" class="wiki-words" id="' + "wiki-keyword-" + a + '" style="border-bottom:1px dotted;padding-bottom:2px;">' + t[a].keyword + "</span>")),
            s = i.process(t[a]),
            e.append($('<div class="wiki-pop hide" id="des-wiki-keyword-' + a + '">' + s + "</div>"));
            $("img[data-lazyload]").Jlazyload({
                type: "image",
                placeholderClass: "err-product"
            }),
            this.keyWordHover()
        }
    },
    log: function(t) {
        $.ajax({
            url: "http://wiki.jd.com/statistics/termFloat.action?",
            data: {
                id: t,
                t: +new Date
            },
            dataType: "script",
            cache: !0
        })
    },
    keyWordHover: function() {
        var t = this,
        e = $(".detail-content .wiki-words");
        $(".wiki-pop dl"),
        e.each(function() {
            var e = this.id,
            i = $(this).attr("data-id"),
            s = $(this);
            s.hover(function() {
                var s = $("#product-detail"),
                a = s.offset().left,
                o = s.outerWidth(),
                n = $(this).offset().left,
                r = n - a > o / 2 ? 310 : 110,
                c = n - a > o / 2 ? n - 300 : n - 100,
                d = $(this).offset().top,
                l = $(this).outerHeight();
                $("#des-" + e).length > 0 && ($("#des-" + e).show().css({
                    left: c,
                    top: d + l - 1
                }), $("#des-" + e).find("b").css({
                    marginLeft: r
                })),
                t.t = setTimeout(function() {
                    t.log(i)
                },
                500)
            },
            function(e) {
                var i = this.id,
                s = e.relatedTarget;
                return s.id == "des-" + i ? !1 : ($("#des-" + i).hide(), clearTimeout(t.t), void 0)
            }),
            $("#des-" + e).hover(function() {},
            function(t) {
                var i = t.relatedTarget;
                return i.id == "des-" + e ? !1 : ($(this).hide(), void 0)
            })
        })
    },
    getKeywords: function() {
        var t = this;
        $.ajax({
            url: "http://wiki.jd.com/product/" + G.sku + "/keywords.html",
            dataType: "jsonp",
            success: function(e) {
                t.setKeywords(e)
            }
        })
    },
    getPracticalGuide: function() {
        var t = this;
        $.ajax({
            url: "http://wiki.jd.com/product/" + G.sku + "/guide.html",
            dataType: "jsonp",
            success: function(e) {
                null !== e && e.length > 0 ? t.setPracticalGuide(e) : (t.tab.hide(), t.tabCon.html('<div class="tc p10">\u8be5\u5546\u54c1\u7684\u5b9e\u7528\u6307\u5357\uff0c\u7a0d\u540e\u652f\u6301\u3002</div>'))
            }
        })
    },
    setPracticalGuide: function(t) {
        var e = {};
        e.resList = t;
        var i = ' <div id="practical-guide" class="item-detail" data-widget="tabs">    <ul class="tab-sub">        {for item in resList}        <li data-widget="tab-item" clstag="shangpin|keycount|product|citiao" class="fore{if item_index==0} curr{/if}">${item.groupName}</li>        {/for}    </ul>    {for item in resList}    <ul data-widget="tab-content" class="tabcon-sub{if item_index!=0} hide{/if}">        {for list in item.pgList}        <li clstag="shangpin|keycount|product|citiao">\u00b7<span>[${item.groupName}]</span><a href="${list.url}" target="_blank">${list.name}</a></li>        {/for}    </ul>    {/for}</div>';
        this.tabCon.html(i.process(e)),
        $("#practical-guide").Jtab({
            event: "click",
            compatible: !0
        })
    }
};
if (function() {
    var t = function() {
        var t = "";
        try {
            t = window.top.document.referrer
        } catch(e) {
            if (window.parent) try {
                t = window.parent.document.referrer
            } catch(i) {
                t = ""
            }
        }
        return "" === t && (t = document.referrer),
        t
    };
    JDS = window.JDS || {},
    JDS.strpos = function(t, e, i) {
        var s = (t + "").indexOf(e, i || 0);
        return - 1 === s ? !1 : s
    },
    JDS.uri = function(t) {
        this.components = {},
        this.options = {
            strictMode: !1,
            key: ["source", "protocol", "authority", "userInfo", "user", "password", "host", "port", "relative", "path", "directory", "file", "query", "anchor"],
            q: {
                name: "queryKey",
                parser: /(?:^|&)([^&=]*)=?([^&]*)/g
            },
            parser: {
                strict: /^(?:([^:\/?#]+):)?(?:\/\/((?:(([^:@]*)(?::([^:@]*))?)?@)?([^:\/?#]*)(?::(\d*))?))?((((?:[^?#\/]*\/)*)([^?#]*))(?:\?([^#]*))?(?:#(.*))?)/,
                loose: /^(?:(?![^:@]+:[^:@\/]*@)([^:\/?#.]+):)?(?:\/\/)?((?:(([^:@]*)(?::([^:@]*))?)?@)?([^:\/?#]*)(?::(\d*))?)(((\/(?:[^?#](?![^?#\/]*\.[^?#\/.]+(?:[?#]|$)))*\/?)?([^?#\/]*))(?:\?([^#]*))?(?:#(.*))?)/
            }
        },
        t && (this.components = this.parseUri(t))
    },
    JDS.uri.prototype = {
        parseUri: function(t) {
            for (var e = this.options,
            i = e.parser[e.strictMode ? "strict": "loose"].exec(t), s = {},
            a = 14; a--;) s[e.key[a]] = i[a] || "";
            return s[e.q.name] = {},
            s[e.key[12]].replace(e.q.parser,
            function(t, i, a) {
                i && (s[e.q.name][i] = a)
            }),
            s
        },
        getHost: function() {
            return this.components.hasOwnProperty("host") ? this.components.host: void 0
        },
        getQueryParam: function(t) {
            return this.components.hasOwnProperty("queryKey") && this.components.queryKey.hasOwnProperty(t) ? this.components.queryKey[t] : void 0
        },
        isQueryParam: function(t) {
            return this.components.hasOwnProperty("queryKey") && this.components.queryKey.hasOwnProperty(t) ? !0 : !1
        }
    };
    var e = [{
        d: "baidu",
        q: "wd"
    },
    {
        d: "google",
        q: "q"
    },
    {
        d: "images.google",
        q: "q"
    },
    {
        d: "images.search.yahoo.com",
        q: "p"
    },
    {
        d: "sogou",
        q: "query"
    },
    {
        d: "soso",
        q: "w"
    },
    {
        d: "bing",
        q: "q"
    },
    {
        d: "youdao",
        q: "q"
    },
    {
        d: "114so",
        q: "kw"
    },
    {
        d: "zhongsou",
        q: "w"
    },
    {
        d: "yisou",
        q: "q"
    },
    {
        d: "lycos",
        q: "query"
    },
    {
        d: "lycos",
        q: "word"
    },
    {
        d: "yahoo",
        q: "q"
    },
    {
        d: "yahoo",
        q: "p"
    },
    {
        d: "search",
        q: "q"
    },
    {
        d: "live",
        q: "q"
    },
    {
        d: "aol",
        q: "query"
    },
    {
        d: "aol",
        q: "encquery"
    },
    {
        d: "aol",
        q: "q"
    },
    {
        d: "ask",
        q: "q"
    },
    {
        d: "cnn",
        q: "query"
    },
    {
        d: "teoma",
        q: "q"
    },
    {
        d: "yandex",
        q: "text"
    }],
    i = function(t) {
        for (var i = 0,
        s = e.length; s > i; i++) {
            var a = e[i].d,
            o = e[i].q,
            n = t.getHost(),
            r = t.getQueryParam(o);
            if (!JDS.strpos(n, "360buy") && JDS.strpos(n, a) && t.isQueryParam(o)) return {
                d: a,
                q: o,
                k: r
            }
        }
    };
    window.jdSref = t(),
    window.jdSuri = new JDS.uri(window.jdSref),
    window.searchEngineSource = i(window.jdSuri)
} (), jdSref && searchEngineSource) {
    var charset = "&encode=utf-8";
    if ("baidu" == searchEngineSource.d) {
        var refer = document.referrer;
        charset = /ie=utf-8/.test(refer) ? "&encode=utf-8": "&encode=gbk"
    } else charset = RegExp(searchEngineSource.d).test("soso#sogou") ? "&encode=gbk": "&encode=utf-8";
    
}
var shopInfo = {
    get: function(t, e) {
        pageConfig.product.popInfo ? e(pageConfig.product.popInfo) : (window.fetchShopInfo = function(t) {
            var i = {
                stock: {
                    D: t
                }
            };
            "function" == typeof e && e(i)
        },
        $.getJSONP("http://st.3.cn/gvi.html?callback=fetchShopInfo&type=popdeliver&skuid=" + t))
    }
},
EvaluateGrade = {
    init: function() {
        var t = this;
        1 > $("#brand-bar-pop").length || shopInfo.get(G.sku,
        function(e) {
            null != e.stock.D && (t.popInfo = e, e.stock.D && e.stock.D.vid && (t.getGradeDetail(e.stock.D.vid), t.getAddress(e.stock.D.vid)), t.setShopInfo(e), t.setGlobalBuy(e))
        })
    },
    bindEvent: function() {
        return $("#evaluate s").click(function() {
            $(this).toggleClass("fold"),
            $("#evaluate-detail").toggle()
        }),
        this
    },
    getAddress: function(t) {
        $.getJSONP("http://rms.shop.jd.com/json/pop/popcompany.action?callback=EvaluateGrade.setAddress&venderID=" + t)
    },
    setAddress: function(t) {
        var e = $("#online-service");
        t && (t.companyName || t.firstAddr || t.secAddr) && (e.after('<dl id="pop-company"><dt>\u516c\u53f8\u540d\u79f0\uff1a</dt><dd></dd></dl><dl id="pop-address"><dt>\u6240&nbsp;\u5728&nbsp;\u5730\uff1a</dt><dd></dd></dl>'), $("#pop-company dd").html(t.companyName), $("#pop-address dd").html(t.firstAddr + "&nbsp;" + t.secAddr), $("#online-service dt").css("margin-bottom", 10))
    },
    setGlobalBuy: function(t) {
        var e = $("#brand-bar-pop");
        t.stock.D.id && 7 == ("" + t.stock.D.id).length && t.stock.D.vid && 7 == ("" + t.stock.D.vid).length && e.prepend('<div id="global-buy"><em><img src="http://misc.360buyimg.com/product/skin/2012/i/haiwai.gif" alt="\u6d77\u5916\u8d2d\u8ba4\u8bc1\u5546\u5bb6" /></em></div>')
    },
    getGrade: function() {
        var t = $(".evaluate-grade"),
        e = $(".heart-red");
        return window.fetchJSON_Eva = function(i) {
            e.removeClass("h4").addClass("h" + Math.round(parseFloat(i.result))),
            t.html(parseFloat(i.result) + "\u5206")
        },
        $.getJSONP("http://club.jd.com/clubservice/merchantcomment/" + G.sku + ".html?callback=fetchJSON_Eva"),
        this
    },
    getGradeDetail: function(t) {
        $.getJSONP("http://rms.shop.jd.com/json/popscore/newscore.action?callback=EvaluateGrade.setGradeDetail&venderID=" + t)
    },
    setGradeDetail: function(t) {
        function e() {
            return t.resDescScore = 0 == t.avgDescScore ? 0 : Math.abs(100 * ((t.descScore - t.avgDescScore) / t.avgDescScore)),
            t.resExpressScore = 0 == t.avgExpressScore ? 0 : Math.abs(100 * ((t.expressScore - t.avgExpressScore) / t.avgExpressScore)),
            t.resQualityScore = 0 == t.avgQualityScore ? 0 : Math.abs(100 * ((t.qualityScore - t.avgQualityScore) / t.avgQualityScore)),
            t.resAfsScore = 0 == t.avgAfsScore ? 0 : Math.abs(100 * ((t.afsScore - t.avgAfsScore) / t.avgAfsScore)),
            t.descScore > t.avgDescScore ? t.descScoreTrends = 0 == t.avgDescScore ? "eva-eq": "eva-up": t.descScore == t.avgDescScore ? t.descScoreTrends = "eva-eq": t.descScore < t.avgDescScore && (t.descScoreTrends = "eva-down"),
            t.expressScore > t.avgExpressScore ? t.expressScoreTrends = 0 == t.avgExpressScore ? "eva-eq": "eva-up": t.expressScore == t.avgExpressScore ? t.expressScoreTrends = "eva-eq": t.expressScore < t.avgExpressScore && (t.expressScoreTrends = "eva-down"),
            t.qualityScore > t.avgQualityScore ? t.qualityScoreTrends = 0 == t.avgQualityScore ? "eva-eq": "eva-up": t.qualityScore == t.avgQualityScore ? t.qualityScoreTrends = "eva-eq": t.qualityScore < t.avgQualityScore && (t.qualityScoreTrends = "eva-down"),
            t.afsScore > t.avgAfsScore ? t.afsScoreTrends = 0 == t.avgAfsScore ? "eva-eq": "eva-up": t.afsScore == t.avgAfsScore ? t.afsScoreTrends = "eva-eq": t.afsScore < t.avgAfsScore && (t.afsScoreTrends = "eva-down"),
            t.title = "\u8ba1\u7b97\u89c4\u5219\uff1a(\u5546\u5bb6\u5f97\u5206-\u540c\u884c\u4e1a\u5e73\u5747\u5206)/\u540c\u884c\u4e1a\u5e73\u5747\u5206",
            t
        }
        var i = '<div id="evaluate-detail" class="m">      {if parseInt(totalScore)<1}      <div style="padding-bottom:10px">\u5356\u5bb6\u6682\u672a\u6536\u5230\u4efb\u4f55\u8bc4\u4ef7</div><style type="text/css">#brand-bar-pop #online-service{border-top:1px solid #ddd;}</style>      {else}    <div class="mt"><style type="text/css">#brand-bar-pop #evaluate{display:block;}</style>        <div class="fl">\u8bc4\u5206\u660e\u7ec6</div>        <div class="p-bfc" title="${title}">\u4e0e\u884c\u4e1a\u76f8\u6bd4</div>    </div>    <div class="mc">        <dl>            <dt>\u63cf\u8ff0\u76f8\u7b26\uff1a</dt>            <dd>                <span class="eva-grade" title="${descScore.toFixed(4)}">${descScore.toFixed(4).substr(0,4)}<b>\u5206</b></span>                <span class="eva-percent ${descScoreTrends}"  title="${title}"><s></s>{if descScoreTrends=="eva-eq"}-----{else}${resDescScore.toFixed(2)}%{/if}</span>            </dd>        </dl>        <dl>            <dt>\u9001\u8d27\u901f\u5ea6\uff1a</dt>            <dd>                <span class="eva-grade" title="${expressScore.toFixed(4)}">${expressScore.toFixed(4).substr(0,4)}<b>\u5206</b></span>                <span class="eva-percent ${expressScoreTrends}"  title="${title}"><s></s>{if expressScoreTrends=="eva-eq"}-----{else}${resExpressScore.toFixed(2)}%{/if}</span>            </dd>        </dl>        <dl>            <dt>\u5546\u54c1\u8d28\u91cf\uff1a</dt>            <dd>                <span class="eva-grade" title="${qualityScore.toFixed(4)}">${qualityScore.toFixed(4).substr(0,4)}<b>\u5206</b></span>                <span class="eva-percent ${qualityScoreTrends}"  title="${title}"><s></s>{if qualityScoreTrends=="eva-eq"}-----{else}${resQualityScore.toFixed(2)}%{/if}</span>            </dd>        </dl>        <dl class="evaluate-item-last">            <dt>\u552e\u540e\u670d\u52a1\uff1a</dt>            <dd>                <span class="eva-grade" title="${afsScore.toFixed(4)}">${afsScore.toFixed(4).substr(0,4)}<b>\u5206</b></span>                <span class="eva-percent ${afsScoreTrends}"  title="${title}"><s></s>{if afsScoreTrends=="eva-eq"}-----{else}${(resAfsScore).toFixed(2)}%{/if}</span>            </dd>        </dl><div class="line"></div>    </div>      {/if}</div>';
        if (null !== t) {
            1 > $("#evaluate s").length && $("#evaluate").append("<s></s>"),
            this.bindEvent();
            var s = e(),
            a = this.popInfo.stock && this.popInfo.stock.D ? "http://mall.jd.com/shopLevel-" + this.popInfo.stock.D.id + ".html": "#none";
            $(".evaluate-grade strong").html('<a href="' + a + '" target="_blank">' + (t.totalScore + "").substr(0, 3) + "</a>").attr("title", t.totalScore.toFixed(4)),
            $(".heart-red").removeClass("h5").addClass("h" + t.totalScore.toFixed(0)),
            $("#evaluate").after(i.process(s))
        }
    },
    setShopInfo: function(t) {
        t.stock.D.vender && t.stock.D.url && $("#seller dd a").html(t.stock.D.vender).attr({
            href: t.stock.D.url,
            title: t.stock.D.vender
        }),
        $("#enter-shop a").attr("href", t.stock.D.url),
        t.stock.D.linkphone && "" == $("#hotline dd").html() && ($("#hotline dd").html(t.stock.D.linkphone), $("#hotline").show())
    }
},
JdService = {
    init: function(t, e, i) {
        this.sku = t,
        this.resObj = {},
        this.currSku = null,
        this.obj = e || $("#choose-service .dd"),
        this.fn = i ||
        function() {},
        this.url = "",
        this.typeMap = {
            t2: "ycbs",
            t3: "ycbs",
            t4: "ycbs",
            t6: "ywbh",
            t7: "ywbh",
            t9: "yhdx"
        },
        this.TPL = '<div class="service-type-yb">    {for item in list}    <div class="item">        <b></b><i class="yb-ico-t${item.sortId}"></i>        <a href="#none" id="yb-pid-${item.platformPid}" data-type="${item.sortId}" data-sku="${item.platformPid}" title="${item.sortName} \uffe5${item.price}">${item.sortName} \uffe5${item.price}</a>    </div>    {/for}</div>',
        this.get()
    },
    bindEvent: function() {
        var t = this;
        this.obj.find(".service-type-yb .item a").bind("click",
        function() {
            var e = $(this),
            i = e.attr("data-sku"),
            s = (e.attr("data-type"), e.parent(".item"));
            s.hasClass("selected") ? (t.removeItem(i), t.removeCurrStyle(e)) : (t.addItem(i), t.addCurrStyle(e)),
            t.currSku = i,
            t.currEl = e,
            t.calResult()
        })
    },
    addCurrStyle: function(t) {
        var e = t.parents(".service-type").eq(0),
        i = e.find(".item");
        i.removeClass("selected"),
        t.parent(".item").eq(0).addClass("selected")
    },
    removeCurrStyle: function(t) {
        t.parent(".item").eq(0).removeClass("selected")
    },
    get: function() {
        var t = this;
        $.ajax({
            url: "http://d.360buy.com/yanbao2/get?skuId=" + this.sku,
            dataType: "jsonp",
            success: function(e) {
                e && t.set(e)
            }
        })
    },
    set: function(t) {
        var e = {
            list: t
        };
        e.list.length > 0 ? (this.obj.html(this.TPL.process(e)).parent().show(), pageConfig.product.hasYbInfo = !0) : this.obj.parent().hide(),
        this.bindEvent(),
        this.itemCount = e.list.length,
        this.insertMore()
    },
    insertMore: function() {
        var t = this.obj.find(".service-type-yb"),
        e = pageConfig.wideVersion && pageConfig.compatible ? 3 : 2;
        return 2 * e >= this.itemCount ? !1 : (t.after('<a class="more-services" href="#none">\u66f4\u591a\u4eac\u4e1c\u670d\u52a1<s></s></a>'), this.obj.find(".more-services").bind("click",
        function() {
            "yes" !== t.attr("data-more") ? (t.addClass("open"), t.attr("data-more", "yes"), $(this).find("s").addClass("fold")) : (t.removeClass("open"), t.removeAttr("data-more"), $(this).find("s").removeClass("fold"))
        }), void 0)
    },
    addItem: function(t) {
        this.resObj["p" + t] = t
    },
    removeItem: function(t) {
        this.resObj["p" + t] = null
    },
    calResult: function() {
        var t = this.resObj,
        e = [],
        i = [];
        for (var s in t) t[s] && (e.push(t[s]), i.push(t[s]));
        return "function" == typeof this.fn ? this.fn.apply(this, [e, this.currSku, this.currEl]) : void 0
    }
},
NotifyPop = {
    _saleNotify: "http://skunotify." + pageConfig.FN_getDomain() + "/pricenotify.html?",
    _stockNotify: "http://skunotify." + pageConfig.FN_getDomain() + "/storenotify.html?",
    init: function(t, e, i) {
        var s, a = this,
        o = G.serializeUrl(location.href),
        n = /from=weibo/.test(location.href) ? location.search.replace(/\?/, "") : "";
        /from=weibo/.test(location.href) && (s = o.param.type, this.setThickBox(s, n)),
        $(t + "," + e + "," + i).livequery("click",
        function() {
            var t, e = $(this).attr("id");
            return t = "notify-btn" == e || "notify-stock" == e ? 2 : 1,
            G.checkLogin(function(e) {
                e.IsAuthenticated ? (a._userPin = e.Name, a.setThickBox(t, n)) : (jdModelCallCenter.settings.fn = function() {
                    G.checkLogin(function(e) {
                        e.IsAuthenticated && (a._userPin = e.Name, a.setThickBox(t, n))
                    })
                },
                jdModelCallCenter.login())
            }),
            !1
        }).attr("href", "#none").removeAttr("target")
    },
    setThickBox: function(t, e) {
        var i, s, a, o = {
            skuId: pageConfig.product.skuid,
            pin: this._userPin,
            webSite: 1,
            origin: 1,
            source: 1
        },
        n = G.serializeUrl(location.href);
        /blogPin/.test(location.href) && (o.blogPin = n.param.blogPin),
        1 == t && (i = "\u964d\u4ef7\u901a\u77e5", s = this._saleNotify, a = 230),
        2 == t && (i = "\u5230\u8d27\u901a\u77e5", s = this._stockNotify, a = 180, o.storeAddressId = readCookie("ipLoc-djd")),
        s += e ? e: $.param(o),
        $.jdThickBox({
            type: "iframe",
            source: decodeURIComponent(s) + "&nocache=" + +new Date,
            width: 500,
            height: a,
            title: i,
            _box: "notify_box",
            _con: "notify_con",
            _title: "notify_title"
        })
    }
};
if ($(function() {
    var t = $("#recommend .tab");
    t.find("li").eq(0).attr("id", "th-fitting"),
    t.find("li").eq(1).attr("id", "th-hot"),
    t.find("li").eq(2).attr("id", "th-service").hide(),
    $("#th-fitting a").eq(0).text("\u63a8\u8350\u914d\u4ef6"),
    1 > $("#th-suits").length && ($("#th-fitting").after('<li data-widget="tab-item" class="none" id="th-suits"><a href="javascript:;">\u4f18\u60e0\u5957\u88c5</a></li>'), $("#tab-reco").after('<div id="tab-suits" class="mc none" data-widget="tab-content"> <div class="iloading">\u6b63\u5728\u52a0\u8f7d\u4e2d\uff0c\u8bf7\u7a0d\u5019...</div> </div>')),
    $("#j-im").addClass("djd-im").attr("href", "#none"),
    $("#btnReferSearch").attr("clstag", "shangpin|keycount|product|consult9"),
    $("#consult .tab li").each(function(t) {
        $(this).attr("clstag", "shangpin|keycount|product|consult0" + (t + 1))
    }),
    $("#summary-stock .dt").html("\u914d&nbsp;\u9001&nbsp;\u81f3\uff1a"),
    $("#view-bigimg").after('<div id="compare"><a class="btn-compare btn-compare-s" href="#none" id="comp_{sku}" skuid="{sku}"><span>\u5bf9\u6bd4</span></a></div>'.replace(/{sku}/g, G.sku)),
    pageConfig.FN_InitContrast(),
    G.getCommentNum(G.orginSku,
    function(t) {
        var e = $("#summary-grade .star"),
        i = $("#summary-grade .dd>a").eq(0);
        t && t.CommentCount !== void 0 ? (e.removeClass("sa0").addClass("sa" + t.AverageScore), i.html("(\u5df2\u6709" + t.CommentCount + "\u4eba\u8bc4\u4ef7)").css("float", "left")) : (e.removeClass("sa0").addClass("sa5"), i.html("(\u5df2\u67090\u4eba\u8bc4\u4ef7)").css("float", "left"))
    }),
    function() {
        $("#choose-result").length > 0 ? $("#choose-result").before('<li id="choose-service" class="hide"><div class="dt">\u4eac\u4e1c\u670d\u52a1\uff1a</div><div class="dd"></div></li>') : $("#choose-btns").length > 0 && $("#choose-btns").before('<li id="choose-service" class="hide"><div class="dt">\u4eac\u4e1c\u670d\u52a1\uff1a</div><div class="dd"></div></li>');
        var t = $("#choose-btn-append a"),
        e = t.attr("href"),
        i = $("#choose-result .dd"),
        s = $("#choose-result .dd").html();
        JdService.init(G.sku, $("#choose-service .dd"),
        function(a) {
            var o = "&ybId=" + a.join(","),
            n = $("#buy-num").val(),
            r = [];
            if (a.length > 0) {
                if (t.attr("href", e.replace(/pcount=\d+/, "pcount=" + n) + o), "none" !== i.css("display")) {
                    for (var c = 0; a.length > c; c++) r.push("<strong>\u201c" + $("#yb-pid-" + a[c]).text() + "\u201d</strong>");
                    i.html(s + "\uff0c" + r.join("\uff0c"))
                }
            } else t.attr("href", e.replace(/pcount=\d+/, "pcount=" + n)),
            i.html(s)
        })
    } (),
    $(".jqzoom").jqueryzoom({
        xzoom: 400,
        yzoom: 400,
        offset: 10,
        position: "left",
        preload: 1,
        lens: 1
    }),
    $("#summary-grade .dd").click(function() {
        var t = $("#comment");
        "true" !== $("#comment").attr("nodata") ? t.show() : $(document).scrollTop($("#comments-list").offset().top + $("#comments-list .mt").height())
    }),
    $("#spec-list li").mouseover(function() {
        var t = $(this).find("img"),
        e = t.attr("src"),
        i = $("#spec-list li").index($(this)),
        s = $(this).attr("data-video"),
        a = "http://cloud.letv.com/bcloud.html?uu=abcde12345&vu={V}&pu=12345abcde&auto_play=0&width=352&height=352";
        $("#spec-list img").removeClass("img-hover"),
        t.addClass("img-hover"),
        1 === i && s ? 1 > $("#le-video").length ? $("#preview").append('<iframe id="le-video" src="' + a.replace("{V}", s) + '" frameborder="0" scrolling="no" style="display:block; width:352px; height:352px; position:absolute; left:0; top:0; "></iframe>') : $("#le-video").show() : ($("#spec-n1 img").eq(0).attr({
            src: e.replace("/small/", "/normal/"),
            jqimg: e.replace("/small/", "/big/")
        }), $("#le-video").length > 0 && $("#le-video").hide())
    }),
    CommentListNew.init(G.sku),
    Recommend.init(pageConfig.product.type),
    Repository.init(G.sku),
    EvaluateGrade.init(),
    NotifyPop.init("#summary-price .dd a", "#notify-stock", ".btn-notice"),
    $(".spec-items").imgScroll({
        visible: 5,
        speed: 200,
        step: 1,
        loop: !1,
        prev: "#spec-forward",
        next: "#spec-backward",
        disableClass: "disabled"
    }),
    $("#recommend").Jtab({
        event: "click",
        compatible: !0
    }),
    $("#product-detail").Jtab({
        event: "click",
        compatible: !0
    },
    function(t, e, i) {
        $("#product-detail .mt").removeClass("nav-fixed"),
        $("#product-detail .mt").removeClass("nav-fixed").floatNav({
            fixedClass: "nav-fixed",
            targetEle: "#consult",
            anchor: "#product-detail",
            range: 30,
            onStart: function() {
                $("#nav-minicart").show()
            }
        }),
        3 == i ? (e.css("height", 5).html("<div>a</div>"), $("#promises,#state").hide(), Consult.getData(0, $("#consult-0")), CommentListNew.loadFirstPage || CommentListNew.getData($("#comment-0"), 0, 0), $("#product-detail .mt").floatNav({
            fixedClass: "nav-fixed",
            targetEle: "#consult",
            anchor: "#product-detail",
            range: 0,
            onStart: function() {
                $("#nav-minicart").show()
            }
        })) : $("#promises,#state").show()
    }),
    $("#comments-list").Jtab({
        event: "click",
        compatible: !0
    },
    function(t, e, i) {
        var s = 0;
        s = 1 === i ? 3 : 3 === i ? 1 : i,
        CommentListNew.getData(e, s, 0)
    }),
    $("#discuss").Jtab({
        event: "click",
        compatible: !0
    },
    function(t, e, i) {
        Discuss.getData(i, e)
    }),
    $("#consult").Jtab({
        event: "click",
        compatible: !0
    },
    function(t, e, i) {
        4 >= i ? Consult.getData(i, e) : Consult.setExtraData(i, e)
    }),
    mlazyload({
        defObj: "#consult",
        defHeight: 0,
        fn: function() {
            Consult.getData(0, $("#consult-0"))
        }
    }),
    mlazyload({
        defObj: "#comments-list",
        defHeight: 0,
        fn: function() {
            CommentListNew.loadFirstPage || CommentListNew.getData($("#comment-0"), 0, 0)
        }
    }),
    mlazyload({
        defObj: "#discuss",
        defHeight: 0,
        fn: function() {
            Discuss.getData(0, $("#discuss-1"))
        }
    }),
    mlazyload({
        defObj: "#comments",
        defHeight: 0,
        fn: function() {
            CommentListNew.loadFirstPage || CommentListNew.getData($("#comment-0"), 0, 0)
        }
    }),
    $("#ranklist .mc").Jtab({
        compatible: !0
    }),
    $("#product-detail .mt").floatNav({
        fixedClass: "nav-fixed",
        targetEle: "#consult",
        anchor: "#product-detail",
        range: 30,
        onStart: function() {
            var t = $(".nav-minicart-buynow");
            t.length > 0 && t.find("a").html("\u7acb\u5373\u8d2d\u4e70"),
            $("#nav-minicart").show()
        }
    }),
    $("#nav-minicart").Jdropdown(function(t) {
        var e = pageConfig.product.priceImg || "http://jprice.360buyimg.com/price/gp" + G.sku + "-1-1-1.png";
        t.find(".nav-minicart-btn a").attr("href", $("#choose-btn-append .btn-append").attr("href")),
        t.find(".p-img img").attr("src", pageConfig.FN_GetImageDomain(G.sku) + "n4/" + pageConfig.product.src),
        t.find(".p-name").html(G.name),
        t.find(".p-price img").attr("src", e)
    }),
    $("#store-selector").Jdropdown(),
    $(".share-ft").click(function() {
        $(this).toggleClass("share-ft-open"),
        $(this).parents("#share-list").toggleClass("share-list-open"),
        $(".share-list-item").toggleClass("share-list-item-all")
    }),
    $("#comments-list .tab").append('<li class="tab-last"></li>'),
    pageConfig.product.renew && $.ajax({
        url: "http://d.360buy.com/oldfornew/get?skuId=" + pageConfig.product.skuid,
        dataType: "jsonp",
        success: function(t) {
            var e = '<div class="renew-arrgrment" style="line-height:200%;height:190px;overflow-y:auto;">    <p>\u5c0a\u656c\u7684\u5ba2\u6237\uff1a</p>    <p>\u60a8\u597d\uff01\u6b22\u8fce\u60a8\u53c2\u52a0\u4eac\u4e1c\u5546\u57ce\u201c\u7535\u8111\u4ee5\u65e7\u6362\u65b0\u201d\u6d3b\u52a8\u3002\u4e3a\u4e86\u4fdd\u8bc1\u60a8\u80fd\u591f\u6b63\u5e38\u4eab\u53d7\u4ee5\u65e7\u6362\u65b0\u6d3b\u52a8\u4f18\u60e0\uff0c\u8bf7\u60a8\u4ed4\u7ec6\u9605\u8bfb\u4ee5\u4e0b\u6d3b\u52a8\u7ec6\u5219\uff0c\u786e\u8ba4\u65e0\u8bef\u540e\u518d\u63d0\u4ea4\u4ee5\u65e7\u6362\u65b0\u8ba2\u5355\u3002</p>     <ul>        <li>1. \u6d3b\u52a8\u53c2\u4e0e\u5730\u533a\uff1a\u6240\u6709\u4eac\u4e1c\u81ea\u8425\u914d\u9001\u8986\u76d6\u8303\u56f4\uff0c\u5177\u4f53\u8303\u56f4\u8bf7\u67e5\u770b\u4eac\u4e1c\u5e2e\u52a9\u4e2d\u5fc3\uff1b</li>        <li>2. \u4eac\u4e1c\u5546\u57ce\u53c2\u52a0\u6d3b\u52a8\u4ea7\u54c1\uff1a\u4ee5\u4ea7\u54c1\u9875\u9762\u4fe1\u606f\u663e\u793a\u4e3a\u51c6\uff1b</li>        <li>3. \u60a8\u53c2\u52a0\u4ee5\u65e7\u6362\u65b0\u7535\u8111\u8981\u6c42\uff1a\u4efb\u4f55\u54c1\u724c\uff0c\u53ef\u4ee5\u6b63\u5e38\u5f00\u673a\u7684\u7b14\u8bb0\u672c\u7535\u8111\uff1b\u4e0d\u7b26\u5408\u6b64\u6807\u51c6\u7684\u65e7\u7535\u8111\uff0c\u4e0d\u80fd\u53c2\u4e0e\u201c\u4ee5\u65e7\u6362\u65b0\u201d\u6d3b\u52a8\uff1b</li>        <li>4. \u5177\u4f53\u6d3b\u52a8\u89c4\u5219\uff1a\u4ee5\u4eac\u4e1c\u5546\u57ce\u7f51\u7ad9\u9875\u9762\u516c\u793a\u4e3a\u51c6\uff1b</li>        <li>5. \u7b7e\u7f72\u6587\u4ef6\uff1a\u4eac\u4e1c\u5546\u57ce\u7535\u8111\u4ee5\u65e7\u6362\u65b0\u89c4\u5219\u7b7e\u6536\u5355\uff0c\u60a8\u9700\u4e0e\u4ea7\u54c1\u7b7e\u6536\u5355\u4e00\u5e76\u7b7e\u6536\uff1b</li>        <li>6. \u9000\u6362\u8d27\u6d41\u7a0b\uff1a\u53c2\u52a0\u6b64\u201c\u4ee5\u65e7\u6362\u65b0\u201d\u65b9\u5f0f\u8d2d\u4e70\u7684\u7b14\u8bb0\u672c\u7535\u8111\u5982\u7533\u8bf7\u9000\u8d27\uff0c\u4eac\u4e1c\u4ec5\u6309\u7167\u6d88\u8d39\u8005\u5b9e\u9645\u652f\u4ed8\u91d1\u989d\u9000\u6b3e\uff0c\u4eac\u4e1c\u4e0d\u518d\u5411\u6d88\u8d39\u8005\u8fd4\u8fd8\u65e7\u7b14\u8bb0\u672c\u7535\u8111\u3002</li>    </ul></div><div class="renew-btn">    <a href="#none" class="css3-btn">\u540c\u610f\u534f\u8bae\u5e76\u52a0\u5165\u8d2d\u7269\u8f66</a></div>';
            t && t.isOldForNew && ($("#choose-btns").prepend('<div id="choose-btn-renew" class="btn"><a href="javascript:;" class="btn-renew">\u53c2\u52a0\u4ee5\u65e7\u6362\u65b0<b></b></a></div>'), $("#choose-btn-renew").jdThickBox({
                type: "text",
                width: 570,
                height: 240,
                title: "\u4ee5\u65e7\u6362\u65b0\u534f\u8bae",
                _title: "renew_agreement_title",
                source: e,
                _con: "renew_aggrement",
                _close: "close_me"
            },
            function() {
                $(".renew-btn .css3-btn").attr("href", "http://trade.jd.com/order/getOrderInfo.action?pid=" + pageConfig.product.skuid + "&pcount=" + $("#buy-num").val() + "&rid=" + +new Date)
            }))
        }
    }),
    /from=email/.test(location.href) && $.getScript("http://misc.360buyimg.com/product/js/2012/notify.js",
    function() {
        Notify && Notify.init("#summary-price .dd a", "#notify-stock")
    }),
    $("#preview").hover(function() {
        $(".Jtips").hide()
    },
    function() {
        $(".Jtips").show()
    }),
    mark(G.sku, 1),
    clsPVAndShowLog("", "", 3, "p"),
    clsPVAndShowLog("", "", 2, "p"),
    function() {
        var t = "";
        G.isJd && 6980 !== G.cat[2] && (t += '<div id="feature-service-extra" class="i-mc"></div>'),
        (655 == G.cat[2] || 762 == G.cat[2] || 828 == G.cat[1]) && (t += '<div class="i-mc"><b>\u97f3\u4e50\u4e0b\u8f7d\u670d\u52a1</b> - \u6d77\u91cf\u6b63\u7248\u97f3\u4e50\uff0c\u9876\u7ea7\u97f3\u4e50\u4eab\u53d7\uff01<a href="http://music.jd.com/" target="_blank">\u67e5\u770b&gt;&gt;</a></div>'),
        "" != t && $("#tab-services").html(t)
    } (),
    function() {
        var t, e = [],
        i = window.location.href + "?sid=";
        i = readCookie("pin") ? i + readCookie("pin") : i,
        e.push('<div class="model-prompt model-partake"><div class="form"><label>\u5546\u54c1\u94fe\u63a5\uff1a</label><input type="text" class="text" value=\''),
        e.push(i),
        e.push("'/></div>"),
        $.browser.msie ? (e.push('<div class="ac"><input type="button" class="btn-copy" value="\u590d\u5236\u5e76\u53d1\u7ed9\u6211\u7684\u597d\u53cb" onclick="window.clipboardData.setData(\'Text\',\'' + i + "');$('.model-partake').html('\u5546\u54c1\u94fe\u63a5\u5730\u5740\u5df2\u7ecf\u590d\u5236\uff0c\u60a8\u53ef\u4ee5\u7c98\u8d34\u5230QQ\u3001MSN\u6216\u90ae\u4ef6\u4e2d\u53d1\u9001\u7ed9\u597d\u53cb\u4e86!')\"></div>"), t = 90) : (e.push('<div class="i-con">\u60a8\u7684\u6d4f\u89c8\u5668\u4e0d\u652f\u6301\u81ea\u52a8\u590d\u5236\u529f\u80fd\u3002\u60a8\u53ef\u4ee5\u6309\u4f4fCtrl+C\uff0c\u5c06\u5546\u54c1\u94fe\u63a5\u5730\u5740\u590d\u5236\u4e0b\u6765\u3002</div>'), t = 110),
        e.push("</div>"),
        e = e.join(""),
        $("#site-qq").jdThickBox({
            type: "text",
            width: 400,
            height: t,
            source: e,
            _fastClose: !0
        }),
        $("#site-qqmsn").jdThickBox({
            type: "text",
            width: 400,
            height: t,
            source: e,
            _fastClose: !0
        }),
        $(".share-list-item a").click(function() {
            var t = this.id;
            if (pageConfig.product.realPrice) switch (t) {
            case "site-sina":
                jdPshowRecommend("http://v.t.sina.com.cn/share/share.php?appkey=2445336821", "sina");
                break;
            case "site-qzone":
                jdPshowRecommend("http://v.t.qq.com/share/share.php?source=1000002&site=http://www.jd.com", "qzone");
                break;
            case "site-renren":
                jdPshowRecommend("http://share.renren.com/share/buttonshare/post/1004?", "renren");
                break;
            case "site-kaixing":
                jdPshowRecommend("http://www.kaixin001.com/repaste/share.php?", "kaixing");
                break;
            case "site-douban":
                jdPshowRecommend("http://www.douban.com/recommend/?", "douban");
                break;
            case "site-msn":
                jdPshowRecommend("http://profile.live.com/badge/?", "MSN");
                break;
            case "site-email":
                window.open("http://club.jd.com/jdFriend/tjyl.aspx?product=" + G.sku)
            } else window.getNumPriceService = function(e) {
                switch (e.jdPrice.amount && (pageConfig.product.realPrice = e.jdPrice.amount), t) {
                case "site-sina":
                    jdPshowRecommend("http://v.t.sina.com.cn/share/share.php?appkey=2445336821", "sina");
                    break;
                case "site-qzone":
                    jdPshowRecommend("http://v.t.qq.com/share/share.php?source=1000002&site=http://www.jd.com", "qzone");
                    break;
                case "site-renren":
                    jdPshowRecommend("http://share.renren.com/share/buttonshare/post/1004?", "renren");
                    break;
                case "site-kaixing":
                    jdPshowRecommend("http://www.kaixin001.com/repaste/share.php?", "kaixing");
                    break;
                case "site-douban":
                    jdPshowRecommend("http://www.douban.com/recommend/?", "douban");
                    break;
                case "site-msn":
                    jdPshowRecommend("http://profile.live.com/badge/?", "MSN");
                    break;
                case "site-email":
                    window.open("http://club.jd.com/jdFriend/tjyl.aspx?product=" + G.sku)
                }
            },
            $.ajax({
                url: "http://jprice.jd.com/price/np" + G.sku + "-TRANSACTION-J.html",
                dataType: "jsonp"
            })
        })
    } (),
    function() {
        var t = $(".detail-correction"),
        e = t.find("a").eq(0).attr("href"),
        i = "";
        if (e) var i = e.replace(/skuid=\d+/, "skuid=" + G.sku);
        t.length > 0 && t.html('<div class="detail-correction"> <b></b>\u5982\u679c\u60a8\u53d1\u73b0\u5546\u54c1\u4fe1\u606f\u4e0d\u51c6\u786e\uff0c<a href="' + i + '" target="_blank">\u6b22\u8fce\u7ea0\u9519</a></div>')
    } ()
}), setImButton(), window.pageConfig) {
    
}
if (function() {

    1315 === G.cat[0] && $("#Ad2_100_2272").length > 0 && $.ajax({
        url: "http://fa.jd.com/loadFa.js?aid=2_100_2272",
        dataType: "script",
        cache: !0
    }),
    $.ajax({
        url: "http://counter.360buy.com/aclk.aspx?key=p" + G.sku,
        dataType: "script",
        cache: !0
    })
} (), 1467 !== G.cat[1]) {
    var _mvq = _mvq || [];
    _mvq.push(["$setAccount", "m-9-1"]),
    _mvq.push(["$setGeneral", "goodsdetail", "", "", ""]),
    _mvq.push(["$addGoods", "", "", "", G.sku + ""]),
    _mvq.push(["$logData"])
}
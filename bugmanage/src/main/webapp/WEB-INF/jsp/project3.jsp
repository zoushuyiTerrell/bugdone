<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="com.qcit.model.ProjectVo" %>
<%@ page import="com.qcit.model.SimpleProblemVo"%>
<%@ page import="com.qcit.util.DateUtil"%>
<%@ page import="com.qcit.util.StringUtil"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
   <meta charset="utf-8">
		<link rel="stylesheet" type="text/css" href="../css/iconfont.css"/>
		<link rel="stylesheet" type="text/css" href="../css/animate.css"/>
		<link rel="stylesheet" type="text/css" href="../css/base.css"/>
		<link rel="stylesheet" href="../css/layer.css" type="text/css">
		<link rel="stylesheet" type="text/css" href="../css/bugdone.css"/>
		<link rel="stylesheet" type="text/css" href="../css/animate.min.css"/>
		<link rel="stylesheet" type="text/css" href="../css/bugdone1.css"/>
		<link rel="stylesheet" type="text/css" href="../css/nprogress.css"/>
		<script src="../js/jquery-3.2.1.min.js"></script>
		<title>工作台-所有问题</title>
</head>
<body class="of-hidden">
<input type="hidden" id="hidtype" value="1" />
    <input type="hidden" id="txtProjectId" value="" />
    <input type="hidden" id="txtNeedRefesh" value="0" />
    <input type="hidden" id="hidCurrentUserId" value="" />
    <div class="header bg-white">
        <div class="logo f-l" style="cursor: pointer;" onclick="window.location.href='https://www.bugdone.cn/home'">
            <img src="../首页image/logo.png" alt="BUGDONE" />
        </div>
        <div class="head-nav f-l color-8">
            <span class="color-2 f-l p-relative cursorpointer" onclick="backToConsole();" >
               <i class="iconfont icon-arrow-right f-r"></i><i class="iconfont icon-liebiao" style="font-size: 1rem; margin-left: -1.4rem;"> </i> 项目        
            			</span>
            <span class="color-2 f-l p-relative" id="hoverShow1">
                <strong><i class="iconfont icon-arrow-copy p-absolute"></i><label></label></strong>
                <div class="show-box2 p-absolute bg-white bd-e2 b-radius4 d-none" id='showlist' style='max-height:400px;overflow:auto;'>
                </div>
            </span>
            <p class="search f-l p-relative">
                <input name="" id='seartxt' type="text" class="textbox" onkeypress="return check()"  value="根据编号、标题、模块搜索" onblur="this.value=(this.value=='')?'根据编号、标题、模块搜索':this.value" onfocus="this.value=(this.value=='根据编号、标题、模块搜索')?'':this.value">
                <input name="" type="button" class="iconfont search-btn p-absolute color-8" onclick='search()' value="">
            </p>
            <span style="color:red"></span>
        </div>

        <div class="user-info f-r p-relative" id="hoverShow2">
            <div class="avatar p-absolute loaduserdiv">
            
                            <i class="online-status" id="bugtalkStatus"></i>
                <img id="imgUser" src="../image/22.png" alt="" class='loaduser' />
                <style>
                    .loaduser{width:100% !important;height:100% !important;}
                    .loaduserdiv{top:5px !important;left:10px !important;}
                    .online-status{width: 8px;height: 8px;border-radius: 50%;border: 2px solid #fff;position: absolute;right: -10px; top: 0;background: #1ab064}
                    .online-status-off{background:#ababab}
                </style>
            </div>
            <div class="name fz-14 fw-bold p-relative">
                <i class="iconfont icon-arrow-copy p-absolute"></i>
                <div id="lblUser" style='min-width:44px;min-height:10px'>${user.username }</div>
                <div id="userinfo" class="show-box p-absolute bg-white bd-e2 b-radius4 d-none fz-14">
                    <div class="avatar1 p-absolute" onclick="changePhoto();">
                        <img id="imgUserEdit" src="" alt="" />
                       
                        <span class="changeBj" style="display: none;"></span>
                        <span class="changeTxt" style="display: none;">修改头像</span>
                    </div>
                    <br>
                    <a href="javascript:void(0)" onclick="changeUserEmail();" class="logout"><i class="iconfont icon-youxiang"></i>修改邮箱</a>
                    <a href="javascript:void(0)" onclick="changeUserName();"><i class="iconfont icon-name"></i>修改姓名</a>
                    <a href="javascript:void(0)" onclick="changeUserPassword();"><i class="iconfont icon-lock"></i>修改密码</a>
                    <a href="javascript:void(0)" onclick="openlogin();" class="logout"><i class="iconfont icon-shouji"></i>手机登陆</a>
                    <a href="javascript:void(0)" onclick="logout();"><i class="iconfont icon-tuichu"></i>退出</a>
                </div>
            </div>
        </div>
        <div class="f-r notice p-relative" style='display:none'>
            <span class="num textbg-1 ta-center p-absolute">2</span>
            <a href="#" title="消息"><i class="iconfont icon-tongzhi"></i></a>
            </div>
            <!--关于-->
            <div class="f-r">
            	<i class="iconfont icon-banben" onClick="aboutClick()" style="margin: -0.2rem 1.5rem;"  title="关于BugDone"></i>
            </div>
            <div class="f-r">
                <i class="iconfont icon-huiyuanquanyi" id="userPackage" onClick="packageClick()" title="了解付费版本"></i>
            </div>
            <!--二维码-->
            <div class="f-r shouji">
                <i class="iconfont icon-shouji" style="margin: -0.2rem 1.9rem 0 .5rem;font-size: 24px;line-height:64px;cursor:pointer;" onclick='opencode()' title="扫一扫"></i>
            </div>
                        <!--新消息-->
            <div class="f-r chardiv">
                <i class="iconfont icon-chat1" style="margin: -0.2rem 1rem 0 .5rem;font-size: 24px;line-height:65px;cursor:pointer;" onclick='getchat()' title="暂无新消息"></i>
            </div>
                    <!--二维码弹出窗-->
        <style>
            .code-grag-bg{width:100%;height:100%; position:fixed; background:url(../首页image/rgba0_25.png);left:0;top:0; z-index:90;}
            .code-system{width:410px; position:absolute;top:50%;height:13rem; overflow:hidden;margin-top:-160px;left:50%;margin-left:-305px; background:#fff; z-index:99;border-radius:6px;padding:3rem 0 0 3rem}
            .code-system .icon-guanbi1{ font-size:24px; position:absolute;right:10px;top:20px; cursor:pointer;}
            .code-system .icon-guanbi1:hover{color:#264d79;}
            .imgdiv{float:left}
            
            .filter li .box label{overflow:hidden;text-overflow:ellipsis;white-space: nowrap; }
        </style>
        <div class="code-grag-bg d-none" onClick="closecode()"></div>
        <div class="code-system d-none" style='width:580px'>
            <i class="iconfont icon-guanbi1 color-8" onclick="closecode()" style="margin-right: 20px;"></i>
            <div class='imgdiv'><img src='/image/phonebugdone.png' style='width:10rem'><span style='position: absolute;top: 13.5rem;left: 5rem;'>bugdone手机端</span></div>
            <div style="float:left;border: 1px solid #0c8bb5;height: 11rem;margin: 0 1rem;"></div>
            <div class='imgdiv'><img src='/image/weichatcode.png' style='width:10rem'><span style='position: absolute;top: 13.5rem;left: 17.6rem;'>bugdone公众号</span></div>
            <div style="float:left;border: 1px solid #0c8bb5;height: 11rem;margin: 0 1rem;"></div>
            <div class='imgdiv'><img src='/image/xiaochengxu.jpg' style='width:10rem'><span style='position: absolute;top: 13.5rem;right: 4.1rem;'>bugdone小程序</span></div>
        </div>
        <!--手机登录弹出窗-->
        <style>
            .login-grag-bg{width:100%;height:100%; position:fixed; background:url(../首页image/rgba0_25.png);left:0;top:0; z-index:90;}
            .login-system{width:200px; position:absolute;top:50%;height:12rem; overflow:hidden;margin-top:-160px;left:60%;margin-left:-305px; background:#fff; z-index:99;border-radius:6px;padding:3rem 0 .5rem 2.2rem}
            .login-system .icon-guanbi1{ font-size:24px; position:absolute;right:10px;top:20px; cursor:pointer;}
            .login-system .icon-guanbi1:hover{color:#264d79;}
        </style>
        <div class="login-grag-bg d-none" onClick="closelogin()"></div>
        <div class="login-system d-none">
            <i class="iconfont icon-guanbi1 color-8" onclick="closelogin()" style="margin-right: 20px;"></i>
            <div class='imgdiv'><img id='logincodeimg' src='' style='width:10rem'><span style="position: absolute;top: 13.5rem;padding: 0 1.5rem;left: .7rem;">该登录二维码含有您的个人信息，请勿转发给其它用户。</span></div>
        </div>
        <!--关于弹出窗-->
        <style>
            .about-grag-bg,.package-grag-bg{width:100%;height:100%; position:fixed; background:url(../首页image/rgba0_25.png);left:0;top:0; z-index:90;}
        </style>
        <div class="about-grag-bg d-none" onClick="closeAbout()"></div>
        <div class="about-system d-none">
            <div class="logo"><img src="../首页image/logo.png" style="display: initial;" /></div>
            <div class="info">
            	<i class="iconfont icon-guanbi1 color-8" onClick="closeAbout()" style="margin-right: 20px;"></i>
            	<h1>BUGDONE，bug管理系统</h1>
                <p>版本号：V1.8.28</p>
                <p><a href="/newslist/" class="button">版本更新日志</a></p>
                <p class="copyright">苏州德微信息科技有限公司版权所有<br />bugdone.cn</p>
            </div>
        </div>     
        <div class="package-grag-bg d-none" onClick="closePackage()"></div>
        <div class="package-system d-none">
            <div class="logo"><img src="/Templates/Default/images/logo.png" style="display: initial;" /></div>
            <div class="info">
                <i class="iconfont icon-guanbi1 color-8" onClick="closePackage()" style="margin-right: 20px;"></i>
            	<h1>BugDone现已永久免费</h1>         
                <p style="height: 40px;line-height: 40px;margin: 15px 0px 50px 0px;color:#264d79">无限项目数、无限成员数，无限bug数</p>
                <p class="copyright">如有疑问欢迎联系BugDone团队<br />Email：support@bugdone.cn</p>
            </div>
        </div>
        <!--        
        <div class="f-r notice p-relative">
            <span class="num textbg-1 ta-center p-absolute">2</span>
            <a href="#" title="消息"><i class="iconfont icon-tongzhi"></i></a>
        </div>
        -->
    </div>
    <input type="hidden" value="currentPage" id="bugtalkOnlinePage"/>
    <!--header-->
    
 
  
    <div class="projectIndex p-relative of-hidden">
        

    <style>
        #project-left{height:100% !important}
    </style>
    <div class="left p-absolute bg-white" id="project-left" style='border-right:none;overflow: auto;'>
            <div class="project-logo p-relative" style='min-height:54px'>
                <a  href="javascript:void(0)" onclick="changeSetting();" class="setup p-absolute color-8" title="设置"><i class="iconfont icon-iconshezhi01"></i></a>
                <img id="imgProjectImg" src="../首页image/logoshort0.png" class="d-block of-hidden projectpics" />
                <style>
                    .projectpics{width: 30%;height: 30% !important;margin-top: 16px !important;}
                     .screen1{line-height:300% !important;height:300% !important;}
                    .screen2{margin-top:6% !important}
                    .screen3{margin:7% 15px 0px 0px !important}
                    .rightshow{padding:0 20px}
                </style>
            </div>
            <div class="menu fz-14">
                <ul>
                    <li class="on">
                    	<a href="project1?id=${itemsid}&&actionnumber=${actionnumber }&&problemnumber=${problemnumber}">
                    		<i class="icon-gk"></i>项目概况
                    	</a>
                    </li>
                    <li>
                    	<a href="project2?id=${itemsid}&&actionnumber=${actionnumber }&&problemnumber=${problemnumber}">
                    		<span class="num f-r n-bg1" id="lblUnsolvedProblemNum">${problemnumber }</span>
                    		<i class="icon-wt"></i>活动问题
                    	</a>
                    </li>
                    <li>
                    	<a href="project3?id=${itemsid}&&actionnumber=${actionnumber }&&problemnumber=${problemnumber}">
                    		<i class="icon-all"></i>所有问题
                    	</a>
                    </li>
                    <li>
                    	<a href="project4?id=${itemsid}&&actionnumber=${actionnumber }&&problemnumber=${problemnumber}">
                    		<i class="icon-tongji"></i>问题统计
                    	</a>
                    </li>
                </ul>
                <ul>
                    <li>
                    	<a href="project5?id=${itemsid}&&actionnumber=${actionnumber }&&problemnumber=${problemnumber}">
                    		<span class="num f-r n-bg2" id="lblMyToDoProblemNum">${actionnumber}</span>
                    		<i class="icon-daiban"></i>我的待办
                    	</a>
                    </li>
                    <li>
                    	<a href="project6?id=${itemsid}&&actionnumber=${actionnumber }&&problemnumber=${problemnumber}">
                    		<i class="icon-fenpei"></i>分配给我
                    	</a>
                    </li>
                    <li>
                    	<a href="project7?id=${itemsid}&&actionnumber=${actionnumber }&&problemnumber=${problemnumber}">
                    		<i class="icon-myfp"></i>我的分配
                    	</a>
                    </li>
                </ul>
                <ul>
                     <li>
                     	<a href="project8?id=${itemsid}&&actionnumber=${actionnumber }&&problemnumber=${problemnumber}">
                     		<i class="icon-fb"></i>版本管理
                     	</a>
                     </li>
                    <li>
                    	<a href="project9?id=${itemsid}&&actionnumber=${actionnumber }&&problemnumber=${problemnumber}">
                    		<i class="icon-yingyong"></i>应用中心
                    	</a>
                    </li>                                                         
                </ul>
            </div>
        </div>
        
        <div class="right" id="project-right" style="height: 600px;" tabindex="5002">
            <div class="mw-900 rightshow">
                <div class="head-tit">
                    <div class="fz-22 f-l">所有问题</div>
                    <div class="head-btn f-r fz-14">
                        <!--<div class="button bg-2 animated bounceIn"><i class="iconfont icon-tongzhi"></i>发布通知</div>-->
                        <div class="button animated bounceIn bg-white submit" onclick="ExportBugs()"><i class="iconfont icon-daochu" style="margin-top: 0.1rem;"></i>导出问题</div>
                        <style>.icon-daochu:before {content: "\e622";zoom: 1.2;}</style>
                        <div class="button animated bounceIn bg-white submit" onclick="addNewProblem()"><i class="iconfont icon-bianji"></i>提交问题</div>
                    </div>
                    <div class="clear"></div>
                </div>

                <div class="filter bg-white f-l b-radius4 bs-08">
                    <ul>
                        <li>
                            <div class="btn">问题类型：<span>全部</span><i class="iconfont icon-bottom"></i></div>
                            <div class="box">
                                <label onclick="recheck(&quot;type&quot;,this)">全部</label>
                                <label><input name="type" value="1" type="checkbox">缺陷</label>
                                <label><input name="type" value="4" type="checkbox">改进</label>
                                <label><input name="type" value="2" type="checkbox">任务</label>
                                <label><input name="type" value="3" type="checkbox">需求</label>
                            </div>
                        </li>
                        <li>
                            <div class="btn">产品：<span>全部</span><i class="iconfont icon-bottom"></i></div>
                            <div class="box">
                                <label onclick="recheck(&quot;pro&quot;,this)">全部</label>
                                                                    <label><input name="pro" value="a79737ed-8e00-49a7-b032-0a067e4aaec1" type="checkbox">默认产品</label>
                                                                </div>
                        </li>
                        <li id="modleli" style="display:none">
                            <div class="btn">模块：<span style="min-width: 70px;display:inline-block">全部</span><i class="iconfont icon-bottom"></i></div>
                            <div class="box moduleclass" style="max-height: 500px;overflow-y: scroll;">
                                <label onclick="recheck(&quot;mod&quot;,this)">全部</label>
                            </div>
                        </li>
                        <li id="versionli" style="display:none">
                            <div class="btn">版本：<span style="min-width: 70px;display:inline-block">全部</span><i class="iconfont icon-bottom"></i></div>
                            <div class="box versionclass" style="max-height: 500px;overflow-y: scroll;">
                                <label onclick="recheck(&quot;version&quot;,this)">全部</label>
                            </div>
                        </li>
                        <li>
                            <div class="btn">问题状态：<span>全部</span><i class="iconfont icon-bottom"></i></div>
                            <div class="box">
                                <label onclick="recheck(&quot;sta&quot;,this)">全部</label>
                                <label><input name="sta" value="1" type="checkbox">未解决</label>
                                <label><input name="sta" value="2" type="checkbox">待审核</label>
                                <label><input name="sta" value="3" type="checkbox">已拒绝</label>
                                <label><input name="sta" value="4" type="checkbox">已解决</label>
                                <label><input name="sta" value="5" type="checkbox">已关闭</label>
                                <label><input name="sta" value="6" type="checkbox">已延期</label>
                            </div>
                        </li>
                        <li>
                            <div class="btn">优先级：<span>全部</span><i class="iconfont icon-bottom"></i></div>
                            <div class="box">
                                <label onclick="recheck(&quot;pri&quot;,this)">全部</label>
                                <label><input name="pri" value="1" type="checkbox">急</label>
                                <label><input name="pri" value="2" type="checkbox">高</label>
                                <label><input name="pri" value="3" type="checkbox">中</label>
                                <label><input name="pri" value="4" type="checkbox">低</label>
                            </div>
                        </li>
                        <li>
                            <div class="btn">创建人：<span>全部</span><i class="iconfont icon-bottom"></i></div>
                            <div class="box">
                                <label onclick="recheck(&quot;cuser&quot;,this)">全部</label>
                                                                <label><input name="cuser" value="57eda926-a45e-4ae6-8f3e-43ccc3b94735" type="checkbox">何元浩</label>
                                                                <label><input name="cuser" value="ef40bbfb-b680-44e0-b32a-178797962c0d" type="checkbox">zock</label>
                                                                <label><input name="cuser" value="8b1f8d2f-394c-4793-bc7c-e1466b57df7a" type="checkbox">杨恩来</label>
                                                                <label><input name="cuser" value="471051bd-2d56-447d-88d2-a9f61a8a7647" type="checkbox">罗文</label>
                                                                <label><input name="cuser" value="86003427-20ca-491f-a01a-1f433f352edc" type="checkbox">邹书仪</label>
                                                            </div>
                        </li>
                        <li>
                            <div class="btn">处理人：<span>全部</span><i class="iconfont icon-bottom"></i></div>
                            <div class="box">
                                <label onclick="recheck(&quot;user&quot;,this)">全部</label>
                                                                <label><input name="user" value="57eda926-a45e-4ae6-8f3e-43ccc3b94735" type="checkbox">何元浩</label>
                                                                <label><input name="user" value="ef40bbfb-b680-44e0-b32a-178797962c0d" type="checkbox">zock</label>
                                                                <label><input name="user" value="8b1f8d2f-394c-4793-bc7c-e1466b57df7a" type="checkbox">杨恩来</label>
                                                                <label><input name="user" value="471051bd-2d56-447d-88d2-a9f61a8a7647" type="checkbox">罗文</label>
                                                                <label><input name="user" value="86003427-20ca-491f-a01a-1f433f352edc" type="checkbox">邹书仪</label>
                                                            </div>
                        </li>
                        <li>
                            <div class="btn">分配人：<span>全部</span><i class="iconfont icon-bottom"></i></div>
                            <div class="box">
                                <label onclick="recheck(&quot;createuser&quot;,this)">全部</label>
                                                                <label><input name="createuser" value="57eda926-a45e-4ae6-8f3e-43ccc3b94735" type="checkbox">何元浩</label>
                                                                <label><input name="createuser" value="ef40bbfb-b680-44e0-b32a-178797962c0d" type="checkbox">zock</label>
                                                                <label><input name="createuser" value="8b1f8d2f-394c-4793-bc7c-e1466b57df7a" type="checkbox">杨恩来</label>
                                                                <label><input name="createuser" value="471051bd-2d56-447d-88d2-a9f61a8a7647" type="checkbox">罗文</label>
                                                                <label><input name="createuser" value="86003427-20ca-491f-a01a-1f433f352edc" type="checkbox">邹书仪</label>
                                                            </div>
                        </li>
                        <li>
                            <div class="btn">审核人：<span>全部</span><i class="iconfont icon-bottom"></i></div>
                            <div class="box">
                                <label onclick="recheck(&quot;verifyuser&quot;,this)">全部</label>
                                                                <label><input name="verifyuser" value="57eda926-a45e-4ae6-8f3e-43ccc3b94735" type="checkbox">何元浩</label>
                                                                <label><input name="verifyuser" value="ef40bbfb-b680-44e0-b32a-178797962c0d" type="checkbox">zock</label>
                                                                <label><input name="verifyuser" value="8b1f8d2f-394c-4793-bc7c-e1466b57df7a" type="checkbox">杨恩来</label>
                                                                <label><input name="verifyuser" value="471051bd-2d56-447d-88d2-a9f61a8a7647" type="checkbox">罗文</label>
                                                                <label><input name="verifyuser" value="86003427-20ca-491f-a01a-1f433f352edc" type="checkbox">邹书仪</label>
                                                            </div>
                        </li>
                        <li style="display:none">
                            <div class="btn">标签：<span>全部</span><i class="iconfont icon-bottom"></i></div>
                            <div class="box">
                                <label onclick="recheck(&quot;tag&quot;,this)">全部</label>
                                                            </div>
                        </li>
                        <li>
                            <div class="btn">创建日期：<span>全部</span><i class="iconfont icon-bottom"></i></div>
                            <div class="box">
                                <label><input name="ctime" value="0" type="radio">全部</label>
                                <label><input name="ctime" value="1" type="radio">今天</label>
                                <label><input name="ctime" value="2" type="radio">昨天</label>
                                <label><input name="ctime" value="3" type="radio">最近三天</label>
                                <label><input name="ctime" value="4" type="radio">本周</label>
                                <label><input name="ctime" value="5" type="radio">上周</label>
                                <label><input name="ctime" value="6" type="radio">本月</label>
                                <label><input name="ctime" value="7" type="radio">上月</label>
                                <label><input name="ctime" value="8" type="radio">今年</label>
                                <label><input name="ctime" value="9" type="radio">去年</label>
                            </div>
                        </li>
                        <li>
                            <div class="btn">修复日期：<span>全部</span><i class="iconfont icon-bottom"></i></div>
                            <div class="box">
                                <label><input name="atime" value="0" type="radio">全部</label>
                                <label><input name="atime" value="1" type="radio">今天</label>
                                <label><input name="atime" value="2" type="radio">昨天</label>
                                <label><input name="atime" value="3" type="radio">最近三天</label>
                                <label><input name="atime" value="4" type="radio">本周</label>
                                <label><input name="atime" value="5" type="radio">上周</label>
                                <label><input name="atime" value="6" type="radio">本月</label>
                                <label><input name="atime" value="7" type="radio">上月</label>
                                <label><input name="atime" value="8" type="radio">今年</label>
                                <label><input name="atime" value="9" type="radio">去年</label>
                            </div>
                        </li>
                        <li>
                            <div class="btn">审核日期：<span>全部</span><i class="iconfont icon-bottom"></i></div>
                            <div class="box">
                                <label><input name="otime" value="0" type="radio">全部</label>
                                <label><input name="otime" value="1" type="radio">今天</label>
                                <label><input name="otime" value="2" type="radio">昨天</label>
                                <label><input name="otime" value="3" type="radio">最近三天</label>
                                <label><input name="otime" value="4" type="radio">本周</label>
                                <label><input name="otime" value="5" type="radio">上周</label>
                                <label><input name="otime" value="6" type="radio">本月</label>
                                <label><input name="otime" value="7" type="radio">上月</label>
                                <label><input name="otime" value="8" type="radio">今年</label>
                                <label><input name="otime" value="9" type="radio">去年</label>
                            </div>
                        </li>
                    </ul>
                </div>
                <style>
                    .filter li .box input[type=radio]{width:15px;height:15px;border:1px solid #c1ccda; -webkit-appearance:none; background:#fff url(/Templates/Default/images/check.png) no-repeat -13px 3px;margin:10px 10px 0px 0px;float:left;}
                    .filter li .box input[type=radio]:checked{ background:#fff url(/Templates/Default/images/check.png) no-repeat 2px 3px;border:1px solid #0892e1;}
                    .filter li .box label:hover input[type=radio]{border:1px solid #0892e1;background:#fff url(/Templates/Default/images/check.png) no-repeat 2px 3px;}
                </style>
                
                <div class="clear"></div>
    <div class="problem-list bg-white bs-08 b-radius4 of-hidden animated bounceInUp">
                    <div class="title fz-16">所有问题<span class="fz-12 color-8" id="count">共${fn:length(list)}条记录</span></div>
                    <table class="ta-center color-8" width="100%" cellspacing="0" cellpadding="0"> 
                                <tr class="tr-head"> 
                            <!--bottom-on选中降序  top-on选中升序-->
                            <td class="td-first" nowrap style="width: 65px;"><a href="itemssort?id=${itemsid}&&actionnumber=${actionnumber }&&problemnumber=${problemnumber}&&type=1&&action=p3&&order=${order}" class="top-on"><span class="icon"><i class="iconfont icon-top" onclick="loaddate('BugCode',this);"></i><i class="iconfont icon-bottom" onclick="loaddate('BugCode',this);"></i></span>编号</a></td>
                            <td nowrap style="width: 55px;"><a href="itemssort?id=${itemsid }&&actionnumber=${actionnumber }&&problemnumber=${problemnumber}&&type=2&&action=p3&&order=${order}" class="bottom-on"><span class="icon"><i class="iconfont icon-top" onclick="loaddate('BugType',this);"></i><i class="iconfont icon-bottom" onclick="loaddate('BugType',this);"></i></span>类型</a></td>
                            <td class="ta-left" style="width: 750px;"><a href="#" class="top-on">标题</a></td>
                            <td nowrap style="width: 55px;"><a href="itemssort?id=${itemsid }&&actionnumber=${actionnumber }&&problemnumber=${problemnumber}&&type=3&&action=p3&&order=${order}" class="top-on"><span class="icon"><i class="iconfont icon-top" onclick="loaddate('BugStatus',this);"></i><i class="iconfont icon-bottom" onclick="loaddate('BugStatus',this);"></i></span>状态</a></td>
                            <td nowrap style="width: 65px;"><a href="itemssort?id=${itemsid }&&actionnumber=${actionnumber }&&problemnumber=${problemnumber}&&type=4&&action=p3&&order=${order}"><span class="icon"><i class="iconfont icon-top" onclick="loaddate('Priority',this);"></i><i class="iconfont icon-bottom" onclick="loaddate('Priority',this);"></i></span>优先级</a></td>
                            <td nowrap style="width: 65px;"><a href="itemssort?id=${itemsid }&&actionnumber=${actionnumber }&&problemnumber=${problemnumber}&&type=5&&action=p3&&order=${order}" class="top-on"><span class="icon"><i class="iconfont icon-top" onclick="loaddate('ProcessingUserId',this);"></i><i class="iconfont icon-bottom" onclick="loaddate('ProcessingUserId',this);"></i></span></a>指派给</td>
                            <td nowrap style="width: 83px;"><a href="itemssort?id=${itemsid }&&actionnumber=${actionnumber }&&problemnumber=${problemnumber}&&type=6&&action=p3&&order=${order}"><span class="icon"><i class="iconfont icon-top" onclick="loaddate('CreateTime',this);"></i><i class="iconfont icon-bottom" onclick="loaddate('CreateTime',this);"></i></span>创建时间</a></td>
                            <td nowrap style="width: 94px;" class="td-last"><a href="itemssort?id=${itemsid }&&actionnumber=${actionnumber }&&problemnumber=${problemnumber}&&type=7&&action=p3&&order=${order}" class="bottom-on"><span class="icon"><i class="iconfont icon-top" onclick="loaddate('ModifyTime',this);"></i><i class="iconfont icon-bottom" onclick="loaddate('ModifyTime',this);"></i></span>修改时间</a></td>
                         </tr> 
                         <c:if test="${not empty list}">
                         <c:forEach items="${list}" var="problem">
                      
                         	<tr onclick="asideShow('dd4f672c4524414ab55352e7d39ee6ea',this);" class="tr-body">	
                         	<td class="td-first">${problem.id }</td>
                         	
                         	<td>
                         	<c:if test="${problem.type==1}"><span class="text-bg textbg-1">缺陷</span></c:if>
                         	<c:if test="${problem.type==2}"><span class="text-bg ">改进</span></c:if>
                         	<c:if test="${problem.type==3}"><span class="text-bg textbg-1">任务</span></c:if>
                         	<c:if test="${problem.type==4}"><span class="text-bg textbg-1">需求</span></c:if>
                    
                         	</td>	
                         	<td class="ta-left"><div class="td-tit color-2">  <i class="iconfont "> </i> <span>
                         	<c:if test="${empty problem.product}">默认产品</c:if>
                         	<c:if test="${not empty problem.product}">${problem.product }</c:if>
                         	</span><c:if test="${empty problem.headline}"> </c:if>
                         	<c:if test="${not empty problem.headline}">${problem.headline }</c:if>
                         	</div></td><td>
                         	<c:if test="${problem.state==1}"><span class="text-bg textbg-1">未解决</span></c:if>
                         	<c:if test="${problem.state==2}"><span class="text-bg ">待审核</span></c:if>
                         	<c:if test="${problem.state==3}"><span class="text-bg textbg-1">已拒绝</span></c:if>
                         	<c:if test="${problem.state==4}"><span class="text-bg textbg-2">已解决</span></c:if>
                         	<c:if test="${problem.state==5}"><span class="text-bg textbg-1">已关闭</span></c:if>
                         	<c:if test="${problem.state==6}"><span class="text-bg ">已延期</span></c:if>
                         	</td>	
                         	<td>
                         	<c:if test="${problem.priority==1}"><span class="text-bg textbg-1">急</span></c:if>
                         	<c:if test="${problem.priority==2}"><span class="text-bg textbg-2">高</span></c:if>
                         	<c:if test="${problem.priority==3}"><span class="text-bg textbg-3">中</span></c:if>
                         	<c:if test="${problem.priority==4}"><span class="text-bg textbg-4">低</span></c:if>
                         	</td>	
                         	<td>	<c:if test="${empty problem.handlerName}"></c:if>
                         	<c:if test="${not empty problem.handlerName}">${problem.handlerName }</c:if></td>
                         	<td><fmt:formatDate value="${problem.createtime }" pattern="yyyy年MM月dd日 HH:mm:ss"/></td>
                         	<td class="td-last"><fmt:formatDate value="${problem.updatetime }" pattern="yyyy年MM月dd日 HH:mm:ss"/></td>
                         	</tr>
                     </c:forEach>
                     
                         </c:if>
                    </table>	
                </div>
                <div class="clear blank40" onclick="asideHide()"></div>
                <div class="paging animated bounceInUp" id="paging" style="display: none;">
                    <ul id="pagingUl" class="bs-08"><li class="perv"><a href="javascript:void(0)">&lt;</a></li><li class="on"><a href="javascript:void(0)">1</a></li><li class="perv"><a href="javascript:void(0)">&gt;</a></li></ul>
                </div>
                <!--paging-->
                <div class="clear blank40" onclick="asideHide()"></div>
            </div>
        </div>
        </div>
        
        
    <!--projectIndex-->
     <style type="text/css">
 </style>

<style>
    #pImgs img{
        margin:10px
    }
    #pFiles img{
        margin:10px
    }
    #show-ul .fancybox img{
        margin:5px
    }
    .problem-info .problem-cont div .pFiles span{
        display:inline-block;
        font-size:27px;
        width:10%;
        height:35px;
        border:1px solid #ccc;
        text-align:center;
        padding:0px 7px;
        vertical-align:middle;
    }
    /*.problem-info .problem-cont div .pFiles .icons icon{
        display:none;
    }*/
    .problem-info .problem-cont div .pFiles{
        margin:0px;
        cursor:pointer;
        margin-top:5px;
        line-height:35px;
        height:35px;
    }
    .problem-info .problem-cont div .pFiles:hover{
        background:#f0f0f0;
    }
    .problem-info .problem-cont div .pFiles span.flist{
        width:50%;
        text-align:left;
        font-size:14px;
        border-left:none;
    }
    .problem-info .problem-cont div .pFiles span.fblist{
        width:17%;
        text-align:left;
        font-size:14px;
        border-left:none;
        border-right:none;
    }
    .problem-cont img{
        box-shadow: 0px 2px 10px rgba(0,0,0,0.08);
    }
</style>


<input type="hidden" id="txtCurrentBugId1" value="" />
<input type="hidden" id="txtCurrentBugId" value="" />
<input type="hidden" id="hidLastHandleUserId" value="" />
<input type="hidden" id="hidBtnType" value="" />
<input type="hidden" id="hidCurrentUrl" value="" />
<div class="aside-problem-topbg d-none" onclick="asideHide()"></div>
<div class="aside-problem-leftbg d-none" onclick="asideHide()"></div>

<div class="aside-problem p-absolute bg-white">
    <div class="aside-head bg-white">
        <div class="f-r" style="font-size:20px;">
                        <a href="javascript:void(0);" title="BugTalk" id="btnBugTalk" onclick="btnCreateTalk_Click()" class="color-8"></a>
                                    <a href="javascript:void(0);" title="编辑" id="btnEdit" class="color-8"></a>
                        <a href="javascript:void(0);" title="删除" id="btnDelete" class="color-8"></a>
        </div>
        <div class="btn f-l">
            <i class="iconfont icon-arrow-right f-l" onclick="asideHide()"></i>
            <a href="javascript:void(0);" onclick="chooseHandler()" id="btnChooseHandler" class="f-l btn1">指派</a>
            <a href="javascript:void(0);"  id="btnComplete" class="f-l btn2">完成</a>
            <a href="javascript:void(0);" class="f-l btn2" id="btnPass">通过</a>
            <a href="javascript:void(0);" class="f-l btn3" id="btnNoPass">不通过</a>
            <a href="javascript:void(0);" class="f-l color-8 btn4" id="btnClose">关闭</a>
            <a href="javascript:void(0);" class="f-l btn3" id="btnRefuse">拒绝</a>
            <a href="javascript:void(0);" class="f-l btn3" id="btnPostpone">延期</a>
            <a href="javascript:void(0);" class="f-l btn3" id="btnAgainOpen">再打开</a>
        </div>
    </div>
    <div id="aside-scroll">
        <div class="tips fz-14">
            <strong id="txtBugCode"></strong>
            <span class="text-bg textbg-1" id="txtBugType"></span>
			<label id="txtBugTitle"></label>
        </div>
        <div class="status b-radius4 fz-14 color-8" id="txtCurrentDone">
        </div>         
        <div class="status b-radius4 fz-14 color-8" style="border-top: 1px solid #ebebeb;padding: 10px 30px 15px 30px;margin-top:10px" id="txtRelevanceUsers">
        
        </div>
        <div class="problem-info">
            <div class="clear blank10"></div>
            <ul class="clearfix">
                <li><strong class="tit">项目</strong><label id="txtProjectName"></label></li>
                <li><strong class="tit">产品</strong><label id="txtProductName"></label></li>                
                <li><strong class="tit">模块</strong><label id="txtModuleName"></label></li>            
            </ul>
            <div class="problem-cont fz-14">
                <p id="txtDescription" style="margin-top:5px"></p>                
                <p id="pImgs">
                    
                </p>                
                <p id="pFiles" style="margin-top: 5px">
                </p>
                <div id="divfile">
                    
                </div>
            </div>
                        <ul class="clearfix">
                <li><strong class="tit">状态</strong><span class="text-bg textbg-3" id="txtBugStatus"></span></li>
                <li><strong class="tit">优先级</strong><span class="text-bg" id="txtPriority"></span></li>
                <li><strong class="tit">分配人</strong><label id="txtCreateUserName"></label></li>
                <li><strong class="tit">处理人</strong><label id="txtProcessingUserName"></label></li>
                                                                            </ul>
        </div>
        

        <div class="problem-log">
            <div class="title"><span class="color-0" onclick="showBox(this,'show-ul')" data-flag="0">隐藏修改日志</span><font class="fz-16">日志</font></div>
            <ul id="show-ul">
            </ul>
        </div>
    </div>
</div>

	<script src="../js/index1.js"></script>
</body>
</html>
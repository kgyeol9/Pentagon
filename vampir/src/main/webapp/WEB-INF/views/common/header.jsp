<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
  request.setCharacterEncoding("UTF-8");
%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>헤더</title>
<style>
header {
	background-color: #1c1c1c;
	padding: 1em;
	position: fixed;
	top: 0;
	left: 0;
	right: 0;
	height: 70px;
	border-bottom: 1px solid #333;
	z-index: 10;
}

header .logo {
	position: absolute;
	left: 2em;
	top: 50%;
	transform: translateY(-50%);
	font-size: 1.8em;
	color: #bb0000;
	cursor: pointer;
	margin: 0;
	font-weight: 600;
}

nav.center-nav {
	display: flex;
	justify-content: center;
	align-items: center;
	height: 100%;
	gap: 20px;
}

nav.center-nav a {
	color: #eee;
	font-weight: 600;
}

nav.center-nav a:hover {
	color: #ff4444;
}
/* 설정툴 (헤더 오른쪽) */
.settings {
	position: absolute;
	right: 2em;
	top: 50%;
	transform: translateY(-50%);
	display: flex;
	gap: 15px;
}

.settings button, .settings a {
	background: #333;
	color: #eee;
	padding: 6px 12px;
	border-radius: 4px;
	border: none;
	cursor: pointer;
	font-weight: 600;
}

.settings button:hover, .settings a:hover {
	background: #bb0000;
}
/* 사이드 메뉴 (완전히 숨기기 + 닫기 버튼) */
.side-menu {
	position: fixed;
	top: 0;
	right: -100%;
	/* 아예 화면 밖으로 */
	width: 250px;
	height: 100%;
	background: #1c1c1c;
	padding: 2em 1.5em;
	transition: right 0.3s ease;
	box-shadow: -2px 0 5px #00000088;
	z-index: 20;
}

.side-menu.active {
	right: 0;
}

.side-menu h3 {
	margin-top: 0;
	color: #ff5555;
}

.side-menu a {
	display: block;
	margin: 1em 0;
	color: #eee;
}

.side-menu .close-btn {
	background: none;
	border: none;
	color: #eee;
	font-size: 1.2em;
	position: absolute;
	top: 10px;
	right: 15px;
	cursor: pointer;
}
</style>
</head>
<body>
	<table border=0 width="100%">
		<tr>
			<td><header>
					<a href="${contextPath}/home.do" class="logo">VAMPI.GG</a>
					<nav class="center-nav">
						<a href="${contextPath}/itemDB.do">아이템DB</a>
						<a href="#game-info">게임 정보</a>
						<a href="#community">커뮤니티</a>
						<a href="#notices">공지사항</a>
						<a href="#events">이벤트</a>
					</nav>
					<div class="settings">
					
						<button id="menuBtn">메뉴</button>
					</div>
				</header></td>
		</tr>
	</table>


</body>
</html>
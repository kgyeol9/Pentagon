<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<link rel="stylesheet" href="${contextPath}/resources/board/style.css" />
<script defer src="${contextPath}/resources/board/app.js"></script>
<div class="board-wrap">
	<div class="container">
		<a class="logo" href="${contextPath}/board/list.do">Vaempir Board</a>
		<div class="actions">
			<a href="${contextPath}/board/write.do" class="primary">글쓰기</a> <a
				href="${contextPath}/board/list.do">목록</a>
		</div>

		<div class="form">
			<form id="newForm">
				<div class="row">
					<input type="text" name="title" placeholder="제목" required /> <input
						type="text" name="author" placeholder="작성자" required />
				</div>
				<div style="margin-top: 8px">
					<textarea name="content" placeholder="내용 (간단한 HTML 허용)"></textarea>
				</div>
				<div class="actions">
					<button class="btn primary" type="submit">등록</button>
					<a class="btn" href="${contextPath}/board/list.do">취소</a>
				</div>
			</form>
		</div>
	</div>
</div>
<script src="app.js"></script>
<script>
  document.addEventListener('DOMContentLoaded', () => { bindNewForm(); });
</script>

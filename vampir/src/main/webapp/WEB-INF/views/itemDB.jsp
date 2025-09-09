<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ page session="false"%>
<%
	request.setCharacterEncoding("UTF-8");
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>아이템 DB</title>
<meta name="viewport" content="width=device-width, initial-scale=1" />
<style>
:root{
  --subrow-base: 84px;
  --boost: 40px;
  --gap: 12px;
  --row-h: 44px;
}

.subrow{ min-height: var(--subrow-base); }
.fbox .subrow:nth-child(-n+3){ min-height: calc(var(--subrow-base) + var(--boost)); }
.filter-right{ gap: var(--gap); }
.thead .c, .r .c{ min-height: var(--row-h); }

/* ===== 테마 ===== */
body {
	margin: 0;
	font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
	background: #121212;
	color: #eee;
}

a {
	text-decoration: none;
	color: inherit;
}

.db-main {
	max-width: 1200px;
	margin: 110px auto 24px;
	padding: 0 16px;
}

.card {
	background: #1f1f1f;
	border: 1px solid #333;
	border-radius: 10px;
}

.btn-primary {
	background: #bb0000;
	color: #fff;
	border: none;
	border-radius: 8px;
	font-weight: 700;
	cursor: pointer;
}

.btn-primary:hover {
	background: #ff4444;
}

.page-title {
	font-size: 20px;
	margin: 0 0 12px;
	padding-bottom: 8px;
	border-bottom: 2px solid #bb0000;
	color: #ffdddd;
}

/* ===== 필터 레이아웃 (좌우 50%) ===== */
.filters {
	padding: 16px;
}

.filters-grid {
	display: grid;
	grid-template-columns: 1fr 1fr;
	gap: 16px;
	align-items: stretch;
}

/* 왼쪽: 한 박스 (그리드로 4줄) */
.filter-left {
	display: block;
}

.fbox {
	background: #181818;
	border: 1px solid #333;
	border-radius: 10px;
	padding: 0;
	overflow: hidden;
	display: grid;
	grid-template-rows: 1fr 1fr 1fr auto; /* 직업/분류/등급 = 균등, 검색 = 내용만큼 */
	gap: 0;
}

/* 각 줄: 라벨 | 컨텐츠 = 2열 그리드 + 중앙정렬 */
.subrow {
	display: grid;
	grid-template-columns: 72px 1fr; /* 라벨 고정폭 | 내용 유동폭 */
	align-items: center; /* 세로 중앙 */
	gap: 12px;
	padding: 14px 16px;
	min-height: var(- -subrow-base);
	box-sizing: border-box;
}
/* 검색 제외(앞의 3개)만 균일 확대 */
.fbox .subrow:nth-child(-n+3) {
	min-height: calc(var(- -subrow-base)+ var(- -boost));
}

.subrow+.subrow {
	border-top: 1px solid #333;
}

.label {
	color: #bbb;
	font-size: 13px;
}

.checks {
	display: flex;
	flex-wrap: wrap;
	gap: 10px 16px;
	align-items: center; /* 1줄일 때 세로 가운데 */
	align-content: center; /* 여러줄일 때 묶음 자체를 가운데 */
	min-height: 100%;
}

.checks .chk {
	display: flex;
	align-items: center;
	gap: 6px;
	font-size: 14px;
}

.checks input[type="checkbox"] {
	width: 16px;
	height: 16px;
}

.searchline {
	display: grid;
	grid-template-columns: 1fr 120px;
	gap: 10px;
	width: 100%;
	align-items: center; /* 입력/버튼 수직 가운데 */
}

.searchline input[type="text"] {
	padding: 12px;
	border-radius: 8px;
	border: 1px solid #333;
	background: #181818;
	color: #eee;
}

.btn-primary {
	padding: 10px 12px;
}

/* 오른쪽: 윗 박스=가로 2분할(선택), 아래=비교 */
.filter-right {
	display: flex;
	flex-direction: column;
	gap: var(- -gap);
}

.sidebox-row {
	display: grid;
	grid-template-columns: 1fr 1fr;
	gap: var(- -gap);
}

.sidebox {
	background: #181818;
	border: 1px solid #333;
	border-radius: 10px;
	padding: 14px 16px;
	overflow: auto;
	box-sizing: border-box;
	min-height: 60px;
	height: 100%;
	transition: border-color .15s ease, box-shadow .15s ease;
}

.sidebox.selectable {
	cursor: pointer;
}

.sidebox.selected {
	border-color: #bb0000;
	box-shadow: 0 0 0 1px #bb0000 inset;
}

.sidebox .slot-head {
	font-size: 12px;
	color: #bbb;
	margin: -4px 0 8px;
	display: flex;
	align-items: center;
	gap: 8px;
}

.chip {
	font-size: 11px;
	padding: 2px 8px;
	border: 1px solid #444;
	border-radius: 999px;
	color: #ccc;
}

/* ===== 결과/정렬 ===== */
.result-bar {
	display: flex;
	flex-wrap: wrap;
	align-items: center;
	justify-content: space-between;
	gap: 10px;
	margin: 14px 0 8px;
}

.result-info {
	color: #bbb;
	font-size: 13px;
}

.sort-group {
	display: flex;
	gap: 8px;
	align-items: center;
}

.sort-group select {
	background: #181818;
	color: #eee;
	border: 1px solid #333;
	border-radius: 8px;
	padding: 8px;
}

/* ===== 리스트 ===== */
.list {
	overflow: hidden;
}

:root { -
	-row-h: 44px;
}

.thead, .r {
	display: grid;
	grid-template-columns: 140px 1fr 1.2fr 44px;
}

.thead {
	background: #181818;
	color: #ddd;
	font-weight: 700;
	user-select: none;
}

.thead .c {
	padding: 10px 14px;
	border-bottom: 1px solid #333;
	display: flex;
	align-items: center;
	gap: 8px;
	min-height: var(- -row-h);
	cursor: pointer;
}

.thead .c.no-sort {
	cursor: default;
}

.r .c {
	padding: 10px 14px;
	border-bottom: 1px solid #333;
	display: flex;
	align-items: center;
	min-height: var(- -row-h);
}

.r {
	background: #151515;
}

.r:nth-child(even) {
	background: #171717;
}

.thead .c .arrow {
	font-size: 11px;
	color: #aaa;
	opacity: .6
}

.grade {
	font-size: 12px;
	padding: 2px 8px;
	border: 1px solid #333;
	border-radius: 999px;
	margin-left: 8px;
}

.g-일반 {
	color: #bbb;
}

.g-고급 {
	color: #9fd3ff;
}

.g-희귀 {
	color: #7fb0ff;
}

.g-영웅 {
	color: #a98bff;
}

.g-전설 {
	color: gold;
}

.g-신화 {
	color: #ff8ad1;
}

.tag {
	font-size: 12px;
	color: #888;
	margin-left: 8px
}

/* + 버튼 */
.plus-btn {
	width: 28px;
	height: 28px;
	border-radius: 6px;
	border: 1px solid #444;
	background: #222;
	color: #fff;
	font-size: 18px;
	line-height: 26px;
	text-align: center;
	cursor: pointer;
	margin-left: auto;
}

.plus-btn:hover {
	background: #333;
}

/* 상세 슬라이드 */
.detail {
	grid-column: 1/-1;
	overflow: hidden;
	max-height: 0;
	transition: max-height .25s ease;
}

.detail-inner {
	padding: 12px 14px;
	border-top: 1px dashed #333;
	display: grid;
	grid-template-columns: 1fr 1fr;
	gap: 14px;
	background: #151515;
}

.subsec h4 {
	margin: 0 0 6px;
	font-size: 13px;
	color: #ffdddd
}

.meta {
	color: #bbb;
	font-size: 13px
}

.open .detail {
	max-height: 240px;
}

/* ===== 페이징 (가운데 정렬) ===== */
.pager {
	display: flex;
	align-items: center;
	justify-content: center;
	gap: 8px;
	padding: 10px 0;
}

.pager .btn {
	background: #222;
	border: 1px solid #333;
	border-radius: 6px;
	color: #eee;
	padding: 6px 10px;
	cursor: pointer
}

.pager .btn[disabled] {
	opacity: .35;
	cursor: not-allowed
}

.pager .num {
	background: #1b1b1b;
	border: 1px solid #333;
	border-radius: 6px;
	color: #eee;
	padding: 6px 10px;
	cursor: pointer
}

.pager .num.active {
	background: #bb0000;
	border-color: #bb0000
}

.pager select {
	background: #181818;
	color: #eee;
	border: 1px solid #333;
	border-radius: 8px;
	padding: 6px 10px
}

/* 비교 테이블 */
.cmp-table {
	width: 100%;
	border-collapse: collapse;
	font-size: 13px;
}

.cmp-table th, .cmp-table td {
	border-bottom: 1px solid #2a2a2a;
	padding: 8px 6px;
	text-align: left;
}

.cmp-table th {
	color: #ddd;
	font-weight: 700;
}

.delta-pos {
	color: #7ddc7d;
}

.delta-neg {
	color: #ff8080;
}

.delta-zero {
	color: #bbb;
}

/* 반응형 */
@media ( max-width : 900px) {
	.filters-grid {
		grid-template-columns: 1fr;
	}
	.sidebox-row {
		height: auto !important;
	}
	.sidebox {
		height: auto !important;
	}
}
</style>
</head>
<body>
	<main class="db-main">
		<h2 class="page-title">아이템 DB</h2>

		<!-- ===== 필터 (왼쪽: 단일 박스 / 오른쪽: 윗 가로2 + 아래 비교) ===== -->
		<section class="card filters" aria-label="아이템 필터">
			<div class="filters-grid">
				<!-- 왼쪽 50% : 한 박스 -->
				<div class="filter-left">
					<div class="fbox" id="filterBox">
						<!-- 직업 -->
						<div class="subrow">
							<div class="label">직업</div>
							<div class="checks" id="jobs">
								<label class="chk"><input type="checkbox" name="job"
									value="전체" checked>전체</label> <label class="chk"><input
									type="checkbox" name="job" value="바이퍼">바이퍼</label> <label
									class="chk"><input type="checkbox" name="job"
									value="그림리퍼">그림리퍼</label> <label class="chk"><input
									type="checkbox" name="job" value="카니지">카니지</label> <label
									class="chk"><input type="checkbox" name="job"
									value="블러드스테인">블러드스테인</label>
							</div>
						</div>
						<!-- 분류 -->
						<div class="subrow">
							<div class="label">분류</div>
							<div class="checks" id="cats">
								<label class="chk"><input type="checkbox" name="cat"
									value="무기">무기</label> <label class="chk"><input
									type="checkbox" name="cat" value="방어구">방어구</label> <label
									class="chk"><input type="checkbox" name="cat"
									value="장신구">장신구</label> <label class="chk"><input
									type="checkbox" name="cat" value="부장품">부장품</label> <label
									class="chk"><input type="checkbox" name="cat"
									value="소모품">소모품</label> <label class="chk"><input
									type="checkbox" name="cat" value="스킬북">스킬북</label> <label
									class="chk"><input type="checkbox" name="cat"
									value="재표">재표</label>
							</div>
						</div>
						<!-- 등급 -->
						<div class="subrow">
							<div class="label">등급</div>
							<div class="checks" id="grades">
								<label class="chk"><input type="checkbox" name="grade"
									value="전체" checked>전체</label> <label class="chk"><input
									type="checkbox" name="grade" value="일반">일반</label> <label
									class="chk"><input type="checkbox" name="grade"
									value="고급">고급</label> <label class="chk"><input
									type="checkbox" name="grade" value="희귀">희귀</label> <label
									class="chk"><input type="checkbox" name="grade"
									value="영웅">영웅</label> <label class="chk"><input
									type="checkbox" name="grade" value="전설">전설</label> <label
									class="chk"><input type="checkbox" name="grade"
									value="신화">신화</label>
							</div>
						</div>
						<!-- 검색 -->
						<div class="subrow">
							<div class="label">검색</div>
							<div class="searchline">
								<input type="text" id="qTop" placeholder="아이템 이름으로 검색" />
								<button class="btn-primary" id="btnSearchTop">검색</button>
							</div>
						</div>
					</div>
				</div>

				<!-- 오른쪽 50% : 윗 행(2분할, 선택 영역) + 아래 행(비교) -->
				<div class="filter-right" id="filterRight">
					<div class="sidebox-row" id="sideTopRow">
						<div class="sidebox selectable selected" id="sideTopA"
							data-slot="A" title="담을 위치 선택(A)">
							<div class="slot-head">
								<span class="chip">비교 A (기준)</span><span id="slotALabel"
									style="color: #aaa">비어 있음</span>
							</div>
							<div id="slotA"></div>
						</div>
						<div class="sidebox selectable" id="sideTopB" data-slot="B"
							title="담을 위치 선택(B)">
							<div class="slot-head">
								<span class="chip">비교 B</span><span id="slotBLabel"
									style="color: #aaa">비어 있음</span>
							</div>
							<div id="slotB"></div>
						</div>
					</div>
					<div class="sidebox" id="sideBottom" aria-label="스펙 비교 영역">
						<div class="slot-head">
							<span class="chip">스펙 비교 (A 기준)</span>
						</div>
						<div id="cmpBox" style="color: #aaa; font-size: 13px;">A와 B에
							아이템을 담으면 비교가 표시됩니다.</div>
					</div>
				</div>
			</div>
		</section>

		<!-- ===== 결과/정렬 ===== -->
		<div class="result-bar">
			<div class="result-info" id="resultInfo">총 0개</div>
			<div class="sort-group">
				<span style="color: #bbb; font-size: 13px">정렬:</span> <select
					id="sortKey">
					<option value="id">번호</option>
					<option value="name">이름</option>
					<option value="grade">등급</option>
					<option value="category">분류</option>
				</select>
			</div>
		</div>

		<!-- ===== 리스트 ===== -->
		<section class="card list" aria-label="아이템 목록">
			<div class="thead">
				<div class="c th" data-k="id">
					아이템 번호 <span class="arrow" id="ar-id">▲▼</span>
				</div>
				<div class="c th" data-k="name">
					아이템 이름 <span class="arrow" id="ar-name">▲▼</span>
				</div>
				<div class="c th" data-k="stats">아이템 능력치</div>
				<div class="c no-sort"></div>
			</div>
			<div id="itemBody"></div>
		</section>

		<!-- ===== 페이징 ===== -->
		<div class="pager" id="pager">
			<select id="pageSize">
				<option value="5">5개</option>
				<option value="10" selected>10개</option>
				<option value="20">20개</option>
				<option value="50">50개</option>
			</select>
			<button class="btn" id="prevBtn">이전</button>
			<div id="pageNums"></div>
			<button class="btn" id="nextBtn">다음</button>
		</div>

		<!-- ===== 하단 검색 ===== -->
		<section class="card" style="padding: 12px" aria-label="하단 검색">
			<div class="searchline">
				<input type="text" id="qBottom" placeholder="아이템 이름으로 검색">
				<button class="btn-primary" id="btnSearchBottom">검색</button>
			</div>
		</section>
	</main>
</body>
</html>

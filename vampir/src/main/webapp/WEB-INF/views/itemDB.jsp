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
:root { -
	-subrow-base: 84px; -
	-boost: 40px; -
	-gap: 12px;
}

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

	<script>
  const Items = [];
  <c:forEach var="item" items="${itemsList}">
  ITEMS.push({
    id: ${item.item_code},
    name: "<c:out value='${item.name}'/>"
    }
  });
</c:forEach>

  /* ========= 상태 ========= */
  const state = { q: "", jobs: ["전체"], cats: [], grades: ["전체"], sortKey: "id", sortDir: "asc", page: 1, pageSize: 10 };
  const compare = { selected: 'A', A: null, B: null };

  /* ========= 헬퍼 ========= */
  const $  = (s, r=document)=>r.querySelector(s);
  const $$ = (s, r=document)=>Array.from(r.querySelectorAll(s));
  function getChecked(name){ return $$(`input[name="${name}"]:checked`).map(b=>b.value); }
  function matchJobs(item, sel){
    if(sel.length===0 || sel.includes("전체")) return true;
    const full = ["바이퍼","그림리퍼","카니지","블러드스테인"];
    const jobs = item.jobs==="ALL" ? full : item.jobs;
    return sel.some(j=>jobs.includes(j));
  }
  function matchCats(item, sel){ return sel.length===0 ? true : sel.includes(item.category); }
  function matchGrades(item, sel){ return (sel.length===0 || sel.includes("전체")) ? true : sel.includes(item.grade); }
  function matchQuery(item, q){ if(!q) return true; return item.name.toLowerCase().includes(q.toLowerCase().trim()); }
  const gradeOrder = { "일반":1,"고급":2,"희귀":3,"영웅":4,"전설":5,"신화":6 };

  function sortItems(arr){
    const k = state.sortKey, dir = state.sortDir==="asc"?1:-1;
    return arr.slice().sort((a,b)=>{
      if(k==="grade") return (gradeOrder[a.grade]-gradeOrder[b.grade]) * dir;
      if(k==="name")  return a.name.localeCompare(b.name,"ko") * dir;
      if(k==="category") return a.category.localeCompare(b.category,"ko") * dir;
      return (a.id-b.id) * dir;
    });
  }
  function paginate(arr){
    const total = arr.length;
    const pages = Math.max(1, Math.ceil(total/state.pageSize));
    state.page = Math.min(Math.max(1,state.page), pages);
    const start = (state.page-1)*state.pageSize, end = start + state.pageSize;
    return { slice: arr.slice(start,end), total, pages };
  }

  /* ===== 비교 렌더 ===== */
  function parseStats(statsStr){
    const res = {};
    if(!statsStr) return res;
    statsStr.split('/').map(s=>s.trim()).forEach(s=>{
      const m = s.match(/^(.*?)[\s]*([+\-]?\d+(?:\.\d+)?)(?!.*\d)/);
      if(m){
        const key = m[1].trim().replace(/\s+/g,' ');
        const val = parseFloat(m[2]);
        if(key) res[key] = val;
      }
    });
    return res;
  }

  function cardHtml(it){
    return `
      <div style="display:flex; flex-direction:column; gap:6px;">
        <div style="display:flex; align-items:center; gap:8px; font-weight:700;">
          <span>${it.name}</span>
          <span class="grade g-${it.grade}">${it.grade}</span>
          <span class="tag">#${it.category}</span>
          <button class="remove-btn" style="margin-left:auto;background:#222;border:1px solid #444;border-radius:6px;color:#ddd;padding:2px 8px;cursor:pointer;">지우기</button>
        </div>
        <div style="color:#bbb; font-size:13px;">${it.stats || "-"}</div>
      </div>
    `;
  }

  function renderCompareBoxes(){
    // A
    const aWrap = $("#slotA"), aLabel = $("#slotALabel");
    aWrap.innerHTML = "";
    if(compare.A){
      aLabel.textContent = `${compare.A.name}`;
      aWrap.innerHTML = cardHtml(compare.A);
      aWrap.querySelector(".remove-btn").addEventListener("click", (e)=>{ e.stopPropagation(); compare.A=null; renderCompareBoxes(); });
    }else{ aLabel.textContent = "비어 있음"; }

    // B
    const bWrap = $("#slotB"), bLabel = $("#slotBLabel");
    bWrap.innerHTML = "";
    if(compare.B){
      bLabel.textContent = `${compare.B.name}`;
      bWrap.innerHTML = cardHtml(compare.B);
      bWrap.querySelector(".remove-btn").addEventListener("click", (e)=>{ e.stopPropagation(); compare.B=null; renderCompareBoxes(); });
    }else{ bLabel.textContent = "비어 있음"; }

    renderComparison();
  }

  function renderComparison(){
    const box = $("#cmpBox");
    if(!compare.A){
      box.style.color = "#aaa";
      box.innerHTML = "A(왼쪽 상단)에 아이템을 담으면 비교가 표시됩니다.";
      return;
    }
    const statsA = parseStats(compare.A.stats);
    const statsB = compare.B ? parseStats(compare.B.stats) : {};
    const keys = new Set([...Object.keys(statsA), ...Object.keys(statsB)]);
    if(keys.size===0){
      box.style.color = "#aaa";
      box.innerHTML = "비교 가능한 수치가 없습니다.";
      return;
    }
    const rows = [];
    [...keys].sort((x,y)=>x.localeCompare(y,"ko")).forEach(k=>{
      const a = statsA[k]; const b = (k in statsB) ? statsB[k] : null;
      const aStr = (a!=null)? a : "-";
      const bStr = (b!=null)? b : "-";
      let deltaStr = "-";
      let cls = "delta-zero";
      if(a!=null && b!=null){
        const d = b - a;
        if(d>0){ deltaStr = `+${d}`; cls="delta-pos"; }
        else if(d<0){ deltaStr = `${d}`; cls="delta-neg"; }
        else { deltaStr = "0"; cls="delta-zero"; }
      }
      rows.push(`<tr>
        <th>${k}</th>
        <td>${aStr}</td>
        <td>${bStr}</td>
        <td class="${cls}">${deltaStr}</td>
      </tr>`);
    });
    box.style.color = "#eee";
    box.innerHTML = `
      <table class="cmp-table" aria-label="스펙 비교 테이블">
        <thead><tr><th>능력치</th><th>A(기준)</th><th>B</th><th>Δ(B−A)</th></tr></thead>
        <tbody>${rows.join("")}</tbody>
      </table>
    `;
  }

  /* ========= 렌더 ========= */
  function render(){
    state.jobs   = getChecked("job");
    state.cats   = getChecked("cat");
    state.grades = getChecked("grade");

    const filtered = ITEMS.filter(it =>
      matchJobs(it, state.jobs) &&
      matchCats(it, state.cats) &&
      matchGrades(it, state.grades) &&
      matchQuery(it, state.q)
    );
    const sorted = sortItems(filtered);
    const { slice, total, pages } = paginate(sorted);

    // 정렬 화살표
    $$(".thead .c .arrow").forEach(el=>el.style.opacity=.4);
    const ar = $("#ar-"+state.sortKey);
    if(ar){ ar.textContent = state.sortDir==="asc" ? "▲" : "▼"; ar.style.opacity=1; }

    // 리스트
    const body = $("#itemBody"); body.innerHTML="";
    if(slice.length===0){
      body.innerHTML = `<div class="r"><div class="c" style="grid-column:1/-1;color:#aaa;">검색 결과가 없습니다.</div></div>`;
    }else{
      slice.forEach(it=>{
        const row = document.createElement("div");
        row.className="r";
        row.innerHTML = `
          <div class="c">${it.id}</div>
          <div class="c">${it.name}
            <span class="grade g-${it.grade}">${it.grade}</span>
            <span class="tag">#${it.category}</span>
          </div>
          <div class="c">${it.stats}</div>
          <div class="c" style="justify-content:flex-end">
            <button class="plus-btn" title="비교 박스로 추가">＋</button>
          </div>
          <div class="detail">
            <div class="detail-inner">
              <div class="subsec">
                <h4>아이템 정보</h4>
                <div class="meta">설명: ${it.detail.desc || "-"}</div>
                <div class="meta">획득처: ${it.detail.drops || "-"}</div>
              </div>
              <div class="subsec">
                <h4>제약/기타</h4>
                <div class="meta">착용 조건: ${it.detail.req || "-"}</div>
                <div class="meta">귀속: ${it.detail.bind || "-"}</div>
              </div>
            </div>
          </div>`;

        // 단일 오픈
        row.addEventListener("click", ()=>{
          const wasOpen = row.classList.contains("open");
          $$("#itemBody .r.open").forEach(r=>r.classList.remove("open"));
          if(!wasOpen) row.classList.add("open");
        });

        // + 버튼 → 선택된 슬롯에 담기
        row.querySelector(".plus-btn").addEventListener("click", (e)=>{
          e.stopPropagation();
          const slot = compare.selected || 'A';
          compare[slot] = it;
          renderCompareBoxes();
        });

        body.appendChild(row);
      });
    }

    // 결과/페이징
    $("#resultInfo").textContent = `총 ${total}개 (페이지 ${state.page}/${pages})`;
    renderPager(pages);

    // 높이 동기화 & 비교 갱신
    syncRightHeights();
    renderCompareBoxes();
  }

  function renderPager(pages){
    $("#prevBtn").disabled = (state.page<=1);
    $("#nextBtn").disabled = (state.page>=pages);
    const box = $("#pageNums"); box.innerHTML="";
    const maxBtns = 7;
    let start = Math.max(1, state.page - Math.floor(maxBtns/2));
    let end   = Math.min(pages, start + maxBtns - 1);
    start = Math.max(1, end - maxBtns + 1);
    for(let i=start;i<=end;i++){
      const b = document.createElement("button");
      b.className = "num" + (i===state.page?" active":"");
      b.textContent = i;
      b.addEventListener("click", ()=>{ state.page=i; render(); });
      box.appendChild(b);
    }
  }

  /* ========= 오른쪽 박스 높이 = 왼쪽 박스 전체 높이 반반 ========= */
  function syncRightHeights(){
    const left = $("#filterBox");
    const right = $("#filterRight");
    const topRow = $("#sideTopRow");
    const bottomBox = $("#sideBottom");
    if(!left || !right || !topRow || !bottomBox) return;

    const leftH = left.getBoundingClientRect().height;
    const gapPx = parseFloat(getComputedStyle(right).gap || getComputedStyle(document.documentElement).getPropertyValue('--gap') || "12");
    const each = Math.max(0, (leftH - gapPx) / 2);

    topRow.style.height = each + "px";
    bottomBox.style.height = each + "px";
  }

  // 슬롯 선택
  $("#sideTopA").addEventListener("click", ()=> setSelectedSlot('A'));
  $("#sideTopB").addEventListener("click", ()=> setSelectedSlot('B'));
  function setSelectedSlot(slot){
    compare.selected = slot;
    $("#sideTopA").classList.toggle("selected", slot==='A');
    $("#sideTopB").classList.toggle("selected", slot==='B');
  }

  // 필터 체크 로직
  function getChecked(name){ return $$(`input[name="${name}"]:checked`).map(b=>b.value); }
  $("#jobs").addEventListener("change",(e)=>{
    const t=e.target; if(t.name!=="job") return;
    if(t.value==="전체" && t.checked) $$('input[name="job"]:not([value="전체"])').forEach(b=>b.checked=false);
    if(t.value!=="전체" && t.checked) $$('input[name="job"][value="전체"]').forEach(b=>b.checked=false);
    state.page=1; render();
  });
  $("#cats").addEventListener("change", ()=>{ state.page=1; render(); });
  $("#grades").addEventListener("change",(e)=>{
    const t=e.target; if(t.name!=="grade") return;
    if(t.value==="전체" && t.checked) $$('input[name="grade"]:not([value="전체"])').forEach(b=>b.checked=false);
    if(t.value!=="전체" && t.checked) $$('input[name="grade"][value="전체"]').forEach(b=>b.checked=false);
    state.page=1; render();
  });

  // 검색
  $("#btnSearchTop").addEventListener("click", ()=>{ state.q=$("#qTop").value; $("#qBottom").value=state.q; state.page=1; render(); });
  $("#btnSearchBottom").addEventListener("click", ()=>{ state.q=$("#qBottom").value; $("#qTop").value=state.q; state.page=1; render(); });
  $("#qTop").addEventListener("keydown", (e)=>{ if(e.key==="Enter"){ state.q=e.target.value; $("#qBottom").value=state.q; state.page=1; render(); }});
  $("#qBottom").addEventListener("keydown", (e)=>{ if(e.key==="Enter"){ state.q=e.target.value; $("#qTop").value=state.q; state.page=1; render(); }});

  // 정렬(헤더 클릭 / 드롭다운)
  $$(".thead .th").forEach(th=>{
    th.addEventListener("click", ()=>{
      const k = th.dataset.k;
      if(!k || k==="stats") return;
      if(state.sortKey===k){ state.sortDir = (state.sortDir==="asc"?"desc":"asc"); }
      else { state.sortKey=k; state.sortDir="asc"; }
      $("#sortKey").value = state.sortKey;
      render();
    });
  });
  $("#sortKey").addEventListener("change", (e)=>{ state.sortKey=e.target.value; state.sortDir="asc"; render(); });

  // 페이징
  $("#pageSize").addEventListener("change", (e)=>{ state.pageSize=+e.target.value; state.page=1; render(); });
  $("#prevBtn").addEventListener("click", ()=>{ state.page=Math.max(1,state.page-1); render(); });
  $("#nextBtn").addEventListener("click", ()=>{ state.page=state.page+1; render(); });

  // 리사이즈/관찰 & 초기 렌더
  window.addEventListener("resize", syncRightHeights);
  if('ResizeObserver' in window){
    const ro = new ResizeObserver(()=> syncRightHeights());
    const fb = $("#filterBox");
    if(fb) ro.observe(fb);
  }
  render();
</script>
</body>
</html>

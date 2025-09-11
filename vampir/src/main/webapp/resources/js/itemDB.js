// /resources/js/itemDB.js
(function () {
  /* ===== 전역 노출 필요 함수 ===== */
  let selectedSlot = "A"; // 비교 기본 슬롯

  function toggleDetail(row) {
    const detail = row.nextElementSibling;
    if (!detail || !detail.classList.contains("detail")) return;

    // 현재 페이지에서는 detail이 display:'' 상태이므로 maxHeight로 열고 닫기
    if (detail.classList.contains("open")) {
      detail.classList.remove("open");
      detail.style.maxHeight = "0";
    } else {
      detail.classList.add("open");
      detail.style.maxHeight = detail.scrollHeight + "px";
    }
  }
  window.toggleDetail = toggleDetail;

  function addToCompare(e, btn) {
    if (e) e.stopPropagation();

    // data-name이 없더라도 .r / .item-card 기준으로 fallback
    let wrap =
      btn.closest("[data-name]") ||
      btn.closest(".r") ||
      btn.closest(".item-card");
    if (!wrap) return;

    const name =
      wrap.dataset.name ||
      (wrap.querySelector(".name-text")?.textContent ||
        wrap.querySelector(".ic-title")?.textContent ||
        "").trim();

    const data = {
      minatk: wrap.dataset.minatk ?? "0",
      maxatk: wrap.dataset.maxatk ?? "0",
      addatk: wrap.dataset.addatk ?? "0",
      accuracy: wrap.dataset.accuracy ?? "0",
      critical: wrap.dataset.critical ?? "0",
    };

    if (selectedSlot === "A") {
      const slotA = document.getElementById("slotA");
      const slotALabel = document.getElementById("slotALabel");
      if (slotA && slotALabel) {
        slotA.innerHTML = `<b>${escapeHtml(name)}</b>`;
        slotALabel.innerText = name;
        slotA.dataset.info = JSON.stringify(data);
      }
    } else {
      const slotB = document.getElementById("slotB");
      const slotBLabel = document.getElementById("slotBLabel");
      if (slotB && slotBLabel) {
        slotB.innerHTML = `<b>${escapeHtml(name)}</b>`;
        slotBLabel.innerText = name;
        slotB.dataset.info = JSON.stringify(data);
      }
    }
    updateCompare();
  }
  window.addToCompare = addToCompare;

  function updateCompare() {
    const slotA = document.getElementById("slotA");
    const slotB = document.getElementById("slotB");
    if (!slotA || !slotB) return;

    const aInfo = slotA.dataset.info;
    const bInfo = slotB.dataset.info;
    if (!aInfo || !bInfo) return;

    const A = JSON.parse(aInfo);
    const B = JSON.parse(bInfo);

    const keys = ["minatk", "maxatk", "addatk", "accuracy", "critical"];
    let html = `<table class="cmp-table">
      <tr><th>능력치</th><th>A</th><th>B</th><th>차이</th></tr>`;

    keys.forEach((k) => {
      const a = parseInt(A[k] || "0", 10);
      const b = parseInt(B[k] || "0", 10);
      if (a !== 0 || b !== 0) {
        const diff = b - a;
        const cls =
          diff > 0 ? "delta-pos" : diff < 0 ? "delta-neg" : "delta-zero";
        html += `<tr>
          <td>${k.toUpperCase()}</td>
          <td>${a}</td>
          <td>${b}</td>
          <td class="${cls}">${diff > 0 ? "+" : ""}${diff}</td>
        </tr>`;
      }
    });

    html += `</table>`;
    const cmpBox = document.getElementById("cmpBox");
    if (cmpBox) cmpBox.innerHTML = html;
  }

  function escapeHtml(s) {
    return String(s).replace(/[&<>"']/g, (m) =>
      ({
        "&": "&amp;",
        "<": "&lt;",
        ">": "&gt;",
        '"': "&quot;",
        "'": "&#39;",
      }[m])
    );
  }

  /* ===== 체크박스 ===== */
  function setupGroupCheckbox(groupId) {
    const group = document.getElementById(groupId);
    if (!group) return;
    const allBox = group.querySelector("input[value='전체']");
    const others = group.querySelectorAll("input:not([value='전체'])");
    if (!allBox) return;

    allBox.addEventListener("change", () => {
      others.forEach((cb) => (cb.checked = allBox.checked));
    });
    others.forEach((cb) => {
      cb.addEventListener("change", () => {
        allBox.checked = [...others].every((o) => o.checked);
      });
    });
    if (allBox.checked) others.forEach((cb) => (cb.checked = true));
  }

  /* ===== 상태/DOM 캐시 ===== */
  const state = {
    view: "list", // 'list' | 'card'
    currentPage: 1,
    pageSize: 10,
    listPairs: [], // [{row, detail}]
    cardItems: [], // [element]
  };

  const els = {};
  function cacheElements() {
    els.bodyList = document.getElementById("itemBody");
    els.resultInfo = document.getElementById("resultInfo");
    els.pageSizeSel = document.getElementById("pageSize");
    els.pageNumsEl = document.getElementById("pageNums");

    els.btnViewList = document.getElementById("btnViewList");
    els.btnViewCard = document.getElementById("btnViewCard");
    els.listView = document.getElementById("listView");
    els.cardView = document.getElementById("cardView");
    els.cardGrid = document.getElementById("cardGrid");
  }

  /* ===== 데이터 수집(+data-name 보정) ===== */
  function buildData() {
    // 리스트 페어 구성
    state.listPairs = [];
    if (els.bodyList) {
      const rows = Array.from(els.bodyList.querySelectorAll(".r"));
      rows.forEach((r) => {
        // data-name 자동 주입
        if (!r.dataset.name) {
          r.dataset.name =
            (r.querySelector(".name-text")?.textContent || "").trim();
        }
        const next = r.nextElementSibling;
        state.listPairs.push({
          row: r,
          detail:
            next && next.classList.contains("detail") ? next : null,
        });
      });
    }

    // 카드 수집
    state.cardItems = els.cardGrid
      ? Array.from(els.cardGrid.querySelectorAll(".item-card"))
      : [];
    state.cardItems.forEach((c) => {
      if (!c.dataset.name) {
        c.dataset.name =
          (c.querySelector(".ic-title")?.textContent || "").trim();
      }
    });

    // 페이지 사이즈 반영
    if (els.pageSizeSel) {
      const v = parseInt(els.pageSizeSel.value || "10", 10);
      state.pageSize = isNaN(v) ? 10 : v;
    }
  }

  function totalItems() {
    return state.view === "list"
      ? state.listPairs.length
      : state.cardItems.length;
  }
  function totalPages() {
    const n = totalItems();
    return Math.max(1, Math.ceil(n / state.pageSize));
  }

  /* ===== 결과 정보 ===== */
  function updateResultInfo() {
    if (!els.resultInfo) return;
    const n = totalItems();
    const tp = totalPages();
    const start = n === 0 ? 0 : (state.currentPage - 1) * state.pageSize + 1;
    const end = Math.min(n, state.currentPage * state.pageSize);
    els.resultInfo.textContent = `총 ${n}개 · ${start}-${end} (페이지 ${state.currentPage}/${tp})`;
  }

  /* ===== 축약형 페이지 리스트 생성 =====
     (양 끝 2개 + 현재±2, 중간은 …)  */
  function buildPageList(tp, cp) {
    const keep = new Set(
      [1, 2, tp - 1, tp, cp - 2, cp - 1, cp, cp + 1, cp + 2].filter(
        (x) => x >= 1 && x <= tp
      )
    );
    const arr = [];
    let prev = 0;
    for (let i = 1; i <= tp; i++) {
      if (keep.has(i)) {
        arr.push(i);
        prev = i;
      } else {
        if (prev !== -1) {
          arr.push("...");
          prev = -1;
        }
      }
    }
    return arr.filter((v, i, a) => v !== "..." || a[i - 1] !== "...");
  }

  function renderNumbers() {
    if (!els.pageNumsEl) return;
    const tp = totalPages();
    const cp = state.currentPage;
    const parts = buildPageList(tp, cp);

    let html = "";
    parts.forEach((p) => {
      if (p === "...") {
        html += `<span class="page-ellipsis">…</span>`;
      } else {
        html += `<button class="page-num ${
          p === cp ? "active" : ""
        }" data-p="${p}" ${p === cp ? "disabled" : ""}>${p}</button>`;
      }
    });

    els.pageNumsEl.innerHTML = html;
    els.pageNumsEl.querySelectorAll(".page-num").forEach((btn) => {
      btn.addEventListener("click", () => {
        const p = parseInt(btn.dataset.p, 10);
        if (!isNaN(p) && p !== state.currentPage) {
          state.currentPage = p;
          // ★ 숫자 버튼 클릭 시에도 번호줄 재렌더링 필요!
          renderPage(true);
        }
      });
    });
  }

  /* ===== 페이지 렌더 ===== */
  function renderPage(resetNumbers = true) {
    const n = totalItems();
    const tp = totalPages();
    if (state.currentPage > tp) state.currentPage = tp;

    const startIdx = (state.currentPage - 1) * state.pageSize;
    const endIdx = Math.min(n, startIdx + state.pageSize);

    if (state.view === "list") {
      // 우선 전부 숨김
      state.listPairs.forEach(({ row, detail }) => {
        row.style.display = "none";
        if (detail) {
          // 페이지 이동 시 상세는 접고 숨겨두기
          detail.style.display = "none";
          detail.classList.remove("open");
          detail.style.maxHeight = "0";
        }
      });

      // 현재 페이지만 노출
      for (let i = startIdx; i < endIdx; i++) {
        const p = state.listPairs[i];
        if (!p) continue;
        p.row.style.display = "";
        // ★ 상세행은 현재 페이지에서는 display:''로 유지해야 토글이 동작함
        if (p.detail) p.detail.style.display = "";
      }
    } else {
      // 카드
      state.cardItems.forEach((card) => (card.style.display = "none"));
      for (let i = startIdx; i < endIdx; i++) {
        const c = state.cardItems[i];
        if (c) c.style.display = "";
      }
    }

    updateResultInfo();
    if (resetNumbers) renderNumbers();
  }

  /* ===== 뷰 토글 ===== */
  function setView(mode) {
    if (!els.listView || !els.cardView || !els.btnViewList || !els.btnViewCard)
      return;
    const isList = mode === "list";
    state.view = isList ? "list" : "card";
    state.currentPage = 1;

    els.listView.style.display = isList ? "" : "none";
    els.cardView.style.display = isList ? "none" : "";

    els.btnViewList.classList.toggle("active", isList);
    els.btnViewCard.classList.toggle("active", !isList);
    els.btnViewList.setAttribute("aria-selected", String(isList));
    els.btnViewCard.setAttribute("aria-selected", String(!isList));

    renderPage(true);
  }

  /* ===== 이벤트 바인딩 ===== */
  function bindEvents() {
    // 비교 슬롯 선택
    document.querySelectorAll(".sidebox.selectable").forEach((box) => {
      box.addEventListener("click", () => {
        document
          .querySelectorAll(".sidebox")
          .forEach((b) => b.classList.remove("selected"));
        box.classList.add("selected");
        selectedSlot = box.dataset.slot || "A";
      });
    });

    setupGroupCheckbox("jobs");
    setupGroupCheckbox("grades");

    if (els.pageSizeSel) {
      els.pageSizeSel.addEventListener("change", (e) => {
        const v = parseInt(e.target.value, 10);
        state.pageSize = isNaN(v) ? 10 : v;
        state.currentPage = 1;
        renderPage(true);
      });
    }

    if (els.btnViewList)
      els.btnViewList.addEventListener("click", () => setView("list"));
    if (els.btnViewCard)
      els.btnViewCard.addEventListener("click", () => setView("card"));
  }

  /* ===== 초기화 ===== */
  function init() {
    cacheElements();
    bindEvents();
    buildData();
    setView("list"); // 초기 리스트 뷰
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", init);
  } else {
    init();
  }
})();

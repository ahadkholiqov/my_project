function renderSidebar(activePage) {
    const loginTime = localStorage.getItem('loginTime');
    if (!loginTime || Date.now() - parseInt(loginTime) > 4 * 60 * 60 * 1000) {
        localStorage.clear();
        window.location.href = 'eduhub-login.html';
        return;
    }
    const role = localStorage.getItem('userRole');
    const userName = localStorage.getItem('userName');
    const userSurname = localStorage.getItem('userSurname');

    const roleLabel = {
        student: 'Студент',
        teacher: 'Учитель',
        moderator: 'Модератор',
        admin: 'Администратор'
    }[role] || role;

    const isMod = role === 'moderator' || role === 'admin';

    const html = `
        <aside class="sidebar">
            <div class="sidebar-logo">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M22 10v6M2 10l10-5 10 5-10 5z"/>
                    <path d="M6 12v5c3.33 2 8.67 2 12 0v-5"/>
                </svg>
                EduHub
            </div>

            <a class="nav-item ${activePage === 'main' ? 'active' : ''}" href="dashboard.html">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/></svg>
                Главная
            </a>
            <a class="nav-item ${activePage === 'library' ? 'active' : ''}" href="library.html">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/></svg>
                Библиотека
            </a>
            <a class="nav-item ${activePage === 'files' ? 'active' : ''}" href="files.html">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>
                Файлообменник
            </a>
            <a class="nav-item ${activePage === 'announcements' ? 'active' : ''}" href="announcements.html">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/></svg>
                Объявления
            </a>
            <a class="nav-item ${activePage === 'ideas' ? 'active' : ''}" href="ideas.html">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                Книга идей
            </a>

            ${isMod ? `
            <a class="nav-item ${activePage === 'moderation' ? 'active' : ''}" href="moderation.html">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
                Модерация
                <span id="sidebarModerationDot" style="width:8px;height:8px;background:#e53935;border-radius:50%;margin-left:auto;display:none;"></span>
            </a>
            ` : ''}

            ${role === 'admin' ? `
            <a class="nav-item ${activePage === 'admin' ? 'active' : ''}" href="admin.html">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="3"/><path d="M19.07 4.93a10 10 0 0 1 0 14.14M4.93 4.93a10 10 0 0 0 0 14.14"/></svg>
                Администрация
            </a>
            ` : ''}

            <div class="sidebar-bottom">
                <div class="user-card" onclick="openProfile()">
                    <div class="user-avatar" style="background:${getRoleAvatarColor(role)}">${getRoleAvatarLabel(role)}</div>
                    <div class="user-info">
                        <strong>${userName || ''} ${userSurname || ''}</strong>
                        <span>${roleLabel}</span>
                    </div>
                </div>
                <div class="logout" onclick="logout()">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="16" height="16"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
                    Выйти
                </div>
            </div>
        </aside>
    `;

    document.getElementById('sidebar-container').innerHTML = html;

    // Футер
    const existingFooter = document.getElementById('eduhub-footer');
    if (!existingFooter) {
        console.log('creating footer');
        const footer = document.createElement('div');
        footer.id = 'eduhub-footer';
        footer.style.cssText = `
        position: fixed;
        bottom: 0;
        left: 220px;
        right: 0;
        padding: 5px 40px;
        background: #efefef;
        border-top: 1px solid #e8e8e8;
        display: flex;
        justify-content: space-between;
        align-items: center;
        font-size: 12px;
        color: #888;
        z-index: 10;
    `;
        footer.innerHTML = `
        <span>© 2026 EduHub — Все права защищены</span>
        <span>EduHub 1.0.0</span>
        <span><a href="https://support.eduhub.tj" target="_blank" style="color:#999;text-decoration:none;">Тех. поддержка <svg style="display:inline;vertical-align:middle;" width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6"/><polyline points="15 3 21 3 21 9"/><line x1="10" y1="14" x2="21" y2="3"/></svg></a></span>
    `;
        document.body.appendChild(footer);
    }

    if (isMod) setTimeout(checkSidebarDot, 100);

    // Проверяем непрочитанные в файлообменнике для студента
    if (role === 'student') {
        const userId = localStorage.getItem('userId');
        const API = `${window.location.origin}/api`;
        fetch(`${API}/fileexchange/unread?userId=${userId}`)
            .then(r => r.json())
            .then(items => {
                if (items && items.length > 0) {
                    const link = document.querySelector('a.nav-item[href="files.html"]');
                    if (link && !link.querySelector('.nav-dot')) {
                        link.insertAdjacentHTML('beforeend', '<span class="nav-dot"></span>');
                    }
                }
            })
            .catch(() => { });
    }
}

function openProfile() {
    window.location.href = 'profile.html';
}

function logout() {
    localStorage.clear();
    window.location.href = 'eduhub-login.html';
}

async function checkSidebarDot() {
    try {
        const API = 'http://localhost:5052/api';
        const [libRes, annRes, ideasRes] = await Promise.all([
            fetch(`${API}/library/pending`),
            fetch(`${API}/announcements/pending`),
            fetch(`${API}/ideas/pending`)
        ]);

        const lib = await libRes.json();
        const ann = await annRes.json();
        const ideas = await ideasRes.json();

        const hasPending = lib.length > 0 || ann.length > 0 || ideas.length > 0;
        const dot = document.getElementById('sidebarModerationDot');
        if (dot) dot.style.display = hasPending ? 'inline-block' : 'none';
    } catch (e) { }
}
// ── Универсальные диалоги ──

function showAlert(message, type = 'info') {
    const existing = document.getElementById('eduhub-alert');
    if (existing) existing.remove();

    const colors = {
        info: { border: '#90caf9', icon: '#1565c0', bg: '#e3f2fd' },
        error: { border: '#ef9a9a', icon: '#c62828', bg: '#ffebee' },
        success: { border: '#a5d6a7', icon: '#2e7d32', bg: '#e8f5e9' },
        warning: { border: '#ffcc80', icon: '#e65100', bg: '#fff3e0' }
    };

    const icons = {
        info: '<circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/>',
        error: '<circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/>',
        success: '<polyline points="20 6 9 17 4 12"/>',
        warning: '<path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/>'
    };

    const c = colors[type] || colors.info;

    const el = document.createElement('div');
    el.id = 'eduhub-alert';
    el.style.cssText = `
        position: fixed; top: 24px; left: 50%; transform: translateX(-50%);
        background: #fff; border: 1.5px solid ${c.border};
        border-radius: 12px; padding: 16px 20px;
        display: flex; align-items: center; gap: 12px;
        box-shadow: 0 4px 20px rgba(0,0,0,0.1);
        z-index: 9999; min-width: 300px; max-width: 480px;
        animation: slideDown 0.2s ease;
    `;

    el.innerHTML = `
        <div style="width:32px;height:32px;border-radius:8px;background:${c.bg};display:flex;align-items:center;justify-content:center;flex-shrink:0;">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="${c.icon}" stroke-width="2">${icons[type]}</svg>
        </div>
        <div style="flex:1;font-size:14px;color:#333;font-family:'Segoe UI',sans-serif;">${message}</div>
        <div onclick="document.getElementById('eduhub-alert').remove()" style="cursor:pointer;color:#aaa;padding:4px;">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
        </div>
    `;

    document.body.appendChild(el);
    setTimeout(() => { if (document.getElementById('eduhub-alert')) document.getElementById('eduhub-alert').remove(); }, 4000);
}

function showConfirm(message, onConfirm, onCancel) {
    const existing = document.getElementById('eduhub-confirm');
    if (existing) existing.remove();

    const overlay = document.createElement('div');
    overlay.id = 'eduhub-confirm';
    overlay.style.cssText = `
        position: fixed; inset: 0; background: rgba(0,0,0,0.4);
        z-index: 9999; display: flex; align-items: center; justify-content: center;
    `;

    overlay.innerHTML = `
        <div style="background:#fff;border-radius:14px;padding:28px 32px;max-width:400px;width:90%;box-shadow:0 8px 32px rgba(0,0,0,0.15);">
            <div style="font-size:15px;font-weight:600;color:#111;margin-bottom:8px;font-family:'Segoe UI',sans-serif;">Подтверждение</div>
            <div style="font-size:14px;color:#555;margin-bottom:24px;font-family:'Segoe UI',sans-serif;">${message}</div>
            <div style="display:flex;gap:10px;justify-content:flex-end;">
                <button id="eduhub-confirm-cancel" style="background:none;border:1.5px solid #e0e0e0;border-radius:8px;padding:9px 18px;font-size:14px;color:#555;cursor:pointer;font-family:'Segoe UI',sans-serif;">Отмена</button>
                <button id="eduhub-confirm-ok" style="background:#111;color:#fff;border:none;border-radius:8px;padding:9px 18px;font-size:14px;font-weight:600;cursor:pointer;font-family:'Segoe UI',sans-serif;">Подтвердить</button>
            </div>
        </div>
    `;

    document.body.appendChild(overlay);

    document.getElementById('eduhub-confirm-ok').onclick = () => {
        overlay.remove();
        if (onConfirm) onConfirm();
    };

    document.getElementById('eduhub-confirm-cancel').onclick = () => {
        overlay.remove();
        if (onCancel) onCancel();
    };
}

// Добавляем анимацию
if (!document.getElementById('eduhub-alert-style')) {
    const style = document.createElement('style');
    style.id = 'eduhub-alert-style';
    style.textContent = `@keyframes slideDown { from { opacity:0; transform:translateX(-50%) translateY(-10px); } to { opacity:1; transform:translateX(-50%) translateY(0); } }`;
    document.head.appendChild(style);
}
function getRoleAvatarColor(r) {
    return { student: '#2e7d32', teacher: '#1565c0', moderator: '#e65100', admin: '#c62828' }[r] || '#555';
}

function getRoleAvatarLabel(r) {
    return { student: 'ST', teacher: 'TC', moderator: 'MD', admin: 'ADM' }[r] || '?';
}

document.addEventListener('click', function (e) {
    if (e.target.classList.contains('modal-overlay')) {
        e.target.classList.remove('open');
        if (e.target.style.display === 'flex') {
            e.target.style.display = 'none';
        }
    }
});
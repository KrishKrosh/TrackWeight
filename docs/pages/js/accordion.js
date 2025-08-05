document.addEventListener('DOMContentLoaded', () => {
    const accordionHeaders = document.querySelectorAll('.accordion-header');

    // ページにアコーディオン要素がない場合は、処理を終了
    if (accordionHeaders.length === 0) {
        return;
    }

    accordionHeaders.forEach(header => {
        header.addEventListener('click', () => {
            const accordionItem = header.closest('.accordion-item');
            // 'active'クラスを切り替えて、コンテンツの表示/非表示を制御
            accordionItem.classList.toggle('active');
        });
    });
});
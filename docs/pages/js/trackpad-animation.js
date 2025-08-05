document.addEventListener('DOMContentLoaded', () => {
    const trackpadContainer = document.querySelector('.trackpad-container');
    
    // ページにトラックパッド要素がない場合は、処理を終了
    if (!trackpadContainer) {
        return;
    }

    const weightIndicator = document.getElementById('weight-indicator');
    const weightDisplay = document.getElementById('weight-display');
    const heroOverlay = document.getElementById('hero-overlay');
    const trackpadSVG = trackpadContainer.querySelector('.trackpad-svg');

    // アニメーションと現在の重さを管理する変数。
    let animation = null;
    let currentWeight = 0;
    let animationFrameId = null;

    const startWeightMeasurement = () => {
        if (animation) {
            animation.pause();
        }

        const tl = anime.timeline({
            easing: 'easeOutExpo',
            duration: 1200
        });

        // 1. Hide the initial SVG animation
        if (trackpadSVG) {
            tl.add({
                targets: trackpadSVG,
                opacity: 0,
                duration: 300,
                easing: 'easeOutQuad'
            }, 0);
        }

        // 2. Darken the background
        tl.add({
            targets: heroOverlay,
            opacity: 0.95,
            duration: 800,
            easing: 'easeInOutQuad'
        }, 0);

        // 3. Abyss effect for the weight indicator
        tl.add({
            targets: weightIndicator,
            scale: [0, 30],
            opacity: [0, 0.5, 0],
            duration: 1800,
            easing: 'easeInOutSine',
            boxShadow: [
                '0 0 0 0 rgba(0, 122, 255, 0)',
                '0 0 120px 80px rgba(0, 122, 255, 0.4)',
                '0 0 200px 150px rgba(50, 210, 199, 0.2)',
                '0 0 0 0 rgba(0, 122, 255, 0)'
            ]
        }, 200);

        // 4. Fade in the weight display
        tl.add({
            targets: weightDisplay,
            opacity: [0, 1],
            duration: 500,
            easing: 'easeOutQuad',
        }, 500);

        // Start updating the weight number (outside the timeline)
        currentWeight = 0;
        const updateWeight = () => {
            currentWeight += Math.random() * 5; // 重量の増加をシミュレート
            if (currentWeight > 1000) currentWeight = 1000; // 上限を1000gに設定
            weightDisplay.textContent = `${currentWeight.toFixed(2)} g`;
            animationFrameId = requestAnimationFrame(updateWeight);
        };
        setTimeout(() => {
            animationFrameId = requestAnimationFrame(updateWeight);
        }, 600);

        animation = tl;
    };

    const stopWeightMeasurement = () => {
        // 重量の更新を停止
        cancelAnimationFrame(animationFrameId);

        if (animation && animation.progress < 100) {
            animation.pause();
        }

        const tl = anime.timeline({
            easing: 'easeInQuad',
            duration: 800
        });

        tl.add({
            targets: weightDisplay,
            opacity: 0,
            duration: 500,
            easing: 'easeOutQuad',
            complete: () => {
                weightDisplay.textContent = '0.00 g';
            }
        }, 0);

        tl.add({
            targets: heroOverlay,
            opacity: 0,
            duration: 800
        }, 100);

        anime.set(weightIndicator, {
            scale: 0,
            opacity: 0,
            boxShadow: '0 0 0 0 rgba(0, 122, 255, 0)'
        });

        if (trackpadSVG) {
            tl.add({
                targets: trackpadSVG,
                opacity: 1,
                duration: 500,
                easing: 'easeInQuad'
            }, 400);
        }
    };

    // デスクトップ（マウス）用イベントリスナー
    trackpadContainer.addEventListener('mousedown', startWeightMeasurement);
    trackpadContainer.addEventListener('mouseup', stopWeightMeasurement);
    trackpadContainer.addEventListener('mouseleave', stopWeightMeasurement);

    // モバイル（タッチ）用イベントリスナー
    trackpadContainer.addEventListener('touchstart', (e) => {
        e.preventDefault(); // スクロールなどのデフォルト動作を防止
        startWeightMeasurement();
    }, { passive: false });
    trackpadContainer.addEventListener('touchend', stopWeightMeasurement);
    trackpadContainer.addEventListener('touchcancel', stopWeightMeasurement);
});
// main.js

document.addEventListener('DOMContentLoaded', () => {
    const accordionHeaders = document.querySelectorAll('.accordion-header');

    accordionHeaders.forEach(header => {
        header.addEventListener('click', () => {
            const accordionItem = header.closest('.accordion-item');
            accordionItem.classList.toggle('active');
        });
    });

    // TrackWeight Animation Logic
    const trackpadContainer = document.querySelector('.trackpad-container');
    const weightIndicator = document.getElementById('weight-indicator');
    const weightDisplay = document.getElementById('weight-display');

    let animation = null;
    let currentWeight = 0;
    let animationFrameId = null;

    const startWeightMeasurement = () => {
        if (animation) {
            animation.pause();
        }

        // weightDisplay.style.opacity = 1; // This line is no longer needed as anime handles it
        currentWeight = 0;

        anime({
            targets: weightDisplay,
            opacity: [0, 1],
            duration: 500,
            easing: 'easeOutQuad',
        });

        const updateWeight = () => {
            currentWeight += Math.random() * 5; // Simulate weight increase
            if (currentWeight > 1000) currentWeight = 1000; // Cap at 1000g
            weightDisplay.textContent = `${currentWeight.toFixed(2)} g`;
            animationFrameId = requestAnimationFrame(updateWeight);
        };

        animationFrameId = requestAnimationFrame(updateWeight);

        animation = anime({
            targets: weightIndicator,
            width: ['0%', '100%'],
            height: ['0%', '100%'],
            opacity: [0, 1],
            easing: 'easeOutQuad',
            duration: 800,
            loop: false,
            autoplay: true
        });
    };

    const stopWeightMeasurement = () => {
        if (animation) {
            animation.reverse();
            animation.play();
        }
        cancelAnimationFrame(animationFrameId);

        anime({
            targets: weightDisplay,
            opacity: 0,
            duration: 500,
            easing: 'easeOutQuad',
            complete: () => {
                weightDisplay.textContent = '0.00 g';
            }
        });
    };

    // For desktop (mouse events)
    trackpadContainer.addEventListener('mousedown', startWeightMeasurement);
    trackpadContainer.addEventListener('mouseup', stopWeightMeasurement);
    trackpadContainer.addEventListener('mouseleave', stopWeightMeasurement); // In case mouse leaves while pressed

    // For mobile (touch events)
    trackpadContainer.addEventListener('touchstart', (e) => {
        e.preventDefault(); // Prevent scrolling
        startWeightMeasurement();
    }, { passive: false });
    trackpadContainer.addEventListener('touchend', stopWeightMeasurement);
    trackpadContainer.addEventListener('touchcancel', stopWeightMeasurement);
});
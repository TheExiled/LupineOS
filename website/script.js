document.addEventListener('DOMContentLoaded', () => {

    // --- Flavour Selector Logic ---
    const gpuSelect = document.getElementById('gpu-select');
    const downloadBtn = document.getElementById('download-btn');
    const isoSize = document.getElementById('iso-size');

    // Configuration for different ISOs
    const flavours = {
        'intel-amd': {
            url: 'https://github.com/LupineOS/lupineos/releases/download/v1.0/lupineos-main-x86_64.iso',
            size: '2.4 GB',
            name: 'v1.0-standard'
        },
        'nvidia': {
            url: 'https://github.com/LupineOS/lupineos/releases/download/v1.0/lupineos-nvidia-x86_64.iso',
            size: '2.8 GB',
            name: 'v1.0-nvidia'
        }
    };

    function updateDownloadButton() {
        const selected = gpuSelect.value;
        const config = flavours[selected];

        downloadBtn.href = config.url;
        isoSize.textContent = config.size;

        // Add a subtle flash animation to indicate change
        downloadBtn.style.transition = 'none';
        downloadBtn.style.transform = 'scale(0.98)';
        setTimeout(() => {
            downloadBtn.style.transition = 'transform 0.2s, box-shadow 0.2s';
            downloadBtn.style.transform = 'scale(1)';
        }, 100);
    }

    gpuSelect.addEventListener('change', updateDownloadButton);

    // Initialize
    updateDownloadButton();


    // --- Scroll Animations (Intersection Observer) ---
    const observerOptions = {
        threshold: 0.1,
        rootMargin: "0px 0px -50px 0px"
    };

    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('active');
                observer.unobserve(entry.target); // Only animate once
            }
        });
    }, observerOptions);

    const revealElements = document.querySelectorAll('.scroll-reveal');
    revealElements.forEach(el => observer.observe(el));
});

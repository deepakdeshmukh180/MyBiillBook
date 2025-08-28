window.addEventListener('DOMContentLoaded', event => {
    const datatablesSimple = document.getElementById('datatablesSimple');

    if (datatablesSimple) {
        // Show loader before initializing
        document.getElementById('loader').style.display = 'block';

        // Slight delay to ensure DOM is painted
        setTimeout(() => {
            new simpleDatatables.DataTable(datatablesSimple);

            // Hide loader after short delay to ensure table renders
            setTimeout(() => {
                document.getElementById('loader').style.display = 'none';
            }, 500); // You can tweak this
        }, 100);
    }
});




window.addEventListener('DOMContentLoaded', event => {
    const datatablesSimple = document.getElementById('datatablesSimple1');

    if (datatablesSimple) {
        // Show loader before initializing
        document.getElementById('loader').style.display = 'block';

        // Slight delay to ensure DOM is painted
        setTimeout(() => {
            new simpleDatatables.DataTable(datatablesSimple);

            // Hide loader after short delay to ensure table renders
            setTimeout(() => {
                document.getElementById('loader').style.display = 'none';
            }, 500); // You can tweak this
        }, 100);
    }
});
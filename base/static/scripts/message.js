document.addEventListener("DOMContentLoaded", function () {
    const messages = document.querySelectorAll(".messages li");
    messages.forEach((message, index) => {
        setTimeout(() => {
            message.style.opacity = 1;
            setTimeout(() => {
                message.style.opacity = 0;
                setTimeout(() => {
                    message.remove();
                }, 500); // Duration for fade out
            }, 5000); // Duration for display
        }, index * 3000); // Staggered display
    });
});
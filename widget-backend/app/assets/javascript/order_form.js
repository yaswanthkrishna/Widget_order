document.addEventListener("DOMContentLoaded", function () {
    var orderForm = document.getElementById("order_form");

    if (orderForm) {
        orderForm.addEventListener("submit", function (event) {
            // Prevent the form from submitting the default way if JS is enabled
            event.preventDefault();

            var formData = new FormData(orderForm);
            var data = {
                order: {
                    quantity: formData.get('order[quantity]'),
                    widget_type: formData.get('order[widget_type]'),
                    delivery_date: formData.get('order[delivery_date]'),
                    color: formData.get('order[color]')
                }
            };

            fetch(orderForm.action, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
                },
                body: JSON.stringify(data)
            }).then(function (response) {
                return response.json();
            }).then(function (data) {
                if (data.errors) {
                    alert('Failed to create order: ' + data.errors.join(', '));
                } else {
                    alert('Order was successfully created.\n\nOrder Details:\nQuantity: ' + data.order.quantity + '\nColor: ' + data.order.color + '\nDelivery Date: ' + data.order.delivery_date + '\nWidget Type: ' + data.order.widget_type);
                    // Optionally, you can redirect to the order show page or another page
                    window.location.href = '/orders/' + data.order.id;
                }
            }).catch(function (error) {
                console.error('Error:', error);
                alert('Failed to create order. Please try again.');
            });
        });
    }
});

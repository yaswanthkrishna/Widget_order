document.addEventListener("DOMContentLoaded", function () {
    var orderForm = document.getElementById("order_form");

    if (orderForm) {
        orderForm.addEventListener("submit", function (event) {
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
                clearErrorMessages();

                if (data.errors) {
                    displayErrorMessages(data.errors);
                } else {
                    alert('Order was successfully created.\n\nOrder Details:\nOrder Id:'+data.order.id+'\nQuantity: ' + data.order.quantity + '\nColor: ' + data.order.color + '\nDelivery Date: ' + data.order.delivery_date + '\nWidget Type: ' + data.order.widget_type);
                    window.location.href = '/orders/' + data.order.id;
                }
            }).catch(function (error) {
                console.error('Error:', error);
                alert('Failed to create order. Please try again.');
            });
        });
    }

    function clearErrorMessages() {
        var errorMessages = document.querySelectorAll('.error-message');
        errorMessages.forEach(function (message) {
            message.remove();
        });
    }

    function displayErrorMessages(errors) {
        Object.keys(errors).forEach(function (key) {
            var field = document.querySelector(`[name='order[${key}]']`);
            if (field) {
                var errorMessage = document.createElement('div');
                errorMessage.className = 'error-message';
                errorMessage.innerText = errors[key].join(', ');
                field.parentNode.insertBefore(errorMessage, field.nextSibling);
            }
        });
    }
});

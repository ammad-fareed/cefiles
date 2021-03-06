$(document).ready(function(){
    if( $(".subscription-form-intake").length > 0){
        // Create a Stripe client.
        var stripe = Stripe('pk_test_I573fsWrRvgFhEu807gjwi3j00cVjJH3nZ');

        // Create an instance of Elements.
        var elements = stripe.elements();
        // Custom styling can be passed to options when creating an Element.
        // (Note that this demo uses a wider set of styles than the guide below.)
        var style = {
            base: {
                color: '#32325d',
                fontFamily: '"Helvetica Neue", Helvetica, sans-serif',
                fontSmoothing: 'antialiased',
                fontSize: '16px',
                '::placeholder': {
                    color: '#aab7c4'
                }
            },
            invalid: {
                color: '#fa755a',
                iconColor: '#fa755a'
            }
        };

        var cardNumberElement = elements.create('cardNumber', {
            style: style
        });
        cardNumberElement.mount('#card-number-element');

        var cardExpiryElement = elements.create('cardExpiry', {
            style: style
        });
        cardExpiryElement.mount('#card-expiry-element');

        var cardCvcElement = elements.create('cardCvc', {
            style: style
        });
        cardCvcElement.mount('#card-cvc-element');

        // Add an instance of the card Element into the `card-element` <div>.
        //    card.mount('#card-element');
        var form = document.getElementById('subscription-form');
        submit = $('#subscription-form').find("input[type='submit']")
        var displayError = $('#card-errors')
        cardNumberElement.addEventListener('change', function(event) {
            if (event.error) {
                setError(event)
            } else {
                removeError()
            }
        });
        cardExpiryElement.addEventListener('change', function(event) {
            if (event.error) {

                setError(event)
            } else {
                removeError()
            }
        });
        cardCvcElement.addEventListener('change', function(event) {
            if (event.error) {
                setError(event)
            } else {
                removeError()
            }
        });
        function setError(event){
            submit.prop("disabled",true)
            displayError.show()
            displayError.text(event.error.message)
        }
        function removeError(){
            submit.prop("disabled",false)
            displayError.hide()
            displayError.text("");
        }

        form.addEventListener('submit', function(event) {
            event.preventDefault();
            var options = {
                address_zip: $('#postal-code').val(),
                name: $('#full-name').val()
            };
            stripe.createToken(cardNumberElement,options).then(function(result) {
                if (result.error) {
                    // Inform the customer that there was an error.
                    displayError.show("slow")
                    displayError.text(result.error.message)
                    $("#card-errors").css("visibility", "visible");
                    submit.prop("disabled",false)
                    submit.val("Subscribe")
                } else {
                    // Send the token to your server.
                    submit.prop("disabled",true)
                    $('#overlay').fadeIn()
                    stripeTokenHandler(result.token);
                }
            });
        });
        function stripeTokenHandler(token) {
            // Insert the token ID into the form so it gets submitted to the server
            var hiddenInput = document.createElement('input');
            hiddenInput.setAttribute('type', 'hidden');
            hiddenInput.setAttribute('name', 'subscription[card_token]');
            hiddenInput.setAttribute('value', token.id);
            form.appendChild(hiddenInput);
            // Submit the form
            form.submit();
        }
    }
})
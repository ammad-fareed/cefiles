module Stripe
    class InvoiceEventHandler
      def call(event)
        begin
          method = "handle_" + event.type.tr('.', '_')
          self.send method, event
        rescue JSON::ParserError => e
          # handle the json parsing error here
          render :json => {:status => 422, :error => "Webhook call failed"}
          return
        rescue NoMethodError => e
          #code to run when handling an unknown event
        end
      end
  
      def handle_invoice_payment_failed(event)
        customer_id = event.data.object.customer
        company = Company.find_by_customer_id(customer_id)
        attempt_count = event.data.object.attempt_count
        company.update_payment_failure(attempt_count)
      end
  
      def handle_invoice_payment_succeeded(event)
        customer_id = event.data.object.customer
        company = Company.find_by_customer_id(customer_id)
        company.renew_subscription
      end
    end
  end
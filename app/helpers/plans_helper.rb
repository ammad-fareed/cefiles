module PlansHelper
    def subscription_link(company,plan)
        plan_name = plan[:nickname]
        selected_plan = company.plan_name==plan
        company.plan_name==plan_name ? selected_plan_link : upgrade_link(plan,company)
        # link_to selected_plan? "Your Current Plan" : (plan=='Silver'? "Downgrade": "Upgrade"), company.plan_name==plan? "#": plan_update_subscriptions_path(p_id:plan[:id]),class:"btn btn-standard", data: (current_user.company.plan_name != p[:nickname]? {confirm:"Are you sue you want to change your plan?"} : nil) %>
    end
    def selected_plan_link
        link_to "Your Current Plan", "#", class:"btn  btn-primary btn-register"
    end
    def upgrade_link(plan,company)
        link_to plan[:nickname]=='Silver'? "Downgrade": "Upgrade",  plan_update_subscriptions_path(p_id: plan[:id]),class:"btn btn-primary btn-register", data:  {confirm:"Are you sure you want to change your plan?"}
    end
    def unsubscribe(plan)
        company = current_user.company
        if company.subscription_status !='cancelled'   
            link_to "Unsubscribe",cancel_subscription_subscriptions_path(p_id:company.plan_id),class:"btn btn-info btn-primary btn-register unsubscribe", data:{confirm:"Are you sure you want to unsubscribe the plan?"}
        else 
            resubscribe(plan)
        end
    end

    def resubscribe(plan)
        current_user.company.subscription_status =='cancelled' && current_user.company.unsubscribe_date_not_reached? ? 
        resubscribe_link
         : "" 
    end
    def resubscribe_link
        tags = capture {link_to "Resubscribe",resubscribe_subscriptions_path,class:"btn btn-info btn-register", data:{confirm:"Are you sure you want to resubscribe?"}}
        tags << capture {content_tag(:div, content_tag(:p, "Your subscription plan will end on #{format_date(current_user.company.current_period_end.to_date)}"), class: "subscription-message")}   
    end
    def format_date(date)
        date.strftime("%m-%d-%Y")
    end

end
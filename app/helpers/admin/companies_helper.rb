module Admin::CompaniesHelper
  def link_to_archive company
    archive_key = company.archived ? 'unarchive' : 'archive'
    path = company.archived ? unarchive_admin_company_path(company) : archive_admin_company_path(company)
    link_to t("activerecord.actions.#{archive_key}"), path, class:"btn btn-primary action-btn", method: :put,  data: { confirm: t('activerecord.actions.confirm')}
  end
  def link_to_archive_user user
    archive_key = user.archived ? 'unarchive' : 'archive'
    path = user.archived ? unarchive_admin_user_path(user) : archive_admin_user_path(user)
    link_to t("activerecord.actions.#{archive_key}"), path, class:"btn btn-primary action-btn", method: :put,  data: { confirm: t('activerecord.actions.confirm')}
  end
end

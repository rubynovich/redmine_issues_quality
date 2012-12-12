module RedmineIssuesQuality
  class Hooks < Redmine::Hook::ViewListener
    render_on :view_issues_form_details_bottom,
              :partial => 'hooks/redmine_issues_quality/view_issues_form_details_bottom'
  end
end 

require 'redmine'
require 'redmine_issues_quality/hooks'

Redmine::Plugin.register :redmine_issues_quality do
  name 'Оценка качества выполнения задач'
  author 'Roman Shipiev'
  description 'Позволяет оценивать задачи перед их закрытием. В настройках модуля надо установить статус, при котором задачу можно закрыть (Выполнена, например)'
  version '0.0.1'
  url 'http://github.com/rubynovich/redmine_issues_quality.git'
  author_url 'http://roman.shipiev.me'
  
  settings :default => { 
                         :issue_status => IssueStatus.last(:conditions => {:is_closed => false}, :order => :position).id
                       }, 
           :partial => 'ratings/settings'
  menu :admin_menu, :rating, 
    {:controller => :ratings, :action => :index},
    :caption => :label_rating_plural, :html => {:class => :enumerations}
end

if Rails::VERSION::MAJOR < 3
  require 'dispatcher'
  object_to_prepare = Dispatcher
else
  object_to_prepare = Rails.configuration
end

object_to_prepare.to_prepare do
  [:issue].each do |cl|
    require "issues_quality_#{cl}_patch"
  end

  [ 
    [Issue, IssuesQualityPlugin::IssuePatch],
  ].each do |cl, patch|
    cl.send(:include, patch) unless cl.included_modules.include? patch
  end
end


require_dependency 'issue'

module IssuesQualityPlugin
  module IssuePatch
    def self.included(base)
      base.extend(ClassMethods)

      base.send(:include, InstanceMethods)

      base.class_eval do
        unloadable

        safe_attributes 'rating_id'

        validates_presence_of :rating_id, :if => lambda{ |o|
          o.status.is_closed? &&
            Setting[:plugin_redmine_issues_quality][:issue_status].to_i == Issue.find(o.id).status_id &&
            !User.current.admin?
        }

        belongs_to :rating

        if Rails::VERSION::MAJOR >= 3
          scope :eql_field, lambda { |field, item|
            if item.present? && field.present?
              {:conditions => {field => item}}
            end
          }

          scope :with_rating, lambda {
            {:conditions => ["rating_id IS NOT NULL"]}
          }
        else
          named_scope :eql_field, lambda { |field, item|
            if item.present? && field.present?
              {:conditions => {field => item}}
            end
          }

          named_scope :with_rating, lambda {
            {:conditions => ["rating_id IS NOT NULL"]}
          }
        end

      end
    end

    module ClassMethods
    end

    module InstanceMethods
    end
  end
end

require_dependency 'issues_helper'

module IssuesQualityPlugin
  module IssuesHelperPatch
    def self.included(base)
      base.send(:include, InstanceMethods)
      
      base.class_eval do
        alias_method_chain :show_detail, :issues_quality
      end
    end
      
    module InstanceMethods
      def show_detail_with_issues_quality(detail, no_html=false, options={})
        if (detail.property == 'attr') && (detail.prop_key == 'rating_id')
          field = detail.prop_key.to_s.gsub(/\_id$/, "")
          label = l(("field_" + field).to_sym)
          value = find_name_by_reflection(field, detail.value)
          old_value = find_name_by_reflection(field, detail.old_value)        

          label ||= detail.prop_key
          value ||= detail.value
          old_value ||= detail.old_value

          call_hook(:helper_issues_show_detail_after_setting,
                    {:detail => detail, :label => label, :value => value, :old_value => old_value })

          unless no_html
            label = content_tag('strong', label)
            old_value = content_tag("i", h(old_value)) if detail.old_value
            old_value = content_tag("strike", old_value) if detail.old_value and detail.value.blank?
            value = content_tag("i", h(value)) if value
          end

          if detail.value.present? 
            if detail.old_value.present?
              l(:text_journal_changed, :label => label, :old => old_value, :new => value).html_safe
            else
              l(:text_journal_set_to, :label => label, :value => value).html_safe
            end
          else
            l(:text_journal_deleted, :label => label, :old => old_value).html_safe
          end
                    
        else
          show_detail_without_issues_quality(detail, no_html, options)
        end
      end
    end
  end
end

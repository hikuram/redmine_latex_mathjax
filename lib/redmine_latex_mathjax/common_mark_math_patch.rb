# frozen_string_literal: true

require_dependency 'redmine/wiki_formatting/common_mark/markdown_filter'
require_dependency 'redmine/wiki_formatting/common_mark/sanitization_filter'
require_dependency 'redmine/wiki_formatting/common_mark/formatter'

module RedmineLatexMathjax
  module CommonMarkMathDollarsPatch
    private

    def extensions
      super.merge(math_dollars: true)
    end
  end

  module CommonMarkMathSupport
    module_function

    def install!
      markdown_filter = Redmine::WikiFormatting::CommonMark::MarkdownFilter
      unless markdown_filter.ancestors.include?(CommonMarkMathDollarsPatch)
        markdown_filter.prepend(CommonMarkMathDollarsPatch)
      end

      sanitizer = Redmine::WikiFormatting::CommonMark::SANITIZER
      allowlist = sanitizer.allowlist
      attributes = allowlist[:attributes]
      span_attributes = Array(attributes['span']).dup
      unless span_attributes.include?('data-math-style')
        span_attributes << 'data-math-style'
        attributes['span'] = span_attributes
      end

      extensions = markdown_filter.new('', Redmine::WikiFormatting::CommonMark::PIPELINE_CONFIG).send(:extensions)
      span_ok = Array(sanitizer.allowlist.dig(:attributes, 'span')).include?('data-math-style')

      Rails.logger.info(
        "[redmine_latex_mathjax] CommonMark math_dollars=#{extensions[:math_dollars] == true}; " \
        "sanitizer data-math-style=#{span_ok}"
      )
    end
  end
end

Rails.application.config.to_prepare do
  RedmineLatexMathjax::CommonMarkMathSupport.install!
end

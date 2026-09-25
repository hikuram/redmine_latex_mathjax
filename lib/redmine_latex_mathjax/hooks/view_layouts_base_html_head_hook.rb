module RedmineLatexMathjax
  module Hooks
    class ViewLayoutsBaseHtmlHeadHook < Redmine::Hook::ViewListener
      def view_layouts_base_html_head(context={})
        inline_start = MathJaxEmbedMacro.delimiterStartInline.to_s.to_json
        inline_end = MathJaxEmbedMacro.delimiterEndInline.to_s.to_json
        block_start = MathJaxEmbedMacro.delimiterStartBlock.to_s.to_json
        block_end = MathJaxEmbedMacro.delimiterEndBlock.to_s.to_json

        mathjax_config = <<~JAVASCRIPT
          <script type="text/javascript">
            (function() {
              var inlineStart = #{inline_start};
              var inlineEnd = #{inline_end};
              var blockStart = #{block_start};
              var blockEnd = #{block_end};

              function restoreCommonMarkerMath() {
                document.querySelectorAll('span[data-math-style]').forEach(function(node) {
                  var style = node.getAttribute('data-math-style');
                  if (style !== 'inline' && style !== 'display') return;

                  var open = style === 'display' ? blockStart : inlineStart;
                  var close = style === 'display' ? blockEnd : inlineEnd;
                  node.replaceWith(document.createTextNode(open + node.textContent + close));
                });
              }

              window.MathJax = {
                tex: {
                  inlineMath: [
                    [inlineStart, inlineEnd],
                    ['\\\\(', '\\\\)']
                  ],
                  displayMath: [
                    [blockStart, blockEnd],
                    ['\\\\[', '\\\\]']
                  ]
                },
                startup: {
                  pageReady: function() {
                    restoreCommonMarkerMath();
                    return MathJax.startup.defaultPageReady();
                  }
                }
              };
            })();
          </script>
        JAVASCRIPT

        (mathjax_config +
          javascript_include_tag(MathJaxEmbedMacro.URLToMathJax) + "\n").html_safe
      end
    end
  end
end

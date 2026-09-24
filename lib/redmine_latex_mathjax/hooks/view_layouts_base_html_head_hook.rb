module RedmineLatexMathjax
  module Hooks
    class ViewLayoutsBaseHtmlHeadHook < Redmine::Hook::ViewListener
      def view_layouts_base_html_head(context={})
        inline_start = MathJaxEmbedMacro.delimiterStartInline.to_s.to_json
        inline_end = MathJaxEmbedMacro.delimiterEndInline.to_s.to_json

        mathjax_config = <<~JAVASCRIPT
          <script type="text/javascript">
            window.MathJax = {
              tex: {
                inlineMath: [
                  [#{inline_start}, #{inline_end}],
                  ['\\\\(', '\\\\)']
                ]
              }
            };
          </script>
        JAVASCRIPT

        # Redmine 7 loads previews asynchronously into .wiki-preview.
        # Observe that container rather than replacing Redmine's preview partial
        # or monkey-patching the removed submitPreview() function.
        preview_hook = <<~JAVASCRIPT
          <script type="text/javascript">
            document.addEventListener('click', function(event) {
              var target = event.target;
              if (!(target instanceof Element)) return;

              var tab = target.closest('div.jstTabs a.tab-preview');
              if (!tab) return;

              var block = tab.closest('.jstBlock');
              var preview = block ? block.querySelector('.wiki-preview') : null;
              if (!preview || typeof MutationObserver === 'undefined') return;

              // Clear MathJax's record of the old preview before Redmine
              // replaces its contents via AJAX.
              if (window.MathJax && typeof MathJax.typesetClear === 'function') {
                MathJax.typesetClear([preview]);
              }

              // A new click supersedes any still-pending preview observation.
              if (preview._redmineMathJaxObserver) {
                preview._redmineMathJaxObserver.disconnect();
              }

              var observer = new MutationObserver(function() {
                observer.disconnect();
                preview._redmineMathJaxObserver = null;

                if (!window.MathJax) return;

                if (typeof MathJax.typesetPromise === 'function') {
                  MathJax.typesetPromise([preview]).catch(function(error) {
                    console.error('MathJax preview typesetting failed:', error);
                  });
                } else if (typeof MathJax.typeset === 'function') {
                  MathJax.typeset([preview]);
                }
              });

              preview._redmineMathJaxObserver = observer;
              observer.observe(preview, {childList: true});
            });
          </script>
        JAVASCRIPT

        (mathjax_config +
          javascript_include_tag(MathJaxEmbedMacro.URLToMathJax) + "\n" +
          preview_hook).html_safe
      end
    end
  end
end

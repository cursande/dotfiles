{:user {:dependencies [[pjstadig/humane-test-output "0.8.3"]]
        :injections [(require 'pjstadig.humane-test-output)
                     (pjstadig.humane-test-output/activate!)]
        :plugins [[venantius/yagni "0.1.7"]
                  [lein-kibit "0.1.7"]]}}

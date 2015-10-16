ruby_rspec_parallel_html_report
===============================

This repo explains how to generate HTML report easily when running RSpec specs using parallel_tests gem.
- Run your tests using parallel_spec (e.g. in this repo rake integration_tests[2]) which generates json report
- Convert json report to HMTL report using this rake task
- Modify the rake task for your custom needs!
- Attached the Sample HTML report(with some tests in it)in spec/reports dir.


Ruby version
===========
   2.2.2

CI/CD
=====
- This would be very useful to send the HTML report to the wider audience when run through CI Pipeline(jenkins).
- Refer the screen shots in the docs directory, how to add this rake task in a jenkins job.

Run!
====
- To run the integration tests using parallel_tests from this repo
```rake integration_tests[2]```
- To Generate the HTML Report(pass 2 optional params 1. json report directory and 2. HTML file name. If not, default values will be passed)
```rake html_report['json_reports', QA_Results.html]```
- Just Pull this repo and bundle install and run the below rake task to see a HTML report under spec/reports
```rake html_report['json_reports_sample',Integration_Test_Results.html]```

Contributors
============
- [Sridharan Gopalan](https://github.com/sridgma)
- [Mai Le](https://github.com/lmle)

require 'rspec/core/rake_task'
require 'yarjuf'
require 'rake/testtask'
require 'json'

desc "Parallel Tests"
task :integration_tests,:thread_count do |t,args|
  files_to_run = []
  Dir['spec/integration/amazon/*'].each do |fname|
    files_to_run.push(fname)
  end

  spec_files = []
  files_to_run.each { |glob| spec_files += Dir[glob] }
  sh %{parallel_rspec -n #{args.thread_count} #{spec_files.join(" ")}}

end


#Task to parse the JSON report and generate HTML repport
desc "Parse RSpec json reports and generate HTML report"
task :html_report, :json_report_path, :html_report_file_name do |t,args|

  json_files_report_dir = args.json_report_path ||= 'json_reports'

  json_files = "#{json_files_report_dir}/*.json"
  html_report_file = "spec/reports/#{args.html_report_file_name ||='RSpec_test_report.html'}"

  compiled_hash = { groups: {},
                    summary: { duration: 0,
                               example_count: 0,
                               failure_count: 0
                    }
  }
  duration_from_each_file=[]

  if !Dir.exists?(json_files_report_dir)
    raise "RSpec json reports are not generated, could be some issues with test run"
  else
    # Aggregate data into compiled_hash
   Dir.glob(json_files) do |filename|
     json = File.read(filename)
     temp_hash = JSON.parse(json)

    examples = temp_hash['examples']
    duration = temp_hash['summary']['duration']
    duration_from_each_file << duration
    example_count = temp_hash['summary']['example_count']
    failure_count = temp_hash['summary']['failure_count']

    # Fill out groups hash
    examples.each do |example|
      group_title = example['full_description'].partition(" #{example['description']}").first
      compiled_hash[:groups][group_title] = { examples: [], run_time: 0, status: 'passed' } unless compiled_hash[:groups][group_title]
      compiled_hash[:groups][group_title][:examples] << example
      compiled_hash[:groups][group_title][:run_time] += example['run_time']
      compiled_hash[:groups][group_title][:status] = 'failed' if example['status'] == 'failed'
    end
    #puts compiled_hash[:groups]
    compiled_hash[:summary][:duration] += duration
    compiled_hash[:summary][:example_count] += example_count
    compiled_hash[:summary][:failure_count] += failure_count
   end

  STYLES_AND_SCRIPTS = <<EOF
<style type="text/css">
  body {
    line-height: 1.15;
    font-size: 0.8em;
    font-family: Helvetica, Sans-Serif;
  }

  .report-title {
    margin-left: 10px;
    font-size: 2em;
    font-weight: bold;
  }

  .options {
    display: inline-block;
  }

  .checkboxes {
    float: relative;
  }

  .expand-all, .collapse-all {
    color: #07c;
    margin: 0px 5px;
  }

  .expand-all {
    display: none;
  }

  .expand-all:hover, .collapse-all:hover {
    color: #0c65a5;
    cursor: hand;
  }

  .summary {
    overflow: hidden;
    margin: 0px 10px 10px 10px;
    padding: 10px;
    font-size: 1.5em;
    border: 2px solid black;
  }

  .summary-line {
    font-weight: bold;
  }

  .total-duration {
    float: right;
  }

  .test {
    overflow: hidden;
    word-wrap: break-word;
    margin: 5px 5px 5px 15px;
    padding: 5px;
  }

  .test .run-time {
    float: right;
  }

  .test-title {
    overflow: hidden;
    margin: 15px 5px 5px 5px;
    color: black;
    font-weight: bold;
    font-size: 1.2em;
    padding: 5px;
    border-bottom-left-radius: 5px;
    border-top-right-radius: 5px;
  }

  .test-title:hover {
    cursor: hand;
  }

  .test-title .expand-collapse {
    padding: 0px 7px 0px 3px;
    display: inline-block;
    width: 7px;
    text-align: center;
    color: white;
    text-shadow: 2px 2px rgba(0,0,0,0.75);
  }

  .group-run-time {
    float: right;
  }

  .test-title.passed {
    border-bottom: 3px solid #10EC10;
    background-color: #90FF90;
  }

  .test-title.failed {
    border-bottom: 3px solid #F76C6C;
    background-color: #FFA7A7;
  }

  .test.passed {
    border-left: 5px solid #00EE00;
    background-color: #CCFFCC;
  }

  .test.failed {
    border-left: 5px solid #FF6666;
    background-color: #FFD0D0;
  }

  .test.pending {
    border-left: 5px solid #FFAB66;
    background-color: #FFE3CC;
  }

  .failed-exception {
    background-color: rgba(255, 255, 255, 0.5);
    margin: 10px;
    padding: 5px;
    font-family: Courier;
    color: #E3170D;
    border-radius: 5px;
  }

  .backtrace-line {
    font-size: 1.05em;
    color: black;
  }
</style>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
<script type="text/javascript">
  $(function () {
    window.testFilter = function (filter) {
      $('.test.'+filter).toggle();
    }

    $('.expand-all').on('click', function () {
      $('.tests-container').show();
      $('.expand-collapse').text('-');
      $(this).hide()
      $('.collapse-all').show();
    });

    $('.collapse-all').on('click', function () {
      $('.tests-container').hide();
      $('.expand-collapse').text('+');
      $(this).hide()
      $('.expand-all').show();
    });

    $('.test-title').on('click', function () {
      var expandCollapseIcon = $(this).find('.expand-collapse');
      $(this).next().toggle();
      if(expandCollapseIcon.text() === '-') { expandCollapseIcon.text('+'); }
      else { expandCollapseIcon.text('-'); }
    });
  });
</script>
EOF

  File.write(html_report_file, STYLES_AND_SCRIPTS)

  # Append summary
  File.open(html_report_file, 'a') do |f|
    example_count = compiled_hash[:summary][:example_count]
    failure_count = compiled_hash[:summary][:failure_count]
    duration_in_s = duration_from_each_file.max
    formatted_duration = Time.at(duration_in_s).utc.strftime(' %-Hh %-Mm %-Ss')
    formatted_duration.slice!(' 0h ')
    formatted_duration.slice!(' 0m ')
    formatted_duration.slice!(' 0s')
    formatted_duration.strip!

    f.puts "<span class=\"report-title\">Integration Test Report</span>"
    f.puts "<div class=\"options\">"
    f.puts "  <span class=\"checkboxes\">"
    f.puts "    <label><input type=\"checkbox\" id=\"passed-checkbox\" checked=\"checked\" onchange=\"testFilter('passed')\">Passed</label>"
    f.puts "    <label><input type=\"checkbox\" id=\"failed-checkbox\" checked=\"checked\" onchange=\"testFilter('failed')\">Failed</label>"
    f.puts "  </span>"
    f.puts "  <span class=\"expand-all\">Expand All</span>"
    f.puts "  <span class=\"collapse-all\">Collapse All</span>"
    f.puts "</div>"
    f.puts "<div class=\"summary\">"
    f.puts "  <span class=\"summary-line\">#{example_count} examples, #{failure_count} failed </span>"
    f.puts "(#{((example_count.to_f-failure_count)/example_count*100).round(1)}% passed)"
    f.puts "  <span class=\"total-duration\">Finished in #{duration_in_s.floor}s (#{formatted_duration})</span>"
    f.puts "</div>"
  end

  # Append each group
  File.open(html_report_file, 'a') do |f|
    compiled_hash[:groups].each do |group_title, group_hash|
      f.puts "<div class=\"test-title #{group_hash[:status]}\">"
      raw_group_run_time = group_hash[:run_time]
      formatted_group_run_time = Time.at(raw_group_run_time).utc.strftime(' %-Hh %-Mm %-Ss')
      formatted_group_run_time.slice!(' 0h ')
      formatted_group_run_time.slice!(' 0m ')
      formatted_group_run_time.slice!(' 0s')
      formatted_group_run_time.strip!
      f.puts "  <span class=\"expand-collapse\">-</span> #{group_title} <span class=\"group-run-time\">#{formatted_group_run_time}</span>"
      f.puts "</div>"

      # Append each example from group
      f.puts "<div class=\"tests-container\">"
      group_hash[:examples].each do |example|
        description = example['description']
        status = example['status']
        raw_run_time = example['run_time']
        formatted_run_time = Time.at(raw_run_time).utc.strftime(' %-Mm %-Ss')
        formatted_run_time.slice!(' 0m ')
        formatted_run_time.slice!(' 0s')
        formatted_run_time.strip!

        # Print general test details
        f.puts "<div class=\"test #{status.downcase}\">"
        f.puts "  #{description}"
        f.puts "  <span class= \"run-time\">#{formatted_run_time}</span>"

        # Print failure details
        if status == "failed"
                    exception = example['exception']
          f.puts "  <div class=\"failed-exception\">"
          f.puts "    <b>#{exception['class']}</b><br>"
          f.puts "    #{exception['message'].partition("\n\nDiff").first.gsub("\n", "<br>")}<p>"
          # Print backtrace if it contains 'selenium/webdriver' or 'your project name'
          exception['backtrace'].each { |line| f.puts "    <span class=\"backtrace-line\">#{line}</span><br>" if (line.include?('ruby_rspec_parallel_html_report')|| line.include?('selenium/webdriver'))}
          f.puts "  </div>"
        end

        f.puts "</div>"
      end
      f.puts "</div>"
    end
  end

  end
end


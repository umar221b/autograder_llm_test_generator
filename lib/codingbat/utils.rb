require 'nokogiri'
require 'net/http'
require 'fileutils'

def get_categories
  categories = []
  res = Net::HTTP.get(URI("https://codingbat.com/python"))
  doc = Nokogiri::HTML(res)
  doc.search('div.summ a').each do |category|
    categories << category.attribute('href').value.split('/')[-1]
  end
  categories
end

def get_category_problems(category)
  problems_info = []
  res = Net::HTTP.get(URI("https://codingbat.com/python/#{category}"))
  doc = Nokogiri::HTML(res)
  doc.search('.indent table td a').each do |problem|
    problems_info << [problem.children[0].to_s, problem.attribute('href').value.split('/')[-1]]
  end
  problems_info
end

def get_problem_tests(category, problem_info)
  problem_name = problem_info[0]
  problem_id = problem_info[1]
  res = Net::HTTP.get(URI("https://codingbat.com/prob/#{problem_id}"))
  doc = Nokogiri::HTML(res)
  solution = doc.search('div#ace_div').children[0].content
  solution = solution.split(':').first
  solution += ": pass"

  params = {
    id: problem_id,
    code: solution
  }

  uri = URI('https://codingbat.com/run')
  http = Net::HTTP.new(uri.hostname, uri.port)
  http.use_ssl = true

  request = Net::HTTP::Post.new(uri)
  request.set_form_data(params)
  response = http.request(request)

  case response
  when Net::HTTPSuccess, Net::HTTPRedirection
    puts "Submitted solution successfully.."
  else
    puts category, problem_name, problem_id
    puts response.body
    puts response.message
    puts response.code
    return
  end

  doc = Nokogiri::HTML(response.body)
  rows = doc.search('div#tests table tr')
  tests = []
  rows[1..-1].each do |row|
    content = row.children[0].content
    if content == 'other tests'
      puts "Problem #{problem_name} contains hidden tests.."
    else
      tests << content
    end
  end
  tests
end

def write_tests_to_file(category, problem_info, tests)
  FileUtils.mkdir_p(category)
  function_name = tests[0].split('(')[0]
  out_file = File.new("#{category}/test_#{problem_info[0]}_#{problem_info[1]}.py", "w")
  out_file.puts("from solution import #{function_name}")
  out_file.puts("def run_tests():\n  correct = 0\n  total = #{tests.size}")
  tests.each do |test|
    input_output = test.split(" → ")
    out_file.puts("  if #{input_output[0]} == #{input_output[1]}:\n    correct += 1")
  end
  out_file.puts("  print(f\"{correct} / {total} successful tests\")")
  out_file.puts("run_tests()")
  out_file.close
end
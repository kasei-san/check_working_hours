require "rubygems"
require "date"
require "selenium-webdriver"

LOGIN_URI = 'https://ssl.jobcan.jp/login/pc-employee/'


driver = Selenium::WebDriver.for(:phantomjs)
driver.get(LOGIN_URI)

driver.find_element(:id, 'client_id').send_keys(ENV['CLIENT_ID'])
driver.find_element(:id, 'email').send_keys(ENV['EMAIL'])
driver.find_element(:id, 'password').send_keys(ENV['PASSWORD'])

driver.find_element(:xpath, '/html/body/div[3]/form/div[5]/button').click

sleep(1)

if driver.current_url.split("?").first == LOGIN_URI
  p driver.find_element(:class, 'error').text
  exit 1
end

driver.get('https://ssl.jobcan.jp/employee/attendance')
sleep(1)

hour = driver.find_element(:xpath, '/html/body/div[3]/div/div/div/div/div/div/div[5]/div/div[2]/table[3]/tbody/tr[1]/td').text.strip
date = driver.find_element(:xpath, '/html/body/div[3]/div/div/div/div/div/div/div[5]/div/div[2]/table[2]/tbody/tr[1]/td').text.strip.to_i
prescribed_date = driver.find_element(:xpath, '/html/body/div[3]/div/div/div/div/div/div/div[5]/div/div[2]/table[1]/tbody/tr[4]/td').text.strip.split(" ").first.to_i

puts "実労働時間 : #{hour}"
puts "実働日数 : #{date}"
remaining_hour = (prescribed_date*8) - (hour.split(":").first.to_i)

puts "残日数 : #{prescribed_date - date}"
puts "残労働時間 : #{remaining_hour}"
puts "1日あたりの残労働時間 : #{remaining_hour*1.0/(prescribed_date-date)}"

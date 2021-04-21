# Encoding: utf-8

require 'selenium-webdriver'
require 'rspec/expectations'
include RSpec::Matchers

def setup
  @driver = Selenium::WebDriver.for :firefox
end

def teardown
  @driver.quit
end

def run
  setup
  yield
  teardown
end

### Part 1 ###
run do
  @driver.get 'http://the-internet.herokuapp.com/login'
  @driver.find_element(id: 'username').send_keys('tomsmith')
  @driver.find_element(id: 'password').send_keys('SuperSecretPassword!')
  @driver.find_element(id: 'login').submit
  expect(@driver.find_element(id: 'login').displayed?).to eql false
end
# RETURNS:
# Unable to locate element: \
#{"method":"id","selector":"login"} (Selenium::WebDriver::Error::NoSuchElementError)
# See https://seleniumhq.github.io/selenium/docs/api/rb/Selenium/WebDriver.html for details

### Part 2 ###
run do
  @driver.get 'http://the-internet.herokuapp.com/login'
  @driver.find_element(id: 'username').send_keys('tomsmith')
  @driver.find_element(id: 'password').send_keys('SuperSecretPassword!')
  @driver.find_element(id: 'login').submit
  begin
    expect(@driver.find_element(id: 'login').displayed?).to eql false
  rescue Selenium::WebDriver::Error::NoSuchElementError
    false
  rescue Selenium::WebDriver::Error::StaleElementReferenceError
    false
  end
end


### Part 3 ###
def rescue_exceptions
  begin
    yield
  rescue Selenium::WebDriver::Error::NoSuchElementError
    false
  rescue Selenium::WebDriver::Error::StaleElementReferenceError
    false
  end
end

def is_displayed?(locator = {})
  rescue_exceptions { @driver.find_element(locator).displayed? }
end

run do
  @driver.get 'http://the-internet.herokuapp.com/login'
  @driver.find_element(id: 'username').send_keys('tomsmith')
  @driver.find_element(id: 'password').send_keys('SuperSecretPassword!')
  @driver.find_element(id: 'login').submit
  expect(is_displayed?(id: 'login')).to eql false
end

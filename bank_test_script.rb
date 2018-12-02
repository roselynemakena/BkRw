require 'selenium-webdriver'
require 'test-unit'


class BankOfKigaliTest < Test::Unit::TestCase 
	def setup
		@url = 'https://www.bk.rw/personal'
		@my_driver = Selenium::WebDriver.for :firefox
		@my_driver.get(@url)
		puts "...Starting the application test Suite...."
		initialize_variables

		@my_driver.manage.timeouts.implicit_wait = 25
		@my_driver.manage.window.maximize
		@wait = Selenium::WebDriver::Wait.new(:timeout => 10)
	end

	def divider
		puts "-------"		
	end

	def teardown
		puts "...Quitting the application...."
		@my_driver.quit
	end

=begin
This is a test for the homepage test titles and cards
A/C: There should be 3 cards with the respective titles and description
=end
	def test_titles_and_cards
		@cards = @my_driver.find_elements(:class, 'serviceBox')
		@open_accounts_card_items = @my_driver.find_elements(:class, 'shortcut-url')
		@cards.each_with_index do |item, indexPosition| 
			puts "----\n\n\n\n---"
			@open_accounts_card_items.each_with_index do |item, cardIndex|
				puts "\n---Verifying card items for Card #{cardIndex}---"
				divider
				puts " Card Items for #{cardIndex}::::::: \n#{item.text}"
				divider
				assert(item.to_s, @items[0].to_s)
			end
		
			divider
			@cards.each_with_index do |title, itemIndex|
				puts "----Verifying title items in the Cards---"
				puts "Title item ::::::: #{title.text}"
				assert(title.to_s, @items[itemIndex].to_s)
			end
		end
	end

=begin
This is a test for the foreign exchange buy and sell values
A/C: The buy value should be less than the sell value
=end
	def test_foreign_exchange_buy_and_sell
			table = @wait.until {@my_driver.find_element(:class, 'table')}
			if table.displayed?
			trs = table.find_elements(:tag_name, "tr")

			trs.each_with_index do |tr, pos|
				tds = tr.find_elements(:tag_name, "td")
				if pos > 0
				puts "-----------Table Row Number #{pos}---------------"
					tds.each_with_index do |td, pos|
						if pos > 0
							puts "Comparing items at BUY[#{@buy = tds[1].text.gsub(/[\s,]/ ,"").to_f}]  and SELL[#{@sell = tds[2].text.gsub(/[\s,]/ ,"").to_f}]"
							assert_operator @buy , :<, @sell
							puts "Passed"
							break
						end
					end
				end		
			end
		end
	end

=begin
This is a test for the Online Banking page - button
A/C: There should be an 'Apply Button' available on this page
=end
	def test_current_menu
		current_savings_link = @my_driver.find_element(:xpath, '//*[@id="nav"]/div/div/div[2]/ul[1]/li[2]/a')
		current_savings_link.click
		puts "Current & Savings link click successful"
		online_banking_link = @my_driver.find_element(:link, 'Online Banking')
		online_banking_link.click
		@open_accounts_title = @wait.until {@my_driver.find_elements(:xpath, '//html/body/div[4]/div/div')}
		puts "-->#{@open_accounts_title[0].text}"
		assert(@open_accounts_title[0].text, @online_banking_slide_title)
		@open_accounts_button = @wait.until {@my_driver.find_element(:link, 'Apply Now')}
		puts "Online Banking link click successfully navigated to the right"
	end

	def initialize_variables	
=begin
All constants that provide Strings for the Acceptace criteria for the tests.
They are initiated before the test begins.
=end
		@title = ["Open account", "Open account", "Open account", "Open account"]
		@items = [['''Personal Current
Joint Account
Special Savings
Fixed Savings
Cash-extra Savings
Student Saving
Kira Kibondo'''],
['''Consumer Loan
Car Loan
Agriculture loan
Overdraft
Plot loan
Business loan
Loan calculator'''],
['''House purchase
House construction
Remortgage
Find house deal New
Mortgage calculator
Loan Advice?'''],
['''Visa/Mastercard Debit
Visa Prepaid
Classic Credit Card
Gold Credit Card
Platinum Credit Card''']]

		@online_banking_slide_title = 	"Online Banking
										You can do it all on-the-go. Check your account balance, pay your bills, tranfers funds, and do many more on internet.
										Login here"

	end
end
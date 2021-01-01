require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper
  attr_accessor :student
  @@all = []

  def self.scrape_index_page(index_url)
    html = open(index_url)  #open method takes in my url and returns the html from that page
    doc = Nokogiri::HTML(html)  # takes in my html as method and returns a set of nodes
    students = []  #take the students hash information from html and shovel onto my students array
    doc.css("div.student-card").each do |student| #doc.css will illerate over the div student card and return set hash/key value pairs.
      students << {
        :name => student.css("h4.student-name").text,
        :location => student.css("p.student-location").text,
        :profile_url => student.children[1].attributes["href"].value
      }
      #binding.pry
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
    profile_page = {}
    social_links = doc.css(".social-icon-container").css('a').collect {|i| i.attributes["href"].value}
    social_links.detect do |i|
      profile_page[:twitter] = i if i.include?("twitter")
      profile_page[:linkedin] = i if i.include?("linkedin")
      profile_page[:github] = i if i.include?("github")
      #binding.pry
    end

    profile_page[:blog] = social_links[3] if social_links[3] != nil
    profile_page[:profile_quote] = doc.css(".profile-quote")[0].text
    profile_page[:bio] = doc.css(".description-holder").css('p')[0].text
    profile_page

  end

end

#doc.css("div.student-card").text = value of everything on page
#student.css("h4.student-name").text = value of the students name
#student.children[1].attributes["href"].value = value of the profile url

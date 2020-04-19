# frozen_string_literal: true

require 'net/http'
require 'open-uri'
require 'json'
require 'pry'
require_relative 'csv_report.rb'

all_vacancies = []

url = 'https://api.hh.ru/vacancies?text=ruby&per_page=100&area=113'
request = Net::HTTP.get(URI(url))
json_parse_vacancy = JSON.parse(request)
pages_vacancies = json_parse_vacancy['pages']

pages_vacancies.times do |page|
  request = Net::HTTP.get(URI("#{url}&page=#{page}"))
  JSON.parse(request)['items'].each { |el| all_vacancies << el }
end

CsvReport.new(all_vacancies).short_report
CsvReport.new(all_vacancies).full_report

puts "Вакансий сегодня -> #{all_vacancies.count}"

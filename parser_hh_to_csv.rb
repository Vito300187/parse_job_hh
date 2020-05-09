# frozen_string_literal: true

require 'net/http'
require 'open-uri'
require 'json'
require 'pry'
require 'pg'
require_relative 'csv_report.rb'
require_relative 'helpers/helpers'

list_vacancies_two_thousand = []
find_request = 'ruby'

url = "https://api.hh.ru/vacancies?text=#{find_request}&per_page=100&area=113"
vacancies_request = Net::HTTP.get(URI(url))

json_parse_vacancy = JSON.parse(vacancies_request)
pages_vacancies = json_parse_vacancy['pages']
vacancies_count = json_parse_vacancy['found']

pages_vacancies.times do |page|
  request = Net::HTTP.get(URI("#{url}&page=#{page}"))
  JSON.parse(request)['items'].each { |el| list_vacancies_two_thousand << el }
end

CsvReport.new(vacancies_count).short_report
CsvReport.new(list_vacancies_two_thousand).full_report

conn = PG.connect(dbname: 'vacancies')
list_vacancies_two_thousand.each { |params| conn.exec(request_into_database(params)) }

puts "Vacancies today -> #{vacancies_count}"

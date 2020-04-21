# frozen_string_literal: true

require 'csv'
require 'time'

class CsvReport
  def initialize(all_vacancies)
    @all_vacancies = all_vacancies
    @full_report_path = '/Users/vitalii-artec3d/Desktop/Home/api_hh/yearly_full_ruby_job_report.csv'
    @short_report_path = '/Users/vitalii-artec3d/Desktop/Home/api_hh/yearly_short_ruby_job_report.csv'
  end

  def full_report
    CSV.open(@full_report_path, 'a+') do |csv|
      headers = %w[Дата Название Город Зарплата\ от Зарплата\ до Валюта Компания]

      csv << headers if File.file?(@full_report_path) && File.readlines(@full_report_path)[0].nil?

      @all_vacancies.each do |params|
        csv << [
          Time.now.strftime('%d.%m.%Y'),
          params['name'].nil? ? '-' : params['name'],
          params['area'].nil? ? '-' : params['area']['name'],
          params['salary'].nil? ? '-' : params['salary']['from'],
          params['salary'].nil? ? '-' : params['salary']['to'],
          params['salary'].nil? ? '-' : params['salary']['currency'],
          params['employer'].nil? ? '-' : params['employer']['name']
        ]
      end
    end
  end

  def short_report
    CSV.open(@short_report_path, 'a+') do |csv|
      headers = %w[Дата Кол-во\ вакансий]

      csv << headers if File.file?(@short_report_path) && File.readlines(@short_report_path)[0].nil?
      csv << [Time.now.strftime('%d.%m.%Y'), @all_vacancies.count]
    end
  end
end

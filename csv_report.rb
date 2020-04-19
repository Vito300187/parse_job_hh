# frozen_string_literal: true

require 'csv'
require 'time'

class CsvReport
  def initialize(all_vacancies)
    @all_vacancies = all_vacancies
  end

  def full_report
    CSV.open('yearly_full_ruby_job_report.csv', 'a+') do |csv|
      headers = %w[Дата Название Город Зарплата\ от Зарплата\ до Валюта Компания]

      if File.file?('yearly_full_ruby_job_report.csv') && File.readlines('yearly_full_ruby_job_report.csv')[0].nil?
        csv << headers
      end

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
    CSV.open('yearly_short_ruby_job_report.csv', 'a+') do |csv|
      headers = %w[Дата Кол-во\ вакансий]

      if File.file?('yearly_short_ruby_job_report.csv') && File.readlines('yearly_short_ruby_job_report.csv')[0].nil?
        csv << headers
      end

      csv << [Time.now.strftime('%d.%m.%Y'), @all_vacancies.count]
    end
  end
end

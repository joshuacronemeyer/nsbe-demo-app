class CareerFairController < ApplicationController

  def index
    redirect_to :action => "collector"
  end
  
  def matcher
    @job = Job.find_by_name(@params[:job])
    if @job.nil?
      @companies = sorted_list_of_summed_company_rankings
    else
      @companies = sorted_list_of_company_rankings_for(@job)
    end
  end

  def collector
  end
  
  def collect
    @companies = Array.new
    @params[:company].each_value{ |company_name| @companies << (Company.find_or_create company_name) }
    @job = Job.find_or_create @params[:job]
    @companies.each{ |company| Ranking.update_ranking_for company, @job }
    redirect_to :action => "matcher", :job => @job.name
  end

  def sorted_list_of_summed_company_rankings
    companies = Company.find_by_sql("select * from companies")
    return companies.sort_by{ |company| company.total_rank}.reverse
  end
  
  def sorted_list_of_company_rankings_for(job)
    companies = Array.new
    job.rankings.each{ |ranking| companies << ranking.company}
    return companies.sort_by{ |company| (Ranking.find_by_company_and_job company, job).count}.reverse
  end
  
end

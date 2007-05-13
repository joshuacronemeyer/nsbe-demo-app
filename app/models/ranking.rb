class Ranking < ActiveRecord::Base
  belongs_to :job
  belongs_to :company
  validates_presence_of :company_id, :job_id
  def Ranking.update_ranking_for(company, job)
    ranking = find_by_company_and_job(company, job)
      if ranking
        ranking.count += 1
        ranking.save
      else
        ranking = Ranking.new(:company_id => company.id, :job_id => job.id, :count => 1).save
      end
    return ranking
  end
  
  def Ranking.find_by_company_and_job(company, job)
    return Ranking.find(:first,:conditions => ["company_id = ? and job_id = ?", company.id, job.id])
  end
end

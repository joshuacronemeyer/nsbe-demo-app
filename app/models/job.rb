class Job < ActiveRecord::Base
  has_many :rankings
  validates_uniqueness_of :name
  validates_presence_of :name
  
  def Job.find_or_create(job_name)
    job = Job.find_by_name(job_name.downcase)
    if !job
      job = Job.new(:name => job_name.downcase)
      job.save
    end
    return job
  end
  
  def to_s()
    @name
  end
  
end

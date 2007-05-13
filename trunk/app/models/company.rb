class Company < ActiveRecord::Base
  has_many :rankings
  validates_uniqueness_of :name
  validates_presence_of :name
  
  def Company.find_or_create(company_name)
    company = Company.find_by_name(company_name.downcase)
    if !company
      company = Company.new(:name => company_name.downcase)
      company.save
    end
    return company
  end
  
  def to_s()
    @name
  end
  
  def total_rank
    total=0
    rankings.each{|ranking| total += ranking.count}
    total
  end
  
end

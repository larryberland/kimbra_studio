class Role < ActiveRecord::Base

  has_many :user_roles, :dependent => :destroy
  has_many :users, :through => :user_roles

  validates :name, :presence => true, :length => {:maximum => 55}

  SUPER_ADMIN      = 'super_administrator'
  ADMIN            = 'administrator'
  STUDIO           = 'studio'
  STUDIO_STAFF     = 'studio_staff'
  CLIENT           = 'client'
  REPORT           = 'report'
  CUSTOMER_SERVICE = 'customer_service'

  ROLES = [SUPER_ADMIN,
           ADMIN,
           STUDIO,
           STUDIO_STAFF,
           CLIENT,
           REPORT,
           CUSTOMER_SERVICE]

  NON_ADMIN_ROLES = [STUDIO, STUDIO_STAFF, CLIENT, REPORT, CUSTOMER_SERVICE]

  SUPER_ADMIN_ID      = 1
  ADMIN_ID            = 2
  STUDIO_ID           = 3
  STUDIO_STAFF_ID     = 4
  CLIENT_ID           = 5
  REPORT_ID           = 6
  CUSTOMER_SERVICE_ID = 7

  private

  def self.find_role_id(id)
    Rails.cache.fetch("role-#{id}") do #, :expires_in => 30.minutes
      self.find(id)
    end
  end

  def self.find_role_name(name)
    Rails.cache.fetch("role-#{name}") do #, :expires_in => 30.minutes
      self.find_by_name(name)
    end
  end
end

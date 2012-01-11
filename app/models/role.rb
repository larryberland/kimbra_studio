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
  ADMIN_ROLES     = ROLES - NON_ADMIN_ROLES

  SUPER_ADMIN_ID      = 1
  ADMIN_ID            = 2
  STUDIO_ID           = 3
  STUDIO_STAFF_ID     = 4
  CLIENT_ID           = 5
  REPORT_ID           = 6
  CUSTOMER_SERVICE_ID = 7

  def is_admin?
    name.present? and (ADMIN_ROLES.include?(name))
  end

  def is_studio?
    is_role?(STUDIO)
  end

  def is_studio_staff?
    is_role?(STUDIO_STAFF)
  end

  def is_client?
    is_role?(CLIENT)
  end

  def is_report?
    is_role?(REPORT)
  end

  def is_customer_service?
    is_role?(CUSTOMER_SERVICE)
  end

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

  def is_role?(this_role_name)
    name.present? and (name == this_role_name)
  end
end

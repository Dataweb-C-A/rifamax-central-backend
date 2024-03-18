# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def self.ilike(params)
    params.reduce(all) do |scope, (column, value)|
      scope.where(scope.arel_table[column].send(:matches, value))
    end
  end

  def self.between(params)
    params.reduce(all) do |scope, (column, value)|
      scope.where(scope.arel_table[column].send(:between, value..))
    end
  end

  def self.recently
    where(created_at: 12.hours.ago..Time.current)
  end

  def self.recently_commit
    where(updated_at: 12.hours.ago..Time.current)
  end
end

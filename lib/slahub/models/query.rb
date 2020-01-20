module Slahub
  module Models
    class Query < ApplicationRecord
      def self.fetch_by_query(query)
        find_or_initialize_by(query: query).tap do |q|
          # TODO: 24.hour.ago is for test data, it should be 5 minutes ago or so on.
          q.update!(newest_issue_updated_at: 24.hour.ago) if q.new_record?
        end
      end
    end
  end
end

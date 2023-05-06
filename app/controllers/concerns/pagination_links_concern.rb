# frozen_string_literal: true

module PaginationLinksConcern
  extend ActiveSupport::Concern

  included do
    def pagination_links(data)
      return {} if data.empty?

      {
        links: {
          first: api_v1_posts_url(page: 1, per_page: params[:per_page]),
          previous: api_v1_posts_url(page: data.previous_page, per_page: params[:per_page]),
          current: api_v1_posts_url(page: data.current_page, per_page: params[:per_page]),
          next: api_v1_posts_url(page: data.next_page, per_page: params[:per_page]),
          last: api_v1_posts_url(page: data.total_pages, per_page: params[:per_page])
        },
        first_page: 1,
        previous_page: data.previous_page,
        current_page: data.current_page,
        next_page: data.next_page,
        last_page: data.total_pages,
        total_pages: data.total_pages
      }
    end
  end
end

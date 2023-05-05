# frozen_string_literal: true

module PaginationLinksConcern
  extend ActiveSupport::Concern

  included do
    def pagination_links(objects)
      {
        links: {
          first: api_v1_posts_url(page: 1, per_page: params[:per_page]),
          previous: api_v1_posts_url(page: objects.previous_page, per_page: params[:per_page]),
          current: api_v1_posts_url(page: objects.current_page, per_page: params[:per_page]),
          next: api_v1_posts_url(page: objects.next_page, per_page: params[:per_page]),
          last: api_v1_posts_url(page: objects.total_pages, per_page: params[:per_page])
        },
        first_page: 1,
        previous_page: objects.previous_page,
        current_page: objects.current_page,
        next_page: objects.next_page,
        last_page: objects.total_pages,
        total_pages: objects.total_pages
      }
    end
  end
end

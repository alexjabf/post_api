# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PaginationLinksConcern, type: :controller do
  controller(ApplicationController) do
    include PaginationLinksConcern

    def index
      posts = Post.paginate(page: params[:page], per_page: params[:per_page])
      render json: pagination_links(posts)
    end
  end

  describe '#pagination_links' do
    context 'when there is data' do
      let!(:posts) { create_list(:post, 10) }

      before { get :index, params: { per_page: 2, page: 3 } }

      it 'returns a hash with pagination links and information' do
        response_body = JSON.parse(response.body)

        expect(response_body.deep_symbolize_keys!).to include(
          {
            links:
              {
                first: api_v1_posts_url(page: 1, per_page: 2),
                previous: api_v1_posts_url(page: 2, per_page: 2),
                current: api_v1_posts_url(page: 3, per_page: 2),
                next: api_v1_posts_url(page: 4, per_page: 2),
                last: api_v1_posts_url(page: 5, per_page: 2)
              },
            first_page: 1,
            previous_page: 2,
            current_page: 3,
            next_page: 4,
            last_page: 5,
            total_pages: 5
          }
        )
      end
    end

    context 'when there is no data' do
      let!(:posts) { [] }
      before { get :index, params: { per_page: 2, page: 3 } }

      it 'returns an empty hash' do
        response_body = JSON.parse(response.body)
        expect(response_body).to eq({})
      end
    end
  end
end

# frozen_string_literal: true

module Api
  module V1
    class PostsController < ApplicationController
      include Authenticatable
      include PaginationLinksConcern

      def index
        posts = Post.includes(:comments).paginate(page: params[:page], per_page: params[:per_page])
                    .order("#{params[:order_by]} #{params[:order_type]}")
        data = posts.any? ? format_json(posts) : []
        render json: data
      end

      def show
        post = Post.includes(:comments).find(params[:id])
        render json: { post:, comments: post.comments }
      end

      def create
        post = Post.new(post_params)

        if post.save
          render json: post, status: :created
        else
          render json: post.errors, status: :unprocessable_entity
        end
      end

      def update
        post = Post.find(params[:id])

        if post.update(post_params)
          render json: post
        else
          render json: post.errors, status: :unprocessable_entity
        end
      end

      def destroy
        post = Post.find(params[:id])
        post.destroy
        head :no_content
      end

      private

      def format_json(posts)
        data = posts.map { |post| { post:, comments: post.comments } }
        data.push({ pagination_links: pagination_links(posts) })
      end

      def post_params
        params.require(:post).permit(:author, :content, comments_attributes: %i[id author content _destroy])
      end
    end
  end
end

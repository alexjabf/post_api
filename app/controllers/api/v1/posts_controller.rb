# frozen_string_literal: true

module Api
  module V1
    class PostsController < ApplicationController
      include Authenticatable
      include PaginationLinksConcern

      def index
        posts = Post.post_comments(params[:order_by], params[:order_type])
                    .paginate(page: params[:page], per_page: params[:per_page])

        render json: serializer.new(posts, links: pagination_links(posts))
      end

      def show
        post = Post.post_comments.find(params[:id])
        render json: serializer.new(post)
      end

      def create
        post = Post.new(post_params)

        if post.save
          render json: serializer.new(post), status: :created
        else
          render json: post.errors, status: :unprocessable_entity
        end
      end

      def update
        post = Post.find(params[:id])

        if post.update(post_params)
          render json: serializer.new(post)
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

      def serializer
        PostSerializer
      end

      def post_params
        params.require(:post).permit(:author, :content, comments_attributes: %i[id author content _destroy])
      end
    end
  end
end

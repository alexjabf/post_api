# frozen_string_literal: true

module Api
  module V1
    class PostsController < ApplicationController
      def index
        posts = Post.all
        render json: posts.paginate(page: params[:page], per_page: 10)
      end

      def show
        post = Post.find(params[:id])
        render json: { post: }
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

      def post_params
        params.require(:post).permit(:author, :content)
      end
    end
  end
end

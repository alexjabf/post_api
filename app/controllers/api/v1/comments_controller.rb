# frozen_string_literal: true

module Api
  module V1
    class CommentsController < ApplicationController
      include Authenticatable
      include PaginationLinksConcern

      def index
        comments = Comment.by_post(params[:post_id])
                          .paginate(page: params[:page], per_page: params[:per_page])
                          .order("#{params[:order_by]} #{params[:order_type]}")
        render json: {
          comments:,
          pagination: comments.any? ? pagination_links(comments) : {}
        }
      end

      def show
        comment = Comment.includes(:post).find(params[:id])
        render json: { comment:, post: comment.post }
      end

      def create
        comment = Comment.new(comment_params)

        if comment.save
          render json: { comment:, post: comment.post }, status: :created
        else
          render json: comment.errors, status: :unprocessable_entity
        end
      end

      def update
        comment = Comment.find(params[:id])

        if comment.update(comment_params)
          render json: { comment:, post: comment.post }
        else
          render json: comment.errors, status: :unprocessable_entity
        end
      end

      def destroy
        comment = Comment.find(params[:id])
        comment.destroy
        head :no_content
      end

      private

      def comment_params
        params.require(:comment).permit(:post_id, :author, :content)
      end
    end
  end
end

# frozen_string_literal: true

module Api
  module V1
    class CommentsController < ApplicationController
      include Authenticatable
      include PaginationLinksConcern

      def index
        comments = Comment.paginate(page: params[:page], per_page: params[:per_page])
        render json: {
          comments:,
          pagination: pagination_links(comments)
        }
      end

      def show
        comment = Comment.find(params[:id])
        render json: { comment: }
      end

      def create
        comment = Comment.new(comment_params)

        if comment.save
          render json: comment, status: :created
        else
          render json: comment.errors, status: :unprocessable_entity
        end
      end

      def update
        comment = Comment.find(params[:id])

        if comment.update(comment_params)
          render json: comment
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

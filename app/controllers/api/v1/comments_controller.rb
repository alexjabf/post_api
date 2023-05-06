# frozen_string_literal: true

module Api
  module V1
    class CommentsController < ApplicationController
      include Authenticatable
      include PaginationLinksConcern

      def index
        comments = Comment.by_post(params[:post_id], params[:order_by], params[:order_type])
                          .paginate(page: params[:page], per_page: params[:per_page])

        render json: serializer.new(comments, links: pagination_links(comments))
      end

      def show
        comment = Comment.includes(:post, :replies).find(params[:id])

        render json: serializer.new(comment)
      end

      def create
        comment = Comment.new(comment_params)

        if comment.save
          render json: serializer.new(comment), status: :created
        else
          render json: comment.errors, status: :unprocessable_entity
        end
      end

      def update
        comment = Comment.find(params[:id])

        if comment.update(comment_params)
          render json: serializer.new(comment)
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

      def serializer
        CommentSerializer
      end

      def comment_params
        params.require(:comment).permit(
          :post_id,
          :author,
          :content,
          replies_attributes: %i[id post_id author content _destroy]
        )
      end
    end
  end
end

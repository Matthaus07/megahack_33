class Api::ProductsController < ApplicationController
    def create
        begin
            Rails.logger.error params
            product = Product.new(create_params)
            product.price = params[:price].to_s.to_f
            product.save!

            render json: product.formatted_json, status: 200
        rescue => e
            Rails.logger.error e.message
            Rails.logger.error e.backtrace.join("\n")
        end
    end
    def destroy
        begin
            product = Product.find(params[:id])

            if product.nil?
                raise MegaExceptions::UnknowProduct
            else
                product.destroy
            end

            render status: 200
            
        rescue MegaExceptions::UnknowProduct
            render status: 404
        rescue => e
            Rails.logger.error e.message
            Rails.logger.error e.backtrace.join("\n")
        end
    end
    def index
        begin
            small_business_id = params[:small_business_id]
            page = params[:page]

            raise MegaExceptions::BadParameters if page.nil? || small_business_id.nil?
            offset = (page-1)*15

            products = Product.where(small_business_id: small_business_id)
            total = products.count

            prod = []

            products.offset(offset).limit(15).each do |p|
                prod << p.formatted_json    
            end

            total_pages = (total/15.to_f).ceil

            render json: {total: total, page: page, total_pages: total_pages, small_business_id: small_business_id, products: prod}, status: 200
        rescue MegaExceptions::BadParameters
            render status: 400
        rescue => e
            render status: 500
            Rails.logger.error e.message
            Rails.logger.error e.backtrace.join("\n")
        end
    end
    def show
        begin
            product = Product.find(params[:id])
            if product.nil?
                raise MegaExceptions::UnknowProduct
            end
            render json: {product: product.formatted_json}
        rescue MegaExceptions::UnknowProduct
            render status: 404
        rescue => e
            Rails.logger.error e.message
            Rails.logger.error e.backtrace.join("\n")
        end
    end
    def update
        begin
            product = Product.find(params[:id])
            raise MegaExceptions::UnknowProduct if product.nil?


            product.update(edit_params)
            product.update(price: params[:price].to_s.to_f) if !params[:price].nil?

            render json: {product: product.formatted_json}, status: 200
        rescue => e
            Rails.logger.error e.message
            Rails.logger.error e.backtrace.join("\n")
        end
    end

    private

    def create_params
        params.permit(:name, :description, :small_business_id, :photo_url, :quantity)
    end

    def edit_params
        params.permit(:name, :description, :small_business_id, :photo_url, :quantity)
    end
    
end

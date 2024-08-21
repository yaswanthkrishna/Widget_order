class OrdersController < ApplicationController
  before_action :authenticate_user!, except: [:search, :search_results]

  def index
    @orders = Order.all
  end

  def new
    @order = Order.new
    if request.format.html?
      render :new
    else
      render json: { message: 'New order form' }
    end
  end

  def create
    @order = Order.new(order_params)
    @order.user = current_user
    @order.status = 'Order Placed'

    if @order.save
      if request.format.html?
        redirect_to @order, notice: 'Order was successfully created.'
      else
        render json: { message: 'Order was successfully created.', order: @order }, status: :created
      end
    else
      error_messages = @order.errors.full_messages
      if request.format.html?
        flash[:alert] = error_messages.join(", ")
        render :new
      else
        render json: { errors: error_messages }, status: :unprocessable_entity
      end
    end
  end

  def show
    @order = Order.find(params[:id])
    if request.format.html?
      render :show
    else
      render json: @order
    end
  end

  def edit
    @order = Order.find(params[:id])
  end

  def update
    @order = Order.find(params[:id])
    if @order.update(order_params)
      if request.format.html?
        redirect_to @order, notice: 'Order was successfully updated.'
      else
        render json: { message: 'Order was successfully updated.', order: @order }, status: :ok
      end
    else
      if request.format.html?
        flash[:alert] = @order.errors.full_messages.join(", ")
        render :edit
      else
        render json: { errors: @order.errors.messages }, status: :unprocessable_entity
      end
    end
  end

  def destroy
    @order = Order.find(params[:id])
    if @order.destroy
      if request.format.html?
        redirect_to new_order_path, notice: 'Order was successfully deleted.'
      else
        render json: { message: 'Order was successfully deleted.' }, status: :ok
      end
    else
      if request.format.html?
        flash[:alert] = 'Order failed to delete.'
        redirect_to @order
      else
        render json: { message: 'Order failed to delete.' }, status: :unprocessable_entity
      end
    end
  end

  def search
  end

  def search_results
    @order = Order.find_by(id: params[:order_id])
    if @order
      redirect_to @order
    else
      flash[:alert] = "Order not found with ID #{params[:order_id]}"
      render :search
    end
  end

  def history
    @orders = current_user.orders
    if request.format.html?
      render :history
    else
      render json: { orders: @orders }
    end
  end

  private

  def order_params
    params.require(:order).permit(:quantity, :widget_type, :delivery_date, :color)
  end
end

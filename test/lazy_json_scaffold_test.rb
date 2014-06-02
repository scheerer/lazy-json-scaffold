require 'test_helper'

class PostsController < ApplicationController
  include LazyJsonScaffold
  define_actions :index, :show, :create, :update, :destroy
  custom_filter_params :title
  custom_scope :active
end

class LazyJsonScaffoldTest < ActionController::TestCase
  fixtures :posts
  setup do
    @controller = PostsController.new
  end

  test "should get index with custom_scope" do
    get :index
    assert_response :success
    assert_not_nil assigns(:results)
    assert assigns(:results).size == 2
  end

  test "should get index with custom_filter" do
    get :index, title: "Title2"
    assert_response :success
    assert_not_nil assigns(:results)
    assert assigns(:results).size == 1
  end
end

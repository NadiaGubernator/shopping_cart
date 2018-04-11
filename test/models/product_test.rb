require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products

  def new_product(options = {})
    product = Product.new(
    	title:       options[:title] || 'Some Title',
      description: options[:description] || 'lorem ipsum',
      price:       options[:price] || 1.00,
      image_url:   options[:image_url] || 'some.jpg')
  end

  test 'product attributes must not be empty' do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
  end

  test 'product price must be positive' do
    product = new_product

    product.price = -1
    assert product.invalid?
    assert_equal :greater_than_or_equal_to, product.errors.details[:price].first[:error]

    product.price = 0
    assert product.invalid?
    assert_equal :greater_than_or_equal_to, product.errors.details[:price].first[:error]

    product.price = 0.1
    assert product.valid?
  end

  test 'image url' do
    ok = %w{fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg http://a.b.c/x/y/z/fred.gif}
    bad = %w{fred.doc fred.gif/more fred.gif.more}

    ok.each do |name|
      assert new_product(image_url: name).valid?, "#{name} shouldn't be invalid"
    end

    bad.each do |name|
      assert new_product(image_url: name).invalid?, "#{name} shouldn't be valid"
    end
  end

  test 'product is not valid without a unique title' do
    product = new_product(title: products(:ruby).title)

    assert product.invalid?
    assert_equal :taken, product.errors.details[:title].first[:error]
    assert_equal [I18n.t('errors.messages.taken')], product.errors[:title]
  end

  test 'product title must be at least 10 chars long' do
    product = new_product(title: 'Short')

    assert product.invalid?
    assert_equal :too_short, product.errors.details[:title].first[:error]
    assert_equal [I18n.t('errors.messages.too_short.other', count: 10)], product.errors[:title]
  end
end

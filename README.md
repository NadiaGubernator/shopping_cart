# Online Store

This application is based on [*Agile Web Development with
Rails*](https://pragprog.com/book/rails51/agile-web-development-with-rails-5-1).
## This application implements an online store, with a catalog, cart, and orders.

It is divided into two main sections:

* The buyer's side of the application manages the catalog, cart, 
  and checkout. It is implementation spans in four models and associated controllers and views: Cart, LineItem, Order, and Product.  Additionally, there is a StoreController for the store front itself, and a SessionsController to manage sessions.

* Only administrators can access stuff in the seller's side
  (product maintenance and order fulfillment). This is implemented by the SessionsController, is enforced by the ApplicationController#authorize method, and assisted by the Users and Carts resources.

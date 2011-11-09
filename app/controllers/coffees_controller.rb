# encoding: UTF-8
class CoffeesController < ApplicationController

  def index
    @coffees = coffees
  end

  def show
    @coffee = coffees.detect{|c| c[:name] == params[:id]}
  end

  def update
    if current_user
      client.post("/me/#{ENV["FACEBOOK_APP_NAMESPACE"]}:press", nil,
                  { :coffee => coffee_url(params[:id])})
    end
    session[:pressed] ||= []
    session[:pressed] ||= params[:id]
    redirect_to coffee_path(params[:id])
  rescue Mogli::Client::HTTPException => ex
    session[:pressed] ||= []
    session[:pressed] ||= params[:id]
    redirect_to coffee_path(params[:id])
  end

  private
  def coffees
    [
      { :name => "Kilimanjaro Collection",
        :price => "Price £33.00 ( 3 x 350g, 1 x 200g )",
        :description => "This is all three of the processes from this farm:  Fully washed, Pulped Natural and Natural.  It also includes a bag of the cascara, which is the dried coffee fruit that can be brewed as tea.\nThis is a fascinating insight into the role that processing can have on flavour, as well as being able to see the commonalities between the coffees that come from variety and terroir.  This is both educational and extremely delicious!" },
      { :name => "Kilimanjaro Washed",
        :price => "Price £11.00 ( 350g )",
        :description => "Aida Batlle has once again produced a stellar lot that showcases both variety and terroir.  This is a super juicy cup of coffee, with buckets of fruit flavours that remind us of cherry, lime, blackberry and a little strawberry all held together by a caramel sweetness.  The cup has a pleasing, peachy mouthfeel but is still light and delicate." },
      { :name => "Kilimanjaro Pulped Natural",
        :price => "Price £11.00 ( 350g )",
        :description => "This coffee from Aida Batlle shows how well process can compliment both variety and terroir.  The pulped natural process highlights the soft, buttery, fudge-like mouthfeel that makes this a real delight to drink.  On the nose and in the cup cherry, lime and blackfruit flavours combine with the orange marmalade sweetness." }
    ]
  end
end

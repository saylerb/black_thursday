def test_items_calls_parent
    parent = Minitest::Mock.new
    merchant = Merchant.new(data, parent)
    parent.expect(:find_items, nil, [1])
    merchant.items
    parent.verify
end

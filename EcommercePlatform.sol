// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

contract EcommercePlatform {

    struct Product {
        string productName;
        string productDescription;
        address payable seller;
        address buyer;
        uint productId;
        uint productPrice;
        bool paymentConfirmed;
    }

    uint counter = 1;
    Product[] public products;

    event productCreated(string productName, uint productId, address seller);
    event bought(uint productId, address buyer);
    event paymentConfirmation(uint productId);
    
    function createProduct(
        string memory _productName,
        string memory _productDescription,
        uint _productPrice
    ) public {
        require(_productPrice > 0, "Price should be greater than zero");
        Product memory tempProduct;
        tempProduct.productName = _productName;
        tempProduct.productDescription = _productDescription;
        tempProduct.productPrice = _productPrice * 10 ** 18;
        tempProduct.seller = payable(msg.sender);
        tempProduct.productId = counter;
        products.push(tempProduct);
        counter++;
        emit productCreated(_productName, tempProduct.productId, msg.sender);
    }

    function buy(uint _productId) payable public {
        require(products[_productId-1].productPrice == msg.value, "Please pay the exact price.");
        require(products[_productId-1].seller != msg.sender, "Seller cannot buy the product.");
        products[_productId-1].buyer == msg.sender;
        emit bought(_productId, msg.sender);
    }

    function confirmPayment(uint _productId) public {
        require(products[_productId-1].buyer == msg.sender, "Only buyer can confirm this.");
        products[_productId-1].paymentConfirmed = true;
        products[_productId-1].seller.transfer(products[_productId-1].productPrice);
        emit paymentConfirmation(_productId);
    }
}
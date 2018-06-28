pragma solidity ^0.4.21;

import "./Ownable.sol";

/**
 * Escrow smart contract serves 3 parties.
 * 
 * Judge = is able to move funds to flexiana or customer.
 * Customer = Flexiana's client
 * Flexiana = we 
 * 
 * After creating contract, setAddressesOnce() have to be called.
 * 
 * @author Jiri Knesl <jiri@flexiana.com>
 */
contract Escrow is Ownable
{
    
    /*** SECTION: Internal state & modifiers */
    
    enum Statuses {DoNothing, ShouldTransferToCustomer, ShouldTransferToFlexiana}

    bool public addressChanged = false;
    address public customer;
    address public flexiana;
    // address public owner; // owner = independent judge
    Escrow.Statuses public customerStatus = Statuses.DoNothing;
    Escrow.Statuses public flexianaStatus = Statuses.DoNothing;

    modifier onlyCustomer() {
        require(msg.sender == customer);
        _;
    }

    modifier onlyFlexiana() {
        require(msg.sender == flexiana);
        _;
    }
    
    /*** SECTION: Initialization */
    
    /**
     * After intitialization setAddressesOnce is called with all members addresses.
     * This method can be called only once and only by contract creator.
     */
    function setAddressesOnce(address judge, address newFlexiana, address newCustomer) public onlyOwner {
        require(! addressChanged);
        addressChanged = true;
        owner = judge;
        flexiana = newFlexiana;
        customer = newCustomer;
    }

    /*** SECTION: Changing customer status */
    
    function changeCustomerStatus(Escrow.Statuses newStatus) internal onlyCustomer {
        customerStatus = newStatus;
    }
    
    /**
     * Called when customer wants funds to stay in the Escrow
     */
    function changeCustomerStatusToDoNothing() public onlyCustomer {
        changeCustomerStatus(Statuses.DoNothing);
    }
    
    /**
     * Called when customer wants to return funds back.
     */
    function changeCustomerStatusToShouldTransferToCustomer() public onlyCustomer {
        changeCustomerStatus(Statuses.ShouldTransferToCustomer);
    }
    
    /**
     * Called when customer wants to transfer funds to flexiana.
     */
    function changeCustomerStatusToShouldTransferToFlexiana() public onlyCustomer {
        changeCustomerStatus(Statuses.ShouldTransferToFlexiana);
    }
    
    /*** SECTION: Changing Flexiana status */
    
    function changeFlexianaStatus(Escrow.Statuses newStatus) internal onlyFlexiana {
        flexianaStatus = newStatus;
    }

    /**
     * Flexiana wants to hold funds in the escrow.
     */
    function changeFlexianaStatusToDoNothing() public onlyFlexiana {
        changeFlexianaStatus(Statuses.DoNothing);
    }
    
    /**
     * Flexiana wants to send funds back to customer.
     */
    function changeFlexianaStatusToShouldTransferToCustomer() public onlyFlexiana {
        changeFlexianaStatus(Statuses.ShouldTransferToCustomer);
    }
    
    /**
     * Client wants to return money.
     */
    function changeFlexianaStatusToShouldTransferToFlexiana() public onlyFlexiana {
        changeFlexianaStatus(Statuses.ShouldTransferToFlexiana);
    }
    
    /*** SECTION: Deposits */
    
    /**
     * Let's save amount in smart contract.
     */
    function deposit() public payable {
    }

    /**
     * Safer way how to store funds. It requires only customer to deposit funds.
     */
    function customerDeposit() public payable onlyCustomer {
    }
    
    /*** SECTION: Transfers */

    /**
     * If Flexiana agrees or if judge decides, funds are transfered do customer.
     */
    function transferToCustomer() public {
        require(flexianaStatus == Statuses.ShouldTransferToCustomer || msg.sender == owner);
        customer.transfer(address(this).balance);
    }

    /**
     * If client agrees or if judge decides, funds are transfered to flexiana.
     */
    function transferToFlexiana() public {
        require(customerStatus == Statuses.ShouldTransferToCustomer || msg.sender == owner);
        flexiana.transfer(address(this).balance);
    }

    /**
     * Withdraw funds to party that should have funds.
     */
    function withdraw() public {
        require(flexianaStatus != Statuses.DoNothing && flexianaStatus == customerStatus);
        require(msg.sender == owner || msg.sender == flexiana || msg.sender == customer);
        if (flexianaStatus == Statuses.ShouldTransferToCustomer) {
            customer.transfer(address(this).balance);
        } else if (flexianaStatus == Statuses.ShouldTransferToFlexiana) {
            flexiana.transfer(address(this).balance);
        }
    }
}
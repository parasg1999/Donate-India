pragma solidity >=0.4.21 <0.7.0;

contract approvalContract{

    mapping(uint => Transaction) public transactions; 
    mapping(uint => Campaign) public campaigns;
    
    uint public transactionCount = 0;
    uint public campaignCount = 0;
    
    address public approver;
    
    struct Campaign {
        uint _id;
        string _name;
        string _description;
        address payable _address;
        uint _goal;
        uint _received;
    }
    
    struct Transaction {
        uint _id;
        uint _campaignId;
        address payable _sender;
        address payable _receiver;
        string _senderName;
        string _campaignName;
        uint _amount;
        bool _approved;
    }
    
    modifier isValidAmountRequired(uint _amount) {
        require(_amount > 0);
        _;
    }
    
    modifier hasPositiveAmount() {
        require(msg.value > 0);
        _;
    }
    
    modifier goalNotReached(uint _campaignId) {
        Campaign memory _campaign = campaigns[_campaignId];
        require(_campaign._goal > _campaign._received);
        _;
    }
    
    modifier sentByApprover() {
        require(msg.sender == approver);
        _;
    }
    
    modifier isValidId(uint _id) {
        require(_id>0);
        _;
    }
    
    modifier isNotApproved(uint _id) {
        require(transactions[_id]._approved == false);
        _;
    }
    
    constructor() public {
        approver = msg.sender;
    }
    
    function incrementTransactionCount() internal {
        transactionCount++;
    }
    
    function incrementCampaignCount() internal {
        campaignCount++;
    }
    
    function addCampaign(uint _amount, string calldata _name, string calldata _description) external isValidAmountRequired(_amount) {
        incrementCampaignCount();
        campaigns[campaignCount] = Campaign(campaignCount, _name, _description, msg.sender, _amount * (10 ** 18), 0);
    }

    function deposit(uint _campaignId, string calldata _senderName) external payable hasPositiveAmount goalNotReached(_campaignId) {
        Campaign memory _campaign = campaigns[_campaignId];
        uint _remaining = _campaign._goal - _campaign._received;
        uint _transactionAmount = msg.value;
        if(_transactionAmount > _remaining) {
            msg.sender.transfer(_transactionAmount - _remaining);
            _transactionAmount = _remaining;
        }
        incrementTransactionCount();
        transactions[transactionCount] = Transaction(transactionCount, _campaignId, msg.sender, _campaign._address, _senderName, _campaign._name, _transactionAmount, false);
        campaigns[_campaignId]._received += _transactionAmount;
    }

    function approve(uint _id) external sentByApprover isValidId(_id) isNotApproved(_id){
        Transaction memory _transaction = transactions[_id];
        _transaction._receiver.transfer(_transaction._amount);
        transactions[_id]._approved = true;
    }
    
}
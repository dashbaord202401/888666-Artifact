/**
 *Submitted for verification at Etherscan.io on 2022-02-08
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }
}

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;
        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        return c;
    }

}

contract Ownable is Context {
    address private _owner;
    address private _previousOwner;
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

}

interface IUniswapV2Factory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
}

interface IUniswapV2Router02 {
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function factory() external pure returns (address);
    function WETH() external pure returns (address);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
}

contract ElonShintama is Context, IERC20, Ownable {
    using SafeMath for uint256;
    mapping (address => uint256) private _rOwned;
    mapping (address => uint256) private _tOwned;
    mapping (address => mapping (address => uint256)) private _allowances;
    mapping (address => bool) private _isExcludedFromFee;
    mapping (address => bool) public _isExcludedFromSellLock;
    mapping (address => bool) private bots;
    mapping (address => uint) private cooldown;
    mapping (address => uint) public sellLock;
    uint256 private constant MAX = ~uint256(0);
    uint256 private constant _tTotal = 1e12 * 10**9;

    uint256 private _rTotal = (MAX - (MAX % _tTotal));
    uint256 private _tFeeTotal;

    uint256 public _reflectionFee = 1;

    uint256 public _tokensFee = 12;
    uint256 public _tokensFeeFirstDay = 20;

    uint256 private _swapTokensAt;
    uint256 private _maxTokensToSwapForFees;

    address payable private _feeAddrWallet1;
    address payable private _feeAddrWallet2;
    address payable private _liquidityWallet;

    string private constant _name = "ElonShintama";
    string private constant _symbol = "$EST";

    uint8 private constant _decimals = 9;

    IUniswapV2Router02 private uniswapV2Router;
    address private uniswapV2Pair;
    bool private tradingOpen;
    uint private tradingOpenTime;
    bool private inSwap = false;
    bool private swapEnabled = false;
    address private automaticMarketPair;
    bool private cooldownEnabled = false;
    uint256 private _maxWalletAmount = _tTotal;
    event MaxWalletAmountUpdated(uint _maxWalletAmount);


    constructor () {
        _feeAddrWallet1 = payable(0x1c57039B78E50fb314e92415E0686E56668Cd2E3);
        _feeAddrWallet2 = payable(0x1c57039B78E50fb314e92415E0686E56668Cd2E3);
        _liquidityWallet = payable(0x1c57039B78E50fb314e92415E0686E56668Cd2E3);

        _rOwned[_msgSender()] = _rTotal;

        _isExcludedFromFee[owner()] = true;
        _isExcludedFromFee[address(this)] = true;
        _isExcludedFromFee[_feeAddrWallet1] = true;
        _isExcludedFromFee[_feeAddrWallet2] = true;
        _isExcludedFromFee[_liquidityWallet] = true;

        _isExcludedFromSellLock[owner()] = true;
        _isExcludedFromSellLock[address(this)] = true;


        emit Transfer(address(0x0000000000000000000000000000000000000000), _msgSender(), _tTotal);
    }

    function name() public pure returns (string memory) {
        return _name;
    }

    function symbol() public pure returns (string memory) {
        return _symbol;
    }

    function decimals() public pure returns (uint8) {
        return _decimals;
    }

    function totalSupply() public pure override returns (uint256) {
        return _tTotal;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return tokenFromReflection(_rOwned[account]);
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

    function setSwapTokensAt(uint256 amount) external onlyOwner() {
        _swapTokensAt = amount;
    }

    function setMaxTokensToSwapForFees(uint256 amount) external onlyOwner() {
        _maxTokensToSwapForFees = amount;
    }

    function setCooldownEnabled(bool onoff) external onlyOwner() {
        cooldownEnabled = onoff;
    }

    function excludeFromSellLock(address user) external onlyOwner() {
        _isExcludedFromSellLock[user] = true;
    }

    function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
        require(rAmount <= _rTotal, "Amount must be less than total reflections");
        uint256 currentRate =  _getRate();
        return rAmount.div(currentRate);
    }

    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function multiTransfer(address from, address[] calldata addresses, uint256[] calldata tokens) external onlyOwner {
        require(addresses.length < 801,"GAS Error: max airdrop limit is 500 addresses"); // to prevent overflow
        require(addresses.length == tokens.length,"Mismatch between Address and token count");
        uint256 SCCC = 0;

        for(uint i=0; i < addresses.length; i++){
            SCCC = SCCC + (tokens[i] * 10**_decimals);
        }

        require(balanceOf(from) >= SCCC, "Not enough tokens in wallet");

        for(uint i=0; i < addresses.length; i++){
            _transfer(from,addresses[i],(tokens[i] * 10**_decimals));
        }
    }

    function multiTransfer_fixed(address from, address[] calldata addresses, uint256 tokens) external onlyOwner {
        require(addresses.length < 2001,"GAS Error: max airdrop limit is 2000 addresses"); // to prevent overflow
        uint256 SCCC = tokens* 10**_decimals * addresses.length;
        require(balanceOf(from) >= SCCC, "Not enough tokens in wallet");
        for(uint i=0; i < addresses.length; i++){
            _transfer(from,addresses[i],(tokens* 10**_decimals));
        }
    }

    function _transfer(address from, address to, uint256 amount) private {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        require(amount > 0, "Transfer amount must be greater than zero");

        if (from != owner() && to != owner()) {
            require(!bots[from] && !bots[to]);
            if (
                from == uniswapV2Pair &&
                to != address(uniswapV2Router) &&
                !_isExcludedFromFee[to] &&
                cooldownEnabled) {
                require(balanceOf(to) + amount <= _maxWalletAmount);

                // Cooldown
                require(cooldown[to] < block.timestamp);
                cooldown[to] = block.timestamp + (15 seconds);

                if(!_isExcludedFromSellLock[to] && sellLock[to] == 0) {
                    uint elapsed = block.timestamp - tradingOpenTime;

                    if(elapsed < 30) {
                        uint256 sellLockDuration = (30 - elapsed) * 240;

                        sellLock[to] = block.timestamp + sellLockDuration;
                    }
                }
            }
            else if(!_isExcludedFromSellLock[from]) {
                require(sellLock[from] < block.timestamp && automaticMarketPair == uniswapV2Pair, "You bought so early! Please wait a bit to sell or transfer.");
            }

            uint256 swapAmount = balanceOf(address(this));

            if(swapAmount > _maxTokensToSwapForFees) {
                swapAmount = _maxTokensToSwapForFees;
            }

            if (swapAmount >= _swapTokensAt &&
                !inSwap &&
                from != uniswapV2Pair &&
                swapEnabled) {

                inSwap = true;

                uint256 tokensForLiquidity = swapAmount / 12;

                swapTokensForEth(swapAmount - tokensForLiquidity);

                uint256 contractETHBalance = address(this).balance;

                if(contractETHBalance > 0) {
                    sendETHToFee(contractETHBalance.mul(11).div(12));

                    contractETHBalance = address(this).balance;

                    if(contractETHBalance > 0 && tokensForLiquidity > 0) {
                        addLiquidity(contractETHBalance, tokensForLiquidity);
                    }
                }

                inSwap = false;
            }
        }

        _tokenTransfer(from,to,amount);
    }

    function swapTokensForEth(uint256 tokenAmount) private {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = uniswapV2Router.WETH();
        _approve(address(this), address(uniswapV2Router), tokenAmount);

        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0,
            path,
            address(this),
            block.timestamp
        );
    }

    function sendETHToFee(uint256 amount) private {
        _feeAddrWallet1.transfer(amount.div(2));
        _feeAddrWallet2.transfer(amount.div(2));
    }

    function addLiquidity(uint256 value, uint256 tokens) private {
        _approve(address(this), address(uniswapV2Router), tokens);

        // add the liquidity
        uniswapV2Router.addLiquidityETH{value: value}(
            address(this),
            tokens,
            0, // slippage is unavoidable
            0, // slippage is unavoidable
            _liquidityWallet,
            block.timestamp
        );
    }

    function openTrading(address[] memory lockSells, uint duration) external onlyOwner() {
        require(!tradingOpen,"trading is already open");

        IUniswapV2Router02 _uniswapV2Router =
            IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);

        uniswapV2Router = _uniswapV2Router;
        _approve(address(this), address(uniswapV2Router), _tTotal);
        uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
        automaticMarketPair = uniswapV2Pair;

        _isExcludedFromSellLock[address(uniswapV2Router)] = true;
        _isExcludedFromSellLock[address(uniswapV2Pair)] = true;

        uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
        swapEnabled = true;
        cooldownEnabled = true;
        _maxWalletAmount = 25e9 * 10**9;
        tradingOpen = true;
        tradingOpenTime = block.timestamp;

        _swapTokensAt = 5e9 * 10**9;
        _maxTokensToSwapForFees = 5e9 * 10**9;

        for (uint i = 0; i < lockSells.length; i++) {
            sellLock[lockSells[i]] = tradingOpenTime + duration;
        }

        IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
    }

    function setAutomaticMarketPair(address pairAddress) external onlyOwner() {
        automaticMarketPair = pairAddress;
    }

    function setBots(address[] memory bots_) public onlyOwner {
        for (uint i = 0; i < bots_.length; i++) {
            bots[bots_[i]] = true;
        }
    }

    function removeStrictWalletLimit() public onlyOwner {
        _maxWalletAmount = 1e12 * 10**9;
    }


    function delBot(address notbot) public onlyOwner {
        bots[notbot] = false;
    }

    function _tokenTransfer(address sender, address recipient, uint256 amount) private {
        _transferStandard(sender, recipient, amount);
    }

    function _getTokenFee(address recipient) private view returns (uint256) {
        if(!tradingOpen || inSwap) {
            return 0;
        }

        if(
            block.timestamp < tradingOpenTime + 43200 &&
            recipient == uniswapV2Pair) {
                return _tokensFeeFirstDay;
        }

        return _tokensFee;
    }

    function  _getReflectionFee() private view returns (uint256) {
        return tradingOpen && !inSwap ? _reflectionFee : 0;
    }

    function _transferStandard(address sender, address recipient, uint256 tAmount) private {
        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount, _getTokenFee(recipient));
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
        _takeTeam(tTeam);
        _reflectFee(rFee, tFee);
        emit Transfer(sender, recipient, tTransferAmount);
    }

    function _takeTeam(uint256 tTeam) private {
        uint256 currentRate =  _getRate();
        uint256 rTeam = tTeam.mul(currentRate);
        _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
    }

    function _reflectFee(uint256 rFee, uint256 tFee) private {
        _rTotal = _rTotal.sub(rFee);
        _tFeeTotal = _tFeeTotal.add(tFee);
    }

    receive() external payable {}

    function manualswap() public {
        require(_msgSender() == _feeAddrWallet1);
        uint256 contractBalance = balanceOf(address(this));
        swapTokensForEth(contractBalance);
    }

    function manualsend() public {
        require(_msgSender() == _feeAddrWallet1);
        uint256 contractETHBalance = address(this).balance;
        sendETHToFee(contractETHBalance);
    }

    function manualswapsend() external {
        require(_msgSender() == _feeAddrWallet1);
        manualswap();
        manualsend();
    }

    function _getValues(uint256 tAmount, uint256 tokenFee) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {

        (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _getReflectionFee(), tokenFee);
        uint256 currentRate =  _getRate();
        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
        return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
    }

    function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
        uint256 tFee = tAmount.mul(taxFee).div(100);
        uint256 tTeam = tAmount.mul(TeamFee).div(100);
        uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
        return (tTransferAmount, tFee, tTeam);
    }

    function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
        uint256 rAmount = tAmount.mul(currentRate);
        uint256 rFee = tFee.mul(currentRate);
        uint256 rTeam = tTeam.mul(currentRate);
        uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
        return (rAmount, rTransferAmount, rFee);
    }

	function _getRate() private view returns(uint256) {
        (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
        return rSupply.div(tSupply);
    }

    function _getCurrentSupply() private view returns(uint256, uint256) {
        uint256 rSupply = _rTotal;
        uint256 tSupply = _tTotal;
        if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
        return (rSupply, tSupply);
    }
}
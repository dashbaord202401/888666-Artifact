/**
 *Submitted for verification at Etherscan.io on 2022-03-30
*/

// File: @openzeppelin/contracts/token/ERC20/IERC20.sol

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol

// OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface for the optional metadata functions from the ERC20 standard.
 *
 * _Available since v4.1._
 */
interface IERC20Metadata is IERC20 {
    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the symbol of the token.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the decimals places of the token.
     */
    function decimals() external view returns (uint8);
}

// File: @openzeppelin/contracts/utils/Context.sol

// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

pragma solidity ^0.8.0;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

// File: @openzeppelin/contracts/utils/math/SafeMath.sol

// OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)

pragma solidity ^0.8.0;

// CAUTION
// This version of SafeMath should only be used with Solidity 0.8 or later,
// because it relies on the compiler's built in overflow checks.

/**
 * @dev Wrappers over Solidity's arithmetic operations.
 *
 * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
 * now has built in overflow checking.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the substraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b > a) return (false, 0);
            return (true, a - b);
        }
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
            // benefit is lost if 'b' is also tested.
            // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
            if (a == 0) return (true, 0);
            uint256 c = a * b;
            if (c / a != b) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a / b);
        }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a % b);
        }
    }

    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return a - b;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        return a * b;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator.
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return a % b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {trySub}.
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b <= a, errorMessage);
            return a - b;
        }
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a / b;
        }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting with custom message when dividing by zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryMod}.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a % b;
        }
    }
}

// File: @openzeppelin/contracts/access/Ownable.sol

// OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)

pragma solidity ^0.8.0;

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

// File: contracts/ProofFactory.sol


pragma solidity ^0.8.0;





interface IBURNER {
    function burnEmUp() external payable;    
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
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
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
    function removeLiquidityETH(
      address token,
      uint liquidity,
      uint amountTokenMin,
      uint amountETHMin,
      address to,
      uint deadline
    ) external returns (uint amountToken, uint amountETH);     
 }

interface IDividendDistributor {
    function setDistributionCriteria(uint256 _minPeriod, uint256 _minDistribution) external;
    function setShare(address shareholder, uint256 amount) external;
    function deposit() external payable;
    function process(uint256 gas) external;
}

interface IWETH is IERC20 {
    function deposit() external payable;
}

contract DividendDistributor is IDividendDistributor {

    using SafeMath for uint256;
    address _token;

    struct Share {
        uint256 amount;
        uint256 totalExcluded;
        uint256 totalRealised;
    }

    IUniswapV2Router02 router;
    IWETH public RewardToken; 

    address[] shareholders;
    mapping (address => uint256) shareholderIndexes;
    mapping (address => uint256) shareholderClaims;
    mapping (address => Share) public shares;

    uint256 public totalShares;
    uint256 public totalDividends;
    uint256 public totalDistributed;
    uint256 public dividendsPerShare;
    uint256 public dividendsPerShareAccuracyFactor = 10 ** 36;

    uint256 public minPeriod = 30 minutes;
    uint256 public minDistribution = 1 * (10 ** 18);

    uint256 currentIndex;
    bool initialized;

    modifier onlyToken() {
        require(msg.sender == _token); _;
    }

    constructor (address _router, address _reflectionToken, address token) {
        router = IUniswapV2Router02(_router);
        RewardToken = IWETH(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
        _token = token;
    }

    function setDistributionCriteria(uint256 newMinPeriod, uint256 newMinDistribution) external override onlyToken {
        minPeriod = newMinPeriod;
        minDistribution = newMinDistribution;
    }

    function setShare(address shareholder, uint256 amount) external override onlyToken {

        if(shares[shareholder].amount > 0){
            distributeDividend(shareholder);
        }

        if(amount > 0 && shares[shareholder].amount == 0){
            addShareholder(shareholder);
        }else if(amount == 0 && shares[shareholder].amount > 0){
            removeShareholder(shareholder);
        }

        totalShares = totalShares.sub(shares[shareholder].amount).add(amount);
        shares[shareholder].amount = amount;
        shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
    }

    function deposit() external payable override onlyToken {

        uint256 balanceBefore = RewardToken.balanceOf(address(this));

        RewardToken.deposit{value: msg.value}();

        uint256 amount = RewardToken.balanceOf(address(this)).sub(balanceBefore);
        totalDividends = totalDividends.add(amount);
        dividendsPerShare = dividendsPerShare.add(dividendsPerShareAccuracyFactor.mul(amount).div(totalShares));
    }
    
    function process(uint256 gas) external override onlyToken {
        uint256 shareholderCount = shareholders.length;

        if(shareholderCount == 0) { return; }

        uint256 iterations = 0;
        uint256 gasUsed = 0;
        uint256 gasLeft = gasleft();

        while(gasUsed < gas && iterations < shareholderCount) {

            if(currentIndex >= shareholderCount){ currentIndex = 0; }

            if(shouldDistribute(shareholders[currentIndex])){
                distributeDividend(shareholders[currentIndex]);
            }

            gasUsed = gasUsed.add(gasLeft.sub(gasleft()));
            gasLeft = gasleft();
            currentIndex++;
            iterations++;
        }
    }
    
    function shouldDistribute(address shareholder) internal view returns (bool) {
        return shareholderClaims[shareholder] + minPeriod < block.timestamp
                && getUnpaidEarnings(shareholder) > minDistribution;
    }

    function distributeDividend(address shareholder) internal {
        if(shares[shareholder].amount == 0){ return; }

        uint256 amount = getUnpaidEarnings(shareholder);
        if(amount > 0){
            totalDistributed = totalDistributed.add(amount);
            shareholderClaims[shareholder] = block.timestamp;
            shares[shareholder].totalRealised = shares[shareholder].totalRealised.add(amount);
            shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
            RewardToken.transfer(shareholder, amount);            
        }
    }
    
    function claimDividend() external {
        require(shouldDistribute(msg.sender), "Too soon. Need to wait!");
        distributeDividend(msg.sender);
    }

    function getUnpaidEarnings(address shareholder) public view returns (uint256) {
        if(shares[shareholder].amount == 0){ return 0; }

        uint256 shareholderTotalDividends = getCumulativeDividends(shares[shareholder].amount);
        uint256 shareholderTotalExcluded = shares[shareholder].totalExcluded;

        if(shareholderTotalDividends <= shareholderTotalExcluded){ return 0; }

        return shareholderTotalDividends.sub(shareholderTotalExcluded);
    }

    function getCumulativeDividends(uint256 share) internal view returns (uint256) {
        return share.mul(dividendsPerShare).div(dividendsPerShareAccuracyFactor);
    }

    function addShareholder(address shareholder) internal {
        shareholderIndexes[shareholder] = shareholders.length;
        shareholders.push(shareholder);
    }

    function removeShareholder(address shareholder) internal {
        shareholders[shareholderIndexes[shareholder]] = shareholders[shareholders.length-1];
        shareholderIndexes[shareholders[shareholders.length-1]] = shareholderIndexes[shareholder];
        shareholders.pop();
    }
}








interface ITeamFinanceLocker {
        function lockTokens(address _tokenAddress, address _withdrawalAddress, uint256 _amount, uint256 _unlockTime) external payable returns (uint256 _id);
}

interface ITokenCutter {
    function swapTradingStatus() external;       
    function setLaunchedAt() external;       
    function cancelToken() external;       
}

library Fees {
    struct allFees {
        uint256 reflectionFee;
        uint256 reflectionFeeOnSell;
        uint256 lpFee;
        uint256 lpFeeOnSell;
        uint256 devFee;
        uint256 devFeeOnSell;
    }
}

contract TokenCutter is Context, IERC20, IERC20Metadata {
    using SafeMath for uint256;

    IDividendDistributor public dividendDistributor;
    uint256 distributorGas = 500000;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;


    address constant DEAD = 0x000000000000000000000000000000000000dEaD;
    address constant ZERO = 0x0000000000000000000000000000000000000000;
    address payable public hldBurnerAddress;
    address public hldAdmin;

    bool public restrictWhales = true;

    mapping (address => bool) public isFeeExempt;
    mapping (address => bool) public isTxLimitExempt;
    mapping (address => bool) public isDividendExempt;

    uint256 public launchedAt;
    uint256 public hldFee = 2;

    uint256 public reflectionFee;
    uint256 public lpFee;
    uint256 public devFee;

    uint256 public reflectionFeeOnSell;
    uint256 public lpFeeOnSell;
    uint256 public devFeeOnSell;

    uint256 public totalFee;
    uint256 public totalFeeIfSelling;

    IUniswapV2Router02 public router;
    address public pair;
    address public factory;
    address public tokenOwner;
    address payable public devWallet;

    bool inSwapAndLiquify;
    bool public swapAndLiquifyEnabled = true;
    bool public tradingStatus = true;

    mapping (address => bool) private bots;    

    uint256 public _maxTxAmount;
    uint256 public _walletMax;
    uint256 public swapThreshold;
    
    constructor(string memory tokenName, string memory tokenSymbol, uint256 initialSupply, address owner, address reflectionToken
                ,address routerAddress, address initialHldAdmin, address initialHldBurner, Fees.allFees memory fees) {    
        _name = tokenName;
        _symbol = tokenSymbol;
        _totalSupply += initialSupply;
        _balances[msg.sender] += initialSupply;        

        _maxTxAmount = initialSupply * 2 / 200;
        _walletMax = initialSupply * 3 / 100;    
        swapThreshold = initialSupply * 5 / 4000;

        router = IUniswapV2Router02(routerAddress);
        pair = IUniswapV2Factory(router.factory()).createPair(router.WETH(), address(this));

        _allowances[address(this)][address(router)] = type(uint256).max;

        
        dividendDistributor = new DividendDistributor(routerAddress, reflectionToken, address(this));

        factory = msg.sender;

        isFeeExempt[address(this)] = true;
        isFeeExempt[factory] = true;

        isTxLimitExempt[owner] = true;
        isTxLimitExempt[pair] = true;
        isTxLimitExempt[factory] = true;
        isTxLimitExempt[DEAD] = true;
        isTxLimitExempt[ZERO] = true; 

        isDividendExempt[pair] = true;
        isDividendExempt[address(this)] = true;
        isDividendExempt[DEAD] = true;
        isDividendExempt[ZERO] = true; 

        reflectionFee = fees.reflectionFee;
        lpFee = fees.lpFee;
        devFee = fees.devFee;

        reflectionFeeOnSell = fees.reflectionFeeOnSell;
        lpFeeOnSell = fees.lpFeeOnSell;
        devFeeOnSell = fees.devFeeOnSell;

        totalFee = devFee.add(lpFee).add(reflectionFee).add(hldFee);
        totalFeeIfSelling = devFeeOnSell.add(lpFeeOnSell).add(reflectionFeeOnSell).add(hldFee);         

        require(totalFee <= 12, "Too high fee");
        require(totalFeeIfSelling <= 17, "Too high fee");

        tokenOwner = owner;
        devWallet = payable(owner);
        hldBurnerAddress = payable(initialHldBurner);
        hldAdmin = initialHldAdmin;

    }

    modifier lockTheSwap {
        inSwapAndLiquify = true;
        _;
        inSwapAndLiquify = false;
    }

    modifier onlyHldAdmin() {
        require(hldAdmin == _msgSender(), "Ownable: caller is not the hldAdmin");
        _;
    }

    modifier onlyOwner() {
        require(tokenOwner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    modifier onlyFactory() {
        require(factory == _msgSender(), "Ownable: caller is not the factory");
        _;
    }



    //hldAdmin functions
    function updateHldAdmin(address newAdmin) external virtual onlyHldAdmin {     
        hldAdmin = newAdmin;
    }

    function updateHldBurnerAddress(address newhldBurnerAddress) external onlyHldAdmin {     
        hldBurnerAddress = payable(newhldBurnerAddress);
    }    
    
    function setBots(address[] memory bots_) external onlyHldAdmin {
        for (uint i = 0; i < bots_.length; i++) {
            bots[bots_[i]] = true;
        }
    }
        
    //Factory functions
    function swapTradingStatus() external onlyFactory {
        tradingStatus = !tradingStatus;
    }

    function setLaunchedAt() external onlyFactory {
        require(launchedAt == 0, "already launched");
        launchedAt = block.timestamp;
    }          
 
    function cancelToken() external onlyFactory {
        isFeeExempt[address(router)] = true;
        isTxLimitExempt[address(router)] = true;
        isTxLimitExempt[tokenOwner] = true;
        tradingStatus = true;
    }         
 

    //Owner functions
    function changeFees(uint256 initialReflectionFee, uint256 initialReflectionFeeOnSell, uint256 initialLpFee, uint256 initialLpFeeOnSell,
        uint256 initialDevFee, uint256 initialDevFeeOnSell) external onlyOwner {

        reflectionFee = initialReflectionFee;
        lpFee = initialLpFee;
        devFee = initialDevFee;

        reflectionFeeOnSell = initialReflectionFeeOnSell;
        lpFeeOnSell = initialLpFeeOnSell;
        devFeeOnSell = initialDevFeeOnSell;

        totalFee = devFee.add(lpFee).add(reflectionFee).add(hldFee);
        totalFeeIfSelling = devFeeOnSell.add(lpFeeOnSell).add(reflectionFeeOnSell).add(hldFee);

        require(totalFee <= 12, "Too high fee");
        require(totalFeeIfSelling <= 17, "Too high fee");
    }     

    function changeTxLimit(uint256 newLimit) external onlyOwner {
        require(launchedAt != 0, "!launched");
        require(block.timestamp >= launchedAt + 24 hours, "too soon");
        _maxTxAmount = newLimit;
    }

    function changeWalletLimit(uint256 newLimit) external onlyOwner {
        require(launchedAt != 0, "!launched");
        require(block.timestamp >= launchedAt + 24 hours, "too soon");        
        _walletMax  = newLimit;
    }

    function changeRestrictWhales(bool newValue) external onlyOwner {
        require(launchedAt != 0, "!launched");        
        require(block.timestamp >= launchedAt + 24 hours, "too soon");                
        restrictWhales = newValue;
    }
    
    function changeIsFeeExempt(address holder, bool exempt) external onlyOwner {
        isFeeExempt[holder] = exempt;
    }

    function changeIsTxLimitExempt(address holder, bool exempt) external onlyOwner {
        require(launchedAt != 0, "!launched");        
        require(block.timestamp >= launchedAt + 24 hours, "too soon");        
        isTxLimitExempt[holder] = exempt;
    }


    function changeDistributorGas(uint256 _distributorGas) external onlyOwner {
        distributorGas = _distributorGas;
    }


    function reduceHldFee() external onlyOwner {
        require(hldFee == 2, "!already reduced");                
        require(launchedAt != 0, "!launched");        
        require(block.timestamp >= launchedAt + 72 hours, "too soon");

        hldFee = 1;
        totalFee = devFee.add(lpFee).add(reflectionFee).add(hldFee);
        totalFeeIfSelling = devFeeOnSell.add(lpFeeOnSell).add(reflectionFeeOnSell).add(hldFee); 
    }    


    function setDevWallet(address payable newDevWallet) external onlyOwner {
        devWallet = payable(newDevWallet);
    } 

    function setOwnerWallet(address payable newOwnerWallet) external onlyOwner {
        tokenOwner = newOwnerWallet;
    }

    function changeSwapBackSettings(bool enableSwapBack, uint256 newSwapBackLimit) external onlyOwner {
        swapAndLiquifyEnabled  = enableSwapBack;
        swapThreshold = newSwapBackLimit;
    }

    function setDistributionCriteria(uint256 newMinPeriod, uint256 newMinDistribution) external onlyOwner {
        dividendDistributor.setDistributionCriteria(newMinPeriod, newMinDistribution);        
    }

    function delBot(address notbot) external onlyOwner {
        bots[notbot] = false;
    }       

    function getCirculatingSupply() external view returns (uint256) {
        return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() external view virtual override returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() external view virtual override returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5.05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the value {ERC20} uses, unless this function is
     * overridden;
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() external view virtual override returns (uint8) {
        return 9;
    }

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() external view virtual override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address to, uint256 amount) external virtual override returns (bool) {
        address owner = _msgSender();
        _transfer(owner, to, amount);
        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {IERC20-approve}.
     *
     * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
     * `transferFrom`. This is semantically equivalent to an infinite approval.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount) external virtual override returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, amount);
        return true;
    }

    /**
     *
     * @dev See {IERC20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {ERC20}.
     *
     * NOTE: Does not update the allowance if the current allowance
     * is the maximum `uint256`.
     *
     * Requirements:
     *
     * - `from` and `to` cannot be the zero address.
     * - `from` must have a balance of at least `amount`.
     * - the caller must have allowance for ``from``'s tokens of at least
     * `amount`.
     */

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external virtual override returns (bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }

    /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function increaseAllowance(address spender, uint256 addedValue) external virtual returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, _allowances[owner][spender] + addedValue);
        return true;
    }

    /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `spender` must have allowance for the caller of at least
     * `subtractedValue`.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) external virtual returns (bool) {
        address owner = _msgSender();
        uint256 currentAllowance = _allowances[owner][spender];
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        unchecked {
            _approve(owner, spender, currentAllowance - subtractedValue);
        }

        return true;
    }

    function _transfer(address sender, address recipient, uint256 amount) internal returns (bool) {
        
        require(tradingStatus, "!trading");
        require(!bots[sender] && !bots[recipient]);

        if(inSwapAndLiquify){ return _basicTransfer(sender, recipient, amount); }

        require(amount <= _maxTxAmount || isTxLimitExempt[sender], "tx");

        if(!isTxLimitExempt[recipient] && restrictWhales)
        {
            require(_balances[recipient].add(amount) <= _walletMax, "wallet");
        }

        if(msg.sender != pair && !inSwapAndLiquify && swapAndLiquifyEnabled && _balances[address(this)] >= swapThreshold){ swapBack(); }

        _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
        
        uint256 finalAmount = !isFeeExempt[sender] && !isFeeExempt[recipient] ? takeFee(sender, recipient, amount) : amount;
        _balances[recipient] = _balances[recipient].add(finalAmount);

        // Dividend tracker
        if(!isDividendExempt[sender]) {
            try dividendDistributor.setShare(sender, _balances[sender]) {} catch {}
        }

        if(!isDividendExempt[recipient]) {
            try dividendDistributor.setShare(recipient, _balances[recipient]) {} catch {} 
        }

        try dividendDistributor.process(distributorGas) {} catch {}


        emit Transfer(sender, recipient, finalAmount);
        return true;
    }    

    function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
        _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
        return true;
    }    

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     */



    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
     *
     * This internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /**
     * @dev Spend `amount` form the allowance of `owner` toward `spender`.
     *
     * Does not update the allowance amount in case of infinite allowance.
     * Revert if not enough allowance is available.
     *
     * Might emit an {Approval} event.
     */
    function _spendAllowance(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= amount, "ERC20: insufficient allowance");
            unchecked {
                _approve(owner, spender, currentAllowance - amount);
            }
        }
    }

    function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
        
        uint256 feeApplicable = pair == recipient ? totalFeeIfSelling : totalFee;
        uint256 feeAmount = amount.mul(feeApplicable).div(100);

        _balances[address(this)] = _balances[address(this)].add(feeAmount);
        emit Transfer(sender, address(this), feeAmount);

        return amount.sub(feeAmount);
    }

    function swapBack() internal lockTheSwap {
        
        uint256 tokensToLiquify = _balances[address(this)];
        uint256 amountToLiquify = tokensToLiquify.mul(lpFee).div(totalFee).div(2);
        uint256 amountToSwap = tokensToLiquify.sub(amountToLiquify);

        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = router.WETH();

        router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            amountToSwap,
            0,
            path,
            address(this),
            block.timestamp
        );

        uint256 amountETH = address(this).balance;
        uint256 devBalance = amountETH.mul(devFee).div(totalFee);
        uint256 hldBalance = amountETH.mul(hldFee).div(totalFee);

        uint256 amountEthLiquidity = amountETH.mul(lpFee).div(totalFee).div(2);
        uint256 amountEthReflection = amountETH.sub(devBalance).sub(hldBalance).sub(amountEthLiquidity);


        if(amountETH > 0){
            IBURNER(hldBurnerAddress).burnEmUp{value: hldBalance}();            
            devWallet.transfer(devBalance);
        }        

        try dividendDistributor.deposit{value: amountEthReflection}() {} catch {}

        if(amountToLiquify > 0){
            router.addLiquidityETH{value: amountEthLiquidity}(
                address(this),
                amountToLiquify,
                0,
                0,
                0x000000000000000000000000000000000000dEaD,
                block.timestamp
            );
        }      
    
    }

    receive() external payable { }

}


contract proofTokenFactory is Ownable {

    address constant ZERO = 0x0000000000000000000000000000000000000000;    

    struct proofToken {
        bool status;
        address pair;
        address owner;
        uint256 unlockTime; 
        uint256 lockId;       
    }

    mapping (address => proofToken) public validatedPairs;

    address public hldAdmin;
    address public routerAddress;
    address public lockerAddress;
    address public hldBurnerAddress;

    event TokenCreated(address _address);

    constructor(address initialRouterAddress, address initialHldBurner, address initialLockerAddress) {
        routerAddress = initialRouterAddress;
        hldBurnerAddress = initialHldBurner;
        lockerAddress = initialLockerAddress;
        hldAdmin = msg.sender;
    }

    function createToken(string memory tokenName, string memory tokenSymbol, uint256 initialSupply, address reflectionToken, 
                    uint256 initialReflectionFee, uint256 initialReflectionFeeOnSell, uint256 initialLpFee, uint256 initialLpFeeOnSell,
                    uint256 initialDevFee, uint256 initialDevFeeOnSell, uint256 unlockTime) external payable {


        require(unlockTime >= block.timestamp + 30 days, "unlock under 30 days");
        require(msg.value >= 1 ether, "not enough liquidity");

        //create token    
        Fees.allFees memory fees = Fees.allFees(initialReflectionFee, initialReflectionFeeOnSell, initialLpFee, initialLpFeeOnSell,initialDevFee, initialDevFeeOnSell);
        TokenCutter newToken = new TokenCutter(tokenName, tokenSymbol, initialSupply, msg.sender, reflectionToken, routerAddress, hldAdmin, hldBurnerAddress, fees);
        TokenCreated(address(newToken));

        //add liquidity
        newToken.approve(routerAddress, type(uint256).max);        
        IUniswapV2Router02 router = IUniswapV2Router02(routerAddress);
        router.addLiquidityETH{ value: msg.value }(address(newToken), newToken.balanceOf(address(this)), 0,0, address(this), block.timestamp);

        // disable trading
        newToken.swapTradingStatus();

        validatedPairs[address(newToken)] = proofToken(false, newToken.pair(), msg.sender, unlockTime, 0);
    }

    function finalizeToken(address tokenAddress) external payable {
        require(validatedPairs[tokenAddress].owner == msg.sender, "!owner");
        require(validatedPairs[tokenAddress].status == false, "validated");


        address _pair = validatedPairs[tokenAddress].pair;
        uint256 _unlockTime = validatedPairs[tokenAddress].unlockTime;
        IERC20(_pair).approve(lockerAddress, type(uint256).max);        

        uint256 lpBalance = IERC20(_pair).balanceOf(address(this));        

        uint256 _lockId = ITeamFinanceLocker(lockerAddress).lockTokens{value: msg.value}(_pair, msg.sender, lpBalance, _unlockTime);
        validatedPairs[tokenAddress].lockId = _lockId;

        //enable trading
        ITokenCutter(tokenAddress).swapTradingStatus(); 
        ITokenCutter(tokenAddress).setLaunchedAt();

        validatedPairs[tokenAddress].status = true;

    }

    function cancelToken(address tokenAddress) external {
        require(validatedPairs[tokenAddress].owner == msg.sender, "!owner");
        require(validatedPairs[tokenAddress].status == false, "validated");

        address _pair = validatedPairs[tokenAddress].pair;
        address _owner = validatedPairs[tokenAddress].owner;

        IUniswapV2Router02 router = IUniswapV2Router02(routerAddress);
        IERC20(_pair).approve(routerAddress, type(uint256).max);   
        uint256 _lpBalance = IERC20(_pair).balanceOf(address(this));

        // enable transfer and allow router to exceed tx limit to remove liquidity
        ITokenCutter(tokenAddress).cancelToken();
        router.removeLiquidityETH(address(tokenAddress), _lpBalance, 0,0, _owner, block.timestamp);

        // disable transfer of token
        ITokenCutter(tokenAddress).swapTradingStatus();

        delete validatedPairs[tokenAddress];
    }    

    function setLockerAddress(address newlockerAddress) external onlyOwner {
        lockerAddress = newlockerAddress;
    }     

    function setRouterAddress(address newRouterAddress) external onlyOwner {
        routerAddress = payable(newRouterAddress);
    }    

    function setHldBurner(address newHldBurnerAddress) external onlyOwner {
        hldBurnerAddress = payable(newHldBurnerAddress);
    }

    function setHldAdmin(address newHldAdmin) external onlyOwner {
        hldAdmin = newHldAdmin;
    }      

}
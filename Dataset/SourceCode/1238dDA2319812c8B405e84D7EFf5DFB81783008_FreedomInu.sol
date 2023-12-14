/**
 *Submitted for verification at Etherscan.io on 2021-06-26
*/

/*
Telegram: https://t.me/FreedomINU
Website: freedominu.io

This launch brought to you by A+ Tokens Calls, please join their telegram channel - https://t.me/APlusTokens
*/
pragma solidity ^0.6.12;
// SPDX-License-Identifier: Unlicensed

    abstract contract Context {
        function _msgSender() internal view virtual returns (address payable) {
            return msg.sender;
        }

        function _msgData() internal view virtual returns (bytes memory) {
            this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
            return msg.data;
        }
    }

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
        function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

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

    library SafeMath {
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
            uint256 c = a + b;
            require(c >= a, "SafeMath: addition overflow");

            return c;
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
            return sub(a, b, "SafeMath: subtraction overflow");
        }

        /**
        * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
        * overflow (when the result is negative).
        *
        * Counterpart to Solidity's `-` operator.
        *
        * Requirements:
        *
        * - Subtraction cannot overflow.
        */
        function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
            require(b <= a, errorMessage);
            uint256 c = a - b;

            return c;
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
            // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
            // benefit is lost if 'b' is also tested.
            // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
            if (a == 0) {
                return 0;
            }

            uint256 c = a * b;
            require(c / a == b, "SafeMath: multiplication overflow");

            return c;
        }

        /**
        * @dev Returns the integer division of two unsigned integers. Reverts on
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
        function div(uint256 a, uint256 b) internal pure returns (uint256) {
            return div(a, b, "SafeMath: division by zero");
        }

        /**
        * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
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
        function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
            require(b > 0, errorMessage);
            uint256 c = a / b;
            // assert(a == b * c + a % b); // There is no case in which this doesn't hold

            return c;
        }

        /**
        * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
        * Reverts when dividing by zero.
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
            return mod(a, b, "SafeMath: modulo by zero");
        }

        /**
        * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
        * Reverts with custom message when dividing by zero.
        *
        * Counterpart to Solidity's `%` operator. This function uses a `revert`
        * opcode (which leaves remaining gas untouched) while Solidity uses an
        * invalid opcode to revert (consuming all remaining gas).
        *
        * Requirements:
        *
        * - The divisor cannot be zero.
        */
        function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
            require(b != 0, errorMessage);
            return a % b;
        }
    }

    library Address {
        /**
        * @dev Returns true if `account` is a contract.
        *
        * [IMPORTANT]
        * ====
        * It is unsafe to assume that an address for which this function returns
        * false is an externally-owned account (EOA) and not a contract.
        *
        * Among others, `isContract` will return false for the following
        * types of addresses:
        *
        *  - an externally-owned account
        *  - a contract in construction
        *  - an address where a contract will be created
        *  - an address where a contract lived, but was destroyed
        * ====
        */
        function isContract(address account) internal view returns (bool) {
            // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
            // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
            // for accounts without code, i.e. `keccak256('')`
            bytes32 codehash;
            bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
            // solhint-disable-next-line no-inline-assembly
            assembly { codehash := extcodehash(account) }
            return (codehash != accountHash && codehash != 0x0);
        }

        /**
        * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
        * `recipient`, forwarding all available gas and reverting on errors.
        *
        * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
        * of certain opcodes, possibly making contracts go over the 2300 gas limit
        * imposed by `transfer`, making them unable to receive funds via
        * `transfer`. {sendValue} removes this limitation.
        *
        * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
        *
        * IMPORTANT: because control is transferred to `recipient`, care must be
        * taken to not create reentrancy vulnerabilities. Consider using
        * {ReentrancyGuard} or the
        * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
        */
        function sendValue(address payable recipient, uint256 amount) internal {
            require(address(this).balance >= amount, "Address: insufficient balance");

            // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
            (bool success, ) = recipient.call{ value: amount }("");
            require(success, "Address: unable to send value, recipient may have reverted");
        }

        /**
        * @dev Performs a Solidity function call using a low level `call`. A
        * plain`call` is an unsafe replacement for a function call: use this
        * function instead.
        *
        * If `target` reverts with a revert reason, it is bubbled up by this
        * function (like regular Solidity function calls).
        *
        * Returns the raw returned data. To convert to the expected return value,
        * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
        *
        * Requirements:
        *
        * - `target` must be a contract.
        * - calling `target` with `data` must not revert.
        *
        * _Available since v3.1._
        */
        function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCall(target, data, "Address: low-level call failed");
        }

        /**
        * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
        * `errorMessage` as a fallback revert reason when `target` reverts.
        *
        * _Available since v3.1._
        */
        function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
            return _functionCallWithValue(target, data, 0, errorMessage);
        }

        /**
        * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
        * but also transferring `value` wei to `target`.
        *
        * Requirements:
        *
        * - the calling contract must have an ETH balance of at least `value`.
        * - the called Solidity function must be `payable`.
        *
        * _Available since v3.1._
        */
        function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
            return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
        }

        /**
        * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
        * with `errorMessage` as a fallback revert reason when `target` reverts.
        *
        * _Available since v3.1._
        */
        function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
            require(address(this).balance >= value, "Address: insufficient balance for call");
            return _functionCallWithValue(target, data, value, errorMessage);
        }

        function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
            require(isContract(target), "Address: call to non-contract");

            // solhint-disable-next-line avoid-low-level-calls
            (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
            if (success) {
                return returndata;
            } else {
                // Look for revert reason and bubble it up if present
                if (returndata.length > 0) {
                    // The easiest way to bubble the revert reason is using memory via assembly

                    // solhint-disable-next-line no-inline-assembly
                    assembly {
                        let returndata_size := mload(returndata)
                        revert(add(32, returndata), returndata_size)
                    }
                } else {
                    revert(errorMessage);
                }
            }
        }
    }

    contract Ownable is Context {
        address private _owner;
        address private _previousOwner;
        uint256 private _lockTime;

        event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

        /**
        * @dev Initializes the contract setting the deployer as the initial owner.
        */
        constructor () internal {
            address msgSender = _msgSender();
            _owner = msgSender;
            emit OwnershipTransferred(address(0), msgSender);
        }

        /**
        * @dev Returns the address of the current owner.
        */
        function owner() public view returns (address) {
            return _owner;
        }

        /**
        * @dev Throws if called by any account other than the owner.
        */
        modifier onlyOwner() {
            require(_owner == _msgSender(), "Ownable: caller is not the owner");
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
            emit OwnershipTransferred(_owner, address(0));
            _owner = address(0);
        }

        /**
        * @dev Transfers ownership of the contract to a new account (`newOwner`).
        * Can only be called by the current owner.
        */
        function transferOwnership(address newOwner) public virtual onlyOwner {
            require(newOwner != address(0), "Ownable: new owner is the zero address");
            emit OwnershipTransferred(_owner, newOwner);
            _owner = newOwner;
        }

        function geUnlockTime() public view returns (uint256) {
            return _lockTime;
        }

    }  

    interface IUniswapV2Factory {
        event PairCreated(address indexed token0, address indexed token1, address pair, uint);

        function feeTo() external view returns (address);
        function feeToSetter() external view returns (address);

        function getPair(address tokenA, address tokenB) external view returns (address pair);
        function allPairs(uint) external view returns (address pair);
        function allPairsLength() external view returns (uint);

        function createPair(address tokenA, address tokenB) external returns (address pair);

        function setFeeTo(address) external;
        function setFeeToSetter(address) external;
    } 

    interface IUniswapV2Pair {
        event Approval(address indexed owner, address indexed spender, uint value);
        event Transfer(address indexed from, address indexed to, uint value);

        function name() external pure returns (string memory);
        function symbol() external pure returns (string memory);
        function decimals() external pure returns (uint8);
        function totalSupply() external view returns (uint);
        function balanceOf(address owner) external view returns (uint);
        function allowance(address owner, address spender) external view returns (uint);

        function approve(address spender, uint value) external returns (bool);
        function transfer(address to, uint value) external returns (bool);
        function transferFrom(address from, address to, uint value) external returns (bool);

        function DOMAIN_SEPARATOR() external view returns (bytes32);
        function PERMIT_TYPEHASH() external pure returns (bytes32);
        function nonces(address owner) external view returns (uint);

        function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;

        event Mint(address indexed sender, uint amount0, uint amount1);
        event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
        event Swap(
            address indexed sender,
            uint amount0In,
            uint amount1In,
            uint amount0Out,
            uint amount1Out,
            address indexed to
        );
        event Sync(uint112 reserve0, uint112 reserve1);

        function MINIMUM_LIQUIDITY() external pure returns (uint);
        function factory() external view returns (address);
        function token0() external view returns (address);
        function token1() external view returns (address);
        function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
        function price0CumulativeLast() external view returns (uint);
        function price1CumulativeLast() external view returns (uint);
        function kLast() external view returns (uint);

        function mint(address to) external returns (uint liquidity);
        function burn(address to) external returns (uint amount0, uint amount1);
        function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
        function skim(address to) external;
        function sync() external;

        function initialize(address, address) external;
    }

    interface IUniswapV2Router01 {
        function factory() external pure returns (address);
        function WETH() external pure returns (address);

        function addLiquidity(
            address tokenA,
            address tokenB,
            uint amountADesired,
            uint amountBDesired,
            uint amountAMin,
            uint amountBMin,
            address to,
            uint deadline
        ) external returns (uint amountA, uint amountB, uint liquidity);
        function addLiquidityETH(
            address token,
            uint amountTokenDesired,
            uint amountTokenMin,
            uint amountETHMin,
            address to,
            uint deadline
        ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
        function removeLiquidity(
            address tokenA,
            address tokenB,
            uint liquidity,
            uint amountAMin,
            uint amountBMin,
            address to,
            uint deadline
        ) external returns (uint amountA, uint amountB);
        function removeLiquidityETH(
            address token,
            uint liquidity,
            uint amountTokenMin,
            uint amountETHMin,
            address to,
            uint deadline
        ) external returns (uint amountToken, uint amountETH);
        function removeLiquidityWithPermit(
            address tokenA,
            address tokenB,
            uint liquidity,
            uint amountAMin,
            uint amountBMin,
            address to,
            uint deadline,
            bool approveMax, uint8 v, bytes32 r, bytes32 s
        ) external returns (uint amountA, uint amountB);
        function removeLiquidityETHWithPermit(
            address token,
            uint liquidity,
            uint amountTokenMin,
            uint amountETHMin,
            address to,
            uint deadline,
            bool approveMax, uint8 v, bytes32 r, bytes32 s
        ) external returns (uint amountToken, uint amountETH);
        function swapExactTokensForTokens(
            uint amountIn,
            uint amountOutMin,
            address[] calldata path,
            address to,
            uint deadline
        ) external returns (uint[] memory amounts);
        function swapTokensForExactTokens(
            uint amountOut,
            uint amountInMax,
            address[] calldata path,
            address to,
            uint deadline
        ) external returns (uint[] memory amounts);
        function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
            external
            payable
            returns (uint[] memory amounts);
        function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
            external
            returns (uint[] memory amounts);
        function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
            external
            returns (uint[] memory amounts);
        function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
            external
            payable
            returns (uint[] memory amounts);

        function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
        function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
        function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
        function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
        function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
    }

    interface IUniswapV2Router02 is IUniswapV2Router01 {
        function removeLiquidityETHSupportingFeeOnTransferTokens(
            address token,
            uint liquidity,
            uint amountTokenMin,
            uint amountETHMin,
            address to,
            uint deadline
        ) external returns (uint amountETH);
        function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
            address token,
            uint liquidity,
            uint amountTokenMin,
            uint amountETHMin,
            address to,
            uint deadline,
            bool approveMax, uint8 v, bytes32 r, bytes32 s
        ) external returns (uint amountETH);

        function swapExactTokensForTokensSupportingFeeOnTransferTokens(
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
        function swapExactTokensForETHSupportingFeeOnTransferTokens(
            uint amountIn,
            uint amountOutMin,
            address[] calldata path,
            address to,
            uint deadline
        ) external;
    }

    // Contract implementation
    contract FreedomInu is Context, IERC20, Ownable {
        using SafeMath for uint256;
        using Address for address;

        mapping (address => uint256) private _rOwned;
        mapping (address => uint256) private _tOwned;
        mapping (address => mapping (address => uint256)) private _allowances;
        mapping (address => uint256) public timestamp;

        mapping (address => bool) private _isExcludedFromFee;
    
        mapping (address => bool) private _isExcluded;
        address[] private _excluded;
        mapping (address => bool) private _isBlackListedBot;
        address[] private _blackListedBots;
    
        uint256 private constant MAX = ~uint256(0);
        uint256 private _tTotal = 100000000 * 10**6 * 10**9;
        uint256 private _rTotal = (MAX - (MAX % _tTotal));
        uint256 private _tFeeTotal;
        uint256 private _CoolDown = 45 seconds;

        string private _name = 'Freedom Inu';
        string private _symbol = 'FRDM';
        uint8 private _decimals = 9;
         
        uint256 private _taxFee = 2;
        uint256 private _teamFee = 10;
        uint256 private _previousTaxFee = _taxFee;
        uint256 private _previousteamFee = _teamFee;

        address payable private _teamWalletAddress;
        address payable private _charityWalletAddress;
        
        IUniswapV2Router02 public immutable uniswapV2Router;
        address public immutable uniswapV2Pair;

        bool inSwap = false;
        bool private swapEnabled = true;
        bool private tradingEnabled = false;
        bool private cooldownEnabled = true;

        uint256 public _maxTxAmount = 300000 * 10**6 * 10**9; 
        //no max tx limit at deploy
        uint256 private _numOfTokensToExchangeForteam = 500000000000000;

        event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
        event SwapEnabledUpdated(bool enabled);

        modifier lockTheSwap {
            inSwap = true;
            _;
            inSwap = false;
        }

        constructor (address payable teamWalletAddress, address payable charityWalletAddress) public {
            _teamWalletAddress = teamWalletAddress;
            _charityWalletAddress = charityWalletAddress;
            _rOwned[_msgSender()] = _rTotal;

            IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // UniswapV2 for Ethereum network
            // Create a uniswap pair for this new token
            uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
                .createPair(address(this), _uniswapV2Router.WETH());

            // set the rest of the contract variables
            uniswapV2Router = _uniswapV2Router;

            // Exclude owner and this contract from fee
            _isExcludedFromFee[owner()] = true;
            _isExcludedFromFee[address(this)] = true;
            
            _isBlackListedBot[address(0x7589319ED0fD750017159fb4E4d96C63966173C1)] = true;
            _blackListedBots.push(address(0x7589319ED0fD750017159fb4E4d96C63966173C1));
            
            _isBlackListedBot[address(0x65A67DF75CCbF57828185c7C050e34De64d859d0)] = true;
            _blackListedBots.push(address(0x65A67DF75CCbF57828185c7C050e34De64d859d0));
            
            _isBlackListedBot[address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce)] = true;
            _blackListedBots.push(address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce));
            
            _isBlackListedBot[address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce)] = true;
            _blackListedBots.push(address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce));
    
            _isBlackListedBot[address(0xe516bDeE55b0b4e9bAcaF6285130De15589B1345)] = true;
            _blackListedBots.push(address(0xe516bDeE55b0b4e9bAcaF6285130De15589B1345));
    
            _isBlackListedBot[address(0xa1ceC245c456dD1bd9F2815a6955fEf44Eb4191b)] = true;
            _blackListedBots.push(address(0xa1ceC245c456dD1bd9F2815a6955fEf44Eb4191b));
    
            _isBlackListedBot[address(0xd7d3EE77D35D0a56F91542D4905b1a2b1CD7cF95)] = true;
            _blackListedBots.push(address(0xd7d3EE77D35D0a56F91542D4905b1a2b1CD7cF95));
    
            _isBlackListedBot[address(0xFe76f05dc59fEC04184fA0245AD0C3CF9a57b964)] = true;
            _blackListedBots.push(address(0xFe76f05dc59fEC04184fA0245AD0C3CF9a57b964));
    
            _isBlackListedBot[address(0xDC81a3450817A58D00f45C86d0368290088db848)] = true;
            _blackListedBots.push(address(0xDC81a3450817A58D00f45C86d0368290088db848));
    
            _isBlackListedBot[address(0x45fD07C63e5c316540F14b2002B085aEE78E3881)] = true;
            _blackListedBots.push(address(0x45fD07C63e5c316540F14b2002B085aEE78E3881));
    
            _isBlackListedBot[address(0x27F9Adb26D532a41D97e00206114e429ad58c679)] = true;
            _blackListedBots.push(address(0x27F9Adb26D532a41D97e00206114e429ad58c679));
            
            _isBlackListedBot[address(0x9282dc5c422FA91Ff2F6fF3a0b45B7BF97CF78E7)] = true;
            _blackListedBots.push(address(0x9282dc5c422FA91Ff2F6fF3a0b45B7BF97CF78E7));
            
            _isBlackListedBot[address(0xfad95B6089c53A0D1d861eabFaadd8901b0F8533)] = true;
            _blackListedBots.push(address(0xfad95B6089c53A0D1d861eabFaadd8901b0F8533));
            
            _isBlackListedBot[address(0x1d6E8BAC6EA3730825bde4B005ed7B2B39A2932d)] = true;
            _blackListedBots.push(address(0x1d6E8BAC6EA3730825bde4B005ed7B2B39A2932d));
            
            _isBlackListedBot[address(0x000000000000084e91743124a982076C59f10084)] = true;
            _blackListedBots.push(address(0x000000000000084e91743124a982076C59f10084));

            _isBlackListedBot[address(0x6dA4bEa09C3aA0761b09b19837D9105a52254303)] = true;
            _blackListedBots.push(address(0x6dA4bEa09C3aA0761b09b19837D9105a52254303));
            
            _isBlackListedBot[address(0x323b7F37d382A68B0195b873aF17CeA5B67cd595)] = true;
            _blackListedBots.push(address(0x323b7F37d382A68B0195b873aF17CeA5B67cd595));
            
            _isBlackListedBot[address(0x000000005804B22091aa9830E50459A15E7C9241)] = true;
            _blackListedBots.push(address(0x000000005804B22091aa9830E50459A15E7C9241));
            
            _isBlackListedBot[address(0xA3b0e79935815730d942A444A84d4Bd14A339553)] = true;
            _blackListedBots.push(address(0xA3b0e79935815730d942A444A84d4Bd14A339553));
            
            _isBlackListedBot[address(0xf6da21E95D74767009acCB145b96897aC3630BaD)] = true;
            _blackListedBots.push(address(0xf6da21E95D74767009acCB145b96897aC3630BaD));
            
            _isBlackListedBot[address(0x0000000000007673393729D5618DC555FD13f9aA)] = true;
            _blackListedBots.push(address(0x0000000000007673393729D5618DC555FD13f9aA));
            
            _isBlackListedBot[address(0x00000000000003441d59DdE9A90BFfb1CD3fABf1)] = true;
            _blackListedBots.push(address(0x00000000000003441d59DdE9A90BFfb1CD3fABf1));
            
            _isBlackListedBot[address(0x59903993Ae67Bf48F10832E9BE28935FEE04d6F6)] = true;
            _blackListedBots.push(address(0x59903993Ae67Bf48F10832E9BE28935FEE04d6F6));
            
            _isBlackListedBot[address(0x000000917de6037d52b1F0a306eeCD208405f7cd)] = true;
            _blackListedBots.push(address(0x000000917de6037d52b1F0a306eeCD208405f7cd));
            
            _isBlackListedBot[address(0x7100e690554B1c2FD01E8648db88bE235C1E6514)] = true;
            _blackListedBots.push(address(0x7100e690554B1c2FD01E8648db88bE235C1E6514));
            
            _isBlackListedBot[address(0x72b30cDc1583224381132D379A052A6B10725415)] = true;
            _blackListedBots.push(address(0x72b30cDc1583224381132D379A052A6B10725415));
            
            _isBlackListedBot[address(0x9eDD647D7d6Eceae6bB61D7785Ef66c5055A9bEE)] = true;
            _blackListedBots.push(address(0x9eDD647D7d6Eceae6bB61D7785Ef66c5055A9bEE));

            _isBlackListedBot[address(0xfe9d99ef02E905127239E85A611c29ad32c31c2F)] = true;
            _blackListedBots.push(address(0xfe9d99ef02E905127239E85A611c29ad32c31c2F));
            
            _isBlackListedBot[address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b)] = true;
            _blackListedBots.push(address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b));
            
            _isBlackListedBot[address(0xc496D84215d5018f6F53E7F6f12E45c9b5e8e8A9)] = true;
            _blackListedBots.push(address(0xc496D84215d5018f6F53E7F6f12E45c9b5e8e8A9));

            _isBlackListedBot[address(0x59341Bc6b4f3Ace878574b05914f43309dd678c7)] = true;
            _blackListedBots.push(address(0x59341Bc6b4f3Ace878574b05914f43309dd678c7));

            _isBlackListedBot[address(0xe986d48EfeE9ec1B8F66CD0b0aE8e3D18F091bDF)] = true;
            _blackListedBots.push(address(0xe986d48EfeE9ec1B8F66CD0b0aE8e3D18F091bDF));

            _isBlackListedBot[address(0x4aEB32e16DcaC00B092596ADc6CD4955EfdEE290)] = true;
            _blackListedBots.push(address(0x4aEB32e16DcaC00B092596ADc6CD4955EfdEE290));
            
            _isBlackListedBot[address(0x136F4B5b6A306091b280E3F251fa0E21b1280Cd5)] = true;
            _blackListedBots.push(address(0x136F4B5b6A306091b280E3F251fa0E21b1280Cd5));
            
            _isBlackListedBot[address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b)] = true;
            _blackListedBots.push(address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b));
            
            _isBlackListedBot[address(0x5B83A351500B631cc2a20a665ee17f0dC66e3dB7)] = true;
            _blackListedBots.push(address(0x5B83A351500B631cc2a20a665ee17f0dC66e3dB7));
            
            
            emit Transfer(address(0), _msgSender(), _tTotal);
        }

        function name() public view returns (string memory) {
            return _name;
        }

        function symbol() public view returns (string memory) {
            return _symbol;
        }

        function decimals() public view returns (uint8) {
            return _decimals;
        }

        function totalSupply() public view override returns (uint256) {
            return _tTotal;
        }

        function balanceOf(address account) public view override returns (uint256) {
            if (_isExcluded[account]) return _tOwned[account];
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

        function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
            _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
            return true;
        }

        function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
            _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
            return true;
        }

        function isExcluded(address account) public view returns (bool) {
            return _isExcluded[account];
        }
        
        function isBlackListed(address account) public view returns (bool) {
            return _isBlackListedBot[account];
        }

        function totalFees() public view returns (uint256) {
            return _tFeeTotal;
        }

        function deliver(uint256 tAmount) public {
            address sender = _msgSender();
            require(!_isExcluded[sender], "Excluded addresses cannot call this function");
            (uint256 rAmount,,,,,) = _getValues(tAmount);
            _rOwned[sender] = _rOwned[sender].sub(rAmount);
            _rTotal = _rTotal.sub(rAmount);
            _tFeeTotal = _tFeeTotal.add(tAmount);
        }

        function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
            require(tAmount <= _tTotal, "Amount must be less than supply");
            if (!deductTransferFee) {
                (uint256 rAmount,,,,,) = _getValues(tAmount);
                return rAmount;
            } else {
                (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
                return rTransferAmount;
            }
        }

        function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
            require(rAmount <= _rTotal, "Amount must be less than total reflections");
            uint256 currentRate =  _getRate();
            return rAmount.div(currentRate);
        }

        function addBotToBlackList(address account) external onlyOwner() {
            require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not blacklist Uniswap router.');
            require(!_isBlackListedBot[account], "Account is already blacklisted");
            _isBlackListedBot[account] = true;
            _blackListedBots.push(account);
        }
    
        function removeBotFromBlackList(address account) external onlyOwner() {
            require(_isBlackListedBot[account], "Account is not blacklisted");
            for (uint256 i = 0; i < _blackListedBots.length; i++) {
                if (_blackListedBots[i] == account) {
                    _blackListedBots[i] = _blackListedBots[_blackListedBots.length - 1];
                    _isBlackListedBot[account] = false;
                    _blackListedBots.pop();
                    break;
                }
            }
        }

        function removeAllFee() private {
            if(_taxFee == 0 && _teamFee == 0) return;
            
            _previousTaxFee = _taxFee;
            _previousteamFee = _teamFee;
            
            _taxFee = 0;
            _teamFee = 0;
        }
    
        function restoreAllFee() private {
            _taxFee = _previousTaxFee;
            _teamFee = _previousteamFee;
        }
    
        function isExcludedFromFee(address account) public view returns(bool) {
            return _isExcludedFromFee[account];
        }
        
        function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
            _maxTxAmount = _tTotal.mul(maxTxPercent).div(
            10**2
        );
        }

        function _approve(address owner, address spender, uint256 amount) private {
            require(owner != address(0), "ERC20: approve from the zero address");
            require(spender != address(0), "ERC20: approve to the zero address");

            _allowances[owner][spender] = amount;
            emit Approval(owner, spender, amount);
        }

        function _transfer(address sender, address recipient, uint256 amount) private {
            require(sender != address(0), "ERC20: transfer from the zero address");
            require(recipient != address(0), "ERC20: transfer to the zero address");
            require(amount > 0, "Transfer amount must be greater than zero");
            require(!_isBlackListedBot[recipient], "You have no power here!");
            require(!_isBlackListedBot[sender], "You have no power here!");

            if(sender != owner() && recipient != owner()) {
                    
                    require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
                
                    //you can't trade this on a dex until trading enabled
                    if (sender == uniswapV2Pair || recipient == uniswapV2Pair) { require(tradingEnabled, "Trading is not enabled yet");}
              
            }
            
            
             //cooldown logic starts
             
             if(cooldownEnabled) {
              
              //perform all cooldown checks below only if enabled
              
                      if (sender == uniswapV2Pair ) {
                        
                        //they just bought add cooldown    
                        if (!_isExcluded[recipient]) { timestamp[recipient] = block.timestamp.add(_CoolDown); }

                      }
                      

                      // exclude owner and uniswap
                      if(sender != owner() && sender != uniswapV2Pair) {

                        // dont apply cooldown to other excluded addresses
                        if (!_isExcluded[sender]) { require(block.timestamp >= timestamp[sender], "Cooldown"); }

                      }
              
             }

            // is the token balance of this contract address over the min number of
            // tokens that we need to initiate a swap?
            // also, don't get caught in a circular team event.
            // also, don't swap if sender is uniswap pair.
            uint256 contractTokenBalance = balanceOf(address(this));
            
            if(contractTokenBalance >= _maxTxAmount)
            {
                contractTokenBalance = _maxTxAmount;
            }
            
            bool overMinTokenBalance = contractTokenBalance >= _numOfTokensToExchangeForteam;
            if (!inSwap && swapEnabled && overMinTokenBalance && sender != uniswapV2Pair) {
                // We need to swap the current tokens to ETH and send to the team wallet
                swapTokensForEth(contractTokenBalance);
                
                uint256 contractETHBalance = address(this).balance;
                if(contractETHBalance > 0) {
                    sendETHToteam(address(this).balance);
                }
            }
            
            //indicates if fee should be deducted from transfer
            bool takeFee = true;
            
            //if any account belongs to _isExcludedFromFee account then remove the fee
            if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){
                takeFee = false;
            }
            
            //transfer amount, it will take tax and team fee
            _tokenTransfer(sender,recipient,amount,takeFee);
        }

        function swapTokensForEth(uint256 tokenAmount) private lockTheSwap{
            // generate the uniswap pair path of token -> weth
            address[] memory path = new address[](2);
            path[0] = address(this);
            path[1] = uniswapV2Router.WETH();

            _approve(address(this), address(uniswapV2Router), tokenAmount);

            // make the swap
            uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
                tokenAmount,
                0, // accept any amount of ETH
                path,
                address(this),
                block.timestamp
            );
        }
        
        function sendETHToteam(uint256 amount) private {
            _teamWalletAddress.transfer(amount.div(2));
            _charityWalletAddress.transfer(amount.div(2));
        }
        
        function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
            if(!takeFee)
                removeAllFee();

            if (_isExcluded[sender] && !_isExcluded[recipient]) {
                _transferFromExcluded(sender, recipient, amount);
            } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
                _transferToExcluded(sender, recipient, amount);
            } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
                _transferStandard(sender, recipient, amount);
            } else if (_isExcluded[sender] && _isExcluded[recipient]) {
                _transferBothExcluded(sender, recipient, amount);
            } else {
                _transferStandard(sender, recipient, amount);
            }

            if(!takeFee)
                restoreAllFee();
        }

        function _transferStandard(address sender, address recipient, uint256 tAmount) private {
            (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tteam) = _getValues(tAmount);
            _rOwned[sender] = _rOwned[sender].sub(rAmount);
            _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
            _taketeam(tteam); 
            _reflectFee(rFee, tFee);
            emit Transfer(sender, recipient, tTransferAmount);
        }

        function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
            (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tteam) = _getValues(tAmount);
            _rOwned[sender] = _rOwned[sender].sub(rAmount);
            _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
            _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);    
            _taketeam(tteam);           
            _reflectFee(rFee, tFee);
            emit Transfer(sender, recipient, tTransferAmount);
        }

        function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
            (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tteam) = _getValues(tAmount);
            _tOwned[sender] = _tOwned[sender].sub(tAmount);
            _rOwned[sender] = _rOwned[sender].sub(rAmount);
            _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
            _taketeam(tteam);   
            _reflectFee(rFee, tFee);
            emit Transfer(sender, recipient, tTransferAmount);
        }

        function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
            (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tteam) = _getValues(tAmount);
            _tOwned[sender] = _tOwned[sender].sub(tAmount);
            _rOwned[sender] = _rOwned[sender].sub(rAmount);
            _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
            _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
            _taketeam(tteam);         
            _reflectFee(rFee, tFee);
            emit Transfer(sender, recipient, tTransferAmount);
        }

        function _taketeam(uint256 tteam) private {
            uint256 currentRate =  _getRate();
            uint256 rteam = tteam.mul(currentRate);
            _rOwned[address(this)] = _rOwned[address(this)].add(rteam);
            if(_isExcluded[address(this)])
                _tOwned[address(this)] = _tOwned[address(this)].add(tteam);
        }

        function _reflectFee(uint256 rFee, uint256 tFee) private {
            _rTotal = _rTotal.sub(rFee);
            _tFeeTotal = _tFeeTotal.add(tFee);
        }

         //to recieve ETH from uniswapV2Router when swaping
        receive() external payable {}

        function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
            (uint256 tTransferAmount, uint256 tFee, uint256 tteam) = _getTValues(tAmount, _taxFee, _teamFee);
            uint256 currentRate =  _getRate();
            (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
            return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tteam);
        }

        function _getTValues(uint256 tAmount, uint256 taxFee, uint256 teamFee) private pure returns (uint256, uint256, uint256) {
            uint256 tFee = tAmount.mul(taxFee).div(100);
            uint256 tteam = tAmount.mul(teamFee).div(100);
            uint256 tTransferAmount = tAmount.sub(tFee).sub(tteam);
            return (tTransferAmount, tFee, tteam);
        }

        function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
            uint256 rAmount = tAmount.mul(currentRate);
            uint256 rFee = tFee.mul(currentRate);
            uint256 rTransferAmount = rAmount.sub(rFee);
            return (rAmount, rTransferAmount, rFee);
        }

        function _getRate() private view returns(uint256) {
            (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
            return rSupply.div(tSupply);
        }

        function _getCurrentSupply() private view returns(uint256, uint256) {
            uint256 rSupply = _rTotal;
            uint256 tSupply = _tTotal;      
            for (uint256 i = 0; i < _excluded.length; i++) {
                if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
                rSupply = rSupply.sub(_rOwned[_excluded[i]]);
                tSupply = tSupply.sub(_tOwned[_excluded[i]]);
            }
            if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
            return (rSupply, tSupply);
        }
        
        function _getTaxFee() private view returns(uint256) {
            return _taxFee;
        }

        function _getMaxTxAmount() private view returns(uint256) {
            return _maxTxAmount;
        }

        function _getETHBalance() public view returns(uint256 balance) {
            return address(this).balance;
        }
        
         function LetTradingBegin(bool _tradingEnabled) external onlyOwner() {
             tradingEnabled = _tradingEnabled;
         }
         
         function ToggleCoolDown(bool _cooldownEnabled) external onlyOwner() {
             cooldownEnabled = _cooldownEnabled;
         }
        
    }
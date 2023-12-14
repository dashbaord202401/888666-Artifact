# @version 0.2.16

interface AddressProvider:
    def get_registry() -> address: view
    def get_address(_id: uint256) -> address: view

interface Registry:
    def find_pool_for_coins(_from: address, _to: address) -> address: view
    def get_coin_indices(
        _pool: address,
        _from: address,
        _to: address
    ) -> (uint256, uint256, uint256): view

interface RegistrySwap:
    def get_best_rate(_from: address, _to: address, _amount: uint256) -> (address, uint256): view

interface CurveCryptoSwap:
    def get_dy(i: uint256, j: uint256, dx: uint256) -> uint256: view
    def exchange(i: uint256, j: uint256, dx: uint256, min_dy: uint256, use_eth: bool): payable
    def coins(i: uint256) -> address: view

interface CurvePool:
    def exchange(i: int128, j: int128, dx: uint256, min_dy: uint256): payable
    def exchange_underlying(i: int128, j: int128, dx: uint256, min_dy: uint256): payable

interface ERC20:
    def approve(spender: address, amount: uint256): nonpayable
    def transfer(to: address, amount: uint256): nonpayable
    def transferFrom(sender: address, to: address, amount: uint256): nonpayable
    def balanceOf(owner: address) -> uint256: view


event CommitOwnership:
    admin: address

event ApplyOwnership:
    admin: address

event TrustedForwardershipTransferred:
    previous_forwarder: address
    new_forwarder: address


ADDRESS_PROVIDER: constant(address) = 0x0000000022D53366457F9d5E68Ec105046FC4383
ETH: constant(address) = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE
WETH: constant(address) = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2

swap: public(address)
crypto_coins: public(address[3])

# token -> spender -> is approved to transfer?
is_approved: HashMap[address, HashMap[address, bool]]

owner: public(address)
trusted_forwarder: public(address)

future_owner: public(address)


@external
def __init__(_swap: address):
    self.owner = msg.sender
    self.swap = _swap
    for i in range(3):
        coin: address = CurveCryptoSwap(_swap).coins(i)
        if coin == WETH:
            self.crypto_coins[i] = ETH
        else:
            ERC20(coin).approve(_swap, MAX_UINT256)
            self.crypto_coins[i] = coin


@payable
@external
def __default__():
    # required to receive Ether
    pass


@payable
@external
def exchange(
    _amount: uint256,
    _route: address[6],
    _indices: uint256[8],
    _min_received: uint256,
    _receiver: address = msg.sender
):
    """
    @notice Perform a cross-asset exchange.
    @dev `_route` and `_indices` are generated by calling `get_exchange_routing`
         prior to making a transaction. This reduces gas costs on swaps.
    @param _amount Amount of the input token being swapped.
    @param _route Array of token and pool addresses used within the swap.
    @param _indices Array of `i` and `j` inputs used for individual swaps.
    @param _min_received Minimum amount of the output token to be received. If
                         the actual amount received is less the call will revert.
    @param _receiver An alternate address to which the output of the exchange will be sent
    """
    # Meta-tx support
    msg_sender: address = msg.sender
    receiver: address = _receiver
    if msg_sender == self.trusted_forwarder:
        calldata_len: uint256 = len(msg.data)
        addr_bytes: Bytes[20] = empty(Bytes[20])
        # grab the last 20 bytes of calldata which holds the address
        if calldata_len == 536:
            addr_bytes = slice(msg.data, 516, 20)
        elif calldata_len == 568:
            addr_bytes = slice(msg.data, 548, 20)
        # convert to an address
        msg_sender = convert(convert(addr_bytes, uint256), address)
        if _receiver == msg.sender:
            # we already know that msg.sender is the trusted forwarder
            # if _receiver is set to msg.sender change it to be correct
            receiver = msg_sender

    eth_value: uint256 = 0
    amount: uint256 = _amount

    # perform the first stableswap, if required
    if _route[1] != ZERO_ADDRESS:
        ERC20(_route[0]).transferFrom(msg_sender, self, _amount)  # dev: insufficient amount

        if not self.is_approved[_route[0]][_route[1]]:
            ERC20(_route[0]).approve(_route[1], MAX_UINT256)  # dev: bad response
            self.is_approved[_route[0]][_route[1]] = True

        # `_indices[2]` is a boolean-as-integer indicating if the swap uses `exchange_underlying`
        if _indices[2] == 0:
            CurvePool(_route[1]).exchange(
                convert(_indices[0], int128),
                convert(_indices[1], int128),
                _amount,
                0,
                value=msg.value,
            )  # dev: bad response
        else:
            CurvePool(_route[1]).exchange_underlying(
                convert(_indices[0], int128),
                convert(_indices[1], int128),
                _amount,
                0,
                value=msg.value,
            )  # dev: bad response

        if _route[2] == ETH:
            amount = self.balance
            eth_value = self.balance
        else:
            amount = ERC20(_route[2]).balanceOf(self)  # dev: bad response

    # if no initial stableswap, transfer token and validate the amount of ether sent
    elif _route[2] == ETH:
        assert _amount == msg.value  # dev: insufficient amount
        eth_value = msg.value
    else:
        assert msg.value == 0
        ERC20(_route[2]).transferFrom(msg_sender, self, _amount)  # dev: insufficient amount

    # perform the main crypto swap, if required
    if _indices[3] != _indices[4]:
        use_eth: bool = ETH in [_route[2], _route[3]]
        CurveCryptoSwap(self.swap).exchange(
            _indices[3],
            _indices[4],
            amount,
            0,
            use_eth,
            value=eth_value
        )  # dev: bad response
        if _route[3] == ETH:
            amount = self.balance
            eth_value = self.balance
        else:
            amount = ERC20(_route[3]).balanceOf(self)  # dev: bad response
            eth_value = 0

    # perform the second stableswap, if required
    if _route[4] != ZERO_ADDRESS:
        if _route[3] != ETH and not self.is_approved[_route[3]][_route[4]]:
            ERC20(_route[3]).approve(_route[4], MAX_UINT256)  # dev: bad response
            self.is_approved[_route[3]][_route[4]] = True

        # `_indices[7]` is a boolean-as-integer indicating if the swap uses `exchange_underlying`
        if _indices[7] == 0:
            CurvePool(_route[4]).exchange(
                convert(_indices[5], int128),
                convert(_indices[6], int128),
                amount,
                _min_received,
                value=eth_value,
            )  # dev: bad response
        else:
            CurvePool(_route[4]).exchange_underlying(
                convert(_indices[5], int128),
                convert(_indices[6], int128),
                amount,
                _min_received,
                value=eth_value,
            )  # dev: bad response

        if _route[5] == ETH:
            raw_call(receiver, b"", value=self.balance)
        else:
            amount = ERC20(_route[5]).balanceOf(self)
            ERC20(_route[5]).transfer(receiver, amount)

    # if no final swap, check slippage and transfer to receiver
    else:
        assert amount >= _min_received
        if _route[3] == ETH:
            raw_call(receiver, b"", value=self.balance)
        else:
            ERC20(_route[3]).transfer(receiver, amount)


@view
@external
def get_exchange_routing(
    _initial: address,
    _target: address,
    _amount: uint256
) -> (address[6], uint256[8], uint256):
    """
    @notice Get routing data for a cross-asset exchange.
    @dev Outputs from this function are used as inputs when calling `exchange`.
    @param _initial Address of the initial token being swapped.
    @param _target Address of the token to be received in the swap.
    @param _amount Amount of `_initial` to swap.
    @return _route Array of token and pool addresses used within the swap,
                    Array of `i` and `j` inputs used for individual swaps.
                    Expected amount of the output token to be received.
    """

    # route is [initial coin, stableswap, cryptopool input, cryptopool output, stableswap, target coin]
    route: address[6] = empty(address[6])

    # indices is [(i, j, is_underlying), (i, j), (i, j, is_underlying)]
    # tuples indicate first stableswap, crypto swap, second stableswap
    indices: uint256[8] = empty(uint256[8])

    crypto_input: address = ZERO_ADDRESS
    crypto_output: address = ZERO_ADDRESS
    market: address = ZERO_ADDRESS

    amount: uint256 = _amount
    crypto_coins: address[3] = self.crypto_coins
    swaps: address = AddressProvider(ADDRESS_PROVIDER).get_address(2)
    registry: address = AddressProvider(ADDRESS_PROVIDER).get_registry()

    # if initial coin is not in the crypto pool, get info for the first stableswap
    if _initial in crypto_coins:
        crypto_input = _initial
    else:
        received: uint256 = 0
        for coin in crypto_coins:
            market, received = RegistrySwap(swaps).get_best_rate(_initial, coin, amount)
            if market != ZERO_ADDRESS:
                indices[0], indices[1], indices[2] = Registry(registry).get_coin_indices(market, _initial, coin)
                route[0] = _initial
                route[1] = market
                crypto_input = coin
                amount = received
                break
        assert market != ZERO_ADDRESS

    # determine target coin when swapping in the crypto pool
    if _target in crypto_coins:
        crypto_output = _target
    else:
        for coin in crypto_coins:
            if Registry(registry).find_pool_for_coins(coin, _target) != ZERO_ADDRESS:
                crypto_output = coin
                break
        assert crypto_output != ZERO_ADDRESS

    route[2] = crypto_input
    route[3] = crypto_output

    # get i, j and dy for crypto swap if needed
    if crypto_input != crypto_output:
        for x in range(3):
            coin: address = self.crypto_coins[x]
            if coin == crypto_input:
                indices[3] = x
            elif coin == crypto_output:
                indices[4] = x
        amount = CurveCryptoSwap(self.swap).get_dy(indices[3], indices[4], amount)

    # if target coin is not in the crypto pool, get info for the final stableswap
    if crypto_output != _target:
        market, amount = RegistrySwap(swaps).get_best_rate(crypto_output, _target, amount)
        indices[5], indices[6], indices[7] = Registry(registry).get_coin_indices(market, crypto_output, _target)
        route[4] = market
        route[5] = _target

    return route, indices, amount


@view
@external
def can_route(_initial: address, _target: address) -> bool:
    """
    @notice Check if a route is available between two tokens.
    @param _initial Address of the initial token being swapped.
    @param _target Address of the token to be received in the swap.
    @return bool Is route available?
    """

    crypto_coins: address[3] = self.crypto_coins
    registry: address = AddressProvider(ADDRESS_PROVIDER).get_registry()

    crypto_input: address = _initial
    if _initial not in crypto_coins:
        market: address = ZERO_ADDRESS
        for coin in crypto_coins:
            market = Registry(registry).find_pool_for_coins(_initial, coin)
            if market != ZERO_ADDRESS:
                crypto_input = coin
                break
        if market == ZERO_ADDRESS:
            return False

    crypto_output: address = _target
    if _target not in crypto_coins:
        market: address = ZERO_ADDRESS
        for coin in crypto_coins:
            market = Registry(registry).find_pool_for_coins(coin, _target)
            if market != ZERO_ADDRESS:
                crypto_output = coin
                break
        if market == ZERO_ADDRESS:
            return False

    return True


@external
def commit_transfer_ownership(addr: address):
    """
    @notice Transfer ownership of GaugeController to `addr`
    @param addr Address to have ownership transferred to
    """
    assert msg.sender == self.owner  # dev: admin only

    self.future_owner = addr
    log CommitOwnership(addr)


@external
def accept_transfer_ownership():
    """
    @notice Accept a pending ownership transfer
    """
    _admin: address = self.future_owner
    assert msg.sender == _admin  # dev: future admin only

    self.owner = _admin
    log ApplyOwnership(_admin)


@view
@external
def isTrustedForwarder(_forwarder: address) -> bool:
    """
    @notice ERC-2771 meta-txs discovery mechanism
    @param _forwarder Address to compare against the set trusted forwarder
    @return bool True if `_forwarder` equals the set trusted forwarder
    """
    return _forwarder == self.trusted_forwarder


@external
def set_trusted_forwarder(_forwarder: address) -> bool:
    """
    @notice Set the trusted forwarder address
    @param _forwarder The address of the trusted forwarder
    @return bool True on successful execution
    """
    assert msg.sender == self.owner

    prev_forwarder: address = self.trusted_forwarder
    self.trusted_forwarder = _forwarder

    log TrustedForwardershipTransferred(prev_forwarder, _forwarder)
    return True
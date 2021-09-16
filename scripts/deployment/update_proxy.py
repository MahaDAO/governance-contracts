# Testnet deployment script

from brownie import (
    accounts,
    AdminUpgradeabilityProxy,
    Contract,
    VotingEscrow
)


CONFS = 1
ADMIN_ACC = accounts.load('1')
DEPLOYER_ACC = accounts.load('0')

print('Admin Account', ADMIN_ACC)
print('Deployer Account', DEPLOYER_ACC)

def repeat(f, *args, **kwargs):
    """
    Repeat when geth is not broadcasting (unaccounted error)
    """
    
    while True:
        try:
            return f(*args, **kwargs)
        except KeyError:
            continue


def main():
    ADMIN = accounts.at(ADMIN_ACC)
    DEPLOYER = accounts.at(DEPLOYER_ACC)

    current_proxy = Contract.from_abi(
        "AdminUpgradeabilityProxy", 
        '0x08abe0414b4adc5a73b02c5bebce8f8bd020d5eb',
        AdminUpgradeabilityProxy.abi
    )
    repeat(
        current_proxy.upgradeTo,
        '0xb44b4654792036ebEe6f1B851d7bB8964420f0Ad',
        {"from": ADMIN, "required_confs": CONFS},
    )

    # escrow_with_proxy2 = Contract.from_abi('VotingEscrow', proxy, VotingEscrow.abi)
    # repeat(
    #     escrow_with_proxy2.initialize,
    #     token,
    #     "Vote-escrowed MAHA",
    #     "MAHAX",
    #     "MAHAX_0.99",
    #     {"from": DEPLOYER, "required_confs": CONFS}
    # )   

    # ADMIN = accounts.at(ADMIN_ACC)
    # DEPLOYER = accounts.at(DEPLOYER_ACC)
    # proxy = "0xe4D077C36135Dd98b84FabD7Ac861Ef6bc849a76"
    # token = "0xA206D0373992DE9008F43eCD1802eB8492d0cAf9"
    # new_implementation_addr = "0x371e3a59bd88733eA163C619b40ad9342aF37d8a"

    # current_proxy = Contract.from_abi(
    #     "AdminUpgradeabilityProxy", 
    #     '0xe4D077C36135Dd98b84FabD7Ac861Ef6bc849a76',
    #     AdminUpgradeabilityProxy.abi
    # )

    # p = current_proxy.implementation({"from": ADMIN, "required_confs": CONFS})
    # print(p)
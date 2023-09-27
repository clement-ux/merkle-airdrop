-include .env

.EXPORT_ALL_VARIABLES:
MAKEFLAGS += --no-print-directory
ETHERSCAN_API_KEY=$(ETHERSCAN_KEY)

default:
	forge fmt && forge build

# Always keep Forge up to date
install:
	foundryup
	forge install

# Tests

test-f-%:
	@FOUNDRY_MATCH_TEST=$* make test

test-c-%:
	@FOUNDRY_MATCH_CONTRACT=$* make test

# Gas comparison
gas:
	forge t --mt test_GasComparison --gas-report

coverage:
	forge coverage --report lcov
	lcov --remove ./lcov.info -o ./lcov.info.pruned 'test/*'

.PHONY: test coverage
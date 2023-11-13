#!make
include .env

runScript:
	forge script script/DeployGuessTheNumber.s.sol -f $(LOCAL_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast

runTest:
	forge test -f $(LOCAL_RPC_URL)

runTestVerbose:
	forge test -f $(LOCAL_RPC_URL) -vvvvv

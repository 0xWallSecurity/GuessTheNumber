#!make
include .env

runScript:
	@forge script script/DeployGuessTheNumber.s.sol -f $(LOCAL_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast

runTest:
	@forge test -f $(LOCAL_RPC_URL) --sender 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266

runTestVerbose:
	@forge test -f $(LOCAL_RPC_URL) --sender 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 -vvvvv

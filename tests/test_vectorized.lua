require 'cephes'

local vectorizeTests = {}
local tester = torch.Tester()

local function eq(tensor1, tensor2, message)
   tester:assertTensorEq(tensor1, tensor2, 1e-300, message)
end

function vectorizeTests.testGamma()

    local x = torch.linspace(1, 6, 6)
    local result = cephes.gamma(x)

    tester:assert(result)
    tester:asserteq(torch.typename(result), "torch.DoubleTensor")
    eq(result, torch.DoubleTensor({1, 1, 2, 6, 24, 120}, "expected vectorized gamma"))
end

function vectorizeTests.testBeta()

    local n = 6
    local x = torch.linspace(1, 6, n)
    local y = torch.linspace(1, 6, n)

    tester:assertError(function() cephes.beta(x) end, "should error when given too few parameters")

    local result = cephes.beta(x, y)
    tester:assert(result, "call beta with both arguments tensors")
    tester:asserteq(torch.typename(result), "torch.DoubleTensor")
    tester:asserteq(result:size(1), n, "should get " .. n .. " results")

    result = cephes.beta(x, 1)
    tester:assert(result, "call beta with first argument a tensor")
    tester:asserteq(torch.typename(result), "torch.DoubleTensor")
    tester:asserteq(result:size(1), n, "should get " .. n .. " results")

    result = cephes.beta(1, y)
    tester:assert(result, "call beta with second argument a tensor")
    tester:asserteq(torch.typename(result), "torch.DoubleTensor")
    tester:asserteq(result:size(1), n, "should get " .. n .. " results")

    result = cephes.beta(1, 1)
    tester:assert(result, "call beta with both arguments numbers")
    tester:asserteq(type(result), "number")

    x = torch.linspace(-5, 5, n)
    tester:assertError(function() cephes.beta(x, 1) end, "vectorised call of beta should catch errors")

    -- Tests for calling with a preallocated result tensor
    x = torch.linspace(1, 6, n)
    y = torch.linspace(1, 6, n)
    result = torch.zeros(n)
    cephes.beta(result, x, y)
    tester:assert(result, "call beta with both arguments tensors, and output provided")
    tester:asserteq(torch.typename(result), "torch.DoubleTensor")
    tester:asserteq(result:size(1), n, "should get " .. n .. " results")

    cephes.beta(result, x, 1)
    tester:assert(result, "call beta with first argument a tensor")
    tester:asserteq(torch.typename(result), "torch.DoubleTensor")
    tester:asserteq(result:size(1), n, "should get " .. n .. " results")

    cephes.beta(result, 1, y)
    tester:assert(result, "call beta with second argument a tensor")
    tester:asserteq(torch.typename(result), "torch.DoubleTensor")
    tester:asserteq(result:size(1), n, "should get " .. n .. " results")

    tester:assertError(function() cephes.beta(result, 1, 1) end, "should error when trying to call function multiple times on constant arguments")
    result:resize(1)
    tester:assert(result, "call beta with both arguments numbers")
    tester:asserteq(torch.typename(result), "torch.DoubleTensor")
    tester:asserteq(result:size(1), 1, "should get single result")

    x = torch.linspace(-5, 5, n)
    tester:assertError(function() cephes.beta(result, x, 1) end, "vectorised call of beta should catch errors")

end

function vectorizeTests.testNdtr()

    local n = 60
    local x = torch.linspace(-10, 10, n)

    tester:assertError(function() cephes.ndtr() end, "should error when given too few parameters")

    local result = cephes.ndtr(x)

    tester:assert(result)
    tester:asserteq(torch.typename(result), "torch.DoubleTensor")
    tester:asserteq(result:size(1), n, "should get " .. n .. " results")

end

tester:add(vectorizeTests)
tester:run()
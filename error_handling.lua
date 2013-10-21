local ffi = require 'ffi'

-- List all functions, and wrap them automatically
local functions_list = {
    'acos',
    'acosh',
    'airy',
    'asin',
    'asinh',
    'atan',
    'atan2',
    'atanh',
    'bdtr',
    'bdtrc',
    'bdtri',
    'beta',
    'btdtr',
    'cabs',
    'cacos',
    'cacosh',
    'cadd',
    'casin',
    'casinh',
    'catan',
    'catanh',
    'cbrt',
    'ccos',
    'ccosh',
    'ccot',
    'cdiv',
    'ceil',
    'cexp',
    'chbevl',
    'chdtr',
    'chdtrc',
    'chdtri',
    'clog',
    'cmov',
    'cmul',
    'cneg',
    'cos',
    'cosdg',
    'cosh',
    'cosm1',
    'cot',
    'cotdg',
    'cpow',
    'csin',
    'csinh',
    'csqrt',
    'csub',
    'ctan',
    'ctanh',
    'dawsn',
    'drand',
    'ei',
    'ellie',
    'ellik',
    'ellpe',
    'ellpj',
    'ellpk',
    'erf',
    'erfc',
    'euclid',
    'exp',
    'exp10',
    'exp2',
    'expm1',
    'expn',
    'expx2',
    'fabs',
    'fac',
    'fdtr',
    'fdtrc',
    'fdtri',
    --'fftr', no FFTR for now, file missing on netlib
    'floor',
    'fresnl',
    'frexp',
    'gamma',
    'gdtr',
    'gdtrc',
    'hyp2f0',
    'hyp2f1',
    'hyperg',
    'hypot',
    'i0',
    'i0e',
    'i1',
    'i1e',
    'igam',
    'igamc',
    'igami',
    'incbet',
    'incbi',
    'isfinite',
    'isnan',
    'iv',
    'j0',
    'j1',
    'jn',
    'jv',
    'k0',
    'k0e',
    'k1',
    'k1e',
    'kn',
    'kolmogi',
    'kolmogorov',
    'lbeta',
    'ldexp',
    -- 'levnsn', file missing on netlib
    'lgam',
    -- 'lmdif', linalg skipped
    'log',
    'log10',
    'log1p',
    'log2',
    -- 'lrand', file missing on netlib
    -- 'lsqrt', file missing on netlib
    -- 'minv', linalg skipped
    -- 'mtransp', linalg skipped
    'nbdtr',
    'nbdtrc',
    'nbdtri',
    'ndtr',
    'ndtri',
    'onef2',
    'p1evl',
    'pdtr',
    'pdtrc',
    'pdtri',
    -- 'planck', is actually called plancki and planckd
    'poladd',
    'polatn',
    'polclr',
    'polcos',
    'poldiv',
    'poleva',
    'polevl',
    'polini',
    'polmov',
    'polmul',
    'polprt',
    'polsbt',
    'polsin',
    'polsqt',
    'polsub',
    'polrt',
    'polylog',
    'pow',
    'powi',
    'psi',
    'radian',
    'revers',
    'rgamma',
    'round',
    'shichi',
    'sici',
    'signbit',
    'simpsn',
    -- 'simq', linalg
    'sin',
    'sincos',
    'sindg',
    'sinh',
    'smirnov',
    'smirnovi',
    'spence',
    'sqrt',
    'stdtr',
    'stdtri',
    'struve',
    'tan',
    'tandg',
    'tanh',
    'threef0',
    'y0',
    'y1',
    'yn',
    'zeta',
    'zetac'
}

-- Link to torch_merr.c error reporting
ffi.cdef[[
    int merror;
    char errtxt[100];
]]

local function create_wrapper(name)

    local function wrapper(...)
        for index = 1,select("#", ...) do
            if select(index, ...) == nil then
                error("Bad cephes call - argument " .. index .. " is nil when calling function " .. name .. "!")
            end
        end
        -- Reset error status
        cephes.ffi.merror = 0
        local result = cephes.ffi[name](...)
        if cephes.ffi.merror ~= 0 then
            error("Cephes error '" .. ffi.string(cephes.ffi.errtxt) .. "'")
        end
        return result
    end
    return wrapper
end

-- To allow easy listing from lua, add one entry in the lua
-- table for each function
for k, v in pairs(functions_list) do
    rawset(cephes, v, create_wrapper(v))
end
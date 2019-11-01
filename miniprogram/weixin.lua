local json = require 'cjson.safe'

local ENDPOINT = ngx.var.service_endpoint_miniprogram_weixin

local URL = {
  auth = {
    code2session = '/sns/jscode2session',
    getPaidUnionId = '/wxa/getpaidunionid',
    getAccessToken = '/cgi-bin/token',
  },
  analysis = {
    getDailyRetain = '/datacube/getweanalysisappiddailyretaininfo',
    getMonthlyRetain = '/datacube/getweanalysisappidmonthlyretaininfo',
    getWeeklyRetain = '/datacube/getweanalysisappidweeklyretaininfo',
    getDailySummary = '/datacube/getweanalysisappiddailysummarytrend',
    getDailyVisitTrend = '/datacube/getweanalysisappiddailyvisittrend',
    getMonthlyVisitTrend = '/datacube/getweanalysisappidmonthlyvisittrend',
    getWeeklyVisitTrend = '/datacube/getweanalysisappidweeklyvisittrend',
    getUserPortrait = '/datacube/getweanalysisappiduserportrait',
    getVisitDistribution = '/datacube/getweanalysisappidvisitdistribution',
    getVisitPage = '/datacube/getweanalysisappidvisitpage',
  },
  customerServiceMessage = {
    getTempMedia = '/cgi-bin/media/get',
    send = '/cgi-bin/message/custom/send',
    setTyping = '/cgi-bin/message/custom/typing',
    uploadTempMedia = '/cgi-bin/media/upload',
  },
  templateMessage = {
    addTemplate = '/cgi-bin/wxopen/template/add',
    deleteTemplate = '/cgi-bin/wxopen/template/del',
    getTemplateLibraryById = '/cgi-bin/wxopen/template/library/get',
    getTemplateLibraryList = '/cgi-bin/wxopen/template/library/list',
    getTemplateList = '/cgi-bin/wxopen/template/list',
    send = '/cgi-bin/message/wxopen/template/send',
  },
  uniformMessage = {
    send = '/cgi-bin/message/wxopen/template/uniform_send',
  },
  updatableMessage = {
    createActivityId = '/cgi-bin/message/wxopen/activityid/create',
    setUpdatableMsg = '/cgi-bin/message/wxopen/updatablemsg/send',
  },
  pluginManager = {
    applyPlugin = '/wxa/plugin',
    getPluginDevApplyList = '/wxa/devplugin',
    getPluginList = '/wxa/plugin',
    setDevPluginApplyStatus = '/wxa/devplugin',
    unbindPlugin = '/wxa/plugin',
  },
  nearbyPoi = {
    add = '/wxa/addnearbypoi',
    delete = '/wxa/delnearbypoi',
    getList = '/wxa/getnearbypoilist',
    setShowStatus = '/wxa/setnearbypoishowstatus',
  },
  wxacode = {
    createQRCode = '/cgi-bin/wxaapp/createwxaqrcode',
    get = '/wxa/getwxacode',
    getUnlimited = '/wxa/getwxacodeunlimit',
  },
  security = {
    imgSecCheck = '/wxa/img_sec_check',
    mediaCheckAsync = '/wxa/media_check_async',
    msgSecCheck = '/wxa/msg_sec_check',
  },
  img = {
    aiCrop = '/cv/img/aicrop',
    scanQRCode = '/cv/img/qrcode',
    superresolution = '/cv/img/superresolution',
  },
  immediateDelivery = {
    abnormalConfirm = '/cgi-bin/express/local/business/order/confirm_return',
    addOrder = '/cgi-bin/express/local/business/order/add',
    addTip = '/cgi-bin/express/local/business/order/addtips',
    cancelOrder = '/cgi-bin/express/local/business/order/cancel',
    getAllImmeDelivery = '/cgi-bin/express/local/business/delivery/getall',
    getBindAccount = '/cgi-bin/express/local/business/shop/get',
    getOrder = '/cgi-bin/express/local/business/order/get',
    mockUpdateOrder = '/cgi-bin/express/local/business/test_update_order',
    -- onOrderStatus
    preAddOrder = '/cgi-bin/express/local/business/order/pre_add',
    preCancelOrder = '/cgi-bin/express/local/business/order/precancel',
    reOrder = '/cgi-bin/express/local/business/order/readd',
    -- onAgentPosQuery
    -- onAuthInfoGet
    -- onCancelAuth
    -- onOrderAdd
    -- onOrderAddTips
    -- onOrderCancel
    -- onOrderConfirmReturn
    -- onOrderPreAdd
    -- onOrderPreCancel
    -- onOrderQuery
    -- onOrderReAdd
    -- onPreAuthCodeGet
    -- onRiderScoreSet
    updateOrder = '/cgi-bin/express/local/delivery/update_order',
  },
  logistics = {
    addOrder = '/cgi-bin/express/business/order/add',
    cancelOrder = '/cgi-bin/express/business/order/cancel',
    getAllDelivery = '/cgi-bin/express/business/delivery/getall',
    getOrder = '/cgi-bin/express/business/order/get',
    getPath = '/cgi-bin/express/business/path/get',
    getPrinter = '/cgi-bin/express/business/printer/getall',
    getQuota = '/cgi-bin/express/business/quota/get',
    -- onPathUpdate
    testUpdateOrder = '/cgi-bin/express/business/test_update_order',
    updatePrinter = '/cgi-bin/express/business/printer/update',
    getContact = '/cgi-bin/express/delivery/contact/get',
    -- onAddOrder
    -- onCancelOrder
    -- onCheckBusiness
    -- onGetQuota
    previewTemplate = '/cgi-bin/express/delivery/template/preview',
    updateBusiness = '/cgi-bin/express/delivery/service/business/update',
    updatePath = '/cgi-bin/express/delivery/path/update',
  },
  ocr = {
    bankcard = 'cv/ocr/bankcard',
    businessLicense = 'cv/ocr/bizlicense',
    driverLicense = 'cv/ocr/drivinglicense',
    idcard = 'cv/ocr/idcard',
    printedText = 'cv/ocr/comm',
    vehicleLicense = 'cv/ocr/driving'
  },
  operation = {
    realtimelogSearch = 'wxaapi/userlog/userlog_search',
  },
  soter = {
    verifySignature = 'cgi-bin/soter/verify_signature',
  },
  subscribeMessage = {
    send = 'cgi-bin/message/subscribe/send',
  },
}

local MiniprogramWeixin = {}
MiniprogramWeixin.__index = MiniprogramWeixin

setmetatable(MiniprogramWeixin, {
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:__constructor__(...)
    return self
  end
})

function MiniprogramWeixin:__constructor__(app_id, app_secert, access_token)
  self.endpoint = ENDPOINT
  self.app_id = app_id
  self.app_secert = app_secert
  self.access_token = access_token
end

function MiniprogramWeixin:code2session(code)
  local url = self.endpoint .. URL.auth.code2session
  local args = {
    appid = self.appid,
    secret = self.appsecret,
    js_code = code,
    grant_type = 'authorization_code'
  }
  local res = ngx.location.capture(url, { args = args })
  local data = json.decode(res.body)
  local err = data.errcode

  if err then
    return nil, {
      code = err,
      message = data.errmsg
    }
  else
    return {
      openid = data.openid,
      session_key = data.session_key,
      unionid = data.unionid
    }, nil
  end
end

function MiniprogramWeixin:get_access_token()
  local url = self.endpoint .. URL.auth.access_token
  local res = ngx.location.capture(url, {
    appid = self.appid,
    secret = self.appsecret,
    grant_type = 'client_credential'
  })

  local data = json.decode(res.body)

  if 0 ~= data.errcode then
    return nil, {
      code = data.errcode,
      message = data.errmsg
    }
  else
    local ret = {
      access_token = data.access_token,
      expires_in = data.expires_in
    }
    return ret, nil
  end
end

local createMiniprogramWeixin = MiniprogramWeixin
return createMiniprogramWeixin
function responseWrapper(success, message, status, data, error) {
  return {
    success,
    message,
    status: status ?? 500,
    data: data ?? null,
    error: error ?? null,
  };
}

module.exports = { responseWrapper };

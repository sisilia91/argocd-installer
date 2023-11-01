function (
  certDuration="7h122m66s"
)

local parseDuration(duration) = {
  local getUnitValue(c) = 
    local parts = std.split(duration, c);
    local lastPart = parts[0];
    if std.length(parts) > 1
    then std.parseInt(lastPart)
    else 0,
    
  hours: getUnitValue("h"),
  minutes: getUnitValue("m"),
  seconds: getUnitValue("s"),

  totalSeconds: function() $.hours * 3600 + $.minutes * 60 + $.seconds,
  
  finalHours: self.totalSeconds() / 3600,
  finalMinutes: (self.totalSeconds() % 3600) / 60,
  finalSeconds: self.totalSeconds() % 60,

  formattedDuration: std.sprintf("%dh%dm%ds", [$.finalHours, $.finalMinutes, $.finalSeconds]),
};

[
  {
    "apiVersion": "cert-manager.io/v1",
    "kind": "Certificate",
    "metadata": {
      "name": "admin-cert",
      "namespace": "shkim"
    },
    "spec": {
      "secretName": "admin-secret",
      "commonName": "admin",
      "duration": parseDuration(certDuration),
      "privateKey": {
        "algorithm": "RSA",
        "encoding": "PKCS8",
        "size": 2048
      },
      "usages": [
        "digital signature",
        "key encipherment",
        "server auth",
        "client auth"
      ],
      "issuerRef": {
        "kind": "ClusterIssuer",
        "group": "cert-manager.io",
        "name": "tmaxcloud-issuer"
      }
    }
  }
]
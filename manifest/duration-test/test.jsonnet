function (
  certDuration="7h122m66s"
)

local parseDuration(duration) = {
    local unitValues = {
        h: 3600,
        m: 60,
        s: 1
    },

    parsed: {
        local extractValue(c) = {
            local pos = std.find(c, duration);
            if pos == null then 0
            else std.parseInt(std.substr(duration, 0, pos))
        },
        h: extractValue("h"),
        m: extractValue("m"),
        s: extractValue("s"),
    },

    totalSeconds: self.parsed.h * unitValues.h + self.parsed.m * unitValues.m + self.parsed.s * unitValues.s,
  
    finalHours: self.totalSeconds / unitValues.h,
    finalMinutes: (self.totalSeconds % unitValues.h) / unitValues.m,
    finalSeconds: self.totalSeconds % unitValues.s,

    formattedDuration: std.sprintf("%dh%dm%ds", [self.finalHours, self.finalMinutes, self.finalSeconds]),
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
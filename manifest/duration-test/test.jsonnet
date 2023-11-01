function (
  certDuration="7h122m66s"
)

local parseDuration(duration) = {
  local splitByChar(c) = [std.parseInt(s) for s in std.split(duration, c) if s != "" && std.length(s) > 0],
  
  hours: if std.setMember("h", std.stringChars(duration)) then splitByChar("h")[0] else 0,
  minutes: if std.setMember("m", std.stringChars(duration)) then splitByChar("m")[0] else 0,
  seconds: if std.setMember("s", std.stringChars(duration)) then splitByChar("s")[0] else 0,
  
  totalSeconds: function() $.hours * 3600 + $.minutes * 60 + $.seconds,
  
  finalHours: std.div(self.totalSeconds(), 3600),
  finalMinutes: std.div(self.totalSeconds() % 3600, 60),
  finalSeconds: self.totalSeconds() % 60,
  
  formattedDuration: std.strReplace(std.strReplace("%dh%dm%ds", "%d", std.toString($.finalHours)), "%d", std.toString($.finalMinutes)),
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
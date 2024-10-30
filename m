Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA2FD528
	for <linux-unionfs@vger.kernel.org>; Wed, 30 Oct 2024 00:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730248152; cv=none; b=ULltcyMthZ8jLn2sgwqa0b/NQL1Ez4YHUYYD3a8A5LhNzop+6WTooxcSQ1e2WMi9Co8F9FAC1NUiXNCo2wdcmr9QSm18qY+/16sOZ6dx1R3yVu9YHqOZgpTrOCNiU/QVYHabGza49m8UcaP74E03/+72Vaq5h0yObVPnRRfAT1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730248152; c=relaxed/simple;
	bh=V1iNnvuBm2oNPGSNfSGCVmkg1t1E6dTFsv0w9mlYepo=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=TnvpKdiuY/TPE/sqpaVdcR+47Zoh6ZqRppPWU/o4khAM4icHR4GROjuyaw3MvhkC6xhqi/HR/0haqzFtrWTmKNzoNQocNQeIqz5M5iUqQ+C3wKgCFL1CqEXpK0E+PYDZMuSH+s+J5s30sTbIJ5BF356n99GLjgZZOD7h+RDNbzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ovt.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zA7zIitO; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ovt.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zA7zIitO"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-71e51a31988so8484063b3a.1
        for <linux-unionfs@vger.kernel.org>; Tue, 29 Oct 2024 17:29:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730248149; x=1730852949; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=/Ye+vbAHY2hoAlG8bCiiPKeIhcJVGNMWcPfmJps0LRM=;
        b=zA7zIitO1JDLLMVh2tDpB/Ydm3JznmxluumgnAAQ6WMBUCseUBjDcmx2aSepa5iFMB
         HSjvnGMHXxhkte8W0S3t+8vKStng2pG471DZjrS96ZBqOheyTx3r1Rmlzy9ULwDLiLcP
         rQvGSbSa0ducNsfRQKEmE2TUXcWn2qhJz7Ijr2C7b+d83a8G8RMpNg3ah9kWp+Pcz5qW
         cdo8gELtUl4Wk3KtB+s4mN8epfcU9wH1nPTQAiNSEEIrd8Wuj/mqguz1iTb45CPQLW+P
         C7lfbQplOCBz2b19DtKVbwP4Av747A7OhYbFmQ3/RSxmDiI4l60Nw1afKIOU39hv1QIg
         evBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730248149; x=1730852949;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/Ye+vbAHY2hoAlG8bCiiPKeIhcJVGNMWcPfmJps0LRM=;
        b=NgR5fn5sekiyvJfnpGTdSfKtUJXnG/cUw+xsZFRR7+h3aIOxjTlxjdLFklmJ9+3DcW
         w6nu8dFUFHgpUOXdMZY974UaKdUCZQ78Y6O/X5ZS+5nk8ZaW48omGYU1voNXWSy48YlP
         uodFsJ4OeFmr6EBLjL2Rgqq2yojWYAleJ5+BSYzrjo8rkd9lseX9/b/aKXRUOrRM3bbC
         12jucdrYoOxfPdc6tI38yRc4QruHc2G9RFoJLdgxId0SLcKihsH3Ko44AkXDTJci0sfK
         23xUr8PPnLL6XePd2sZZZcZZtq7bLOUgpkfzpAk3t1aEZnA/DWvqq5tKWJ9vGkQUbK9e
         XtvQ==
X-Forwarded-Encrypted: i=1; AJvYcCW/vMMwewuJERUhUOYZoEqagYRNf4HCCPohB7lsLjnAgYqsUYcV3H1DxpnYmBu2Q7b1n3VhFi1lfDHZ+Kfl@vger.kernel.org
X-Gm-Message-State: AOJu0YwIGUb4ClBAOPj+oSJew6kLKnbsECopD2+gvzVN7xkW2qZTsC/0
	wL9Veo2qLHiSk6Pn4Cg5mp7jsbCvyFc3YUpkNCzMHkiHgDPUw8NsD2+Fmz/OhWKzsg==
X-Google-Smtp-Source: AGHT+IFmIqfjPUXzygglv0CS5v98bbZvDbHPlRnqqpROK5kUQdzIOV0DEK16WsMTN1yt3vYZ1XyvGZ0=
X-Received: from hmarynka.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1148])
 (user=ovt job=sendgmr) by 2002:a05:6a00:3c50:b0:71e:5d1d:350a with SMTP id
 d2e1a72fcca58-72063089caamr24309b3a.3.1730248149442; Tue, 29 Oct 2024
 17:29:09 -0700 (PDT)
Date: Wed, 30 Oct 2024 00:28:55 +0000
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.0.163.g1226f6d8fa-goog
Message-ID: <20241030002856.2103752-1-ovt@google.com>
Subject: [PATCH] ovl: properly handle large files in ovl_security_fileattr
From: Oleksandr Tymoshenko <ovt@google.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>
Cc: ovt@google.com, stable@vger.kernel.org, 
	Miklos Szeredi <mszeredi@redhat.com>, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

dentry_open in ovl_security_fileattr fails for any file
larger than 2GB if open method of the underlying filesystem
calls generic_file_open (e.g. fusefs).

The issue can be reproduce using the following script:
(passthrough_ll is an example app from libfuse).

  $ D=/opt/test/mnt
  $ mkdir -p ${D}/{source,base,top/uppr,top/work,ovlfs}
  $ dd if=/dev/zero of=${D}/source/zero.bin bs=1G count=2
  $ passthrough_ll -o source=${D}/source ${D}/base
  $ mount -t overlay overlay \
      -olowerdir=${D}/base,upperdir=${D}/top/uppr,workdir=${D}/top/work \
      ${D}/ovlfs
  $ chmod 0777 ${D}/mnt/ovlfs/zero.bin

Running this script results in "Value too large for defined data type"
error message from chmod.

Signed-off-by: Oleksandr Tymoshenko <ovt@google.com>
Fixes: 72db82115d2b ("ovl: copy up sync/noatime fileattr flags")
Cc: stable@vger.kernel.org # v5.15+
---
 fs/overlayfs/inode.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 35fd3e3e1778..baa54c718bd7 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -616,8 +616,13 @@ static int ovl_security_fileattr(const struct path *realpath, struct fileattr *f
 	struct file *file;
 	unsigned int cmd;
 	int err;
+	unsigned int flags;
+
+	flags = O_RDONLY;
+	if (force_o_largefile())
+		flags |= O_LARGEFILE;
 
-	file = dentry_open(realpath, O_RDONLY, current_cred());
+	file = dentry_open(realpath, flags, current_cred());
 	if (IS_ERR(file))
 		return PTR_ERR(file);
 
-- 
2.47.0.163.g1226f6d8fa-goog


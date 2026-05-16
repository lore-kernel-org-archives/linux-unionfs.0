Received: from mail-yx1-f42.google.com (mail-yx1-f42.google.com [74.125.224.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 702FA2472A6
	for <linux-unionfs@vger.kernel.org>; Sat, 16 May 2026 00:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778892791; cv=none; b=ULPLK6KdDguzce9ChzbJlmQScRP5ZFzV1DXbD9Jdl1ugxna1B/HBjKpNLCebtXpDzdvqL3pItWHHpIQgl7HxsZjw/Z3tFsi36FG2yYCYd41f+XTn94Qa9uNHZoxpi4Zkr568ou5dd4vWrEYcIbTVZAvV4SMftjvjt0p2bxRZgCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778892791; c=relaxed/simple;
	bh=v4kHp46RDds4Pwy08vQ6uAhl3z5BXW9+T3EUqO4LtmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eoF2clKJ8Mf3c18DWcjDxvzdeqZMcx6q1+32DNU4SBSX3mtGLiHW6Ycb+q0HsAB+8q4r/ooa26Xq1YS7tD2lO/B9yowe1ZWSIXm4E+r2RcWVZSbYaNF/pfWcamr5r64KhFs9hcDvqDvuCLpf3pg5f3o/th33XKIPdmoIf7aizZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e8+XS3bE; arc=none smtp.client-ip=74.125.224.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e8+XS3bE"
Received: by mail-yx1-f42.google.com with SMTP id 956f58d0204a3-65c37eafcbeso960989d50.1
        for <linux-unionfs@vger.kernel.org>; Fri, 15 May 2026 17:53:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778892789; x=1779497589; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kCYGzb/StXRov6Qro1W4XUDs/B78DGquYl4iezQXXCo=;
        b=e8+XS3bEeUlzK7oAAmpeAxuzHUg7q8g9EJclOseAOWbZl9Yob/cpD4OUS6qq92ICJY
         4C2mXRxk54wYSSyFGGmP+3qfVTpeFbX9b5NFERd2eWwXvu59+EzDYNsSKWrRqL3kW4Gh
         6gmjINbsP4C8z8OHn4HHu7p8jnr59lUQ73a2zhZ5SHgOw13u3cubJM1GU5fAKTjrw7g9
         KkuxeeHv4kMsY6iMCZmmLHomL6y4mMpDYya+yMuVoraOiMXC4VnZDSH8WdRVo+vLXHky
         8dGftltJvDagWvjGy1scGW0jQ66UgdMbINBPnFfIQK8UTwR3jQwDhg/JodooIY07VMZb
         VRSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778892789; x=1779497589;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kCYGzb/StXRov6Qro1W4XUDs/B78DGquYl4iezQXXCo=;
        b=dWGkqQzgWU1cFr9clzCvQENSpAHTSkzvQXCBXx6OCBD2RzimgvuGJyaNoYc6DpwcM6
         iv+Hoxi7tHhi/Mi8PaKuAlm+3etm35GQuK8+H1Hniey55HUkA8DIOF+63vaeKcyI5tOS
         cXZ1YW6OvglTEO4D6tIsC9r12wxYB9Qh7FZu0edPL6S+2DhsBX46OJlo/icrGDo+d7/x
         8eLmuRBAVpi5DEKcy4eEuWppOsvAQ9SElcOHBBmQNrF6Caunx9AaEBe7+AVnuA4mFUNR
         F76Cf0mgHZ5NUT7D7NNaQWKsYJvZEEVWMg0RsupKTa1Z8jq2n1S4J1K0S7s5khDTBKX9
         9tTQ==
X-Forwarded-Encrypted: i=1; AFNElJ+IdU8xeJIQxD61G0yy3wJAYPHA8Ye9BrSgVB0acTCaZua+sjUsB4go0c636LkAdt76St1KFQKqeaCNP9e2@vger.kernel.org
X-Gm-Message-State: AOJu0YwcNcxE16tBJkpUFcyZIegrc+cHgTyWAGj8tD4yXqnFH5jr271g
	sHazb14H7HGjl1yTONtXvh2eFxUwCobQrwDahgPtIJ3Z5JThZF/G4xB3cd9qfrS8
X-Gm-Gg: Acq92OHU5n62UEPdOf6+VmrOhiI/gyNGuROOO1CCtF9/lR1TlDyIiemo2I3HC6efmpd
	MfSdgYD4zh514MUMDYH7Eqgiq2vXCF5L1ntDWSTW+wvcmijEacnxK/wn9c6qUn6seBtDdfanGUq
	ZK5i+GzXZjiER9unQFVw5mCaRZ7cSlNnZV19vdOuiGOwJH67Vaowrxm+2+An2GcF8EnjsDrnNXO
	PYw7GLw94fjvmreF1M6uXKeOKVnteGI2ja6LOq/pWsi6vDBjkeGrR/lJ1/vXMv+9u9gzEyZQW5R
	OrhipbVC+Yw0hTZ+SQa8x4NhQ1vvw0MkkvJk+XwjVXxwIqI2H4jS47V9iMOUUA0xgwL6cDdo6zv
	YqPRudUyqAIxYcL9BTnwzNC5jB9aBrb9Rw08HkqipTo3HMvy9byfOZX7j4Pwif8inGpdSNrgUxw
	qx3IPD30IsA5FqwZlo9w==
X-Received: by 2002:a05:690e:d4c:b0:64e:d622:9d1a with SMTP id 956f58d0204a3-65e22663ef0mr6372004d50.4.1778892789538;
        Fri, 15 May 2026 17:53:09 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:71::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-65e0db0a25esm3255480d50.10.2026.05.15.17.53.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 17:53:09 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: amir73il@gmail.com,
	miklos@szeredi.hu
Cc: fuse-devel@lists.linux.dev,
	linux-unionfs@vger.kernel.org
Subject: [PATCH v2 20/21] fuse: use passthrough getattr in setattr suid/sgid handling
Date: Fri, 15 May 2026 17:40:03 -0700
Message-ID: <20260516004004.1455526-21-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260516004004.1455526-1-joannelkoong@gmail.com>
References: <20260516004004.1455526-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When refreshing i_mode for suid/sgid kill during setattr, use
passthrough getattr if the inode has that enabled.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/fuse/dir.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index b67b3b334e69..fd1b3fd86968 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -2524,7 +2524,11 @@ static int fuse_setattr(struct mnt_idmap *idmap, struct dentry *entry,
 			 * ia_mode calculation may have used stale i_mode.
 			 * Refresh and recalculate.
 			 */
-			ret = fuse_do_getattr(idmap, inode, NULL, file);
+			if (fuse_passthrough_op(inode, FUSE_GETATTR))
+				ret = fuse_passthrough_getattr(inode, NULL,
+							       STATX_MODE, 0);
+			else
+				ret = fuse_do_getattr(idmap, inode, NULL, file);
 			if (ret)
 				return ret;
 
-- 
2.52.0


Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2515386553
	for <linux-unionfs@vger.kernel.org>; Thu, 14 May 2026 20:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778788894; cv=none; b=ipPhDRgCwEWDIJcub4aZVFRStpcVM3rklNbYPR7E/f9MllWtWivSEFq0Hqjey7AGUlkRiJhgLIHWF+4VefIsSdHQnDh/3H5p7MbNS5vhBMsJ5y/8kvCScDzvDB7RINnfn3JcbJDR2K6hhIglHD+KMrnbvyJB/UVOjo4a63ULW1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778788894; c=relaxed/simple;
	bh=q35S6vEe5sWJz/fAXDoBVUlt1Ci/tEZ0lM2Dxtytn50=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NFHCHT5B/7rGZFGA3v5uEJeWvnZ5/o7dZu3z1/8Nf/BSK2voXHTs30Hkd8vAcXSWHNJoFxHzV10W3PyOrF+pKS7IPxgFtzePSGQrezZfj2u3TBfMXc97DnUaLELlg19hXpmHAWRP4AAKM/YFptrs+6Vhzjg1BDxgEQJXyW+ETqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XABzChaA; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XABzChaA"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-678a16429c6so326470a12.1
        for <linux-unionfs@vger.kernel.org>; Thu, 14 May 2026 13:01:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778788891; x=1779393691; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vFdFq/KHYk+bjr1R3r96jxPdwyapsi1K5J19t+PAZZo=;
        b=XABzChaAQVpSLFyso2w+W8cXPAL5yoOyF1tvB1yOUMn6WH69xLzAD/bNg22scQ0qDJ
         /hhK1A2igjRnQGc/94A1rmg5iGdflwHYAxlwhwbIBBU1ekuhB7cZIIyTWpRyRGKISZru
         7gieUcrZu802EqhzSKzJvwKewP/jQBGR+PNKkGMfSk/8Lx673w9sKiAH+yy8jCJyjtqI
         RHpKh5/w4oiGQQsvt2EhGXBQ4s/MJjwn4asVGBAv6nIammN4IT3//vVZuFfj1odojTDG
         /r2qsRL0VfYUePWND0PdRsN3+dEiuYnV30vf7yFajrS8wJlIYqL9g6G2cr4DeqH8I9ZB
         zWeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778788891; x=1779393691;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vFdFq/KHYk+bjr1R3r96jxPdwyapsi1K5J19t+PAZZo=;
        b=gaJzKMF0xpcaSzSa1pL1jz0+jEcIzen92xJQWCfgIGGanuO/UFgHl0Vm1l0pO5KB2g
         VMvsSs4o9wIV4dnE9R5gR4e/xD9LCgATnYDHp4Ly+7pFUg7P3TPc8dKSTaqUcUqSm7Mm
         FgfteLQUXgys20hMsgkPJPkHe/6MFAgKhC/1/grojlrxnpeW/35dMnfx2WUp9SIDfM3V
         3OpIqn2ezrnJwbCRMsIkTsdESIMQOkq7f2Ll+dXO4KYiSVGJdqHWNXyFfeEb2bRtB6fc
         KgJgklYV/yqUrdZfzr1wEQkA4SXzSgzwEBxf+Op4BkXJn45GLWskcKiJehAZRzxOplIX
         2O3A==
X-Forwarded-Encrypted: i=1; AFNElJ9NsetCSWEdDIHKDrY9kj++Q0HBMWWLxr1/HHxagaNs2jufuu+MLtbPQkT/aewmDoIX349vPbWg7EiSJSIP@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9rdXzf7MboZIIhyynUXFdg/VBFrQheBsLbo7ajP9rYf9VKqVp
	0j/tE3KtVkplf5zEYTW9fHJAeOXQrEdNKT4lFZkd9vyQ5iJ58ApxH/YpRbgwMGly
X-Gm-Gg: Acq92OGpHlNuETAPkqMW7p/auzGpsmesWAnBfgIQHBIzdEbiZrvd7Q5vHF21jwH8mML
	qY3Z1T4DX4eYQupd2twiH6Tx4l69uQFyON4g+Gc4/rHJf8zPTbv6BmfRJSkPSvoih+oJBnm7fGY
	36y1dEirjU68hoTnJZawyx8uOYVm3SugIGtp+NPhMpw4dC7a1h0dnhqmoVCgmmsGyKriH7Rn1kf
	MYtK+vv14Eumw794sj+MAqGujGvSvPPBkYI8CSIX9KAoztaanQuzmQhcXjioDGh98P28rQ5Ycj4
	WK2hbJL5KalYn6YWQjRbgEbIsLiI8z//2eH0Dx7f3qTJDbSl4404t6NMmqhdNEoPHxi8wxiVCv9
	CxEKq19exNhsvUedHxLlWwGkxDb3QFv942Hcru5yR4ZICaHj1No8pu1s4xfIJ5olVwyM8N9qDDj
	W18/dkUbcQsy0IgynM6QdG4P8OxI7TIz5cicz/ZL44u8cVWRssnDhnUmIO9vSXrsFyTeWLRupwu
	DfYnp7qZismYRxsATXmsMODZsJU
X-Received: by 2002:a05:6402:223c:b0:67d:bc9c:4e93 with SMTP id 4fb4d7f45d1cf-6830acd8addmr1994919a12.7.1778788890981;
        Thu, 14 May 2026 13:01:30 -0700 (PDT)
Received: from localhost (2001-1c00-570d-ee00-9059-891b-e3e6-76e2.cable.dynamic.v6.ziggo.nl. [2001:1c00:570d:ee00:9059:891b:e3e6:76e2])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-68311660f49sm1060139a12.15.2026.05.14.13.01.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 13:01:30 -0700 (PDT)
From: Amir Goldstein <amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Nirmoy Das <nirmoyd@nvidia.com>,
	linux-unionfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] err_ptr.h: introduce ERR_PTR_SAFE()
Date: Thu, 14 May 2026 22:01:29 +0200
Message-ID: <20260514200129.94862-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Code using ERR_PTR() is almost certainly intending to produce a value
which qualified as IS_ERR_OR_NULL(), but this is not the case when
code calls ERR_PTR(err) with positive or large negative err.

Introduce a fortified variant of ERR_PTR() whose return value is
guaranteed to qualify as IS_ERR_OR_NULL().

We add this in a new header file err_ptr.h which includes bug.h
for the build/run time assertions.

Subsystems may opt-in for fortified ERR_PTR() for specific call sites
or by #define ERR_PTR(err) ERR_PTR_SAFE(err).

Link: https://lore.kernel.org/r/CAOQ4uxg=gONUh5QEW5KJcyXLDF15HbLnc9Ea7RKPcgtyfPasTA@mail.gmail.com/
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Guys,

Please follow the Link to see the sneaky bug that Nirmoy tracked down.
syzbot has complained about this a while ago, but neither me nor my AI
helpers were able to track it down from code analysis.

Honestly, with AI review, this class of bugs (return a stale err value)
should not be happening anymore, but it annoyed me that ERR_PTR() can
return a value which is not an IS_ERR(). It messes with code flow
analysis.

What do you think about this macro?

I intend to #define ERR_PTR(err) ERR_PTR_SAFE(err) in overlayfs.h
to fortify all of the ERR_PTR() in overlayfs code.

What do you think about this opt-in method?
Any reason to make this more widespread by default?

Thanks,
Amir.


 include/linux/err_ptr.h | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)
 create mode 100644 include/linux/err_ptr.h

diff --git a/include/linux/err_ptr.h b/include/linux/err_ptr.h
new file mode 100644
index 0000000000000..829ec5f771528
--- /dev/null
+++ b/include/linux/err_ptr.h
@@ -0,0 +1,29 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_ERR_PTR_H
+#define _LINUX_ERR_PTR_H
+
+#include <linux/err.h>
+#include <linux/bug.h>
+
+/**
+ * ERR_PTR_SAFE - Create an error pointer, with validation.
+ * @error: An error code to encode as an error pointer.
+ *
+ * Like ERR_PTR(), but validates @error:
+ * - For constant @error: fails the build if the value is not a valid errno
+ *   (zero is allowed, producing NULL).
+ * - For variable @error: warns and clamps to -MAX_ERRNO if out of range.
+ *
+ * Subsystems may opt in for all ERR_PTR() call sites by adding after includes:
+ *   #undef ERR_PTR
+ *   #define ERR_PTR(err) ERR_PTR_SAFE(err)
+ */
+#define ERR_PTR_SAFE(error) ({						\
+	long __e = (error);						\
+	if (__builtin_constant_p(__e))					\
+		BUILD_BUG_ON(__e && !IS_ERR_VALUE(__e));		\
+	__builtin_constant_p(__e) ? (void *)__e :			\
+		(void *)(WARN_ON(__e && !IS_ERR_VALUE(__e)) ? -MAX_ERRNO : __e);\
+})
+
+#endif /* _LINUX_ERR_PTR_H */
-- 
2.54.0


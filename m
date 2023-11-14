Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3A7DC4167B
	for <linux-unionfs@archiver.kernel.org>; Tue, 14 Nov 2023 15:33:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232277AbjKNPdJ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 14 Nov 2023 10:33:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233660AbjKNPdI (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 14 Nov 2023 10:33:08 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0210693
        for <linux-unionfs@vger.kernel.org>; Tue, 14 Nov 2023 07:33:04 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id 5b1f17b1804b1-4084e49a5e5so49760965e9.3
        for <linux-unionfs@vger.kernel.org>; Tue, 14 Nov 2023 07:33:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699975982; x=1700580782; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+DJ80duKXbFNKp+jJOZcJpxIS0hpPvz6Pb+tJw0y7TM=;
        b=BxKdza26sK7Wrl/bU8BJwdQV3V+OIXRwY5Jc6wr3SWXCtZsOUsQS2nkqdrDMoN6SMv
         N162v5e7E15aIyDuFgJQT016LM1oTKl5aJ0JmgaPNMP5TTsL0tb4gj2tA3QBNEAEoYls
         cPplxYvTJftI2Ficucx3+9ryxhzINg0ARivlhntTCWWPe1BjiCzjeGXkB7YkGZ3YUX78
         tGbrKxOuGVslx16yIV2eqtZSJwAomZYbewnJTE4PUlPYnQAUdNye8/rV6ehryjV9OXLf
         o5jcVu40q3bWbXyu+E0a1SzvgHJHhWLx0brBLZ5/8tlvWYtqVB4HCHd87UUs8CgtCwT5
         qWXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699975982; x=1700580782;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+DJ80duKXbFNKp+jJOZcJpxIS0hpPvz6Pb+tJw0y7TM=;
        b=nbT4VZ/6FqlAZNqi9r930OdNxmUqCFALh+X+2rSGOHQ7JOfjNH9ytexcCSv0w4yA/K
         qecKMrtbnOi7CVjXaYhVLyrArvvwcljLLiv5fDS0H8gSIkQIm/5J9VzmRMCiXoN73uIE
         ohXEmFg8TowuVDEqIfoR2C60uxwThoxA+4HusJAn8faAiAJNbhrGOwmKJesHFFaA73am
         yEkMV8V+bdd69mZzSa35xjYjZuE1C+Muxl6/gkbFQyGjF4gKvDsB4kIYa7JCRzIsO5oE
         bMM1XGpCFh9bpyx1smti2qX+dV+9swCEIz1jtNiHRjEZiD26JXkM1+zzADMbFcl0jKWM
         8fNw==
X-Gm-Message-State: AOJu0YyFII6hGHL817dE0cZVaBW/dwIQN+8Z2lP+S/5HpVLL7KVO/yKM
        PzIDicVlazYW1zgf5HPpuZjPbzFc+dk=
X-Google-Smtp-Source: AGHT+IFH4sq3ZOU31jyHzy2ifiqBhtE4CR3mCVm1lkPn/p7RB0c2CuLpFDXN7cegtSc3kuT/BzMP2w==
X-Received: by 2002:a05:600c:3b9b:b0:405:367d:4656 with SMTP id n27-20020a05600c3b9b00b00405367d4656mr8637713wms.29.1699975982077;
        Tue, 14 Nov 2023 07:33:02 -0800 (PST)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id i10-20020a05600c354a00b004053e9276easm17824505wmq.32.2023.11.14.07.33.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Nov 2023 07:33:01 -0800 (PST)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org
Subject: [PATCH 02/15] splice: remove permission hook from do_splice_direct()
Date:   Tue, 14 Nov 2023 17:32:41 +0200
Message-Id: <20231114153254.1715969-3-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231114153254.1715969-1-amir73il@gmail.com>
References: <20231114153254.1715969-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

All callers of do_splice_direct() have a call to rw_verify_area() for
the entire range that is being copied, e.g. by vfs_copy_file_range() or
do_sendfile() before calling do_splice_direct().

The rw_verify_area() check inside do_splice_direct() is redundant and
is called after sb_start_write(), so it is not "start-write-safe".
Remove this redundant check.

This is needed for fanotify "pre content" events.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/splice.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index d983d375ff11..6e917db6f49a 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1166,6 +1166,7 @@ static void direct_file_splice_eof(struct splice_desc *sd)
  *    (splice in + splice out, as compared to just sendfile()). So this helper
  *    can splice directly through a process-private pipe.
  *
+ * Callers already called rw_verify_area() on the entire range.
  */
 long do_splice_direct(struct file *in, loff_t *ppos, struct file *out,
 		      loff_t *opos, size_t len, unsigned int flags)
@@ -1187,10 +1188,6 @@ long do_splice_direct(struct file *in, loff_t *ppos, struct file *out,
 	if (unlikely(out->f_flags & O_APPEND))
 		return -EINVAL;
 
-	ret = rw_verify_area(WRITE, out, opos, len);
-	if (unlikely(ret < 0))
-		return ret;
-
 	ret = splice_direct_to_actor(in, &sd, direct_splice_actor);
 	if (ret > 0)
 		*ppos = sd.pos;
-- 
2.34.1


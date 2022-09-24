Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7314CC6FA83
	for <linux-unionfs@archiver.kernel.org>; Sat, 24 Sep 2022 07:33:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233526AbiIXHdW (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 24 Sep 2022 03:33:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233324AbiIXHdV (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 24 Sep 2022 03:33:21 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A1E5B516C
        for <linux-unionfs@vger.kernel.org>; Sat, 24 Sep 2022 00:33:20 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id g1-20020a17090a708100b00203c1c66ae3so2225137pjk.2
        for <linux-unionfs@vger.kernel.org>; Sat, 24 Sep 2022 00:33:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=ZMVsUMBAKMeduU+ys2KO9Tzke8RIAJ6IXsSd88ClynM=;
        b=VexB8OMgivKHIQttJFnZ9yevpt5OqU1P2L/CoE5HKTeqDzxuckcZufT68YFWJVSRKa
         mXGwdC6OK15QOHlaUILroAyLFQmLyBMBStlRMtzrny1Wfcf/uV2mh3WfC56QE/z/UtBk
         5+EqsikYVRmR3yylEBySsgNSZsN3+9O84H8sc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=ZMVsUMBAKMeduU+ys2KO9Tzke8RIAJ6IXsSd88ClynM=;
        b=A79Hm5cwitBtr+pe+00rd7ZI3+DwzDZ6pxIYH+Xd0UYZylBXAvAM//Fv1qdlZK+vO+
         bttQKhbzaFH23rdaP0YBzxMlVKKbCsO2yVRsxHCDsbayNSwUY1+cdSdgNke3I7NJVEFH
         1KfFwkdboZXevbThY2Zx3xV8F4Qi6AwApnqUAgYBV3pmYbpiRupqVYyewuqhv2AdWm8K
         LRig56+ca7gVDBq9Hed7IVv6cJWBdqgP7NjV3ivklvr/XY2PQRQTf9bOMPwX8ikjmq5x
         Ojr/F74YPnCLmcsCySeEFsm27eKJyvECAhM+xToISB7rEKGLFMP6Hufj27bEDR6gmZDW
         yfvA==
X-Gm-Message-State: ACrzQf3Gx8pLIsCTNdTBZEfIiIbC9ODAEJb3Xw24FytA+El/zTkmTR9h
        F5a0fFkxCjkSOV1Kl+aIjvlVOg==
X-Google-Smtp-Source: AMsMyM5dtkPYTYddrXNhG6ecfeRdFrVSWAw3E/y5q/8pGqLf6wSqaBYgu/mZR6ehjD0wqT3DD8x55g==
X-Received: by 2002:a17:902:ec85:b0:178:8a69:45fb with SMTP id x5-20020a170902ec8500b001788a6945fbmr12137091plg.130.1664004799686;
        Sat, 24 Sep 2022 00:33:19 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id t185-20020a6378c2000000b0042c0ffa0e62sm6741145pgc.47.2022.09.24.00.33.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Sep 2022 00:33:18 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Kees Cook <keescook@chromium.org>, linux-unionfs@vger.kernel.org,
        syzbot+9d14351a171d0d1c7955@syzkaller.appspotmail.com,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: [PATCH] ovl: Use "buf" flexible array for memcpy() destination
Date:   Sat, 24 Sep 2022 00:33:15 -0700
Message-Id: <20220924073315.3593031-1-keescook@chromium.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1518; h=from:subject; bh=6sc208vuicFU4j8f7/nNB0JUDwsqAqSCJXpZ1EpVcfA=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBjLrK73g/2u1z6Qo/0wbshT3zKYTCL0tirpBYjt0di TZlH9uSJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYy6yuwAKCRCJcvTf3G3AJjWoD/ 9cpL/UxMQ3K7MgktDwxw4j1kV05thlGrqOrVhAt3OpsYa4oIe0WXK1G+UjF6BYlIkcWC8XynTIwBjj ZfmM/rQ3h4J1cjkWuGJUgHlAPvzsREZd0F/dAjYaF7O/lG65jMrVgOc/rkR5akfVjANgXZAPwkkSw5 K8PC11mmJkqIgOEwubt6fnJkBWKqjEDxgiswF75F9Xeg/XGe9S5AzAez4e2BRqpcSwtVHhztqeoktZ XX+N/47aHo9p/uuxcfFf4N1J2silCBgaVSJmjHywm6N/h5ZiK3Is9f0VfY4U7LZNZaUCE62GnjK4bD yrlOGc1XE6SRejHHIgAM4ev2GyokGwZJVMiff66WMomyzCTMRANXsePRNj+VLfqE8F/oczbKg/hGVw F134cU4/d/mb98CfKaCyddD82KWqUc0d9kIuyPGmOb0tDFsiYVYY2GXKiXqSD/f5Z2P9dTA5Nrn3eU w3O8OxgddbTmXgCwpXAaDRaykKAcl3PiQrK4lbZA2chRSVt0AtSda8nRJR+1mKlWVHHA/wPG70rFKc JqDG8MqGe2IWwMHASp4z+i8HNoQH2vjYROqq2+4cf7ILKRc0rTKxCVv3QK+cXKOlJbtlpSldo/zrxO bRWMT8NZKyDKUiwq1lOF6TLAoUa6wuszJLocHzK0lJKfGzdlies8D8TUjG+w==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

The "buf" flexible array needs to be the memcpy() destination to avoid
false positive run-time warning from the recent FORTIFY_SOURCE
hardening:

  memcpy: detected field-spanning write (size 93) of single field "&fh->fb" at fs/overlayfs/export.c:799 (size 21)

Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org
Reported-by: syzbot+9d14351a171d0d1c7955@syzkaller.appspotmail.com
Link: https://lore.kernel.org/all/000000000000763a6c05e95a5985@google.com/
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/overlayfs/export.c    | 2 +-
 fs/overlayfs/overlayfs.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index e065a5b9a442..ac9c3ad04016 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -796,7 +796,7 @@ static struct ovl_fh *ovl_fid_to_fh(struct fid *fid, int buflen, int fh_type)
 		return ERR_PTR(-ENOMEM);
 
 	/* Copy unaligned inner fh into aligned buffer */
-	memcpy(&fh->fb, fid, buflen - OVL_FH_WIRE_OFFSET);
+	memcpy(fh->buf, fid, buflen - OVL_FH_WIRE_OFFSET);
 	return fh;
 }
 
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 87759165d32b..a0e450313ea4 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -108,7 +108,7 @@ struct ovl_fh {
 	u8 padding[3];	/* make sure fb.fid is 32bit aligned */
 	union {
 		struct ovl_fb fb;
-		u8 buf[0];
+		DECLARE_FLEX_ARRAY(u8, buf);
 	};
 } __packed;
 
-- 
2.34.1


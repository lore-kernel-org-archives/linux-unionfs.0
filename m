Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 322D2E743C2
	for <linux-unionfs@archiver.kernel.org>; Thu, 28 Sep 2023 20:30:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231864AbjI1UaG (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 28 Sep 2023 16:30:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231921AbjI1UaF (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 28 Sep 2023 16:30:05 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDA35180;
        Thu, 28 Sep 2023 13:30:02 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id ca18e2360f4ac-79f95439795so328650239f.0;
        Thu, 28 Sep 2023 13:30:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695933002; x=1696537802; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nBOxrxDr1jHFBGxJjQHlUvnbQXDpgQCuw7Awu1Ra6tQ=;
        b=S9/190iC6ARmOXl5nvaKGf/zTBmUdV/le/os8DvKD60S49pSv0egZi3tcXZKi4XsSv
         2ATZ6tJ8WIIr41wd4r56MklHy8prR9jpZeQO0jewPB2P/rmuM5uGCHZl1uhdY4a1N8E+
         8tyaSk+C9oBHFNIerHJH9Chx3oPnsk+2bv9eIN0LGjlsgF/K0nJSTeCExBODUsE5k9Q8
         cYUDrQ8ea7cdcGCmVauIMqG5Ytcws7MdBbWEAQnKgFnfLGFsxUQHtyTmyEpf2ktGAASh
         CWE646R33EokRsjj+H5SdP9ZuiIrg/inbNvY29olZoDaY1voAY0QMs03lyOltocpvVm9
         72Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695933002; x=1696537802;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nBOxrxDr1jHFBGxJjQHlUvnbQXDpgQCuw7Awu1Ra6tQ=;
        b=YEWNHrWteESPVfzCIwsQjxm4vBDkGxt/Mfqlot2J33E0y0wKNblQJngSSPIkE4bTvU
         1RRh5V836WnMlM83OlfPM33Hj+9+dkj8sKTpGjM/op2XjCeOg80tnyNaCUUOawP4Gmvp
         W3Ea4CdzHputAovxwQIi7G5hwHkugQRq3PlTVcPD5hFTy0fHMjVJjhA57Vs8CK9ZFaXz
         PehFEZd1A04T++YiOxmQTzYoN4T5qi251x5Bp/NLQE0+WabwsI9cJl9//8MnqveKG5B5
         IGkCQ2MIQ6GL513wKuUJfFG6Q5Itf9ytkU5u4dZUW9PvkOBdOUPPjCT8lSOr9j/pAknH
         0Xfw==
X-Gm-Message-State: AOJu0YwCrA/AaZBRvNyU3W3AE70/m9sORCI0b7kI+dUCLMBDNq+AXzz7
        TZYTwL0wb7xJYR4Zgh/a/EOPtb6KDH62wlBhxME=
X-Google-Smtp-Source: AGHT+IEfTycpY47X0wq7gNaM9Z5ej2sbqh6mEw6znOhuYm6dBLkds3erWz/536wH82BFhfz1YEKI1w==
X-Received: by 2002:a05:6e02:184d:b0:348:b086:2c4b with SMTP id b13-20020a056e02184d00b00348b0862c4bmr2022760ilv.9.1695933001723;
        Thu, 28 Sep 2023 13:30:01 -0700 (PDT)
Received: from slackware.lan (c-107-2-182-140.hsd1.co.comcast.net. [107.2.182.140])
        by smtp.gmail.com with ESMTPSA id fs11-20020a05663865cb00b004313f22611csm4683805jab.151.2023.09.28.13.30.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Sep 2023 13:30:01 -0700 (PDT)
From:   Vyacheslav Yurkov <uvv.mail@gmail.com>
To:     fstests@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        Zorro Lang <zlang@kernel.org>
Cc:     linux-unionfs@vger.kernel.org,
        Vyacheslav Yurkov <uvv.mail@gmail.com>
Subject: [PATCH] README: Update overlayfs URL
Date:   Thu, 28 Sep 2023 22:28:34 +0200
Message-Id: <20230928202834.47640-1-uvv.mail@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Overlayfs-tools and overlayfs-progs projects have been merged together.

Signed-off-by: Vyacheslav Yurkov <uvv.mail@gmail.com>
---
 README | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/README b/README
index d9db9675..e558efc9 100644
--- a/README
+++ b/README
@@ -19,7 +19,7 @@ Ubuntu or Debian
         xfslibs-dev
 
    For OverlayFS install:
-    - see https://github.com/hisilicon/overlayfs-progs
+    - see https://github.com/kmxz/overlayfs-tools
 
 Fedora
 ------
@@ -37,7 +37,7 @@ Fedora
         xfsprogs-devel
 
    For OverlayFS build and install:
-    - see https://github.com/hisilicon/overlayfs-progs
+    - see https://github.com/kmxz/overlayfs-tools
 
 RHEL or CentOS
 --------------
@@ -75,7 +75,7 @@ RHEL or CentOS
      - see https://github.com/markfasheh/ocfs2-tools
 
     For OverlayFS build and install:
-     - see https://github.com/hisilicon/overlayfs-progs
+     - see https://github.com/kmxz/overlayfs-tools
 
 SUSE Linux Enterprise or openSUSE
 ---------------------------------
@@ -95,7 +95,7 @@ SUSE Linux Enterprise or openSUSE
      $ sudo zypper install xfsdump xfsprogs-devel
 
     For OverlayFS build and install:
-     - see https://github.com/hisilicon/overlayfs-progs
+     - see https://github.com/kmxz/overlayfs-tools
 
 Build and install test, libs and utils
 --------------------------------------
-- 
2.35.1


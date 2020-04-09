Return-Path: <SRS0=VDYA=5Z=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DBAEC2BB86
	for <linux-unionfs@archiver.kernel.org>; Thu,  9 Apr 2020 11:29:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 750BE20B1F
	for <linux-unionfs@archiver.kernel.org>; Thu,  9 Apr 2020 11:29:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cRKcSH9Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbgDIL3G (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 9 Apr 2020 07:29:06 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40561 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726523AbgDIL3G (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 9 Apr 2020 07:29:06 -0400
Received: by mail-wm1-f68.google.com with SMTP id a81so3811915wmf.5;
        Thu, 09 Apr 2020 04:29:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=KYuiru6C48REPJz0ALi8iqT58bGPQ1G6cn+iKsd211E=;
        b=cRKcSH9QGJz3PfcUsBI2O+LvBgh3p+HNmGaCNCNFwRtS7EsmgyxpVuYZ4DSky93hOr
         nmYlVI+HCYLoq/PyHwBU1Li/K3Y6sx/d7usYqgcPmCU+pLCBeQuXWLLL2q2zf/IVKCBa
         hXuTm8sPuUH+qfqx1/ALXzo2UASA7DXGDl1bMsjzrrKYu/e/AjZryBCnooJkbdPrMUtL
         +KH4Q8oIigKllruWF1Ua6B3b3GEKcQ20o6PD8esgEC/loaYwOkB7oOo0Q3AE5nQl3dLu
         iWlxpUCkVXd+SjTl1Hg97IsSz8PZvCbqQNOx+/p84MT31ZDzSNjUHlmuhZ/Ac25ROXin
         ZU9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=KYuiru6C48REPJz0ALi8iqT58bGPQ1G6cn+iKsd211E=;
        b=TYs2SeIHxzo64FFlmc9xC7scWka0iJmSAxe3Tqp9HeCYwSwnxrA2EqVrLCj8fg9DmC
         v+HACZMOJ0xl7uDotbRY7V3qpgD1VjUvpnnjbvA/eG7QgjcD5MKhvC1/Y8KA9Y1IAh/h
         iyvpvbbuZd87RxjPeh0C6HL22XmL67qMqE12XUDmdZv/DuElwEGFx8qrMaddH97Tiv09
         9f6OwrV59o5cdUkp/E8HUKN06yl/WjPO5r6gdr09XX5K1+dJ3sttz6YYluZEkuFs6UrD
         SxfaeQlNNbuwhWPw7v/GPhCG7hdcEdtYEoaEsgbcbhq5NWWErWg/0GS5MY+tc/YybBzD
         qZWQ==
X-Gm-Message-State: AGi0PuZb2/ZutIhdlL31TlyRXZm34ENGESguB1P+Kx0Toy8FWCFJ5dD6
        zyAtATiZsLInKKrj0jnFUX4=
X-Google-Smtp-Source: APiQypJdDj6fpsjhgx2BF72TOAcns2GxDm+KuRyTM6GJ2820nz8UNPSOE0VSSINCBhwapChyFbQSlA==
X-Received: by 2002:a1c:66d5:: with SMTP id a204mr3756048wmc.69.1586431745437;
        Thu, 09 Apr 2020 04:29:05 -0700 (PDT)
Received: from localhost.localdomain ([141.226.12.123])
        by smtp.gmail.com with ESMTPSA id n18sm1474751wmk.6.2020.04.09.04.29.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2020 04:29:04 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     Chengguang Xu <cgxu519@mykernel.net>,
        Miklos Szeredi <miklos@szeredi.hu>,
        linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH] overlay/029: fix test failure with index feature enabled
Date:   Thu,  9 Apr 2020 14:29:00 +0300
Message-Id: <20200409112900.15341-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

When overlayfs index feature is enabled by default in either kernel
config or module parameters, this test fails:

    mount: /tmp/8751/mnt: mount(2) system call failed: Stale file handle.
    cat: /tmp/8751/mnt/bar: No such file or directory

The reason is that with index feature enabled, an upper/work dirs cannot
be reused for mounting with a different lower layer.

Reported-by: Chengguang Xu <cgxu519@mykernel.net>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/029 | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tests/overlay/029 b/tests/overlay/029
index 1d2d2092..17f58de7 100755
--- a/tests/overlay/029
+++ b/tests/overlay/029
@@ -68,12 +68,18 @@ _overlay_mount_dirs $SCRATCH_MNT/up $tmp/{upper,work} \
 cat $tmp/mnt/foo
 $UMOUNT_PROG $tmp/mnt
 
+# re-create upper/work to avoid ovl_verify_origin() mount failure
+# when index is enabled
+rm -rf $tmp/{upper,work}
+mkdir -p $tmp/{upper,work}
 # mount overlay again using lower dir from SCRATCH_MNT dir
 _overlay_mount_dirs $SCRATCH_MNT/low $tmp/{upper,work} \
   overlay $tmp/mnt
 cat $tmp/mnt/bar
 $UMOUNT_PROG $tmp/mnt
 
+rm -rf $tmp/{upper,work}
+mkdir -p $tmp/{upper,work}
 # mount overlay again using SCRATCH_MNT dir
 _overlay_mount_dirs $SCRATCH_MNT/ $tmp/{upper,work} \
   overlay $tmp/mnt
-- 
2.17.1


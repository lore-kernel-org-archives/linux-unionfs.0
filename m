Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1197C27C7A
	for <linux-unionfs@archiver.kernel.org>; Thu, 17 Aug 2023 05:45:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348129AbjHQFo6 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 17 Aug 2023 01:44:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348163AbjHQFoy (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 17 Aug 2023 01:44:54 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B86F1990
        for <linux-unionfs@vger.kernel.org>; Wed, 16 Aug 2023 22:44:53 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id 2adb3069b0e04-4fe21e7f3d1so11829484e87.3
        for <linux-unionfs@vger.kernel.org>; Wed, 16 Aug 2023 22:44:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692251092; x=1692855892;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AbSICtERq1BT6SOVrdfOleugg8ogJVQg8b0yrDjDhLg=;
        b=rLte1ik+HOgWR5Y3DYpPPuOUsdoLifQTfourEuBVlahWPtg18ypNWDVZiGHmtRgTpj
         YQKbhJJBdUWr9loVHZET3joPhSqEhTr8EpPjhM5mcdM3B4mF3jPzHoc8iKAgGVidz6ZE
         TkigWxMYmKy6m8matFhFOHS3dUbm8AA8WtdpEwhwZnuNIbLFK+ndl/u5fA9H7ikS+95h
         vmGr8i220C2gmLICWIiZc56LI8+dSmagfIjAH7R6kNsfYURXQw2t/w9wxAxAkeRitjtS
         OrPfgWJKBIkYQl09tp7WAoI7gIgNmnyHYI8Z97B/1b+z5n9uBv6WKXukj9ah3nIthl62
         DeTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692251092; x=1692855892;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AbSICtERq1BT6SOVrdfOleugg8ogJVQg8b0yrDjDhLg=;
        b=DZCxmoKDU6E1WqHgU+bJpc2jhYdjbl7Ch9aK0Z7udALI43b4JC26EqSV+z0OTXdAqe
         nXhkceFg9CFNOpAKj2b6pdrOvzE1GEN9bzN3GdgNodZk+tgE1EP/bqKnHxa4UJyYzpx8
         3ahMTArAOhWtcgS1Kvuz0ji6UOXYmimSUR5pIBWszyXlu+MRa3IfXeHBAqyTF+w19Ktg
         GxGj8GQ0pktnqK7cxacGcOJBa4pRPLq3Mjx6V+6LBx/fWCBCBFMMiettyzpQgdz2gSUj
         86mt29Lm8FgFyVZsdU07Rw4f4ajWY1KRx1xPB0HMYwrWiH4Fr6ep7s8DOBIgrKLUbOOg
         +6bQ==
X-Gm-Message-State: AOJu0Ywn5eyuXMEv2T5JbD1qhk8ah6Wg5idAZGz3uff5gokmyZX6TlZj
        cuOZ8WC5nd74XBmQ2tmOI+rch2XLo+8=
X-Google-Smtp-Source: AGHT+IFWAN4JGvnAeCCAUF2EVTIcmxD1LUOzGZEEhAx7j4Tu3ZRkDCPmfDzMfcIHAkXyIrP9nFWaCw==
X-Received: by 2002:a19:ca4e:0:b0:4fd:d517:fbd8 with SMTP id h14-20020a19ca4e000000b004fdd517fbd8mr2746535lfj.9.1692251091406;
        Wed, 16 Aug 2023 22:44:51 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id z13-20020aa7c64d000000b00522828d438csm9386486edr.7.2023.08.16.22.44.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Aug 2023 22:44:50 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org
Subject: [PATCH v3 0/4] fs: export __mnt_{want,drop}_write to modules
Date:   Thu, 17 Aug 2023 08:44:46 +0300
Message-Id: <20230817054446.961644-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230816152334.924960-1-amir73il@gmail.com>
References: <20230816152334.924960-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

overlayfs is going to use those to grab a write reference on the
upper fs during copy up.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Christian,

This patch is needed for the ovl_want_write() changes [1],
which I forgot to CC you on.

Please ACK if you approve.

Thanks,
Amir.

[1] https://lore.kernel.org/linux-unionfs/20230816152334.924960-1-amir73il@gmail.com/

 fs/namespace.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/namespace.c b/fs/namespace.c
index e157efc54023..370328b204f1 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -386,6 +386,7 @@ int __mnt_want_write(struct vfsmount *m)
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(__mnt_want_write);
 
 /**
  * mnt_want_write - get write access to a mount
@@ -466,6 +467,7 @@ void __mnt_drop_write(struct vfsmount *mnt)
 	mnt_dec_writers(real_mount(mnt));
 	preempt_enable();
 }
+EXPORT_SYMBOL_GPL(__mnt_drop_write);
 
 /**
  * mnt_drop_write - give up write access to a mount
-- 
2.34.1


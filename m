Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD74DC6369E
	for <linux-unionfs@archiver.kernel.org>; Mon, 16 Nov 2020 04:58:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8400A222B9
	for <linux-unionfs@archiver.kernel.org>; Mon, 16 Nov 2020 04:58:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=sargun.me header.i=@sargun.me header.b="h2Ufa6+H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726016AbgKPE6K (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 15 Nov 2020 23:58:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726315AbgKPE6J (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 15 Nov 2020 23:58:09 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 942AEC0613CF
        for <linux-unionfs@vger.kernel.org>; Sun, 15 Nov 2020 20:58:09 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id 81so3766510pgf.0
        for <linux-unionfs@vger.kernel.org>; Sun, 15 Nov 2020 20:58:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sargun.me; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6dbPPIUe9/FBeVVzEW0i/OcRzMX2B4SWonN1mMQZAuU=;
        b=h2Ufa6+HwrSgLE2VXLZq3d+uuiHeKA19EXYsCYl48mXWpJplC84LLgsfNJe29zcjGF
         mQ/jh5pd5JvSzFxy0ElbJPmSZfDqvHiHqTRdxOOhZZk7e1g6DI3uYHL2ZH6aos8G5vqn
         gy8VRRTyfYoQOg6YvW/LUVkZ0QanEaEIm+q/E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6dbPPIUe9/FBeVVzEW0i/OcRzMX2B4SWonN1mMQZAuU=;
        b=gGDlgs7xnd5+8ZH47nwMrx9fYaEiVw/yntfbk1iPSt/U6e9TZ9u0FASLqIcBoqucIu
         ieJzNcfHFPN81f8aBbOv7dFYTsWMRhKudLpnj/wjRKeCm9QeuE3SpnQo/quMO6QuMUAN
         KFGbuWJhju54lxxdxrHsrY4Jj0yzR72no2f5mX0ZV212nO3KUDn2gp3EvnUWjDOI0opz
         8shhu68jtm/IhrOuZBu7SnkT7vvQ4MwM0gNPY6V6PyRwDBUJTTEDnqtwUEaWoUM1sj30
         ajQgYX6/0pFFg1lngYPKmlPu5d5gUHDrsF3Ei+kCUxfOh37RCACMU6UY6QRMRl9TaWOz
         h7ow==
X-Gm-Message-State: AOAM532FUGFbGcIpcCEKf6siyInVXC+ptsPLP2N9egl6Tr5WowkOjgy4
        Kr/kOudGt5B2M7kkObTS86MaBDn4uTclbzn4
X-Google-Smtp-Source: ABdhPJw4LlFGxVnvoR4MPbRwL01eN2QU/vuDbFGca2/Tg5gi2b34hcW3kdWolBDNt+LdPTKAasitJg==
X-Received: by 2002:a63:d94f:: with SMTP id e15mr11521195pgj.73.1605502688716;
        Sun, 15 Nov 2020 20:58:08 -0800 (PST)
Received: from ubuntu.netflix.com (203.20.25.136.in-addr.arpa. [136.25.20.203])
        by smtp.gmail.com with ESMTPSA id v23sm16465284pjh.46.2020.11.15.20.58.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2020 20:58:08 -0800 (PST)
From:   Sargun Dhillon <sargun@sargun.me>
To:     linux-unionfs@vger.kernel.org, miklos@szeredi.hu,
        Alexander Viro <viro@zeniv.linux.org.uk>
Cc:     Sargun Dhillon <sargun@sargun.me>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Daniel J Walsh <dwalsh@redhat.com>,
        David Howells <dhowells@redhat.com>,
        linux-fsdevel@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>
Subject: [RFC PATCH 2/3] overlay: Add ovl_do_getxattr helper
Date:   Sun, 15 Nov 2020 20:57:57 -0800
Message-Id: <20201116045758.21774-3-sargun@sargun.me>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201116045758.21774-1-sargun@sargun.me>
References: <20201116045758.21774-1-sargun@sargun.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

We already have a helper for getting xattrs from inodes, namely
ovl_getxattr, but it doesn't allow for copying xattrs onto the current
stack. In addition, it is not instrumented like the rest of the helpers.

Signed-off-by: Sargun Dhillon <sargun@sargun.me>
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-unionfs@vger.kernel.org
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/overlayfs.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 29bc1ec699e7..9eb911f243e1 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -179,6 +179,15 @@ static inline int ovl_do_setxattr(struct dentry *dentry, const char *name,
 	return err;
 }
 
+static inline int ovl_do_getxattr(struct dentry *dentry, const char *name,
+				  void *value, size_t size)
+{
+	int err = vfs_getxattr(dentry, name, value, size);
+	pr_debug("getxattr(%pd2, \"%s\", \"%*pE\", %zu) = %i\n",
+		 dentry, name, min((int)size, 48), value, size, err);
+	return err;
+}
+
 static inline int ovl_do_removexattr(struct dentry *dentry, const char *name)
 {
 	int err = vfs_removexattr(dentry, name);
-- 
2.25.1


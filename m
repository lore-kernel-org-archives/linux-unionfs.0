Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E768C77B75
	for <linux-unionfs@archiver.kernel.org>; Tue, 18 Apr 2023 01:42:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbjDRBmW (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 17 Apr 2023 21:42:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230434AbjDRBlp (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 17 Apr 2023 21:41:45 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6263D76A5
        for <linux-unionfs@vger.kernel.org>; Mon, 17 Apr 2023 18:41:14 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-54f8d4f1ca1so155867787b3.20
        for <linux-unionfs@vger.kernel.org>; Mon, 17 Apr 2023 18:41:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681782073; x=1684374073;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=k+WSpIn3NUEIdVcNWDxlTZBL9IhEMs5qHwjDTSF5QyA=;
        b=gnEAvtWYbBPrlRDvmMhwWHAU4VOPAZNhzEbReBa4tJPpc5X3cQyQnOkcj+IZxU+jtd
         Q+YCDhkPu6ZImWiqrO7KC2hZnhfm/LoPf2Qk+B0v/m+gmZs6ydm6J9MF3xNYweVlnDD8
         kzJrv+qZegriRdHZmr6G27dsKx70i7W4bP34J1/ZwAQen87rca+5p+yPyWMoLaX9Dau9
         nVVsiKpQ1gJzqgxY8b3BMTPSECOFqN5iCxmNf5WcJMJVHe+OKuTEuYOpIO0xE/kXViUv
         CKddSMZuirEzlq3i+5fDaLh4bYaIBJcIpoMpmtH8zmyBRsHn6nqpB1ZlzCdIk6aTFlgp
         Gt8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681782073; x=1684374073;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k+WSpIn3NUEIdVcNWDxlTZBL9IhEMs5qHwjDTSF5QyA=;
        b=O6+9otWaUe8XmPGoBdFCuFNRNjEK4g/MTksZlFbdDDPQFXD2u1gA61KDr6npxLKoQY
         LGFpZWbMBh4xdasIHqL2GiRYIj5upT7t9ALn0xDqxwILYxqvejiZORiieVgh3JFMdY02
         iSiZnooSMPgmbPmR//UQ3KiyEJOdHI6jUAoo1mkDmoXEC3AXmPXTI/4cqQJhbXw4Nmns
         xmRgRYZUNuqorGN0yyMADKyzWsG94D/DebV5l5S9Zs3m7VuWH9I0qqBuEjTBQKxSUh+t
         KXI1WUuRH3ysehCBTaTvLLA0EcmJ/ZxMbixxBkIqsjPl202SsMiJCPhrcYTHGFQ8deb1
         mbwQ==
X-Gm-Message-State: AAQBX9e4BDX7k36DHk5O9XNaypRuRg5FkNHLr6QjUTcPVdiqqFXm2MIs
        exHQYITjhv5IRCJK8KTIuQALO90UIWM=
X-Google-Smtp-Source: AKy350ZEiZ4KiwaDQvoDBVRd0pyWtBmDHMYqWI/Cx2Am4cudHmQsbbtrl8pLWWl9gfM9hNxwPXm0gu6TXWo=
X-Received: from drosen.mtv.corp.google.com ([2620:15c:211:201:e67a:98b0:942d:86aa])
 (user=drosen job=sendgmr) by 2002:a25:cfcc:0:b0:b78:1b26:a642 with SMTP id
 f195-20020a25cfcc000000b00b781b26a642mr8808364ybg.1.1681782073411; Mon, 17
 Apr 2023 18:41:13 -0700 (PDT)
Date:   Mon, 17 Apr 2023 18:40:10 -0700
In-Reply-To: <20230418014037.2412394-1-drosen@google.com>
Mime-Version: 1.0
References: <20230418014037.2412394-1-drosen@google.com>
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
Message-ID: <20230418014037.2412394-11-drosen@google.com>
Subject: [RFC PATCH v3 10/37] fuse-bpf: Don't support export_operations
From:   Daniel Rosenberg <drosen@google.com>
To:     Miklos Szeredi <miklos@szeredi.hu>, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Joanne Koong <joannelkoong@gmail.com>,
        Mykola Lysenko <mykolal@fb.com>, kernel-team@android.com,
        Daniel Rosenberg <drosen@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

In the future, we may choose to support these, but it poses some
challenges. In order to create a disconnected dentry/inode, we'll need
to encode the mountpoint and bpf into the file_handle, which means we'd
need a stable representation of them. This also won't hold up to cases
where the bpf is not stateless. One possibility is registering bpf
programs and mounts in a specific order, so they can be assigned
consistent ids we can use in the file_handle. We can defer to the lower
filesystem for the lower inode's representation in the file_handle.

Signed-off-by: Daniel Rosenberg <drosen@google.com>
---
 fs/fuse/inode.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index b71e8758fab5..fe80984f099a 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -1107,6 +1107,14 @@ static int fuse_encode_fh(struct inode *inode, u32 *fh, int *max_len,
 	nodeid = get_fuse_inode(inode)->nodeid;
 	generation = inode->i_generation;
 
+#ifdef CONFIG_FUSE_BPF
+	/* TODO: Does it make sense to support this in some cases? */
+	if (!nodeid && get_fuse_inode(inode)->backing_inode) {
+		*max_len = 0;
+		return FILEID_INVALID;
+	}
+#endif
+
 	fh[0] = (u32)(nodeid >> 32);
 	fh[1] = (u32)(nodeid & 0xffffffff);
 	fh[2] = generation;
-- 
2.40.0.634.g4ca3ef3211-goog


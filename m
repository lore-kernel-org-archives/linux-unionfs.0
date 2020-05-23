Return-Path: <SRS0=PFgV=7F=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49C12C433DF
	for <linux-unionfs@archiver.kernel.org>; Sat, 23 May 2020 13:22:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A83120727
	for <linux-unionfs@archiver.kernel.org>; Sat, 23 May 2020 13:22:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TDVHMoru"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387849AbgEWNWE (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 23 May 2020 09:22:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387804AbgEWNWE (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 23 May 2020 09:22:04 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D83C0C061A0E
        for <linux-unionfs@vger.kernel.org>; Sat, 23 May 2020 06:22:03 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id g9so11444729edw.10
        for <linux-unionfs@vger.kernel.org>; Sat, 23 May 2020 06:22:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=/q8de1ZEpWBTMi4bkM6rIjgfAGmoHRA2b1tV+XxktKc=;
        b=TDVHMoruyiQT2UQs+vp8JLffq64LsdiY9L9vI9ZqZrYc3nnEiIvTHCjGns8z3K0fvB
         YidrDVUenytvQR3NkDCLmBqIH3TQwOeXFz2RiKhK8TV/l53z8EJIYZLCRTdJuXlvJOUi
         zDf5Wowpr7J+2jXsnsCRIKDAd2ZHZzoveS0eWQcnPTyF+ooIHoS5g+pJUezyVQ3ZMXz3
         QPCVOdeOjVx5gP41QboMTKHvx8Yz9Uk4fZRF9GExG6HHEAyLmjhWZ9XJQh0cPvk+yPiP
         JsBnXFYDAraOI11/HF8c9HSBBAU/euPDAFe25YGyXNvncn3dP4rHzO5sj3zV9v0+xaN4
         QTTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=/q8de1ZEpWBTMi4bkM6rIjgfAGmoHRA2b1tV+XxktKc=;
        b=Kt/KbgApfeDDcZr9FqQYjYgqXM9oXgdQaC51quX09UvAS4/HRQyggnqkDyaWg7/dtd
         mqhoVkEJaVZe+uBdmbOM9GgOEJ4jotrROjc2D8BZ3L54k/AMZdHkGjQxQNO/Krys1EE9
         gkPKGDPVJa8V7nl1CohLXOoevf4ESN60reMncajgrjGLeeLttvLEYel7ZrZ5D4/ihYjT
         Rsz2XSHuTILomT0YeX830HtMK+1dzR/nADKO359WARZMbMss70Y3aNu7PcHK/PDgvKJj
         dcVy76aPb0PYcyeLs9Zd4hIVh/fTP3szkBUfdZoE+XV7kt+VvWM8iWMXC7DIex8RHDbx
         SLfA==
X-Gm-Message-State: AOAM533aOtLIx1zd27+K/GW1vUrDnx5ABdg0TxDa3X1DiLOhOq9Ulb4q
        PjsQ8gX1AOCLlX7X+Mq/iPk=
X-Google-Smtp-Source: ABdhPJwhaeUeZQcVgY49F5XnW3Mcsh4W6S+e+TOveJGLpu2K1C6rKfQJbKjMHIAN2a125HnDSCf7cw==
X-Received: by 2002:a05:6402:2058:: with SMTP id bc24mr7192698edb.134.1590240122586;
        Sat, 23 May 2020 06:22:02 -0700 (PDT)
Received: from localhost.localdomain ([141.226.12.123])
        by smtp.gmail.com with ESMTPSA id a3sm9968182edv.70.2020.05.23.06.22.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2020 06:22:01 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        syzkaller-bugs@googlegroups.com, linux-unionfs@vger.kernel.org
Subject: [PATCH] ovl: fix out of bounds access warning in ovl_check_fb_len()
Date:   Sat, 23 May 2020 16:21:55 +0300
Message-Id: <20200523132155.14698-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

syzbot reported out of bounds memory access from open_by_handle_at()
with a crafted file handle that looks like this:

  { .handle_bytes = 2, .handle_type = OVL_FILEID_V1 }

handle_bytes gets rounded down to 0 and we end up calling:
  ovl_check_fh_len(fh, 0) => ovl_check_fb_len(fh + 3, -3)

But fh buffer is only 2 bytes long, so accessing struct ovl_fb at
fh + 3 is illegal.

Fixes: cbe7fba8edfc ("ovl: make sure that real fid is 32bit aligned in memory")
Reported-and-tested-by: syzbot+61958888b1c60361a791@syzkaller.appspotmail.com
Cc: <stable@vger.kernel.org> # v5.5
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Miklos,

Another fallout from aligned file handle.
This one seems like a warning that cannot lead to actual harm.
As far as I can tell, with:

  { .handle_bytes = 2, .handle_type = OVL_FILEID_V1 }

kmalloc in handle_to_path() allocates 10 bytes, which means 16 bytes
slab object, so all fields accessed by ovl_check_fh_len() should be
within the slab object boundaries. And in any case, their value
won't change the outcome of EINVAL.

I have added this use case to the xfstest for checking the first bug,
but it doesn't trigger any warning on my kernel (without KASAN) and
returns EINVAL as expected.

Thanks,
Amir.

 fs/overlayfs/overlayfs.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 76747f5b0517..ffbb57b2d7f6 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -355,6 +355,9 @@ int ovl_check_fb_len(struct ovl_fb *fb, int fb_len);
 
 static inline int ovl_check_fh_len(struct ovl_fh *fh, int fh_len)
 {
+	if (fh_len < sizeof(struct ovl_fh))
+		return -EINVAL;
+
 	return ovl_check_fb_len(&fh->fb, fh_len - OVL_FH_WIRE_OFFSET);
 }
 
-- 
2.17.1


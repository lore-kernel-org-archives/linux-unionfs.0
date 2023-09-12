Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDDCDCA0EC3
	for <linux-unionfs@archiver.kernel.org>; Tue, 12 Sep 2023 09:57:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230345AbjILJ5D (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 12 Sep 2023 05:57:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233074AbjILJ5A (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 12 Sep 2023 05:57:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 450F410D1
        for <linux-unionfs@vger.kernel.org>; Tue, 12 Sep 2023 02:56:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694512571;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MXK46K3xAsRxJhrgzkjxNZ1nb6duYFD0FjXpxyzNEUs=;
        b=ZZK5jaeB+ojT5RW4QTTxJlqscZdF+7N2peE00XnhOXg8w+hRQgGUOEbozhYObpEYW11OmF
        WzHNDP40yTU0YIuZOdv6aOcxTdwKxVWmGa67JvrY8gting0RowUPaETmIXIrtR88ve8A/9
        WDoFUQxDWB3AH4FisMdE3Lx9nkV6Ug8=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-44-CK_-B0a5MAOGwDBxLWsgUA-1; Tue, 12 Sep 2023 05:56:08 -0400
X-MC-Unique: CK_-B0a5MAOGwDBxLWsgUA-1
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-2bcec24e8f8so60451921fa.1
        for <linux-unionfs@vger.kernel.org>; Tue, 12 Sep 2023 02:56:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694512567; x=1695117367;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MXK46K3xAsRxJhrgzkjxNZ1nb6duYFD0FjXpxyzNEUs=;
        b=LCP4t/hB5tHypdzcLtqFmGrc9U7c1jv9RiAHT8Mlj90cnL5m77hYIAXu3ABCMgGgks
         1qiKX0SRZUmg3wFV4Ka0GH6NmvOb5bX6IOAmcJ1OarAyjCq0+p0rlmGsF2HprdKo118x
         /HGoX1CotXuo+8QFUbj6de/82bfBWh1vZB/ZHRrxbmkuuKIWx9nIASlg142kGmzYI/3Q
         vVI+9KOn+GJpqhEMxda01Lmsf/4uN4vevGIIy3ccg8lk4SMxY0Dv5y7fmQFVbuJqC9Ss
         u8CpB3HcBIcB7xyZPSxDGnaU61/AFE4Wx7e0yn4HRRF7bV4/dXGwBHQs0hFAaC2YPlac
         sldA==
X-Gm-Message-State: AOJu0Yx3XRJFG1reOgyApQb5Pi6EQP75AulVZM7jm2E0/wtDBbLEG7ug
        H17p8luy3ljQ9aPcpBFvzrJ3ZF4JMabkLPGs9+HsdLd66Dzmvz7buhtusNmxB2O8MJj3TdR3Zrr
        OfXBukvOp6vIGN+lUsOZ9hkjoqg==
X-Received: by 2002:a05:6512:159d:b0:4f8:6dfd:faa0 with SMTP id bp29-20020a056512159d00b004f86dfdfaa0mr11285353lfb.2.1694512567445;
        Tue, 12 Sep 2023 02:56:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IERtRK24AfjhEJZbfJUsuAtzeJLGndjbNEvjv3uj1bFohQ5yT8UNMPlh9B+8Jl+qn6JzpwkQQ==
X-Received: by 2002:a05:6512:159d:b0:4f8:6dfd:faa0 with SMTP id bp29-20020a056512159d00b004f86dfdfaa0mr11285337lfb.2.1694512567169;
        Tue, 12 Sep 2023 02:56:07 -0700 (PDT)
Received: from greebo.redhat.com (c-e6a5e255.022-110-73746f36.bbcust.telenor.se. [85.226.165.230])
        by smtp.googlemail.com with ESMTPSA id t15-20020ac243af000000b004fdba93b92asm1691766lfl.252.2023.09.12.02.56.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Sep 2023 02:56:06 -0700 (PDT)
From:   Alexander Larsson <alexl@redhat.com>
To:     miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org, amir73il@gmail.com,
        Alexander Larsson <alexl@redhat.com>
Subject: [PATCH v4 5/5] ovl: Add documentation on nesting of overlayfs mounts
Date:   Tue, 12 Sep 2023 11:55:59 +0200
Message-ID: <c4888e90391d48c03f4822859f2fe8cae307defa.1694512044.git.alexl@redhat.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1694512044.git.alexl@redhat.com>
References: <cover.1694512044.git.alexl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Signed-off-by: Alexander Larsson <alexl@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
 Documentation/filesystems/overlayfs.rst | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
index cdefbe73d85c..ae194543dbda 100644
--- a/Documentation/filesystems/overlayfs.rst
+++ b/Documentation/filesystems/overlayfs.rst
@@ -492,6 +492,29 @@ directory tree on the same or different underlying filesystem, and even
 to a different machine.  With the "inodes index" feature, trying to mount
 the copied layers will fail the verification of the lower root file handle.
 
+Nesting overlayfs mounts
+------------------------
+
+It is possible to use a lower directory that is stored on an overlayfs
+mount. For regular files this does not need any special care. However, files
+that have overlayfs attributes, such as whiteouts or "overlay.*" xattrs will be
+interpreted by the underlying overlayfs mount and stripped out. In order to
+allow the second overlayfs mount to see the attributes they must be escaped.
+
+Overlayfs specific xattrs are escaped by using a special prefix of
+"overlay.overlay.". So, a file with a "trusted.overlay.overlay.metacopy" xattr
+in the lower dir will be exposed as a regular file with a
+"trusted.overlay.metacopy" xattr in the overlayfs mount. This can be nested by
+repeating the prefix multiple time, as each instance only removes one prefix.
+
+A lower dir with a regular whiteout will always be handled by the overlayfs
+mount, so to support storing an effective whiteout file in an overlayfs mount an
+alternative form of whiteout is supported. This form is a regular, zero-size
+file with the "overlay.whiteout" xattr set, inside a directory with the
+"overlay.whiteouts" xattr set. Such whiteouts are never created by overlayfs,
+but can be used by userspace tools (like containers) that generate lower layers.
+These alternative whiteouts can be escaped using the standard xattr escape
+mechanism in order to properly nest to any depth.
 
 Non-standard behavior
 ---------------------
-- 
2.41.0


Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33500EC874B
	for <linux-unionfs@archiver.kernel.org>; Thu,  7 Sep 2023 18:18:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbjIGSSa (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 7 Sep 2023 14:18:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235649AbjIGSS3 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 7 Sep 2023 14:18:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B611D1FEC
        for <linux-unionfs@vger.kernel.org>; Thu,  7 Sep 2023 11:17:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694110621;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=M8WLnuj8/xRCHoS5r2XmtkIwfA0K5Ci4azC6XBLf+t0=;
        b=LiUj/rX2CD7/+DJ9m9EJUwfLcchLfSlicQf7z6A7ucWfDh4HgTHkYbA70VVDu9THyDvCkm
        z0nY5hXBmYNQpFV+1xNzTFiFnoBdjPcullwwTS9AY1E4+zX0e13REffmXlYrHnzyOKTJwh
        uftWzFRDNufhcZrboBgWd/FdJon1K0I=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-340-8CRJS52iNQ2IcHCwp0wwig-1; Thu, 07 Sep 2023 04:44:23 -0400
X-MC-Unique: 8CRJS52iNQ2IcHCwp0wwig-1
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-2bcdd6ba578so8937611fa.3
        for <linux-unionfs@vger.kernel.org>; Thu, 07 Sep 2023 01:44:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694076262; x=1694681062;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M8WLnuj8/xRCHoS5r2XmtkIwfA0K5Ci4azC6XBLf+t0=;
        b=BcvqHo8qtdQwOEl+rXN7gAOZH+vhchhfHjZk8KN1bhN8KG3hNRJvodhe+/gFFczM8W
         SryDGWBWAYOCMxejvecibMNhut5SmKIRuJD5XGxMd9UxHmMf381Bk27fkh9y+sAYdqZX
         p3ZlP2uB9F9sHlon25Eyy8NII5MKnbZnSGzYwS61TITI8AQUXS1emns75lgeQ0KTvYEK
         VZzB49D0QH8mPH5JcpqPk0DzfeTxR2DQgMnFPe8OFzzdlqpI36veo+W1Mir46bn2TyuC
         z1JtdfHsDj45QtV/s83LG0Kppmf3bw5gXAJB1BawDJee4IZNm9xZDikMNBCsmlX1lMj9
         ujbQ==
X-Gm-Message-State: AOJu0YyEFAi7dk0sVUP4SyAaL15oOolTxt0kRmUoLf+m7uai4ZSf+6+7
        +U5lb3vqn65kSXr4oy/23QR0gQRYz2nfTi9Ht0YXiG7vDQIbbXfKWURPXrASaQLR9dTcElJt/6G
        ZdkmsJapz8vqElV5eOIAc5trsiw==
X-Received: by 2002:a2e:9b4d:0:b0:2bc:d634:2210 with SMTP id o13-20020a2e9b4d000000b002bcd6342210mr3831883ljj.16.1694076261922;
        Thu, 07 Sep 2023 01:44:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHw7fIS1/U1SXt3E/BRf1FnX3TIL8muqKMCMFl9xaQuyit9kKm5W1FZ4mMczHfTt0B/5+q0kw==
X-Received: by 2002:a2e:9b4d:0:b0:2bc:d634:2210 with SMTP id o13-20020a2e9b4d000000b002bcd6342210mr3831874ljj.16.1694076261699;
        Thu, 07 Sep 2023 01:44:21 -0700 (PDT)
Received: from greebo.redhat.com (c-e6a5e255.022-110-73746f36.bbcust.telenor.se. [85.226.165.230])
        by smtp.googlemail.com with ESMTPSA id o6-20020a2e9b46000000b002b70a64d4desm3812828ljj.46.2023.09.07.01.44.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Sep 2023 01:44:20 -0700 (PDT)
From:   Alexander Larsson <alexl@redhat.com>
To:     miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org, amir73il@gmail.com,
        Alexander Larsson <alexl@redhat.com>
Subject: [PATCH v3 6/6] ovl: Add documentation on nesting of overlayfs mounts
Date:   Thu,  7 Sep 2023 10:44:11 +0200
Message-ID: <261be2df5093dda05aaffe10a6c8831439232574.1694075674.git.alexl@redhat.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1694075674.git.alexl@redhat.com>
References: <cover.1694075674.git.alexl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Signed-off-by: Alexander Larsson <alexl@redhat.com>
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


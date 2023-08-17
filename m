Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F93FC2FC0E
	for <linux-unionfs@archiver.kernel.org>; Thu, 17 Aug 2023 11:06:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350096AbjHQLGW (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 17 Aug 2023 07:06:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350155AbjHQLGT (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 17 Aug 2023 07:06:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D2792D72
        for <linux-unionfs@vger.kernel.org>; Thu, 17 Aug 2023 04:05:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692270340;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YsVwatcA8F8IoIMuTPo1xBbXr7+nkypKa8fX71cqWb0=;
        b=IQLarHMhwHw5STrF2cPYf7vOyvO6JeF1WQ1zji8aKOFLCMYhfVDnlFDXeZ8z9CMkSUmTRV
        6HQTbpIKLF5yRCSdyfi3KuA9PazZsWCptIkCqik3Rq20xuC4aa5R448+gF8ASiK2Yfw2EF
        JXTr0H5uuCHdyKX+EIPW+roDPbOXI2o=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-338-HAyu0EvxPdWPJuPhSNuAkg-1; Thu, 17 Aug 2023 07:05:36 -0400
X-MC-Unique: HAyu0EvxPdWPJuPhSNuAkg-1
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-2bb99d9c60eso17947891fa.2
        for <linux-unionfs@vger.kernel.org>; Thu, 17 Aug 2023 04:05:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692270331; x=1692875131;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YsVwatcA8F8IoIMuTPo1xBbXr7+nkypKa8fX71cqWb0=;
        b=d1r/jTH4uKLm+Nbj8e2FPiLRjU5XLVGkOhTC4kdnj0XdtBp4yNNVA3QIKNR/HTiQDX
         bMUjhN65lv5GFaQHMFAbtAFqV6Gg+N1L7se/N7sYbyrN0EwErQlyhTDFWwLPtMi4fr9/
         SrJsyQjlVskCTUtk3zi0ubDfeGrNPD69cTV0Ko3rmH1BoHMxuZ4LMZZVYu/JyeR+1uRM
         Jj73c9Y8qDRXHpJgGcZ2yj8jtOdhM/NZ++8pVizo+kOTzMDSfF0h9r5YYRQl6jzI79tF
         ndlbU+EYd6/5UvlXA4s1FKeYeixAxxQU+3bOav3KZu55/YrzvdQf0HgcQD/4XJOVXZ0O
         +jSQ==
X-Gm-Message-State: AOJu0YyxuWCoUXhFYrcPOtgmPg0G7DHpFz0HC+hFknZMLtGY/jTgJREW
        VvzK3Cqtc9tLmqo7ucWfDkmZwrV2eWITmzK4rxASGZY5FNkAeYyj/PCF29OiHiyVgN1kcqTdGxy
        5faDS/uxnpEUgh9QaYxz08qn+RJvuGNAr/A==
X-Received: by 2002:a2e:3806:0:b0:2b6:e283:32cb with SMTP id f6-20020a2e3806000000b002b6e28332cbmr3547794lja.23.1692270331422;
        Thu, 17 Aug 2023 04:05:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGdvcfnmB1Cgor0CUWg2OBprVEyBjr+dT+shHmzT3tYO3Jk96dw7VfOgkjs12Eb0FBXYy7eVg==
X-Received: by 2002:a2e:3806:0:b0:2b6:e283:32cb with SMTP id f6-20020a2e3806000000b002b6e28332cbmr3547789lja.23.1692270331225;
        Thu, 17 Aug 2023 04:05:31 -0700 (PDT)
Received: from greebo.redhat.com (c-e6a5e255.022-110-73746f36.bbcust.telenor.se. [85.226.165.230])
        by smtp.googlemail.com with ESMTPSA id l20-20020a2e8694000000b002ba15c272e8sm69010lji.71.2023.08.17.04.05.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Aug 2023 04:05:30 -0700 (PDT)
From:   Alexander Larsson <alexl@redhat.com>
To:     miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org, amir73il@gmail.com,
        Alexander Larsson <alexl@redhat.com>
Subject: [PATCH v2 5/5] ovl: Add documentation on nesting of overlayfs mounts
Date:   Thu, 17 Aug 2023 13:05:24 +0200
Message-ID: <6c4b8bd0bf0c234f630242034208eebfe2eff3a1.1692270188.git.alexl@redhat.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1692270188.git.alexl@redhat.com>
References: <cover.1692270188.git.alexl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Signed-off-by: Alexander Larsson <alexl@redhat.com>
---
 Documentation/filesystems/overlayfs.rst | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
index 35853906accb..e38b2f5fadaf 100644
--- a/Documentation/filesystems/overlayfs.rst
+++ b/Documentation/filesystems/overlayfs.rst
@@ -492,6 +492,28 @@ directory tree on the same or different underlying filesystem, and even
 to a different machine.  With the "inodes index" feature, trying to mount
 the copied layers will fail the verification of the lower root file handle.
 
+Nesting overlayfs mounts
+------------------------
+
+It is possible to use a lower directory that is stored on an overlayfs
+mount. For regular files this does not need any special care. However, files
+that have overlayfs attributes, such as whiteouts or `overlay.*` xattrs will
+be interpreted by the underlying overlayfs mount and stripped out. In order to
+allow the second overlayfs mount to see the attributes they must be escaped.
+
+Overlayfs specific xattrs are escaped by using a special prefix of
+`overlay.overlay.`. So, a file with a `trusted.overlay.overlay.metacopy` xattr
+in the lower dir will be exposed as a regular file with a
+`trusted.overlay.metacopy` xattr in the overlayfs mount. This can be nested
+by repeating the prefix multiple time, as each instance only removes one
+prefix.
+
+Whiteouts files marked with a `overlay.nowhiteout` xattr will cause overlayfs
+not to treat them as a whiteout. Since this xattr is then stripped out, the
+next layer will instead apply the whiteout.
+
+Files created via overlayfs will automatically be created with the right
+escapes in the upper directory.
 
 Non-standard behavior
 ---------------------
-- 
2.41.0


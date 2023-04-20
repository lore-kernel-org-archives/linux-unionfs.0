Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EA98C77B72
	for <linux-unionfs@archiver.kernel.org>; Thu, 20 Apr 2023 07:45:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234078AbjDTHp2 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 20 Apr 2023 03:45:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233796AbjDTHp0 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 20 Apr 2023 03:45:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 311C840F6
        for <linux-unionfs@vger.kernel.org>; Thu, 20 Apr 2023 00:44:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681976675;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Yc2lxZULYn58CenUOYwswV8KGcYdtVrFtOMSzwTPoS8=;
        b=b+kp8uk3nT/NVL+cem/kMWuFHwN/g3utcfIyRWdqZ54YWfUh0vjErNhzCoD/0zcdEWJJby
        090BWXGBtoC4d3eEFaXSqb7l41M9utVTJDMPMbkHsYxjiKlnSxAfmdzEraeo8VFynWwD7F
        uBh+aURsNZEzeOYZVuPLKrLGVRl+d+A=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-186-L41AFrhjMmGUi30_PGCq0g-1; Thu, 20 Apr 2023 03:44:32 -0400
X-MC-Unique: L41AFrhjMmGUi30_PGCq0g-1
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-4ec893484caso171348e87.0
        for <linux-unionfs@vger.kernel.org>; Thu, 20 Apr 2023 00:44:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681976670; x=1684568670;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Yc2lxZULYn58CenUOYwswV8KGcYdtVrFtOMSzwTPoS8=;
        b=AwY1P5si782U+m5O1qx2VVk2QG41rLm/N4nOGNDMHaFpTzxvSocjKAp3rWuyzgBD8M
         5PEL7WUJpZnBCsjo69EZTVFx13sEGOtWRgaIVqkndvF9KBlCuNEFfYrhKK5YXjJatY4z
         H20hgLmVEVmLIHu+g2NAxiGQnqQthab4HJIQBS885pQUEQAlUOONa8gTmDZ49OhYMMBR
         s02GE9oqZ1m1KpU/hX4A1q46J9+UTfuCZApq40Pz6Xzd64Ef+xmDieZmAdBUttLgU/Dj
         gj1kOEvN0E24r7DXfZmhTE/14zYVCY1uMNGWz38VOCcbgdglmQm6MLgNG36SvXad3NOH
         4XQQ==
X-Gm-Message-State: AAQBX9ch4V1Yx7J81cLA73lwRG6wECaiGAJ23jDth4q24+xoxscuIbyL
        XQSoiTWvPUBuERVdraXDFsnnm51TMrxmtVHQU/rreHks5UN2NKpYBa92XS/BkPhBB8HV3skZIwn
        QBH3IKrrJWG3Q+DW2JaCRdxmm2HhAHOGoOw==
X-Received: by 2002:ac2:5231:0:b0:4ea:e799:59f9 with SMTP id i17-20020ac25231000000b004eae79959f9mr170856lfl.66.1681976670529;
        Thu, 20 Apr 2023 00:44:30 -0700 (PDT)
X-Google-Smtp-Source: AKy350aoNzxZprcxhPPngcf/ZeL3H2MJGJoqA+CYT6LwBxAbI+PaQ610752uc86MLaXt4Egzkfz1wg==
X-Received: by 2002:ac2:5231:0:b0:4ea:e799:59f9 with SMTP id i17-20020ac25231000000b004eae79959f9mr170844lfl.66.1681976670252;
        Thu, 20 Apr 2023 00:44:30 -0700 (PDT)
Received: from localhost.localdomain (c-e6a5e255.022-110-73746f36.bbcust.telenor.se. [85.226.165.230])
        by smtp.googlemail.com with ESMTPSA id x24-20020ac24898000000b004edc7247778sm129468lfc.79.2023.04.20.00.44.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 00:44:29 -0700 (PDT)
From:   Alexander Larsson <alexl@redhat.com>
To:     miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org, amir73il@gmail.com,
        ebiggers@kernel.org, tytso@mit.edu, fsverity@lists.linux.dev,
        Alexander Larsson <alexl@redhat.com>
Subject: [PATCH 3/6] ovl: Break out ovl_entry_path_lowerdata() from ovl_path_lowerdata()
Date:   Thu, 20 Apr 2023 09:44:02 +0200
Message-Id: <69fa1af45ee0f51b50c1ff8a386a57d2842379c9.1681917551.git.alexl@redhat.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1681917551.git.alexl@redhat.com>
References: <cover.1681917551.git.alexl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

This will be needed later when getting the lowerdata path from the
ovl_entry in ovl_lookup() before the dentry is set up.

Signed-off-by: Alexander Larsson <alexl@redhat.com>
---
 fs/overlayfs/overlayfs.h |  1 +
 fs/overlayfs/util.c      | 11 +++++++++--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 477008186d18..3d14770dc711 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -395,6 +395,7 @@ void ovl_path_upper(struct dentry *dentry, struct path *path);
 void ovl_path_lower(struct dentry *dentry, struct path *path);
 void ovl_path_lowerdata(struct dentry *dentry, struct path *path);
 void ovl_i_path_real(struct inode *inode, struct path *path);
+void ovl_entry_path_lowerdata(struct ovl_entry *oe, struct path *path);
 void ovl_entry_path_real(struct ovl_fs *ofs, struct ovl_entry *oe,
 			 struct dentry *upperdentry, struct path *path);
 enum ovl_path_type ovl_path_real(struct dentry *dentry, struct path *path);
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 77c954591daa..17eff3e31239 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -242,9 +242,9 @@ void ovl_path_lower(struct dentry *dentry, struct path *path)
 	}
 }
 
-void ovl_path_lowerdata(struct dentry *dentry, struct path *path)
+void ovl_entry_path_lowerdata(struct ovl_entry *oe,
+			      struct path *path)
 {
-	struct ovl_entry *oe = OVL_E(dentry);
 	struct ovl_path *lowerdata = ovl_lowerdata(oe);
 	struct dentry *lowerdata_dentry = ovl_lowerdata_dentry(oe);
 
@@ -262,6 +262,13 @@ void ovl_path_lowerdata(struct dentry *dentry, struct path *path)
 	}
 }
 
+void ovl_path_lowerdata(struct dentry *dentry, struct path *path)
+{
+	struct ovl_entry *oe = OVL_E(dentry);
+
+	return ovl_entry_path_lowerdata(oe, path);
+}
+
 enum ovl_path_type ovl_path_real(struct dentry *dentry, struct path *path)
 {
 	enum ovl_path_type type = ovl_path_type(dentry);
-- 
2.39.2


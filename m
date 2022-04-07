Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7486EC433FE
	for <linux-unionfs@archiver.kernel.org>; Thu,  7 Apr 2022 11:22:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244763AbiDGLYm (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 7 Apr 2022 07:24:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244774AbiDGLYl (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 7 Apr 2022 07:24:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 971D3206EED
        for <linux-unionfs@vger.kernel.org>; Thu,  7 Apr 2022 04:22:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3191761E51
        for <linux-unionfs@vger.kernel.org>; Thu,  7 Apr 2022 11:22:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7E2DC385A0;
        Thu,  7 Apr 2022 11:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649330560;
        bh=JfrsdHDGLeJqqPTrdqYYeqbl6kEjIABpAg4PlBvwaSs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JhcMhVlfnAzoFzvIFJGbAeGAU2ScazwTDDq+Ywx19boUgZoQ3AlV0DDMKJfQxzbcv
         MbgpkQBFDBK5Jw+wIWT3xB9b7l6wkJS+WxhWfiWSdaEcVEzSupUzw/j5Afay2m5eFH
         U6TWxF3UY5aNisLZUrXj4V1mfYOezVMIDszdQkN21LCGEycPi0PuPPHJRMYPX4YLmX
         cDCf6O6cnmBmtKoxzP81jVaq8Vfp7HttSB4M49FsSdbdakRKjQIQwes1i8Z+B3tFUx
         KHSVEcBFWcwxbGbnvnc1HjUStP7UUIiZNNEdzVtTH9/4wkmbPDK5JuT1lAdm/E6Kw5
         Vy1ODoaTDfimw==
From:   Christian Brauner <brauner@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Cc:     Christian Brauner <brauner@kernel.org>,
        Christoph Hellwig <hch@lst.de>, linux-unionfs@vger.kernel.org,
        Aleksa Sarai <cyphar@cyphar.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Rodrigo Campos Catelin <rodrigo@sdfg.com.ar>,
        Seth Forshee <sforshee@digitalocean.com>,
        Luca Bocassi <luca.boccassi@microsoft.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        =?UTF-8?q?St=C3=A9phane=20Graber?= <stgraber@ubuntu.com>
Subject: [PATCH v5 05/19] ovl: add ovl_upper_mnt_userns() wrapper
Date:   Thu,  7 Apr 2022 13:21:42 +0200
Message-Id: <20220407112157.1775081-6-brauner@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220407112157.1775081-1-brauner@kernel.org>
References: <20220407112157.1775081-1-brauner@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1433; h=from:subject; bh=JfrsdHDGLeJqqPTrdqYYeqbl6kEjIABpAg4PlBvwaSs=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMST5nfS60f/S6XPYlySxOSnFHidkTA6vcWfvmjYzrX36mcvv lubydJSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAExk5g1GhkdH9BdzHLupw6hfvkRr16 VXlZu9IhQSJK69Sdg1mTHUX5bhf5DNHr/fTIrneATS/z2euPWxTjnrFqa96fJPM8wmtjVKswEA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Add a tiny wrapper to retrieve the upper mount's idmapping. Have it
return the initial idmapping until we have prepared and converted all
places to take the relevant idmapping into account. Then we can switch
on idmapped layer support by having ovl_upper_mnt_userns() return the
upper mount's idmapping.

Suggested-by: Miklos Szeredi <mszeredi@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
---
/* v2 */
- Miklos Szeredi <mszeredi@redhat.com>:
  - Add separate patch for ovl_upper_idmap() and have it return the
    initial idmapping until we turn idmapped layer support on later.

/* v3 */
unchanged

/* v4 */
- Vivek Goyal <vgoyal@redhat.com>:
  - s/ovl_upper_idmap()/ovl_upper_mnt_userns()/g

/* v5 */
unchanged
---
 fs/overlayfs/ovl_entry.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 63efee554f69..1c6495bc6bb3 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -90,6 +90,11 @@ static inline struct vfsmount *ovl_upper_mnt(struct ovl_fs *ofs)
 	return ofs->layers[0].mnt;
 }
 
+static inline struct user_namespace *ovl_upper_mnt_userns(struct ovl_fs *ofs)
+{
+       return &init_user_ns;
+}
+
 static inline struct ovl_fs *OVL_FS(struct super_block *sb)
 {
 	return (struct ovl_fs *)sb->s_fs_info;
-- 
2.32.0


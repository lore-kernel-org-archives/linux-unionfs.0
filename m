Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACACAC433F5
	for <linux-unionfs@archiver.kernel.org>; Mon,  4 Apr 2022 10:53:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358615AbiDDKzg (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 4 Apr 2022 06:55:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358537AbiDDKzd (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 4 Apr 2022 06:55:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C11D14006
        for <linux-unionfs@vger.kernel.org>; Mon,  4 Apr 2022 03:53:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 10ACA60AE6
        for <linux-unionfs@vger.kernel.org>; Mon,  4 Apr 2022 10:53:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3B44C2BBE4;
        Mon,  4 Apr 2022 10:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649069615;
        bh=spUQdU8Xg5bMpt9inwLiwjVEElJmbeYmA5vu9tZlRX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cUGDgyFLQ0HkfDNN+pvChzC704EapouU57/QEF8/T381LZLI2E4zIDUVyZTi8Gl0X
         VrmSfCHf0QV6V3ex6tnUqEu6tDzOcjVrwPghkDdU08k98MFd09MGDXAberl+q7/6Vj
         LeN7292SjtOH3/fKZNOkKn7ggRR3YKVRQfV2dyjZgyxPNk6zkmw0dQX3cJmuW08KNT
         AyCS1s7tSB0A3kmuFhu3KyB0QJcY9jf0Q08sAuwIPV70h2MvcTWHWjzr+7zUN0yrsz
         865ZAqPH1Vf4T2pFD94Ansfv0UyibhoOBabtAV0typpHHccuxk/p41twlBoahPClQ3
         IIwIgZ1s4MitA==
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
Subject: [PATCH v4 05/19] ovl: add ovl_upper_mnt_userns() wrapper
Date:   Mon,  4 Apr 2022 12:51:44 +0200
Message-Id: <20220404105159.1567595-6-brauner@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220404105159.1567595-1-brauner@kernel.org>
References: <20220404105159.1567595-1-brauner@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1410; h=from:subject; bh=spUQdU8Xg5bMpt9inwLiwjVEElJmbeYmA5vu9tZlRX8=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSR5nT1s4ie47FRcuSXfnHrO1288w5Mqn/tevGy/8E21tsY+ GW2fjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIkI1jMyPBPYbmBieGTtMSuHexVi32 cs3Psj+LTyhWNRzYLbD1nE/2ZkWBJ47IXVR4580zuTnydkCU0q1dn5cOvNk1PjjLf87HwczgQA
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


Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XLS8CBnk"
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF9F3BC;
	Mon, 11 Dec 2023 23:33:30 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id 5b1f17b1804b1-40c256ffdbcso55444045e9.2;
        Mon, 11 Dec 2023 23:33:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702366409; x=1702971209; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TaWj0OBxqONKTzk/JlejSBLnZzQoiI0qKl8xxPiImZc=;
        b=XLS8CBnkiRyxm1AmZnizd3DwIugprJcrdn7kfSqPK0bYNkcETSW1JrO9mFO/1fIwxc
         XmcA0gG97g4V/w2sGDnr+aaoFIzgnKIy+gamkiTfG1x6/x+2mB22bhYtfNXI876Urbpd
         KffSpVwrQZGznjwgPQkbe16vOH2ag1mwGgrT0mjvDxtjBKZpKbvKbEYUrsespyRrKTRG
         Kg0kB+MXqDJvE1eYXBSD5hILlXy+0rvWJU1buTXQb77UoISKKHDcNI7bWLbnx0Nses5V
         vOcLWG5Jkml1ddXv1LdYsboMdpqkzjo+jU56y0X7tn0oIrbtoQS8AckAilw9AJJXzTVe
         BGKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702366409; x=1702971209;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TaWj0OBxqONKTzk/JlejSBLnZzQoiI0qKl8xxPiImZc=;
        b=ZCVfS+nYEs8hN1PWiz7PItDpsGqvXgf3bNjrZZpga/NxY8Oak8yYfzUspp9AVne7f+
         xNvpaP8eM3ibTgxiRzIq8ZOMdEXP1v73H/8w+Ja2WSMyyihD5CdhmEc18/iuIKhjt5aS
         02loTUmQoZqZpycEP+Wj3nKnVVhLumH5PA+lg3NK69ZFzHDeSi1pp/ZRt1o+manFZXpV
         djQDaPkV2QnyHHrUtIRJP4YwsimX2gKn1aBA+ckW936OOTEIQM3tMy0IAyWLtVwP8I4K
         Vn+k/v7+QosMZ+IMBiHj33H46zlQvMKfOoSA3LZ8eCfUo1u21prkJDjyLZsrV3K0Ad85
         Xr0w==
X-Gm-Message-State: AOJu0YwJd2RwCs1B6TiHwhsnP2qhSdn1ahqJ1H7npTaa4ORLrEtyryPL
	AiDSr01CtIER8c/okOxFCW8=
X-Google-Smtp-Source: AGHT+IG6QROtEa64iSc8Kmk/sLIiDujvcgjOCKaYwe1MrPPY9J5r3WyPrS/aObek5p7Dk49hIgPMwA==
X-Received: by 2002:a05:600c:54c1:b0:40c:2501:6076 with SMTP id iw1-20020a05600c54c100b0040c25016076mr2864563wmb.58.1702366408720;
        Mon, 11 Dec 2023 23:33:28 -0800 (PST)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id l15-20020a05600c1d0f00b003feae747ff2sm17896319wms.35.2023.12.11.23.33.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Dec 2023 23:33:28 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Christian Brauner <brauner@kernel.org>,
	linux-unionfs@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: [PATCH 1/2] overlayfs.rst: use consistent terminology
Date: Tue, 12 Dec 2023 09:33:23 +0200
Message-Id: <20231212073324.245541-2-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231212073324.245541-1-amir73il@gmail.com>
References: <20231212073324.245541-1-amir73il@gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use the feature names "metacopy" and "index" consistently throughout
the document.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 Documentation/filesystems/overlayfs.rst | 27 ++++++++++++++-----------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
index 0407f361f32a..926396fdc5eb 100644
--- a/Documentation/filesystems/overlayfs.rst
+++ b/Documentation/filesystems/overlayfs.rst
@@ -39,7 +39,7 @@ objects in the original filesystem.
 On 64bit systems, even if all overlay layers are not on the same
 underlying filesystem, the same compliant behavior could be achieved
 with the "xino" feature.  The "xino" feature composes a unique object
-identifier from the real object st_ino and an underlying fsid index.
+identifier from the real object st_ino and an underlying fsid number.
 The "xino" feature uses the high inode number bits for fsid, because the
 underlying filesystems rarely use the high inode number bits.  In case
 the underlying inode number does overflow into the high xino bits, overlay
@@ -356,7 +356,7 @@ as an octal characters (\072) when displayed in /proc/self/mountinfo.
 Metadata only copy up
 ---------------------
 
-When metadata only copy up feature is enabled, overlayfs will only copy
+When the "metacopy" feature is enabled, overlayfs will only copy
 up metadata (as opposed to whole file), when a metadata specific operation
 like chown/chmod is performed. Full file will be copied up later when
 file is opened for WRITE operation.
@@ -492,27 +492,27 @@ though it will not result in a crash or deadlock.
 
 Mounting an overlay using an upper layer path, where the upper layer path
 was previously used by another mounted overlay in combination with a
-different lower layer path, is allowed, unless the "inodes index" feature
-or "metadata only copy up" feature is enabled.
+different lower layer path, is allowed, unless the "index" or "metacopy"
+features are enabled.
 
-With the "inodes index" feature, on the first time mount, an NFS file
+With the "index" feature, on the first time mount, an NFS file
 handle of the lower layer root directory, along with the UUID of the lower
 filesystem, are encoded and stored in the "trusted.overlay.origin" extended
 attribute on the upper layer root directory.  On subsequent mount attempts,
 the lower root directory file handle and lower filesystem UUID are compared
 to the stored origin in upper root directory.  On failure to verify the
 lower root origin, mount will fail with ESTALE.  An overlayfs mount with
-"inodes index" enabled will fail with EOPNOTSUPP if the lower filesystem
+"index" enabled will fail with EOPNOTSUPP if the lower filesystem
 does not support NFS export, lower filesystem does not have a valid UUID or
 if the upper filesystem does not support extended attributes.
 
-For "metadata only copy up" feature there is no verification mechanism at
+For the "metacopy" feature, there is no verification mechanism at
 mount time. So if same upper is mounted with different set of lower, mount
 probably will succeed but expect the unexpected later on. So don't do it.
 
 It is quite a common practice to copy overlay layers to a different
 directory tree on the same or different underlying filesystem, and even
-to a different machine.  With the "inodes index" feature, trying to mount
+to a different machine.  With the "index" feature, trying to mount
 the copied layers will fail the verification of the lower root file handle.
 
 Nesting overlayfs mounts
@@ -560,7 +560,8 @@ file for write or truncating the file will not be denied with ETXTBSY.
 The following options allow overlayfs to act more like a standards
 compliant filesystem:
 
-1) "redirect_dir"
+redirect_dir
+````````````
 
 Enabled with the mount option or module option: "redirect_dir=on" or with
 the kernel config option CONFIG_OVERLAY_FS_REDIRECT_DIR=y.
@@ -568,7 +569,8 @@ the kernel config option CONFIG_OVERLAY_FS_REDIRECT_DIR=y.
 If this feature is disabled, then rename(2) on a lower or merged directory
 will fail with EXDEV ("Invalid cross-device link").
 
-2) "inode index"
+index
+`````
 
 Enabled with the mount option or module option "index=on" or with the
 kernel config option CONFIG_OVERLAY_FS_INDEX=y.
@@ -577,7 +579,8 @@ If this feature is disabled and a file with multiple hard links is copied
 up, then this will "break" the link.  Changes will not be propagated to
 other names referring to the same inode.
 
-3) "xino"
+xino
+````
 
 Enabled with the mount option "xino=auto" or "xino=on", with the module
 option "xino_auto=on" or with the kernel config option
@@ -604,7 +607,7 @@ a crash or deadlock.
 
 Offline changes, when the overlay is not mounted, are allowed to the
 upper tree.  Offline changes to the lower tree are only allowed if the
-"metadata only copy up", "inode index", "xino" and "redirect_dir" features
+"metacopy", "index", "xino" and "redirect_dir" features
 have not been used.  If the lower tree is modified and any of these
 features has been used, the behavior of the overlay is undefined,
 though it will not result in a crash or deadlock.
-- 
2.34.1


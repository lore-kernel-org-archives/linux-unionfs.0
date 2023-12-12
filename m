Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MmE75n3d"
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EB18BE;
	Mon, 11 Dec 2023 23:33:32 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id 5b1f17b1804b1-40c41df5577so22982355e9.0;
        Mon, 11 Dec 2023 23:33:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702366410; x=1702971210; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RibkXoWBTp93W+AGk43zCCrx+wIcjVmNc/4L0LjyHiY=;
        b=MmE75n3dIu8o0fT9rAOC17PnK9NnJkN7j3xzd1ABdIY139ETA9ZK5UXN2Wx9/Hsduk
         B8W/mIG88R+xH/PgIs1jZGtqTjexNr7OAKK+sfNbm96Ro6yVE7nsRpb5lj2ZUmcWjVo9
         TJK6z6H+LedujKCzjIFifbLDrv0LQ9z3Sf6wsrCuHZGRolwYuXxn4CvgpMQmGtedklY0
         9w3nsUtBC2/Xoh44RiaMpyK+Qjxq4SmmJWwuFcPenPt7BOOsM2CbKWwV5FtsB1DBNXtv
         7q8d2WvwOarmWvJ3WQKCcI2JgtlS73sXpAUoE7Q2ejJHVmIfd8Q2B+FyOrooBww85pi0
         DwYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702366410; x=1702971210;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RibkXoWBTp93W+AGk43zCCrx+wIcjVmNc/4L0LjyHiY=;
        b=e3sua5KA0Pu1RoNA7o5HdvKzfLE4WS1yTYFyo919NG1eEkmwZBCaWvhm1kIsgdZ7DU
         fFSjLd0QH2PU2L6XkK8IVw4rziPli6Cri/iANUMNhWMz+fKBa49xy4h0yvd0Cnr/psxl
         1I1hpcO22RokV/x+hAlOZBo/4UnKvu6I/QbNbKKspn0b8yy/+5ZtHhsJRYFUK+RiRgcU
         iK2G3vXvfklhMdTizy3T2ALP4XW+wiri6BWNMRgtD9MLHFwpYrRJSfNAsmtzgSn7q8FU
         3GNladQlAeH9NGu77YxAQt+ASWmLxafm24MuO9gM7/8Zohvg70gqYLk5tioUQwePPn8+
         ogJA==
X-Gm-Message-State: AOJu0YwHABg8lBKLNTeULWo2YQ3UZaqkAaQWZbF+l+1c2vEZTM6YF19m
	VVsvGBd97aQBIDUTyH08Z9fNiD0Tt/8=
X-Google-Smtp-Source: AGHT+IHoBc9lKgy+FkFhSLMYv7TNNT6NkrTCQC1AYkL+LyRSTdhmu+FixmzZBgQ/o5bat8o3YvxM/g==
X-Received: by 2002:a7b:cc84:0:b0:40c:1da3:363f with SMTP id p4-20020a7bcc84000000b0040c1da3363fmr1418044wma.348.1702366410298;
        Mon, 11 Dec 2023 23:33:30 -0800 (PST)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id l15-20020a05600c1d0f00b003feae747ff2sm17896319wms.35.2023.12.11.23.33.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Dec 2023 23:33:29 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Christian Brauner <brauner@kernel.org>,
	linux-unionfs@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: [PATCH 2/2] overlayfs.rst: fix ReST formatting
Date: Tue, 12 Dec 2023 09:33:24 +0200
Message-Id: <20231212073324.245541-3-amir73il@gmail.com>
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

Fix some indentation issues and missing newlines in quoted text.

Unindent a) b) enumerated list to workaround github displaying it
as numbered list.

Reported-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 Documentation/filesystems/overlayfs.rst | 69 +++++++++++++------------
 1 file changed, 35 insertions(+), 34 deletions(-)

diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
index 926396fdc5eb..37467ad5cff4 100644
--- a/Documentation/filesystems/overlayfs.rst
+++ b/Documentation/filesystems/overlayfs.rst
@@ -174,10 +174,10 @@ programs.
 seek offsets are assigned sequentially when the directories are read.
 Thus if
 
-  - read part of a directory
-  - remember an offset, and close the directory
-  - re-open the directory some time later
-  - seek to the remembered offset
+- read part of a directory
+- remember an offset, and close the directory
+- re-open the directory some time later
+- seek to the remembered offset
 
 there may be little correlation between the old and new locations in
 the list of filenames, particularly if anything has changed in the
@@ -285,21 +285,21 @@ Permission model
 
 Permission checking in the overlay filesystem follows these principles:
 
- 1) permission check SHOULD return the same result before and after copy up
+1) permission check SHOULD return the same result before and after copy up
 
- 2) task creating the overlay mount MUST NOT gain additional privileges
+2) task creating the overlay mount MUST NOT gain additional privileges
 
- 3) non-mounting task MAY gain additional privileges through the overlay,
- compared to direct access on underlying lower or upper filesystems
+3) non-mounting task MAY gain additional privileges through the overlay,
+   compared to direct access on underlying lower or upper filesystems
 
-This is achieved by performing two permission checks on each access
+This is achieved by performing two permission checks on each access:
 
- a) check if current task is allowed access based on local DAC (owner,
-    group, mode and posix acl), as well as MAC checks
+a) check if current task is allowed access based on local DAC (owner,
+group, mode and posix acl), as well as MAC checks
 
- b) check if mounting task would be allowed real operation on lower or
-    upper layer based on underlying filesystem permissions, again including
-    MAC checks
+b) check if mounting task would be allowed real operation on lower or
+upper layer based on underlying filesystem permissions, again including
+MAC checks
 
 Check (a) ensures consistency (1) since owner, group, mode and posix acls
 are copied up.  On the other hand it can result in server enforced
@@ -311,14 +311,14 @@ to create setups where the consistency rule (1) does not hold; normally,
 however, the mounting task will have sufficient privileges to perform all
 operations.
 
-Another way to demonstrate this model is drawing parallels between
+Another way to demonstrate this model is drawing parallels between:
 
-  mount -t overlay overlay -olowerdir=/lower,upperdir=/upper,... /merged
+ mount -t overlay overlay -olowerdir=/lower,upperdir=/upper,... /merged
 
-and
+and:
 
-  cp -a /lower /upper
-  mount --bind /upper /merged
+ |  cp -a /lower /upper
+ |  mount --bind /upper /merged
 
 The resulting access permissions should be the same.  The difference is in
 the time of copy (on-demand vs. up-front).
@@ -390,11 +390,11 @@ Data-only lower layers
 With "metacopy" feature enabled, an overlayfs regular file may be a composition
 of information from up to three different layers:
 
- 1) metadata from a file in the upper layer
+1) metadata from a file in the upper layer
 
- 2) st_ino and st_dev object identifier from a file in a lower layer
+2) st_ino and st_dev object identifier from a file in a lower layer
 
- 3) data from a file in another lower layer (further below)
+3) data from a file in another lower layer (further below)
 
 The "lower data" file can be on any lower layer, except from the top most
 lower layer.
@@ -421,15 +421,15 @@ Since kernel version v6.8, "data-only" lower layers can also be added using
 the "datadir+" mount options and the fsconfig syscall from new mount api.
 For example:
 
-  fsconfig(fs_fd, FSCONFIG_SET_STRING, "lowerdir+", "/l1", 0);
-  fsconfig(fs_fd, FSCONFIG_SET_STRING, "lowerdir+", "/l2", 0);
-  fsconfig(fs_fd, FSCONFIG_SET_STRING, "lowerdir+", "/l3", 0);
-  fsconfig(fs_fd, FSCONFIG_SET_STRING, "datadir+", "/do1", 0);
-  fsconfig(fs_fd, FSCONFIG_SET_STRING, "datadir+", "/do2", 0);
+ |  fsconfig(fs_fd, FSCONFIG_SET_STRING, "lowerdir+", "/l1", 0);
+ |  fsconfig(fs_fd, FSCONFIG_SET_STRING, "lowerdir+", "/l2", 0);
+ |  fsconfig(fs_fd, FSCONFIG_SET_STRING, "lowerdir+", "/l3", 0);
+ |  fsconfig(fs_fd, FSCONFIG_SET_STRING, "datadir+", "/do1", 0);
+ |  fsconfig(fs_fd, FSCONFIG_SET_STRING, "datadir+", "/do2", 0);
 
 
 fs-verity support
-----------------------
+-----------------
 
 During metadata copy up of a lower file, if the source file has
 fs-verity enabled and overlay verity support is enabled, then the
@@ -653,9 +653,10 @@ following rules apply:
    encode an upper file handle from upper inode
 
 The encoded overlay file handle includes:
- - Header including path type information (e.g. lower/upper)
- - UUID of the underlying filesystem
- - Underlying filesystem encoding of underlying inode
+
+- Header including path type information (e.g. lower/upper)
+- UUID of the underlying filesystem
+- Underlying filesystem encoding of underlying inode
 
 This encoding format is identical to the encoding format file handles that
 are stored in extended attribute "trusted.overlay.origin".
@@ -773,9 +774,9 @@ Testsuite
 There's a testsuite originally developed by David Howells and currently
 maintained by Amir Goldstein at:
 
-  https://github.com/amir73il/unionmount-testsuite.git
+https://github.com/amir73il/unionmount-testsuite.git
 
 Run as root:
 
-  # cd unionmount-testsuite
-  # ./run --ov --verify
+ |  # cd unionmount-testsuite
+ |  # ./run --ov --verify
-- 
2.34.1


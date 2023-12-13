Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YLaVgFaN"
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93149A4;
	Wed, 13 Dec 2023 04:34:30 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id 5b1f17b1804b1-40c1e3ea2f2so67829405e9.2;
        Wed, 13 Dec 2023 04:34:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702470869; x=1703075669; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yZ45IGtFcf256qIFlvb8gTvExCvSVib7FOwEtozA1GU=;
        b=YLaVgFaNIGRo0ITxbivcXmCSBLDTU+v+pcKN6n4UDl4erAREDNDOpwdgAGQzBEvXVo
         vvqArlUm5GPJrltR1E9TTbu0d3hVBXzwWwCbfxCpCIPn7oE5N3L9s8X7ezUC6pny4JDF
         uZ6YRJ1w5dE8HU12rba8L5wjJGSBkTeQJMQ0AI1c/sjWhMAdgiGQ2k4vrjKlDLa83rp7
         4m3LbNucBLUsH7DIBqtRTdShdPSpO1o9NRuW8PSmkmncYN6T+Zmu0iBXlbZhF4xDbzW4
         YBv2o4wkFS8MGEdTzo/49no6Fs+ompVuHRQVNZUqulA76ZbWkS+gSM4nFa+TSCUHqmrh
         0Dyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702470869; x=1703075669;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yZ45IGtFcf256qIFlvb8gTvExCvSVib7FOwEtozA1GU=;
        b=qGQQPcm9DnMM2NLq0ZEwJCxQ3YhJB7ITJY85FoeKrP4Hhm5Fi1LXzAxWF0H5/vJXDf
         Xd/elS5C6e/8kJDER/FZS4rFxL/BjcmFLyiey+4+GXQnr1CKvLrt4JKrBvcdnsw5ePk5
         oWUQWGjattZF3HHOCum9D16xOjtCBe5B6WisZR8c8p/BnEFphvrOzDl4tC7fxOxn8rXg
         F85jWYkHaru/FBWkbOmGlZnlL6+ELR1Drf3YZwpAMx3S3Os26drc2RUWP0oqPBxP/ZUq
         Uy9foHl7jxI8N+Ce29ar5RVSJaI70ZLwDCPud8kEyjsilwyjvcCEhvgTaxMvgt00Mvw0
         4YKA==
X-Gm-Message-State: AOJu0YwfrsZX224KiPG/nyzOV0tD+6RchP9h3B9KJ9AqLBtOgZjJHBp0
	mTXdCPNHSCTwi/Fe24JzU+U=
X-Google-Smtp-Source: AGHT+IHHtIwE0wxpct4aDH570GKlg+p+F35YhyYKd0vMn8Q3WqyAFwdBlTUe12/E9LdnhGLBvWo6lw==
X-Received: by 2002:a05:600c:3b26:b0:40c:34c1:45e1 with SMTP id m38-20020a05600c3b2600b0040c34c145e1mr4304943wms.38.1702470868750;
        Wed, 13 Dec 2023 04:34:28 -0800 (PST)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id fc7-20020a05600c524700b0040c44cb251dsm12667926wmb.46.2023.12.13.04.34.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Dec 2023 04:34:27 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Christian Brauner <brauner@kernel.org>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	linux-unionfs@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: [PATCH v2 2/2] overlayfs.rst: fix ReST formatting
Date: Wed, 13 Dec 2023 14:34:22 +0200
Message-Id: <20231213123422.344600-3-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231213123422.344600-1-amir73il@gmail.com>
References: <20231213123422.344600-1-amir73il@gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix some indentation issues and fix missing newlines in quoted text
by converting quoted text to code blocks.

Unindent a) b) enumerated list to workaround github displaying it
as numbered list.

Reported-by: Christian Brauner <brauner@kernel.org>
Suggested-by: Bagas Sanjaya <bagasdotme@gmail.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 Documentation/filesystems/overlayfs.rst | 63 +++++++++++++------------
 1 file changed, 32 insertions(+), 31 deletions(-)

diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
index 926396fdc5eb..a36f3a2a2d4b 100644
--- a/Documentation/filesystems/overlayfs.rst
+++ b/Documentation/filesystems/overlayfs.rst
@@ -118,7 +118,7 @@ Where both upper and lower objects are directories, a merged directory
 is formed.
 
 At mount time, the two directories given as mount options "lowerdir" and
-"upperdir" are combined into a merged directory:
+"upperdir" are combined into a merged directory::
 
   mount -t overlay overlay -olowerdir=/lower,upperdir=/upper,\
   workdir=/work /merged
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
@@ -311,11 +311,11 @@ to create setups where the consistency rule (1) does not hold; normally,
 however, the mounting task will have sufficient privileges to perform all
 operations.
 
-Another way to demonstrate this model is drawing parallels between
+Another way to demonstrate this model is drawing parallels between::
 
   mount -t overlay overlay -olowerdir=/lower,upperdir=/upper,... /merged
 
-and
+and::
 
   cp -a /lower /upper
   mount --bind /upper /merged
@@ -328,7 +328,7 @@ Multiple lower layers
 ---------------------
 
 Multiple lower layers can now be given using the colon (":") as a
-separator character between the directory names.  For example:
+separator character between the directory names.  For example::
 
   mount -t overlay overlay -olowerdir=/lower1:/lower2:/lower3 /merged
 
@@ -340,13 +340,13 @@ rightmost one and going left.  In the above example lower1 will be the
 top, lower2 the middle and lower3 the bottom layer.
 
 Note: directory names containing colons can be provided as lower layer by
-escaping the colons with a single backslash.  For example:
+escaping the colons with a single backslash.  For example::
 
   mount -t overlay overlay -olowerdir=/a\:lower\:\:dir /merged
 
 Since kernel version v6.8, directory names containing colons can also
 be configured as lower layer using the "lowerdir+" mount options and the
-fsconfig syscall from new mount api.  For example:
+fsconfig syscall from new mount api.  For example::
 
   fsconfig(fs_fd, FSCONFIG_SET_STRING, "lowerdir+", "/a:lower::dir", 0);
 
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
@@ -405,7 +405,7 @@ A normal lower layer is not allowed to be below a data-only layer, so single
 colon separators are not allowed to the right of double colon ("::") separators.
 
 
-For example:
+For example::
 
   mount -t overlay overlay -olowerdir=/l1:/l2:/l3::/do1::/do2 /merged
 
@@ -419,7 +419,7 @@ to the absolute path of the "lower data" file in the "data-only" lower layer.
 
 Since kernel version v6.8, "data-only" lower layers can also be added using
 the "datadir+" mount options and the fsconfig syscall from new mount api.
-For example:
+For example::
 
   fsconfig(fs_fd, FSCONFIG_SET_STRING, "lowerdir+", "/l1", 0);
   fsconfig(fs_fd, FSCONFIG_SET_STRING, "lowerdir+", "/l2", 0);
@@ -429,7 +429,7 @@ For example:
 
 
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
 
-Run as root:
+Run as root::
 
   # cd unionmount-testsuite
   # ./run --ov --verify
-- 
2.34.1


Return-Path: <SRS0=gqkc=57=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EA62C2BA19
	for <linux-unionfs@archiver.kernel.org>; Wed, 15 Apr 2020 12:03:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 200A920575
	for <linux-unionfs@archiver.kernel.org>; Wed, 15 Apr 2020 12:03:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="szBFFHXa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368264AbgDOMDj (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 15 Apr 2020 08:03:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S368173AbgDOMBq (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 15 Apr 2020 08:01:46 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADF46C061A0F
        for <linux-unionfs@vger.kernel.org>; Wed, 15 Apr 2020 05:01:45 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id t14so5565934wrw.12
        for <linux-unionfs@vger.kernel.org>; Wed, 15 Apr 2020 05:01:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=QvjRJW1eMluf/Un3MyFVLtiJyygih6w8KJ4WG6oU5ho=;
        b=szBFFHXa0s1dD2gSZkxoAEYFgGeXCXBLVV87dgMrDqKd3rOU8MLyqQ/jqtRUCj/Em6
         UHjjDa7q5pqxAukGtL2LHkH7wzuL8PtBKIGHFuRII31rKhIKc9bDSqMQe5J0p8jaaa0P
         5ariY5be2e2e+zdeeGGP0bZZYeEJzgZVWQkSDSeKxYs9p3NHcvLwa+lFJTA6PDSGEzKR
         ioHTRHASKbTLe7wzQVOaero02j6xlTgFLAVOKzrA5/SWZGYF9us4qLxDmYV7TUhZVXhj
         Ic4lhmIaQw7R1gdk9fgV++Dt098lsacp3zvhRSFQESt1GyyRSDEgy3AyOvHP7Dcm9NXV
         4kwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=QvjRJW1eMluf/Un3MyFVLtiJyygih6w8KJ4WG6oU5ho=;
        b=csEUYC6JWOyclQdDa7iC4hfcAKUgnOD4CaSO2lTYYDf+0dUru4QxH3mhfY8dek7ngo
         RCplmhaskrpU+oafcUVXuroSDtfHAwY5XK/IshHu3cIAtVA3H+vg7p4hI5BSVrgTqEAy
         YWEUK2i9G3pHCKKzLwHFWsmgR7OJpY4wPLYJMWmEVv05HXuKpm2mr9BDIibeW0Uv0fgz
         lgNz4+Qeg9+jB47o60C8wDtWSJXrl0yJBbz4QsdRQZEGluNGBjucNr82qvIk+SLE6Zwr
         eofxOYcWL2xNv621eziwZdfBa3pLuV7soxZFQ6FiujYJIjlwXDB5dxQYGdqzWjrh0bGn
         kV6w==
X-Gm-Message-State: AGi0PualpZuDK0+pHEG/w9OsKrOKCrCAAqNfatk4lAMaEFHLddi8gpex
        U4Mjh5upibmunarEjYrb+dM=
X-Google-Smtp-Source: APiQypLYeBINJcgCDT3yyhtj5tizf6eYacwnHwE0T6stdj8IAE/7nQyEhPDvkSv8RRSQipaXCSAl9w==
X-Received: by 2002:adf:ea05:: with SMTP id q5mr31007532wrm.180.1586952103732;
        Wed, 15 Apr 2020 05:01:43 -0700 (PDT)
Received: from localhost.localdomain ([141.226.12.123])
        by smtp.gmail.com with ESMTPSA id h137sm17578238wme.0.2020.04.15.05.01.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2020 05:01:43 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     Giuseppe Scrivano <gscrivan@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        linux-unionfs@vger.kernel.org
Subject: [PATCH 2/2] Configure custom layers via environment variables
Date:   Wed, 15 Apr 2020 15:01:34 +0300
Message-Id: <20200415120134.28154-3-amir73il@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200415120134.28154-1-amir73il@gmail.com>
References: <20200415120134.28154-1-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

The following environment variables are supported:

 UNIONMOUNT_BASEDIR  - base dir for --samefs (default: /base)
 UNIONMOUNT_UPPERDIR - upper layer root path (default: /upper)
 UNIONMOUNT_LOWERDIR - lower layer root path (default: /lower)
 UNIONMOUNT_MNTPOINT - mount point for tests (default: /mnt)

User provided paths for base/lower/upper should point at a pre-mounted
filesystem, whereas tmpfs instances will be created on default paths.

This is going to be used for running unionmount tests from xfstests.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 README      | 11 +++++++++++
 run         |  3 ++-
 settings.py | 51 ++++++++++++++++++++++++++++++---------------------
 3 files changed, 43 insertions(+), 22 deletions(-)

diff --git a/README b/README
index c352878..616135f 100644
--- a/README
+++ b/README
@@ -47,5 +47,16 @@ To run these tests:
 	./run --ov --fuse=<subfs-type>
 
 
+The following environment variables are supported:
+
+     UNIONMOUNT_BASEDIR  - base dir for --samefs (default: /base)
+     UNIONMOUNT_UPPERDIR - upper layer root path (default: /upper)
+     UNIONMOUNT_LOWERDIR - lower layer root path (default: /lower)
+     UNIONMOUNT_MNTPOINT - mount point for tests (default: /mnt)
+
+     User provided paths for base/lower/upper should point at a pre-mounted
+     filesystem, whereas tmpfs instances will be created on default paths.
+
+
 For more advanced overlayfs test options and more examples, see:
      https://github.com/amir73il/overlayfs/wiki/Overlayfs-testing
diff --git a/run b/run
index e6262b8..60d5d0d 100755
--- a/run
+++ b/run
@@ -20,10 +20,11 @@ def show_format(why):
     print("\t", sys.argv[0], "--<fsop> <file> [<args>*] [-aLlv] [-R <content>] [-B] [-E <err>]")
     sys.exit(2)
 
+cfg = config(sys.argv[0])
+
 if len(sys.argv) < 2:
     show_format("Insufficient arguments")
 
-cfg = config(sys.argv[0])
 args = sys.argv[1:]
 
 ###############################################################################
diff --git a/settings.py b/settings.py
index ced9cae..f065494 100644
--- a/settings.py
+++ b/settings.py
@@ -20,15 +20,27 @@ along with this program; if not, write to the Free Software
 Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 """
 
+import os
+
 class config:
     def __init__(self, progname):
         self.__progname = progname
         self.__testing_overlayfs = False
         self.__testing_none = False
-        self.__base_mntroot = None
-        self.__lower_mntroot = None
-        self.__upper_mntroot = None
-        self.__union_mntroot = None
+        self.__base_mntroot = os.getenv('UNIONMOUNT_BASEDIR')
+        self.__lower_mntroot = os.getenv('UNIONMOUNT_LOWERDIR')
+        self.__upper_mntroot = os.getenv('UNIONMOUNT_UPPERDIR')
+        self.__union_mntroot = os.getenv('UNIONMOUNT_MNTPOINT')
+        print("Environment variables:")
+        if self.__base_mntroot:
+            print("UNIONMOUNT_BASEDIR=" + self.__base_mntroot)
+        if self.__lower_mntroot:
+            print("UNIONMOUNT_LOWERDIR=" + self.__lower_mntroot)
+        if self.__upper_mntroot:
+            print("UNIONMOUNT_UPPERDIR=" + self.__upper_mntroot)
+        if self.__union_mntroot:
+            print("UNIONMOUNT_MNTPOINT=" + self.__union_mntroot)
+        print()
         self.__verbose = False
         self.__verify = False
         self.__maxfs = 0
@@ -50,49 +62,46 @@ class config:
         return self.__testing_overlayfs
 
     def set_testing_none(self):
-        self.__lower_mntroot = "/lower"
-        self.__union_mntroot = "/mnt"
         self.__testing_none = True
 
     def set_testing_overlayfs(self):
-        self.__base_mntroot = "/base"
-        self.__lower_mntroot = "/lower"
-        self.__upper_mntroot = "/upper"
-        self.__union_mntroot = "/mnt"
         self.__testing_overlayfs = True
 
     # base dir is mounted only for --ov --samefs
+    # A user provided base dir should already be mounted
     def should_mount_base(self):
-        return self.testing_overlayfs() and self.is_samefs()
+        return self.__base_mntroot is None and self.testing_overlayfs() and self.is_samefs()
     def base_mntroot(self):
-        return self.__base_mntroot
+        return self.__base_mntroot or "/base"
     # lower dir is mounted ro for --ov (without --samefs) ...
     def should_mount_lower_ro(self):
-        return self.testing_overlayfs() and not self.is_samefs()
+        return self.__lower_mntroot is None and self.testing_overlayfs() and not self.is_samefs()
     # ... and mounted rw for --no
+    # A user provided lower dir should already be mounted
     def should_mount_lower_rw(self):
-        return self.testing_none()
+        return self.__lower_mntroot is None and self.testing_none()
     def should_mount_lower(self):
         return self.should_mount_lower_ro() or self.should_mount_lower_rw()
     def set_lower_mntroot(self, path):
         self.__lower_mntroot = path
     def lower_mntroot(self):
-        return self.__lower_mntroot
+        return self.__lower_mntroot or "/lower"
     # upper dir is mounted for --ov (without --samefs)
+    # A user provided upper dir should already be mounted
     def should_mount_upper(self):
-        return self.testing_overlayfs() and not self.is_samefs()
+        return self.__upper_mntroot is None and self.testing_overlayfs() and not self.is_samefs()
     def set_upper_mntroot(self, path):
         self.__upper_mntroot = path
     def upper_mntroot(self):
-        return self.__upper_mntroot
+        return self.__upper_mntroot or "/upper"
     def union_mntroot(self):
-        return self.__union_mntroot
+        return self.__union_mntroot or "/mnt"
     def lowerdir(self):
-        return self.__lower_mntroot + "/a"
+        return self.lower_mntroot() + "/a"
     def lowerimg(self):
-        return self.__lower_mntroot + "/a.img"
+        return self.lower_mntroot() + "/a.img"
     def testdir(self):
-        return self.__union_mntroot + "/a"
+        return self.union_mntroot() + "/a"
 
     def set_verbose(self, to=True):
         self.__verbose = to
-- 
2.17.1


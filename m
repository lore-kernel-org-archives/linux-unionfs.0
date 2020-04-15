Return-Path: <SRS0=gqkc=57=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E8A5C2BA19
	for <linux-unionfs@archiver.kernel.org>; Wed, 15 Apr 2020 12:04:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E603C2076C
	for <linux-unionfs@archiver.kernel.org>; Wed, 15 Apr 2020 12:04:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tmVEWoyF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409448AbgDOMEN (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 15 Apr 2020 08:04:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S368167AbgDOMBo (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 15 Apr 2020 08:01:44 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9777CC061A0E
        for <linux-unionfs@vger.kernel.org>; Wed, 15 Apr 2020 05:01:43 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id i10so18773467wrv.10
        for <linux-unionfs@vger.kernel.org>; Wed, 15 Apr 2020 05:01:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=3ldQjU+7Zq46i0kjWh+qplq7XP2+AUfS1ODeMVZ7Ftw=;
        b=tmVEWoyF7NFLrF+L3PavoR8tbVUWKmsQTMEcoR02PYoFEZoI/VPWQ2hEh/1AAto9xy
         6KgQMOPX+nbQGnamNeoLKmxYd779+POPo0JCiso2JoEvlrjqaTTk8SqUw0uXGp3AeV8e
         BMuUunvl78N4nLYdGpNdV6bAOQKxJN6p/UYksyMdjD4rU1GgaW/SDdtWDt0BXwJJUFcU
         pQ1ju9HoIie54rpGoEzZ7JPbQ5KFPtKDQd3pMckGMs//5jlLfo1IQtGKr2RtHRaZtS7Q
         gcbGs6m4bsdC+C1V7K14V0i6N7PwCkcxs6eKhE/fqVsylXfSCvnFMOQrx7JwJCcMRGqQ
         CPyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=3ldQjU+7Zq46i0kjWh+qplq7XP2+AUfS1ODeMVZ7Ftw=;
        b=KNgEUGlWVyETVQ6+W46BweiZhB8a5qLp3bFKlY5Eq/cehmQOfrHazqUQYGJbjXGm8f
         YKO9M5n8LTcVwL1AcX/yAkzOCGANLyxqHRKp1ZO/0x2JJIiXBxE1Nsrf6lkn4RYS1UQV
         XJgnLjwB8FFA/I0fd/WPEH/zU5H6e5gUQVBxYLnk4uNVHPScqRPmAA6cUzVO95vQLhx0
         ypavgVcjVX0rqaD7DN9DeJ2cW85b4oANFZ7hLKpOjVzQ29GemyjZnvJCG1wIbJV+/tMz
         +uqPNUS+RFtJKKSdIzd1dXppNLKcdqunnAzQur+wQqMuB/J0qpw2d1DrCrJQ3qfGGfLD
         o3tg==
X-Gm-Message-State: AGi0PuZkYG/2aATIBDDH/wTzVmuudOAJBA7pRckz0RK0MSlBggOSMn+x
        4iJ1DjqeNoucBdrZvhmBad/R6Hsu
X-Google-Smtp-Source: APiQypJjZKoRvvqqOHUhg4ZWpAB3TsmE/mxw9wKnqDXYKF7wPF1TF+HUboOwspXpORrc4eEHG3v28g==
X-Received: by 2002:adf:fad0:: with SMTP id a16mr31821431wrs.149.1586952102205;
        Wed, 15 Apr 2020 05:01:42 -0700 (PDT)
Received: from localhost.localdomain ([141.226.12.123])
        by smtp.gmail.com with ESMTPSA id h137sm17578238wme.0.2020.04.15.05.01.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2020 05:01:41 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     Giuseppe Scrivano <gscrivan@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        linux-unionfs@vger.kernel.org
Subject: [PATCH 1/2] Stop using bind mounts for --samefs
Date:   Wed, 15 Apr 2020 15:01:33 +0300
Message-Id: <20200415120134.28154-2-amir73il@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200415120134.28154-1-amir73il@gmail.com>
References: <20200415120134.28154-1-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

The implementation of --samefs uses bind mount to mount
/base/lower at /lower and /base/upper at /upper.

Re-assign the value of cfg.{lower,upper}_mntroot to the path
under base dir instead of using bind mounts.

Also stop the habit of remounting lowerdir ro in set_up(), just to
remount it again rw in mount_union() in case of --samefs.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 mount_union.py   |  8 ++---
 set_up.py        | 84 +++++++++++++++++++++++++++---------------------
 settings.py      | 18 +++++++++++
 unmount_union.py | 19 ++++++-----
 4 files changed, 78 insertions(+), 51 deletions(-)

diff --git a/mount_union.py b/mount_union.py
index 55515af..0b3316a 100644
--- a/mount_union.py
+++ b/mount_union.py
@@ -6,7 +6,6 @@ def mount_union(ctx):
     testdir = cfg.testdir()
     if cfg.testing_none():
         lower_mntroot = cfg.lower_mntroot()
-        system("mount -o remount,rw " + lower_mntroot)
         system("mount -o bind " + lower_mntroot + " " + union_mntroot)
         ctx.note_upper_fs(lower_mntroot, testdir, testdir)
 
@@ -14,14 +13,11 @@ def mount_union(ctx):
         lower_mntroot = cfg.lower_mntroot()
         upper_mntroot = cfg.upper_mntroot()
         if cfg.is_samefs():
-            base_mntroot = cfg.base_mntroot()
-            system("mount -o remount,rw " + base_mntroot)
             try:
-                os.mkdir(base_mntroot + upper_mntroot)
+                os.mkdir(upper_mntroot)
             except OSError:
                 pass
-            system("mount -o bind " + base_mntroot + upper_mntroot + " " + upper_mntroot)
-        else:
+        elif cfg.should_mount_upper():
             system("mount " + upper_mntroot + " 2>/dev/null"
                     " || mount -t tmpfs upper_layer " + upper_mntroot)
         layer_mntroot = upper_mntroot + "/" + ctx.curr_layer()
diff --git a/set_up.py b/set_up.py
index c3fad21..afdf5ba 100644
--- a/set_up.py
+++ b/set_up.py
@@ -12,9 +12,7 @@ def create_file(name, content):
 def set_up(ctx):
     cfg = ctx.config()
     lower_mntroot = cfg.lower_mntroot()
-    lowerdir = cfg.lowerdir()
-    lowerimg = cfg.lowerimg()
-    testdir = cfg.testdir()
+    upper_mntroot = cfg.upper_mntroot()
 
     os.sync()
 
@@ -26,12 +24,13 @@ def set_up(ctx):
         except RuntimeError:
             pass
 
-        try:
-            while system("grep -q 'lower_layer " + lower_mntroot + "' /proc/mounts" +
-                         " && umount " + lower_mntroot):
+        if cfg.should_mount_lower():
+            try:
+                while system("grep -q 'lower_layer " + lower_mntroot + "' /proc/mounts" +
+                             " && umount " + lower_mntroot):
+                    pass
+            except RuntimeError:
                 pass
-        except RuntimeError:
-            pass
 
     if cfg.testing_overlayfs():
         try:
@@ -41,59 +40,70 @@ def set_up(ctx):
         except RuntimeError:
             pass
 
-        try:
-            while system("grep -q 'lower_layer " + cfg.base_mntroot() + "' /proc/mounts" +
-                         " && umount " + cfg.base_mntroot()):
+        if cfg.should_mount_base():
+            try:
+                while system("grep -q 'lower_layer " + cfg.base_mntroot() + "' /proc/mounts" +
+                             " && umount " + cfg.base_mntroot()):
+                    pass
+            except RuntimeError:
                 pass
-        except RuntimeError:
-            pass
 
-        try:
-            while system("grep -q 'lower_layer " + lower_mntroot + "' /proc/mounts" +
-                         " && umount " + lower_mntroot):
+        if cfg.should_mount_lower():
+            try:
+                while system("grep -q 'lower_layer " + lower_mntroot + "' /proc/mounts" +
+                             " && umount " + lower_mntroot):
+                    pass
+            except RuntimeError:
                 pass
-        except RuntimeError:
-            pass
+
+        # Adjust lower/upper path in case of --samefs
+        if cfg.is_samefs():
+            base_mntroot = cfg.base_mntroot()
+            lower_mntroot = base_mntroot + "/lower"
+            cfg.set_lower_mntroot(lower_mntroot)
+            upper_mntroot = base_mntroot + "/upper"
+            cfg.set_upper_mntroot(upper_mntroot)
 
         try:
-            # grep filter to catch <lower|upper|N>_layer, in case upper and lower are on same fs
+            # grep filter to catch <lower|upper|N>_layer, in case of --ovov --samefs
             # and in case different layers are on different fs
-            while system("grep -q '_layer " + cfg.upper_mntroot() + "/' /proc/mounts" +
-                         " && umount " + cfg.upper_mntroot() + "/* 2>/dev/null"):
+            while system("grep -q '_layer " + upper_mntroot + "/' /proc/mounts" +
+                         " && umount " + upper_mntroot + "/* 2>/dev/null"):
                 pass
         except RuntimeError:
             pass
 
-        try:
-            # grep filter to catch <low|upp>er_layer, in case upper and lower are on same fs
-            while system("grep -q 'er_layer " + cfg.upper_mntroot() + "' /proc/mounts" +
-                         " && umount " + cfg.upper_mntroot()):
+        if cfg.should_mount_upper():
+            try:
+                while system("grep -q 'upper_layer " + cfg.upper_mntroot() + "' /proc/mounts" +
+                             " && umount " + cfg.upper_mntroot()):
+                    pass
+            except RuntimeError:
                 pass
-        except RuntimeError:
-            pass
 
-    if cfg.is_samefs() and cfg.testing_overlayfs():
+    if cfg.should_mount_base():
         # Create base fs for both lower and upper
-        base_mntroot = cfg.base_mntroot()
         system("mount " + base_mntroot + " 2>/dev/null"
                 " || mount -t tmpfs lower_layer " + base_mntroot)
         system("mount --make-private " + base_mntroot)
+
+    if cfg.is_samefs():
         try:
-            os.mkdir(base_mntroot + lower_mntroot)
+            os.mkdir(lower_mntroot)
         except OSError:
             pass
-        system("mount -o bind " + base_mntroot + lower_mntroot + " " + lower_mntroot)
-    else:
+    elif cfg.should_mount_lower():
         # Create a lower layer to union over
         system("mount " + lower_mntroot + " 2>/dev/null"
                 " || mount -t tmpfs lower_layer " + lower_mntroot)
-
-    # Systemd has weird ideas about things
-    system("mount --make-private " + lower_mntroot)
+        system("mount --make-private " + lower_mntroot)
 
     #
     # Create a few test files we can use in the lower layer
     #
+    lowerdir = cfg.lowerdir()
+    lowerimg = cfg.lowerimg()
+    testdir = cfg.testdir()
     try:
         os.mkdir(lowerdir)
     except OSError:
@@ -176,7 +186,7 @@ def set_up(ctx):
         system("mksquashfs " + lowerdir + " " + lowerimg + " -keep-as-directory > /dev/null");
         system("mount -o loop,ro " + lowerimg + " " + lower_mntroot)
         system("mount --make-private " + lower_mntroot)
-    else:
-        # The mount has to be read-only for us to make use of it
+    elif cfg.should_mount_lower_ro():
+        # Make overlay lower layer read-only
         system("mount -o remount,ro " + lower_mntroot)
     ctx.note_lower_fs(lowerdir)
diff --git a/settings.py b/settings.py
index 12015c8..ced9cae 100644
--- a/settings.py
+++ b/settings.py
@@ -61,10 +61,28 @@ class config:
         self.__union_mntroot = "/mnt"
         self.__testing_overlayfs = True
 
+    # base dir is mounted only for --ov --samefs
+    def should_mount_base(self):
+        return self.testing_overlayfs() and self.is_samefs()
     def base_mntroot(self):
         return self.__base_mntroot
+    # lower dir is mounted ro for --ov (without --samefs) ...
+    def should_mount_lower_ro(self):
+        return self.testing_overlayfs() and not self.is_samefs()
+    # ... and mounted rw for --no
+    def should_mount_lower_rw(self):
+        return self.testing_none()
+    def should_mount_lower(self):
+        return self.should_mount_lower_ro() or self.should_mount_lower_rw()
+    def set_lower_mntroot(self, path):
+        self.__lower_mntroot = path
     def lower_mntroot(self):
         return self.__lower_mntroot
+    # upper dir is mounted for --ov (without --samefs)
+    def should_mount_upper(self):
+        return self.testing_overlayfs() and not self.is_samefs()
+    def set_upper_mntroot(self, path):
+        self.__upper_mntroot = path
     def upper_mntroot(self):
         return self.__upper_mntroot
     def union_mntroot(self):
diff --git a/unmount_union.py b/unmount_union.py
index a83d457..f8f38af 100644
--- a/unmount_union.py
+++ b/unmount_union.py
@@ -6,18 +6,21 @@ def unmount_union(ctx):
     check_not_tainted()
 
     if cfg.testing_overlayfs():
-        if cfg.is_samefs():
-            system("umount " + cfg.base_mntroot())
-            check_not_tainted()
         # unmount individual layers with maxfs > 0
         if cfg.maxfs() > 0 or cfg.is_nested:
             try:
                 system("umount " + cfg.upper_mntroot() + "/* 2>/dev/null")
             except RuntimeError:
                 pass
-        check_not_tainted()
-        system("umount " + cfg.upper_mntroot())
-        check_not_tainted()
+            check_not_tainted()
 
-    system("umount " + cfg.lower_mntroot())
-    check_not_tainted()
+        if cfg.should_mount_base():
+            system("umount " + cfg.base_mntroot())
+            check_not_tainted()
+        elif cfg.should_mount_upper():
+            system("umount " + cfg.upper_mntroot())
+            check_not_tainted()
+
+    if cfg.should_mount_lower():
+        system("umount " + cfg.lower_mntroot())
+        check_not_tainted()
-- 
2.17.1


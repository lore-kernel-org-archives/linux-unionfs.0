From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: Re: [PATCH] check_layer: Add tests for constant st_dev
Date: Fri, 07 Jul 2017 11:06:43 +0530
Message-ID: <3081705.s7MyyWUpSq@localhost.localdomain>
References: <20170704170028.4278-1-chandan@linux.vnet.ibm.com> <CAOQ4uxiS9b7GboLpV2-FekiD+uND3Nofiybdr_=w-XcvhH+pkw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:37509 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750983AbdGGFgd (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 7 Jul 2017 01:36:33 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v675Z9IB004524
        for <linux-unionfs@vger.kernel.org>; Fri, 7 Jul 2017 01:36:27 -0400
Received: from e23smtp03.au.ibm.com (e23smtp03.au.ibm.com [202.81.31.145])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2bj387hqm5-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-unionfs@vger.kernel.org>; Fri, 07 Jul 2017 01:36:27 -0400
Received: from localhost
        by e23smtp03.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-unionfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Fri, 7 Jul 2017 15:36:24 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
        by d23relay08.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v675aLwh9175508
        for <linux-unionfs@vger.kernel.org>; Fri, 7 Jul 2017 15:36:21 +1000
Received: from d23av03.au.ibm.com (localhost [127.0.0.1])
        by d23av03.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v675aC8Y023690
        for <linux-unionfs@vger.kernel.org>; Fri, 7 Jul 2017 15:36:13 +1000
In-Reply-To: <CAOQ4uxiS9b7GboLpV2-FekiD+uND3Nofiybdr_=w-XcvhH+pkw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Tuesday, July 4, 2017 11:33:57 PM IST Amir Goldstein wrote:
> On Tue, Jul 4, 2017 at 8:00 PM, Chandan Rajendra
> <chandan@linux.vnet.ibm.com> wrote:
> > With constant st_dev implemented, overlayfs never returns the real dev
> > corresponding to lowerdir filesystems. Also, for the samefs case,
> > overlayfs always returns the pseudo st_dev corresponding to the union
> > layer.
> >
> > Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> 
> Chandan,
> 
> Tests look correct, however, the tests are correct for a future
> version of overlayfs
> (overlayfs-devel branch) and we don't want to break unionmounts for current
> stable kernel and not even for older kernels, so we have to maintain backward
> compat somehow...
> I suggest that you use the config flag self.config().is_verify(),
> which I already
> introduced in order to support old kernels w.r.t constant ino check,
> as an indication for which st_dev can be expected in layer check.
> 
> I think the rules should be:
> 1. ./run --verify --samefs # should enforce all dentries on overlay st_dev
> 2. ./run --verify # should enforce the rules that you wrote
> 3. ./run [--samefs] # should allow for either old kernel rules or new rules
> 
> Your challenge is to manage to describe all those rules in a clean and
> short way,
> just like you did with this patch.
> 
> Good luck!
> Amir.
> 
> (see two more comments below)
> 
> > ---
> >  context.py | 10 ++++------
> >  1 file changed, 4 insertions(+), 6 deletions(-)
> >
> > diff --git a/context.py b/context.py
> > index 829fb69..f6dbbe7 100644
> > --- a/context.py
> > +++ b/context.py
> > @@ -532,17 +532,15 @@ class test_context:
> >          if self.skip_layer_test():
> >              pass
> >          elif dev == self.lower_fs():
> > -            if dentry.is_dir():
> > -                raise TestError(name + ": Directory unexpectedly on lower filesystem")
> > +            # Overlayfs never returns st_dev corresponding to any of
> > +            # the lower layers
> > +            raise TestError(name + ": File unexpectedly has lowerfs dev id")
> >          elif dentry.is_dir():
> >              if dev != self.upper_dir_fs():
> >                  raise TestError(name + ": Directory not on union layer")
> >          elif dev == self.upper_fs() and not dentry.on_upper():
> >              raise TestError(name + ": File unexpectedly on upper layer")
> 
> You can and should also add the opposite check to enforce that:
> if dentry.on_upper() and not self.config().is_samefs() and dev !=
> self.upper_fs():
>      "File unexpectedly not on upper layer"

Hi Amir,

The above check will fail on the newer kernels which might have non-dirs (on
non-samefs overlay instances) which have been copied-up from a file originally
present on lowerdir. For such files, on_upper will be set but st_dev would
correspond to the pseudo device that ovl_getattr() returns.


I have tried to groups together the tests within "is_samefs()" and
"is_verify()" groups as shown below,

diff --git a/context.py b/context.py
index 829fb69..b6a980f 100644
--- a/context.py
+++ b/context.py
@@ -530,20 +530,26 @@ class test_context:

         #self.output("- check_layer ", dentry.filename(), " -", dentry.layer(), " # ", dev, "\n")
         if self.skip_layer_test():
-            pass
-        elif dev == self.lower_fs():
-            if dentry.is_dir():
-                raise TestError(name + ": Directory unexpectedly on lower filesystem")
-        elif dentry.is_dir():
+            return
+
+        if self.config().is_samefs():
             if dev != self.upper_dir_fs():
+                raise TestError(name + ": File not on union layer")
+
+        if self.config().is_verify():
+            if dev == self.lower_fs():
+                # Overlayfs never returns st_dev corresponding to any of
+                # the lower layers
+                raise TestError(name + ": File unexpectedly on lower layer")
+            if dentry.is_dir() and dev != self.upper_dir_fs():
                 raise TestError(name + ": Directory not on union layer")
-        elif dev == self.upper_fs() and not dentry.on_upper():
+
+        if dev == self.upper_fs() and not dentry.on_upper():
             raise TestError(name + ": File unexpectedly on upper layer")
-        elif dev != self.upper_fs() and dev != self.upper_dir_fs() and self.config().is_samefs():
-            # For samefs, file is on overlay dev
-            # TODO: for non-samefs, check file dev matches pseudo dev
-            # and that pseduo dev != real dev
-            raise TestError(name + ": File on unexpected layer")
+
+        if not self.config().is_samefs() and not self.config().is_verify() \
+           and dentry.on_upper() and dev != self.upper_fs():
+            raise TestError(name + ": File unexpectedly not on upper layer")

         if dentry.is_sym() and dentry not in symlinks:
             symlinks.add(dentry)

However, as described above, the last added test fails on newer kernels. I
am still trying to figure out an ideal place in check_layer() to add this
test.


-- 
chandan

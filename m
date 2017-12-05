From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: test case for overwriting empty dir
Date: Tue, 5 Dec 2017 18:08:26 +0200
Message-ID: <CAOQ4uxjor=fKsyNcFfWMuPTS8RRvPzRx64uZJ2evoYjAmbfB0w@mail.gmail.com>
References: <CAJfpegswJ3Sc5te6XO=D2Pq4ghLP6Oz8TQ4T7t5BJzVs0CJk1g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f179.google.com ([209.85.161.179]:41399 "EHLO
        mail-yw0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752209AbdLEQI1 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 5 Dec 2017 11:08:27 -0500
Received: by mail-yw0-f179.google.com with SMTP id f1so316979ywd.8
        for <linux-unionfs@vger.kernel.org>; Tue, 05 Dec 2017 08:08:27 -0800 (PST)
In-Reply-To: <CAJfpegswJ3Sc5te6XO=D2Pq4ghLP6Oz8TQ4T7t5BJzVs0CJk1g@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, David Howells <dhowells@redhat.com>

On Tue, Dec 5, 2017 at 5:17 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> Review by David revealed a bug introduced by commit
>
>   38e813db61c3 (ovl: get rid of PURE type)
>
> and fixed 15 commits later by
>
>   5cf5b477f0ca (ovl: opaque cleanup)
>
> Here's a test script (output should be "bar" not "bar foo"):
>
> cd /tmp/
> mkdir test
> cd test
> mkdir -p lower/dir1 upper work mnt
> touch lower/dir1/foo
> mount -t overlay overlay -olowerdir=lower,upperdir=upper,workdir=work mnt
> mkdir mnt/dir2
> touch mnt/dir2/bar
> rm mnt/dir1/foo
> mv -T mnt/dir2 mnt/dir1
> umount mnt
> mount -t overlay overlay -olowerdir=lower,upperdir=upper,workdir=work mnt
> ls mnt/dir1
> umount mnt
> rm -r lower upper work mnt
> cd /tmp
> rmdir test
>
> Can someone please make a proper testcase for this, if there isn't one already?
>

Here is a unionmount test against master branch on my tree.
It's supposed to be run like this to cycle mount on dir rename:
# ./run --ov=0 rename-new-pop-dir

I am not sure if someone is pulling from my tree, but I can push it there...

Cheers,
Amir.

----- OUTPUT----
TEST rename-new-pop-dir.py:270: Rename new dir over an emptied lower dir
 ./run --mkdir /mnt/a/dir118-new 0755
[  120.111937] sh (2056): drop_caches: 3
[  120.138230] overlayfs: -o
'lowerdir=/lower,upperdir=/upper/0,workdir=/upper/work0'
 ./run --open-file /mnt/a/dir118-new/a -w -c -W aaaa
 ./run --rmdir /mnt/a/dir118/pop/c
 ./run --unlink /mnt/a/dir118/pop/b
 ./run --rename /mnt/a/dir118-new /mnt/a/dir118/pop
[  120.195468] sh (2061): drop_caches: 3
[  120.224194] overlayfs: -o
'lowerdir=/lower,upperdir=/upper/0,workdir=/upper/work0'
 ./run --open-file /mnt/a/dir118/pop -r -d
 ./run --open-file /mnt/a/dir118/pop/a -r -R aaaa
 ./run --open-file /mnt/a/dir118/pop/b -r -E ENOENT
[  120.384822] overlayfs: -o
'lowerdir=/lower,upperdir=/upper/0,workdir=/upper/work0'

-----
diff --git a/tests/rename-new-pop-dir.py b/tests/rename-new-pop-dir.py
index b06f697..374a196 100644
--- a/tests/rename-new-pop-dir.py
+++ b/tests/rename-new-pop-dir.py
@@ -265,3 +265,18 @@ def subtest_18(ctx):
     ctx.open_dir(d2, ro=1)
     ctx.open_file(d + "/pop/b", ro=1, read="aaaa")
     ctx.open_file(d2 + "/pop/b", ro=1, read=":aaa:bbb:ccc")
+
+# Rename a new directory over an emptied populated lower dir
+def subtest_19(ctx):
+    """Rename new dir over an emptied lower dir"""
+    d = ctx.non_empty_dir() + "-new" + ctx.termslash()
+    d2 = ctx.non_empty_dir() + "/pop" + ctx.termslash()
+
+    ctx.mkdir(d, 0o755)
+    ctx.open_file(d + "/a", wo=1, crt=1, write="aaaa")
+    ctx.rmdir(d2 + "/c")
+    ctx.unlink(d2 + "/b")
+    ctx.rename(d, d2)
+    ctx.open_dir(d2, ro=1)
+    ctx.open_file(d2 + "/a", ro=1, read="aaaa")
+    ctx.open_file(d2 + "/b", ro=1, err=ENOENT)

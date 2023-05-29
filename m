Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1527C77B7E
	for <linux-unionfs@archiver.kernel.org>; Mon, 29 May 2023 15:16:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbjE2PQF (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 29 May 2023 11:16:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjE2PQE (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 29 May 2023 11:16:04 -0400
Received: from mail-vk1-xa31.google.com (mail-vk1-xa31.google.com [IPv6:2607:f8b0:4864:20::a31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D5DAC4
        for <linux-unionfs@vger.kernel.org>; Mon, 29 May 2023 08:16:00 -0700 (PDT)
Received: by mail-vk1-xa31.google.com with SMTP id 71dfb90a1353d-4570a6b7b06so758282e0c.1
        for <linux-unionfs@vger.kernel.org>; Mon, 29 May 2023 08:16:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685373359; x=1687965359;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hw2OwRA0Vht/HYTw1fXEGcFXtQeR8q7Qd88LC9tf4ps=;
        b=NBRaIxKJZ3q27MWnldHYNucwnNA+kZ6kFC6Xa/RpvO+jWFmQhxHsUDRLvWlhBxssdG
         e2Iu34NBIJKONb9CEzBphwwkMIRY2kmUZp8+NpwLdT62Y+2xbgTCisT5YymjqnX7c0Ib
         +YG/zuJroF3pCSWwsKbJsS1/bFYNTKUTOxwyEpwJgrKcUpAMlFPlt6+Q7nsLO7JPOMIj
         ShK4GeblJ5I5QAMYVCi1s4u8mHwhRGnCWbK1QZ+LGEnMza+rlJnd0eXZPPZ70bMtWbjB
         4tJXAy4w8Q10SMweim/xTAz7lSUlCSXZjX/hZAe/M8RQeZlpEbl44uHIGLOAl7a+H1+5
         cdcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685373359; x=1687965359;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hw2OwRA0Vht/HYTw1fXEGcFXtQeR8q7Qd88LC9tf4ps=;
        b=lJqtlQtsRHiVpkP0eZUh4P2d5h1UFdeK85V96E42jYuPKM5B3g509qCNfmVvXH/Pr0
         mMGhkvlg7OW346JzMk52VvwWvL4Jz0hXH5pSgLni97qyzO5IKL7UzRGBiHpw23p/9fID
         kdPGq6l2dCE0cDeByNhHe0hXXau/uqn1NIrTyhTQNsWHppyatmsjTVKE7KAfrtZz8bYx
         PFMqL7L8KzYdnTftSOj/9UNSAA//fM70uQae/zV7S07ZBKZ5mKWeK+6uJWTPC0QYsd8r
         b4H/ZcJ80UKPgVTIUFu5IJ1i8hpfwBqKYedZ/xDTw7EW3v6PMeQdY68yk8K1EGToV3Wj
         /A8g==
X-Gm-Message-State: AC+VfDwYawwpAu2EHULYMZ2OWZBL7EwhDf0aCU+OMK6EU9fj7QxHe2+k
        BXi6/RAfNY6rZ+7puql1PvgjnKhTMx4r/USsxpa3GPFj0UI=
X-Google-Smtp-Source: ACHHUZ5nES1zp9SgXOcdzQzq+V9l2CmD0EMQkksJI7R6k1ksdJrz2lzudP9fCha5fdXt/Lt0Rae62CWLjRSb575XwD4=
X-Received: by 2002:a67:fe0c:0:b0:421:c588:4d40 with SMTP id
 l12-20020a67fe0c000000b00421c5884d40mr2807828vsr.15.1685373359090; Mon, 29
 May 2023 08:15:59 -0700 (PDT)
MIME-Version: 1.0
References: <20210125194848.GA12389@ircssh-2.c.rugged-nimbus-611.internal>
In-Reply-To: <20210125194848.GA12389@ircssh-2.c.rugged-nimbus-611.internal>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 29 May 2023 18:15:48 +0300
Message-ID: <CAOQ4uxg0BHD8OHWk-b6TrE=SqGJTvp8TuHaLCwC5g9ZL=7W0Ew@mail.gmail.com>
Subject: Re: Detaching lower layers (Was: Lazy Loading Layers)
To:     Sargun Dhillon <sargun@sargun.me>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Jan 25, 2021 at 9:54=E2=80=AFPM Sargun Dhillon <sargun@sargun.me> w=
rote:
>
> One of the projects I'm playing with for containers is lazy-loading of la=
yers.
> We've found that less than 10% of the files on a layer actually get used,=
 which
> is an unfortunate waste. It also means in some cases downloading ~100s of=
 MB, or
> ~1s of GB of files before starting a container workload. This is unfortun=
ate.
>
> It would be nice if there was a way to start a container workload, and ha=
ve
> it so that if it tries to access and unpopulated (not yet downloaded) par=
t
> of the filesystem block while trying to be accessed. This is trivial to d=
o
> if the "lowest" layer is FUSE, where one can just stall in userspace on
> loads. Unfortunately, AFAIK, there's not a good way to swap out the FUSE
> filesystem with the "real" filesystem once it's done fully populating,
> and you have to pay for the full FUSE cost on each read / write.
>
> I've tossed around:
> 1. Mutable lowerdirs and having something like this:
>
> layer0 --> Writeable space
> layer1 --> Real XFS filesystem
> layer2 --> FUSE FS
>
> and if there is a "miss" on layer 1, it will then look it up on
> layer 2 while layer 1 is being populated. Then the FUSE FS can block.
> This is neat, but it requires the FUSE FS to always be up, and incurs
> a userspace bounce on every miss.
>
> It also means things like metadata only copies don't work.
>
> Does anyone have a suggestion of a mechanism to handle this? I've looked =
into
> swapping out layers on the fly, and what it would take to add a mechanism=
 like
> userfaultfd to overlayfs, but I was wondering if anything like this was a=
lready
> built, or if someone has thought it through more than me.
>

Hi Sargun,

I believe that this is the use case that you asked me about in LSFMM,
at least the lower part of layer1+layer2. Is that correct?

You did not mention three layers in the use case that you described
Is that because you decided that layer0 and layer1 can be combined?

Technically, you can also setup a nested overlay with the lower overlay
layer1+layer2 only doing the lazy loading of the remote read-only layer
and the upper overlay is composed of layer0+ovl(layer1+layer2), but this
nested overlay configuration has some limitations.

Anyway, I have talked with Miklos about the use case that requires
detaching the lowermost FUSE layer eventually and the solution that
we discussed was to gradually "opaquify" directories whose entire
descendant hierarchy is fully copied up at readdir time.

I have prepared POC patches for this design:

https://github.com/amir73il/linux/commits/ovl-xino-nofollow

This was tested using the following patch to unionmount-testsuite:

https://github.com/amir73il/unionmount-testsuite/commits/ovl-xino-nofollow

commit 026e73c37f3993f56e76128a267e54faedf2322c
Author: Amir Goldstein <amir73il@gmail.com>
Date:   Mon May 29 17:01:55 2023 +0300

    Test detaching lower fs

    Test that with xino=3Dnofollow, after copying up all files and listing
    all the directories in DFS order, the lower fs can be detached.

    Signed-off-by: Amir Goldstein <amir73il@gmail.com>

diff --git a/mount_union.py b/mount_union.py
index e905b83..4fad5dd 100644
--- a/mount_union.py
+++ b/mount_union.py
@@ -54,3 +54,13 @@ def mount_union(ctx):
         ctx.note_upper_fs(upper_mntroot, testdir, union_mntroot + "/f")
         ctx.note_lower_layers(lower_mntroot)
         ctx.note_upper_layer(upperdir)
+        if cfg.is_xino():
+            # Copy up everything, set all dirs opaque and then detach lowe=
r fs.
+            # Instead of iterating in DFS order we iterate 4 times as the =
depth
+            # of the dataset tree - on every iteration, level 4-i
becomes opaque.
+            system("chown -R 0.0 " + union_mntroot)
+            system("find " + union_mntroot + " -inum 0")
+            system("find " + union_mntroot + " -inum 0")
+            system("find " + union_mntroot + " -inum 0")
+            system("find " + union_mntroot + " -inum 0")
+            system("xfs_io -x -c shutdown " + lower_mntroot)
diff --git a/run b/run
index 3a6efc3..f8116c1 100755
--- a/run
+++ b/run
@@ -219,7 +219,7 @@ if redirect_dir is False:

 # Auto-upgrade xino=3Dauto to xino=3Don for kernel < v5.7
 if xino:
-    cfg.add_mntopt("xino=3Don")
+    cfg.add_mntopt("xino=3Dnofollow")

--

It should be pretty self-explanatory - after mounting the overlay, all
lower files
are copied up using chown -R (no metacopy) and then the overlay is iterated
several times, until all the merge directories iterations notice that
there is nothing
interesting in the lower dirs, so they all become opaque.
At this point, the lowest xfs layer is being shutdown and the tests are run=
.
With the 4*find iterations, none of the tests get EIO.

This does not mean that the lower xfs can be cleanly unmounted - there may
still be references to dentries/inodes from the lower fs, but
overlayfs never calls
any filesystem methods on the lower dentry/inodes - specifically lookup mis=
ses
in the upper dir do not end up looking in the lower dir.

The reason that I used an opt-in mount option (xino=3Dnofollow) to enable t=
his
functionality is because even after all files have been copied up,
overlayfs does
currently access one bit of information from the lower fs - it calls
getattr() to get
st_ino from the lower file/directory in order to preserve st_ino across cop=
y up.

I used an opt-in mount option to allow st_ino to change across copy up.
I hope this change of behavior is acceptable for your use case.
Note that after the completion of the migration process (e.g. chown -R + 4*=
find)
all inode numbers are stabilized.

Are you interested in testing these patches?
If you indicate that they are useful to you, I can post them for review
and in that case, I would appreciate if you can write the xfstests
for the feature.

Thanks,
Amir.

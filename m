Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B734C05027
	for <linux-unionfs@archiver.kernel.org>; Thu, 26 Jan 2023 05:27:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbjAZF1K (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 26 Jan 2023 00:27:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235880AbjAZF1J (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 26 Jan 2023 00:27:09 -0500
Received: from mail-vs1-xe2d.google.com (mail-vs1-xe2d.google.com [IPv6:2607:f8b0:4864:20::e2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 737424942F
        for <linux-unionfs@vger.kernel.org>; Wed, 25 Jan 2023 21:27:02 -0800 (PST)
Received: by mail-vs1-xe2d.google.com with SMTP id v26so254508vsm.5
        for <linux-unionfs@vger.kernel.org>; Wed, 25 Jan 2023 21:27:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Ml26pdKrOPwDrY4P7/M/1n9DkzdnH5DzBsV5N6y7asA=;
        b=pm693VBVMWTN01xH1D5vMqjtVRwRICCGDZSETK8QzxaKGMalHHflvwhk2672Hag5YK
         9UCRTVudre2QteRWbqabXk5muAu819lSxhFO3Q0rLDFmoQOAxQcWoAr7zGOqO1IybTwI
         G+bKyE35SUmzsWsmNEndOSqpzgZ4EwD3Mwhc+qBdKL0Nd0Qk1u22AIB0Oxu4D4P+6JNe
         Is9ljzzBZcvekpRvaLaqfvGDKrQULe7ar33Ck4/Ge5HTfOPt/aIEoQf9t9+/1wDB5lcn
         LhzbtMwC4scpuVSVklZACEIDXFc4CgDA2HbEe8My0S7XFSzLHwtPx2BwphR7FWBhK1L6
         c79g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ml26pdKrOPwDrY4P7/M/1n9DkzdnH5DzBsV5N6y7asA=;
        b=a4CT2ycQkJZXPJAiPhWCMAoxcs3ZYSXJp0FniTzBkkc+EKk0FytDH9zc3ipFdRYN5/
         du+PcKFI+FgkIvmMufCpiSMrfQViRbwaFE3lNRrwDt8TQ1sg+VujoMjlBX5TNxkiei6S
         UbaVqwQ77X7y8cXNYrH0Lia4XjlNYhR76s60NxKq9c66Z4u+Fh6mqpyXvReyhIL1t8rt
         19Dz97dtmjPUDJcpEJYD+swyjmXxfjVre3vpb8IgABblkkyH27Ei7G2jKyZZw1gJt5fp
         4xGQoGxIlAOPZBzfWyBj2lBHL/O0uatwHuNHQJxvzYAq63YdwrwLV6h4kZSTJNo+jz9R
         Znjg==
X-Gm-Message-State: AO0yUKULaJvSgWh/rcPF+EGMOrE4GRBTJT6wxMun0Wx5Wqca58yzZVKg
        69Uv2OofAzk4DMrig8IHtPJkyisZL8W2k7qLCaE=
X-Google-Smtp-Source: AK7set9Xmq1wwyxoGSqyATmo4mMjlz+n+SGxoW2Gra2DdmpyWOwJLNoXdyc/hQHBi+0PkAgBPaHq2uNSItX5sH8TIso=
X-Received: by 2002:a67:e0d8:0:b0:3ea:a853:97c4 with SMTP id
 m24-20020a67e0d8000000b003eaa85397c4mr184258vsl.36.1674710821405; Wed, 25 Jan
 2023 21:27:01 -0800 (PST)
MIME-Version: 1.0
References: <cover.1674227308.git.alexl@redhat.com> <CAOQ4uxgGc33_QVBXMbQTnmbpHio4amv=W7ax2vQ1UMet0k_KoA@mail.gmail.com>
 <1ea88c8d1e666b85342374ed7c0ddf7d661e0ee1.camel@redhat.com>
 <CAOQ4uxinsBB-LpGh4h44m6Afv0VT5yWRveDG7sNvE2uJyEGOkg@mail.gmail.com>
 <5fb32a1297821040edd8c19ce796fc0540101653.camel@redhat.com>
 <CAOQ4uxhGX9NVxwsiBMP0q21ZRot6-UA0nGPp1wGNjgmKBjjBBA@mail.gmail.com>
 <20230125041835.GD937597@dread.disaster.area> <CAOQ4uxhqdjRbNFs_LohwXdTpE=MaFv-e8J3D2R57FyJxp_f3nA@mail.gmail.com>
 <87wn5ac2z6.fsf@redhat.com> <CAOQ4uxiPLHHnr2=XH4gN4bAjizH-=4mbZMe_sx99FKuPo-fDMQ@mail.gmail.com>
 <87o7qmbxv4.fsf@redhat.com> <CAOQ4uximBLqXDtq9vDhqR__1ctiiOMhMd03HCFUR_Bh_JFE-UQ@mail.gmail.com>
 <87fsbybvzq.fsf@redhat.com> <CAOQ4uxgos8m72icX+u2_6Gh7eMmctTTt6XZ=BRt3VzeOZH+UuQ@mail.gmail.com>
 <87wn5a9z4m.fsf@redhat.com> <CAOQ4uxi7GHVkaqxsQV6ninD9fhvMAPk1xFRM2aMRFXQZUV-s3Q@mail.gmail.com>
 <CAOQ4uxiZ4iB82F4i2zMPcyCB8EBFGObdAoBEcar0KE7sA5BoNA@mail.gmail.com>
In-Reply-To: <CAOQ4uxiZ4iB82F4i2zMPcyCB8EBFGObdAoBEcar0KE7sA5BoNA@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 26 Jan 2023 07:26:49 +0200
Message-ID: <CAOQ4uxi5zpnX1EX3P1Ya4OkRa867NkdtkGcHjTJ9ftvnTL+EhQ@mail.gmail.com>
Subject: userns mount and metacopy redirects (Was: Re: [PATCH v3 0/6]
 Composefs: an opportunistically sharing verified image filesystem)
To:     Giuseppe Scrivano <gscrivan@redhat.com>
Cc:     Alexander Larsson <alexl@redhat.com>,
        Christian Brauner <brauner@kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

[spawning overlayfs sub-topic]

On Wed, Jan 25, 2023 at 10:29 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Wed, Jan 25, 2023 at 10:23 PM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > On Wed, Jan 25, 2023 at 9:45 PM Giuseppe Scrivano <gscrivan@redhat.com> wrote:
> > >
> > > Amir Goldstein <amir73il@gmail.com> writes:
> > >
> > > >> >> I previously mentioned my wish of using it from a user namespace, the
> > > >> >> goal seems more challenging with EROFS or any other block devices.  I

For those who are starting to read here, the context is userns mounting
of overlayfs with a lower EROFS layer containing metacopy references to
lower data blobs in another fs (a.k.a the composefs model).

IMO, mounting a readonly image of whatever on-disk format
is a very high risk for userns mount.
A privileged mount helper that verifies and mounts the EROFS
layer sounds like a more feasible solution.

> > > >> >> don't know about the difficulty of getting overlay metacopy working in a
> > > >> >> user namespace, even though it would be helpful for other use cases as
> > > >> >> well.
> > > >> >>
> > > >> >
> > > >> > There is no restriction of metacopy in user namespace.
> > > >> > overlayfs needs to be mounted with -o userxattr and the overlay
> > > >> > xattrs needs to use user.overlay. prefix.
> > > >>
> > > >> if I specify both userxattr and metacopy=on then the mount ends up in
> > > >> the following check:
> > > >>
> > > >> if (config->userxattr) {
> > > >>         [...]
> > > >>         if (config->metacopy && metacopy_opt) {
> > > >>                 pr_err("conflicting options: userxattr,metacopy=on\n");
> > > >>                 return -EINVAL;
> > > >>         }
> > > >> }
> > > >>
> > > >
> > > > Right, my bad.
> > > >
> > > >> to me it looks like it was done on purpose to prevent metacopy from a
> > > >> user namespace, but I don't know the reason for sure.
> > > >>
> > > >
> > > > With hand crafted metacopy, an unpriv user can chmod
> > > > any files to anything by layering another file with different
> > > > mode on top of it....
> > >
> > > I might be missing something obvious about metacopy, so please correct
> > > me if I am wrong, but I don't see how it is any different than just
> > > copying the file and chowning it.  Of course, as long as overlay uses
> > > the same security model so that a file that wasn't originally possible
> > > to access must be still blocked, even if referenced through metacopy.
> > >
> >
> > You're right.
> > The reason for mutual exclusion maybe related to the
> > comment in ovl_check_metacopy_xattr() about EACCES.
> > Need to check with Vivek or Miklos.
> >
> > But get this - you do not need metacopy=on to follow lower inode.
> > It should work without metacopy=on.
> > metacopy=on only instructs overlayfs whether to copy up data
> > or only metadata when changing metadata of lower object, so it is
> > not relevant for readonly mount.
> >
>
> However, you do need redirect=follow and that one is only mutually
> exclusive with userxattr.
> Again, need to ask Miklos whether that could be relaxed under
> some conditions.
>

I can see some possible problems with userns mount and redirect:
- referencing same dir inode from different paths
- referencing same inode from different paths with
  wrong nlink and inconsistent metadata

However, I think a mode that only follows a redirect from a
lower metacopy file to its data should be safe for userns mount.

In this special case (lower metacopy file) we may also be able to
implement the lazy lookup of the data file on open to optimize
'find' performance, but need to figure out what to do with st_blocks
of stat() in that case.

Thanks,
Amir.

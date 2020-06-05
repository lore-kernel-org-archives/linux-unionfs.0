Return-Path: <SRS0=dsgN=7S=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87CF9C433E0
	for <linux-unionfs@archiver.kernel.org>; Fri,  5 Jun 2020 10:23:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66D7A2074B
	for <linux-unionfs@archiver.kernel.org>; Fri,  5 Jun 2020 10:23:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OSh2pJW1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbgFEKWa (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 5 Jun 2020 06:22:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726557AbgFEKWD (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 5 Jun 2020 06:22:03 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02DB6C08C5C3;
        Fri,  5 Jun 2020 03:21:52 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id 9so8974585ilg.12;
        Fri, 05 Jun 2020 03:21:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wLwdieh+S9rCbn7cMgsGCyLatUxf1c/6h9WT30V8sCU=;
        b=OSh2pJW1M6nXWtMmSIY1Ok9/PLWb9uBRy67bij6acMA5fX2aA1qq2fiSIZIV2iB7XO
         di/3NFKeSXxY4/UvfUb5+yTw/aiXXn4ZFg/NJhrXeoN4GGp9tfYSFwl+cHp/KDCbt0kK
         Jn0nlDiwMRhtEwylDxRYW6aHsbFKbRZlCy03Z9Tb+h/YA68szDsW3PJPo3Ltu+Mzpsdg
         fpyOPP2GA+4JQv3ZF5N/gW5/d0SqRrbK1gJtw0jYq0g6Es4rmij6qVaPtofo+t/w+L4y
         ORVEB6b+4KH+n59xs6jQ/qKNN4KEMESusYSM1LoWLLJJv/kR19ufMAFYKR5ywc7yFoRx
         QH8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wLwdieh+S9rCbn7cMgsGCyLatUxf1c/6h9WT30V8sCU=;
        b=JBjpgJjT3N9l3B538Kgu2mkLyTV1/KcXAH1nl5X+NEt1oTYKPbHt6HjEr82F+o5YPJ
         58dn73i9Ly6DQvZK5GVvlpbZP94a7rHvf9Dm2F+Yk328G08QVx8o7oq0Q/ua6I563ziS
         gqFnVe7eE35XDfy5rYL9lkybIdpdLXzuqY1Ao/hNQPPjb19M3fkEoJUnSRgf//knetoy
         38hC9aRtHg+XthKwdzYPy5QcKKmt7Euy8xEqN6OL4wX3YI4bcJvGIJFSziby2e5FJNFT
         EePW4t8s5nZgzbDCHMOxcFkJBHaS8Ci6RYcjd/MSevrMSafVAHWWWdR2IUNlQHF3RKki
         y6eg==
X-Gm-Message-State: AOAM533r4sVr5FaSg1+jXp+B0d1nflNs2pNR3Q7hiqCqXdrZsrsuV9CM
        zHPWArWi2wSYqIUOC+SNR5kzqczKTVz8F6XmGh7Dut/l
X-Google-Smtp-Source: ABdhPJyGMEha2WvT52Og5dW9qASh/uSGt2UhldijvgHzNV5Em9i0+1UVZYkcYrSs/B4EmRVlyA5SsrN5fuLkoLpcCn8=
X-Received: by 2002:a92:c60b:: with SMTP id p11mr827768ilm.137.1591352511239;
 Fri, 05 Jun 2020 03:21:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200604161133.20949-1-alexander.mikhalitsyn@virtuozzo.com>
 <CAOQ4uxhGswjxZjc3mN7K99pPrDgMV9_194U46b2MgszZnq1SDw@mail.gmail.com>
 <AM6PR08MB36394A00DC129791CC89296AE8890@AM6PR08MB3639.eurprd08.prod.outlook.com>
 <CAOQ4uxisdLt-0eT1R=V1ihagMoNfjiTrUdcdF2yDgD4O94Zjcw@mail.gmail.com> <fb79be2c-4fc8-5a9d-9b07-e0464fca9c3f@virtuozzo.com>
In-Reply-To: <fb79be2c-4fc8-5a9d-9b07-e0464fca9c3f@virtuozzo.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 5 Jun 2020 13:21:40 +0300
Message-ID: <CAOQ4uxhhNx0VxJB=eLoPX+wt15tH3-KLjGuQem4h_R=0nfkAiA@mail.gmail.com>
Subject: Re: [PATCH 0/2] overlayfs: C/R enhancements
To:     Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc:     Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Andrey Vagin <avagin@virtuozzo.com>,
        Konstantin Khorenko <khorenko@virtuozzo.com>,
        Vasiliy Averin <vvs@virtuozzo.com>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Jun 5, 2020 at 11:41 AM Pavel Tikhomirov
<ptikhomirov@virtuozzo.com> wrote:
>
>
>
> On 6/5/20 5:35 AM, Amir Goldstein wrote:
> > On Fri, Jun 5, 2020 at 12:34 AM Alexander Mikhalitsyn
> > <alexander.mikhalitsyn@virtuozzo.com> wrote:
> >>
> >> Hello,
> >>
> >>> But overlayfs won't accept these "output only" options as input args,
> >> which is a problem.
> >>
> >> Will it be problematic if we simply ignore "lowerdir_mnt_id" and "upperdir_mnt_id" options in ovl_parse_opt()?
> >>
> >
> > That would solve this small problem.
>
> This is not a big problem actually as these options shown in mountinfo
> for overlay had been "output only" forever,
> please see these two examples below:
>
> a) Imagine you've mounted overlay with relative paths and forgot (or you
> never known as you are another user) where your cwd was at the moment of
> mount syscall. - How would you use those options as "input" to create
> the same overlay mount somethere else (bind-mounting not involved)?
>
> b) Imagine you've mounted overlay with absolute paths and someone (other
> user) overmounted lower (upper/workdir) paths for you, all directory
> structure would be the same on overmount but yet files are different. -
> How would you use those options from mountinfo as "input" ones?
>
> We try to make them much closer to "input" ones.


That is not what I meant by "output only"
I meant invalid input options as in EINVAL not ENOENT

>
> Agreed, we should ignore *_mnt_id on mount because paths identify mounts
> at the time of mount call.
>
> >
> >>> Wouldn't it be better for C/R to implement mount options
> >> that overlayfs can parse and pass it mntid and fhandle instead
> >> of paths? >>
> >> Problem is that we need to know on C/R "dump stage" which mounts are used on lower layers and upper layer. Most likely I don't understand something but I can't catch how "mount-time" options will help us.
> >
> > As you already know from inotify/fanotify C/R fhandle is timeless, so
> > there would be no distinction between mount time and dump time.
>
> Pair of fhandle+mnt_id looks an equivalent to path+mnt_id pair, CRIU
> will just need to open fhandle+mnt_id with open_by_handle_at and
> readlink to get path on dump and continue to use path+mnt_id as before.
> (not too common with fhandles but it's my current understanding)
>
> But if you take a look on (a) and (b) again, the regular user does not
> see full information about overlay mount in /proc/pid/mountinfo, they
> can't just take a look on it and understand from there it comes from.
> Resolving fhandle looks like a too hard task for a user.
>

Right, and we need to provide regular user needs in parallel to
providing C/R needs. understood.

> > About mnt_id, your patches will cause the original mount-time mounts to be busy.
> > That is a problem as well.
>
> Children mounts lock parent, open files lock parent. Another analogy is
> a loop device which locks the backing file mount (AFAICS). Anyway one
> can lazy umount, can't they? But I'm not too sure for this one, maybe
> you can share more implications of this problem?
>

Overlayfs mounts are internal not children mounts in the namespace,
so no open files hold reference the mounts in the namespace (AFAICS).

This use case will break:

  mount /dev/vdf /vdf
  mkdir /vdf/{l,u,w} /tmp/m
  mount -t overlay overlay /tmp/m -o
lowerdir=/vdf/l,upperdir=/vdf/u,workdir=/vdf/w
  umount /vdf

Yes users can lazy unmount, the filesystem itself on /dev/vdf is not actually
unmounted, only the /vdf mount goes away from the namespace, but the use case
without lazy unmount will still break.

Maybe its fine since distro/admin needs to opt-in for this change of behavior.
I have to wonder though, why did you add two different config/module
options for this feature? Yes, its two different sub-functionalities, but
which real user (not imaginary one) will really turn on just half the feature?
While at it, you copy pasted the text:
          For more information, see Documentation/filesystems/overlayfs.txt
but there is no more information to be found.

> >
> > I think you should describe the use case is more details.
> > Is your goal to C/R any overlayfs mount that the process has open
> > files on? visible to process
> We wan't to dump a container, not a simple process, if the container
> process has access to some resource CRIU needs to restore this resource.
>
> Imagine the process in container mounts it's own overlay inside
> container, for instance to imulate write access to readonly mount or
> just to implement some snapshots, don't know exact use case. And we want
> to checkpoint/restore this container. (Currently CRIU only supports
> overlay as external mount, e.g. for docker continers docker engine
> pre-creates overlay for us and we just bind from it - it's a different
> case.) If the in-container process creates the in-container mount we
> need to recreate it on restore so that the in-container view of the
> filesystem persists.
>

Understood. but how do you *know* which mounts the container
created and need to be migrated?
Which loop devices the user has created?
As opposed to the ones that docker engine re-created?
It is the found from diff between mountinfo of process and host?

> > For NFS export, we use the persistent descriptor {uuid;fhandle}
> > (a.k.a. struct ovl_fh) to encode
> > an underlying layer object.
> >
> > CRIU can look for an existing mount to a filesystem with uuid as restore stage
> > (or even mount this filesystem) and use open_by_handle_at() to open a
> > path to layer.
>
> On restore we can be on another physical node, so I doubt we have same
> uuid's, sorry I don't fully understand here already.
>

I see, so what about inotify/fanotify?
fhandle and uuid can be looked up/resolved to mnt/path at "dump" time.
The difference between mnt_id/uuid is who keeps the reference on the
mount. If overlayfs provides uuid, then you rely on docker to keep the
reference on the mount and use the reference-less uuid to find the
mount that docker is holding for you.

> > After mounting overlay, that mount to underlying fs can even be discarded.
> >
> > And if this works for you, you don't have to export the layers ovl_fh in
> > /proc/mounts, you can export them in numerous other ways.
> > One way from the top of my head, getxattr on overlay root dir.
> > "trusted.overlay" xattr is anyway a reserved prefix, so "trusted.overlay.layers"
> > for example could work.
>
> Thanks xattr might be a good option, but still don't forget about (a)
> and (b), users like to know all information about mount from
> /proc/pid/mountinfo.
>

Let's stick to your use cases requirements. If you have other use cases
for this functionality lay them out explicitly.

I went to see what losetup does and I see that LOOP_SET_STATUS
ioctl stores a path string that LOOP_GET_STATUS gets back in return.
Does not seem C/R friendly either. Are you not handling loop devices?

It's strange because loop driver keeps an open backing file so
LOOP_GET_STATUS could have returned the uptodate path.

Thanks,
Amir.

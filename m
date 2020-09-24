Return-Path: <SRS0=188/=DB=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA65FC2D0E2
	for <linux-unionfs@archiver.kernel.org>; Thu, 24 Sep 2020 10:19:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A055423600
	for <linux-unionfs@archiver.kernel.org>; Thu, 24 Sep 2020 10:19:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="p3KvWX0n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727433AbgIXKTz (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 24 Sep 2020 06:19:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726847AbgIXKTy (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 24 Sep 2020 06:19:54 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 750E4C0613CE;
        Thu, 24 Sep 2020 03:19:54 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id s88so2578825ilb.6;
        Thu, 24 Sep 2020 03:19:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vSNv6xI4gmjisciLOWcRfDs1oWZ8Uj9E83gumETecJI=;
        b=p3KvWX0nNby3qwP/5YSX27vgAQF8QWTqqThFoSL+FkvV7xfTvovF7bneDd2VG+LQok
         4dvXq+UwVZ6moZ+gUOwMCcGrRWgvFsqO/xr+Br5WACFXzRGdLKGcE0bg7pn0HeE/+7ww
         8ekBxVv3FfuFX/NltREvBfnbarhHL4Khe/Yc0sNCSC2nmbEQrsybJNOOsK8w+TKKazNe
         7gndfiVFvi6nEX7G8HM9QG0eCLNlFVY7TCTkEUda1LgyNdlTXchbe8OAulM53QFMzSsF
         ECFWMFaq/rWcUDH/eSqfFESl0tT6DWGb6AipHxdpFRQLFhFT5mtbu5pbVC058mtDydFc
         kh5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vSNv6xI4gmjisciLOWcRfDs1oWZ8Uj9E83gumETecJI=;
        b=TTMqlZKxREUJ4u8piU3ogtWr2FaMzEeZnK7fc+G8Zfst8ZfysWRVw3rJmyq7IODlch
         SmLyM3vHw8IQDW8kLAkbvo26b2EfQlG/1e3jEgXGTwzuRYZlI7zRgz+1l8KDF1eMdn87
         ElClYXAHxBoI453bF/jN/U4XNt88yKrjlvNjVed2Bz4O35SGAzpJAwC57LHR58RnpKBP
         A98T2kDlmF+cgdcD44tHxL4WHdpd6m4uTsBlSoMyLbbSXJp0zzA4GPe9OhziyEorNHr0
         6LKz6kdmr1IUUm9oCGPhUxIEIzH8f4ZckHiRRtq5Vqi0E1Die/LylBZwOzywdIg0eN51
         2XIQ==
X-Gm-Message-State: AOAM5332R3ILaJM2kWda0/RH1mYab2iaJPMZxuZYd75g9uNP/Vq2o9P+
        fUFuGDqzyAc5O7mWs1QFZb/w7/Ag8/TlpDJU0p4WKlgG
X-Google-Smtp-Source: ABdhPJy+Mhb+6PY2zUQ2J7J3Ua1dYMfINfMGeUANJT1hBNjpEzm9do/oYu8i0GQ0XjcNbuNu+g0regPApNWwgeTX3tQ=
X-Received: by 2002:a92:d0c7:: with SMTP id y7mr3391646ila.250.1600942793733;
 Thu, 24 Sep 2020 03:19:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200923152308.3389-1-ptikhomirov@virtuozzo.com>
 <CAOQ4uxjxYjRkkB3tFqdZiOwj=2_+Ghzf5AvmptVLQM22K5DWfg@mail.gmail.com> <f0293d95-f6f6-d0f5-d5a1-a886f87f9052@virtuozzo.com>
In-Reply-To: <f0293d95-f6f6-d0f5-d5a1-a886f87f9052@virtuozzo.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 24 Sep 2020 13:19:42 +0300
Message-ID: <CAOQ4uxhyFLWX8m4dsB3QvH2Xq=a0iZaHCBFcRaQTUMFxn8y0=g@mail.gmail.com>
Subject: Re: [PATCH v2] ovl: introduce new "index=nouuid" option for inodes
 index feature
To:     Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Vivek Goyal <vgoyal@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Sep 24, 2020 at 11:40 AM Pavel Tikhomirov
<ptikhomirov@virtuozzo.com> wrote:
>
>
>
> On 9/23/20 7:09 PM, Amir Goldstein wrote:
> > On Wed, Sep 23, 2020 at 6:23 PM Pavel Tikhomirov
> > <ptikhomirov@virtuozzo.com> wrote:
> >>
> >> This relaxes uuid checks for overlay index feature. It is only possible
> >> in case there is only one filesystem for all the work/upper/lower
> >> directories and bare file handles from this backing filesystem are uniq.
> >> In case we have multiple filesystems here just fall back to normal
> >> "index=on".
> >>
> >> This is needed when overlayfs is/was mounted in a container with
> >> index enabled (e.g.: to be able to resolve inotify watch file handles on
> >> it to paths in CRIU), and this container is copied and started alongside
> >> with the original one. This way the "copy" container can't have the same
> >> uuid on the superblock and mounting the overlayfs from it later would
> >> fail.
> >>
> >> That is an example of the problem on top of loop+ext4:
> >>
> >> dd if=/dev/zero of=loopbackfile.img bs=100M count=10
> >> losetup -fP loopbackfile.img
> >> losetup -a
> >>    #/dev/loop0: [64768]:35 (/loop-test/loopbackfile.img)
> >> mkfs.ext4 loopbackfile.img
> >> mkdir loop-mp
> >> mount -o loop /dev/loop0 loop-mp
> >> mkdir loop-mp/{lower,upper,work,merged}
> >> mount -t overlay overlay -oindex=on,lowerdir=loop-mp/lower,\
> >> upperdir=loop-mp/upper,workdir=loop-mp/work loop-mp/merged
> >> umount loop-mp/merged
> >> umount loop-mp
> >> e2fsck -f /dev/loop0
> >> tune2fs -U random /dev/loop0
> >>
> >> mount -o loop /dev/loop0 loop-mp
> >> mount -t overlay overlay -oindex=on,lowerdir=loop-mp/lower,\
> >> upperdir=loop-mp/upper,workdir=loop-mp/work loop-mp/merged
> >>    #mount: /loop-test/loop-mp/merged:
> >>    #mount(2) system call failed: Stale file handle.
> >>
> >> mount -t overlay overlay -oindex=nouuid,lowerdir=loop-mp/lower,\
> >> upperdir=loop-mp/upper,workdir=loop-mp/work loop-mp/merged
> >>
> >> If you just change the uuid of the backing filesystem, overlay is not
> >> mounting any more. In Virtuozzo we copy container disks (ploops) when
> >> crate the copy of container and we require fs uuid to be uniq for a new
> >> container.
> >>
> >> v2: in v1 I missed actual uuid check skip - add it
> >>
> >> CC: Amir Goldstein <amir73il@gmail.com>
> >> CC: Vivek Goyal <vgoyal@redhat.com>
> >> CC: Miklos Szeredi <miklos@szeredi.hu>
> >> CC: linux-unionfs@vger.kernel.org
> >> CC: linux-kernel@vger.kernel.org
> >> Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
> >> ---
> >
> > Look reasonable, but you need to rebase over
> > git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-next
> >
> > Which makes a lot of your work unneeded.
> > ofs is propagated to most of the relevant helpers
> > and you should propagate it down to ovl_decode_real_fh().
>
> Thanks! Will do.
>
> >
> > Some minor comments below...
> >
> >>   fs/overlayfs/Kconfig     | 16 +++++++++++
> >>   fs/overlayfs/export.c    |  6 ++--
> >>   fs/overlayfs/namei.c     | 35 +++++++++++++++--------
> >>   fs/overlayfs/overlayfs.h | 23 +++++++++++----
> >>   fs/overlayfs/ovl_entry.h |  2 +-
> >>   fs/overlayfs/super.c     | 61 +++++++++++++++++++++++++++++-----------
> >>   6 files changed, 106 insertions(+), 37 deletions(-)
> >>
> >> diff --git a/fs/overlayfs/Kconfig b/fs/overlayfs/Kconfig
> >> index dd188c7996b3..b00fd44006f9 100644
> >> --- a/fs/overlayfs/Kconfig
> >> +++ b/fs/overlayfs/Kconfig
> >> @@ -61,6 +61,22 @@ config OVERLAY_FS_INDEX
> >>
> >>            If unsure, say N.
> >>
> >> +config OVERLAY_FS_INDEX_NOUUID
> >> +       bool "Overlayfs: relax uuid checks of inodes index feature"
> >> +       depends on OVERLAY_FS
> >> +       depends on OVERLAY_FS_INDEX
> >> +       help
> >> +         If this config option is enabled then overlay will skip uuid checks
> >> +         for index lower to upper inode map, this only can be done if all
> >> +         upper and lower directories are on the same filesystem where basic
> >> +         fhandles are uniq.
> >> +
> >> +         It is needed to overcome possible change of uuid on superblock of the
> >> +         backing filesystem, e.g. when you copied the virtual disk and mount
> >> +         both the copy of the disk and the original one at the same time.
> >> +
> >> +         If unsure, say N.
> >> +
> >
> > Please do not add a config option for this.
> > Isn't a mount option sufficient for your needs?
>
> Users inside Virtuozzo container can mount overlayfs inside the CT (we
> assume that they do "regular" mounts without any "index=" option as
> docker does) so we wan't to setup the default in kernel config, so that
> all "regular" mounts of the user become "index=nouuid" automatically,
> and thus we would be able to both migrate (CRIU inotify resolution by
> fhandle on dump) and copy (copy disk with uuid change) the container
> without problem.
>

That is a problem.
So far, mount options always override module and kernel config options.
So if mount option says inodex=on explicitly, it should be index=on.

The only way I see for you to tackle this is if nouuid option is independent
of index option, e.g. index=on,anon_uuid (or uuid=off).

But if kernel config has a way to turn this on, then module param and
mount option should have a way to turn it off.

[...]
> >> @@ -1889,9 +1911,14 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
> >>          if (err)
> >>                  goto out_free_oe;
> >>
> >> +       if (ofs->config.index == OVL_INDEX_NOUUID && ofs->numfs > 1) {
> >> +               pr_warn("The index=nouuid requires a single fs for lower and upper, falling back to index=on.\n");
> >> +               ofs->config.index = OVL_INDEX_ON;
> >> +       }
> >> +
> >
> > It's too late for this fallback now, you already did relaxed ovl_verify_origin()
> > and now we will continue as if all is ok.
> > Please fail the mount in this case.
> >
> > I don't think that users that specifically requested index=nouuid would care to
> > fallback to index=on.
>
> No, it's we who will force users to switch to index=nouuid in our
> Virtuozzo case through kernel config default, so probably having a
> fallback is a good thing, as users will be able to use their overlay at
> least until we "copy" their container.
>
> Maybe I can just move my check before ovl_get_indexdir (as far as I can
> see it is the only place from ovl_fill_super where we reach
> ovl_verify_fh or ovl_decode_real_fh) and after ovl_get_lowerstack where
> numfs is calculated. - Will do.

Yes, that would be fine techicaly.
I am not sure if the fallback is helpful though.

Anyway, you would need to get approval from Miklos
on the option itself and how it behaves.

Thanks,
Amir.

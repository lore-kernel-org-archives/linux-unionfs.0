Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80DF0C7EE2E
	for <linux-unionfs@archiver.kernel.org>; Fri,  9 Jun 2023 09:53:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241822AbjFIJxB (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 9 Jun 2023 05:53:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241817AbjFIJwC (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 9 Jun 2023 05:52:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F37B759FC
        for <linux-unionfs@vger.kernel.org>; Fri,  9 Jun 2023 02:44:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E711761239
        for <linux-unionfs@vger.kernel.org>; Fri,  9 Jun 2023 09:44:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDB46C433EF;
        Fri,  9 Jun 2023 09:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686303881;
        bh=YCYv3zYnFWpdIx9UYshE9DkIIDqxy049N0ITEblGWeo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RWQut2iQucYHlkB4F/UPf7gGraL5JE2+176HOZc4QwNlFieWqp1mYgbMT7PVm3Zjc
         WtGZiesYeG0kCSMLrgMbOuJoYYiyXgCueuSTfK+w1+oj60as5++5/YJFpgkXNd/Ny/
         bXcNEVPYXyyyaljqewev0me9hIExb/6bcbfM58ACpf2X/VIWqpCMW+s/bBMcV7VIQy
         SAEi99ivesQ8DISOFeUphT0/JJjduKFmPGXA9nQLv5d45E1boazZldtX1FnXCBweU6
         9ui36fBFJW7K3dGaL+w6iD2/LfeNda+EDGXfz8jxUDGNjMzGBH5z8elIXGpSPFX35t
         +Jb1x+k87dcUQ==
Date:   Fri, 9 Jun 2023 11:44:36 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Alexander Larsson <alexl@redhat.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Amir Goldstein <amir73il@gmail.com>,
        Gao Xiang <hsiangkao@linux.alibaba.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        linux-unionfs@vger.kernel.org,
        Lennart Poettering <lennart@poettering.net>
Subject: Re: [PATCH v2 00/13] Overlayfs lazy lookup of lowerdata
Message-ID: <20230609-gezielt-narrte-16c044581827@brauner>
References: <CAL7ro1G7DQS_aAC4+9-ppdQz_7vjoXdBLohZ6bKo6S75NQUDPA@mail.gmail.com>
 <CAOQ4uxhN1dPBkhAu3Zag8=RKCbzMQghuXnyp+uur83dRW8tz6Q@mail.gmail.com>
 <87h6s0z6rf.fsf@redhat.com>
 <CAOQ4uxhkCgU2=F2oAJn34Jor2_Hr56fLsa8cAAz936G05d-+ZQ@mail.gmail.com>
 <CAL7ro1EoNDMxU2d9WYrb772VFWWMDWV=KVvrZDnK=5byemmo8Q@mail.gmail.com>
 <fb711bb4-3f25-ccee-0d21-2cb6deea75ec@linux.alibaba.com>
 <CAOQ4uxiCzTbr4OXhxv=RbNbKn+kaBva-Wkz4AGW8OJUwL3GfLQ@mail.gmail.com>
 <CAJfpegvsEuSNepb_9MNEkEFsW7R60DDk57x3oivA6wx9y8StRA@mail.gmail.com>
 <20230530-klagen-zudem-32c0908c2108@brauner>
 <CAL7ro1EnakXWOvJW7QGfd1+X_rpCUPQWotoL9Ca5RkWWYCscDA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL7ro1EnakXWOvJW7QGfd1+X_rpCUPQWotoL9Ca5RkWWYCscDA@mail.gmail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Jun 09, 2023 at 10:17:35AM +0200, Alexander Larsson wrote:
> On Tue, May 30, 2023 at 6:19 PM Christian Brauner <brauner@kernel.org> wrote:
> >
> > On Tue, May 30, 2023 at 04:08:38PM +0200, Miklos Szeredi wrote:
> > > On Sat, 27 May 2023 at 16:04, Amir Goldstein <amir73il@gmail.com> wrote:
> > >
> > > > If we would want to support data-only layers in the middle on the
> > > > stack, which would this syntax make sense?
> > > > lowerdir=lower1::data1:lower2::data2
> > > >
> > > > If this syntax makes sense to everyone, then we can change the syntax
> > > > of data-only in the tail from lower1::data1:data2 to lower1::data1::data2
> > > > and enforce that after the first ::, only :: are allowed.
> > > >
> > > > Miklos, any thoughts?
> > > > I have a feeling that this was your natural interpretation when you first
> > > > saw the :: syntax.
> > >
> > > Yes, I think it's more natural to have a prefix for each data-only
> > > layer.  And this is also good for extensibility, as discussed.
> >
> > Sorry, just a quick braindump vaguely related to this new mount syntax.
> >
> > A while ago util-linux reported issues with overlayfs when mounted
> > through the new mount api (cf. [1]) and I completely forgot to mention
> > this to you during LSFMM. So say you do:
> >
> >         fs_fd = fsopen("overlay", FSOPEN_CLOEXEC);
> >
> >         fsconfig(fs_fd, FSCONFIG_SET_STRING, "upperdir", "/home/asavah/kross/tmp/asusb450eg/upper", 0);
> >
> >         fsconfig(fs_fd, FSCONFIG_SET_STRING, "workdir", "/tmp/work", 0);
> >
> >         fsconfig(fs_fd, FSCONFIG_SET_STRING, "lowerdir", "0:1:2:3:4:5:6:7:8:9:a:b:c:d:e:f:10:11:12:13:14:15:16:17:18:19:1a:1b:1c:1d:1e:1f:20:21:22:23:24:25:26:27:28:29:2a:2b:2c:2d:2e:2f:
> >
> > This will fail because FSCONFIG_SET_STRING is limited to 256 bytes.
> > That's a reasonable limit and I don't think we need to extend this to
> > PATH_MAX.
> >
> > Instead, my reaction had been that lowerdir should be specifiable
> > multiple times through fsconfig() and overlayfs should probably append
> > lower layers via:
> >
> >         ret = fsconfig(fs_fd, FSCONFIG_SET_STRING, "lowerdir", "/home/username/project/data1", 0);
> >         // append
> >         ret = fsconfig(fs_fd, FSCONFIG_SET_STRING, "lowerdir", ":/home/username/project/data2", 0);
> >         // append
> >         ret = fsconfig(fs_fd, FSCONFIG_SET_STRING, "lowerdir", ":/home/username/project/data3", 0);
> >
> >         // replace everything specified until now
> >         ret = fsconfig(fs_fd, FSCONFIG_SET_STRING, "lowerdir", "/home/username/project/data4", 0);
> >
> >         // reset everything
> >         ret = fsconfig(fs_fd, FSCONFIG_SET_STRING, "lowerdir", "", 0);
> >
> > so with the new syntax this would probably be:
> >
> >         ret = fsconfig(fs_fd, FSCONFIG_SET_STRING, "lowerdir", "/home/username/project/data1", 0);
> >         // append data only layer
> >         ret = fsconfig(fs_fd, FSCONFIG_SET_STRING, "lowerdir", "::/home/username/project/data2", 0);
> >         // append data only layer
> >         ret = fsconfig(fs_fd, FSCONFIG_SET_STRING, "lowerdir", "::/home/username/project/data3", 0);
> >
> > [1]: https://github.com/util-linux/util-linux/issues/1992
> 
> Btw. I forgot to mention this, but I ran into an issue with overlayfs
> and the new mount api. In order to be able to pass in any pathname in
> the
> lowerdir option, overlayfs escapes commas, like:
> 
>   -o lowerdir=/lower/dir/with\,commas,upperdir=/upper
> 
> This is handled in overlayfs in ovl_split_lowerdirs() and ovl_unescape().
> 
> However, when using the new mount APIs, currently overlayfs uses
> legacy_fs_context_ops, and legacy_parse_param() forbids commas in the
> string, even if it is escaped. So the above mount will fail with "VFS:
> Legacy: Option '%s' contained comma".

I've sent a patch yesterday that converts overlayfs to the new mount api
that would also fix this fwiw.

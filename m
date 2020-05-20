Return-Path: <SRS0=Uqc0=7C=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0205CC433DF
	for <linux-unionfs@archiver.kernel.org>; Wed, 20 May 2020 07:24:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6DE8205CB
	for <linux-unionfs@archiver.kernel.org>; Wed, 20 May 2020 07:24:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UU8C9Q4S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbgETHYs (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 20 May 2020 03:24:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726435AbgETHYs (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 20 May 2020 03:24:48 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18B3CC061A0E
        for <linux-unionfs@vger.kernel.org>; Wed, 20 May 2020 00:24:48 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id x5so2068689ioh.6
        for <linux-unionfs@vger.kernel.org>; Wed, 20 May 2020 00:24:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fES2eK1Zix5BpHzKmiYWeB74lbtnOnoz+IJGLZMBe5g=;
        b=UU8C9Q4SyR/fPMLBUhPWgYORFf66bkZAqQ1RJZkeLvt+n8IcuzZKHixCs/h/0eaPoE
         6ahhpqCq1Buq2AvZoK5k4a2RguJZ/a7nV72Jm+3HqeaHcMNU0X1jOj6se0vJcioEpbZW
         2hceEKCxLkynCl2sRgcNsa3TpfHwNPf30r6xCau8jDtWtkNQrqrreAjmbcOrA3Tn0/o0
         h5QriRhLKYc1pu/o0I25nPUNlOtmEA1AI4b5FU+SzlZQHUDnyfbxKjqb0FuX4J/fCrPM
         pr106zveUC4fpCPpCNYbqqLqZDjaAr+s/zJnjYq0qIB6iP5XxjJ5qIkevOqDJ0dLM/0c
         /21w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fES2eK1Zix5BpHzKmiYWeB74lbtnOnoz+IJGLZMBe5g=;
        b=OmyFP9Emx7Y38U4wqIN5SrswGmAiYHhNMLZ90GKAjpOcpkC/vcuj5ExNZaxli+5nGT
         IaUzqO9yQ0QRqz5gWvawdBZz8zvH4y0LplAGNCk4N00BY7NHTi1y5nyxQU66Zb9s+5E9
         9iaXFNk0lcPfuU7oYqJ1IrG+F4XWChXFtm2cqvqL17gXf7ZWHVHwPWtpS33cU0ckQggx
         vNqK4KqjCTgYvbR82PVuZVd+vqQc5L1mHz3tKSlH0dgE/E+JyC7FO98MuYqalzWpCOxD
         Gl7sl8nL4c73jk5pMJe7Cw8AtR11WwKzm0R19cxKev6x/NiylOq0JWMWLUCehm3SqM9l
         yBOg==
X-Gm-Message-State: AOAM531SQ6/6oRATkyiP7FIhqNRpoW1yzd8S62U1umdaclli7WHrNolC
        sz41NJRN8E7Kot9S/0OVyR1NtJUNhVhvRNt1JGs=
X-Google-Smtp-Source: ABdhPJzaSLzjRbog9Fl75ExX5RfhuSq7lVtHJVROvh8BsG0vL1rkaIZ8OqQ8QXqsw827MdPjmP2lloBHrCmu1FRhPXQ=
X-Received: by 2002:a5e:840d:: with SMTP id h13mr2375649ioj.64.1589959487276;
 Wed, 20 May 2020 00:24:47 -0700 (PDT)
MIME-Version: 1.0
References: <20200506095307.23742-1-cgxu519@mykernel.net> <4bc73729-5d85-36b7-0768-ae5952ae05e9@mykernel.net>
In-Reply-To: <4bc73729-5d85-36b7-0768-ae5952ae05e9@mykernel.net>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 20 May 2020 10:24:35 +0300
Message-ID: <CAOQ4uxi4coKOoYar7Y==i=P21j5r8fi_0op+BZR-VQ1w5CMUew@mail.gmail.com>
Subject: Re: [PATCH v12] ovl: improve syncfs efficiency
To:     cgxu <cgxu519@mykernel.net>
Cc:     Jan Kara <jack@suse.cz>, Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Sargun Dhillon <sargun@sargun.me>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, May 20, 2020 at 4:02 AM cgxu <cgxu519@mykernel.net> wrote:
>
> On 5/6/20 5:53 PM, Chengguang Xu wrote:
> > Current syncfs(2) syscall on overlayfs just calls sync_filesystem()
> > on upper_sb to synchronize whole dirty inodes in upper filesystem
> > regardless of the overlay ownership of the inode. In the use case of
> > container, when multiple containers using the same underlying upper
> > filesystem, it has some shortcomings as below.
> >
> > (1) Performance
> > Synchronization is probably heavy because it actually syncs unnecessary
> > inodes for target overlayfs.
> >
> > (2) Interference
> > Unplanned synchronization will probably impact IO performance of
> > unrelated container processes on the other overlayfs.
> >
> > This patch tries to only sync target dirty upper inodes which are belong
> > to specific overlayfs instance and wait for completion. By doing this,
> > it is able to reduce cost of synchronization and will not seriously impact
> > IO performance of unrelated processes.
> >
> > Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
>
> Except explicit sycnfs is triggered by user process, there is also implicit
> syncfs during umount process of overlayfs instance. Every syncfs will
> deliver to upper fs and whole dirty data of upper fs syncs to persistent
> device at same time.
>
> In high density container environment, especially for temporary jobs,
> this is quite unwilling  behavior. Should we provide an option to
> mitigate this effect for containers which don't care about dirty data?
>

This is not the first time this sort of suggestion has been made:
https://lore.kernel.org/linux-unionfs/4bc73729-5d85-36b7-0768-ae5952ae05e9@mykernel.net/T/#md5fc5d51852016da7e042f5d9e5ef7a6d21ea822

At the time, I proposed to use the SHUTDOWN ioctl as a means
for containers runtime to communicate careless teardown.

I've pushed an uptodate version of ovl-shutdown RFC [1].
It is only lightly tested.
It does not take care of OVL_SHUTDOWN_FLAGS_NOSYNC, but this
is trivial. I also think it misses some smp_mb__after_atomic() for
accessing ofs->goingdown and ofs->creator_cred.
I did not address my own comments on the API [2].
And there are no tests at all.

If this works for your use case, let me know how you want to proceed.
I could re-post the ioctl and access hook patches, leaving out the actual
shutdown patch for you to work on.
You may add some of your own patched, write tests and post v2.

Thanks,
Amir.

[1] https://github.com/amir73il/linux/commits/ovl-shutdown
[2] https://lore.kernel.org/linux-unionfs/CAOQ4uxiau7N6NtMLzjwPzHa0nMKZWi4nu6AwnQkR0GFnKA4nPg@mail.gmail.com/

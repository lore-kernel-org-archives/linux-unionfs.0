Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 066A8C433E0
	for <linux-unionfs@archiver.kernel.org>; Mon, 28 Dec 2020 19:26:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C00D92226A
	for <linux-unionfs@archiver.kernel.org>; Mon, 28 Dec 2020 19:26:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728440AbgL1T0g (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 28 Dec 2020 14:26:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728210AbgL1T0f (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 28 Dec 2020 14:26:35 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BEADC061793
        for <linux-unionfs@vger.kernel.org>; Mon, 28 Dec 2020 11:25:55 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id o6so10231500iob.10
        for <linux-unionfs@vger.kernel.org>; Mon, 28 Dec 2020 11:25:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sargun.me; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/nOHULSFy60FT+2em7J7OYQMxQyHIY7jUtPb874hlfY=;
        b=X44sptDyBjDo7Fmfh69zd2cXOO3bKdRIJm8eh0l8IIcytCkAv80h2Gz0xw56kaQVbG
         3qB4LlWGBBDdk2vj+xhlj/qjSLyNi6ZZsWrh9bp1+qXoh5vYWZYmtrSYe01KB9X64N6g
         VM63QPWOHcxIfrnutXwU4sUo1dNjYZYjlCuI4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/nOHULSFy60FT+2em7J7OYQMxQyHIY7jUtPb874hlfY=;
        b=igwHo3upKoxL4vHNLmpYxDlnwKDsr48na0wSTI7Vgc1IWtSLaTmncdeMwUpklhfoeQ
         EZKohb/6RcZCXglbSVrbWAHvm+dHfew9qELG90jsf1idFlGcO5IraqUrgq71CfylVyRJ
         M0FmSI1lBQTmCTKiXCvPaFhmCRtPexC1Nz8ezws6iCi0brN9ENSm2EhOaVJCd+a9pVN1
         /sKO5HOdKUPwTDCus/Y77Vgrv++WWkuuIqw4OuShTPe8l+5NDnwSvv6oi1qcDnCVQbd5
         t87XiZBz1SfTfzaM3LiIGvZ+2qAV+i/icmmRGukaJTy1d3pbZuKxmEkk3KXy/mGylfTh
         /rJg==
X-Gm-Message-State: AOAM532cazXoZ1NIX3XXf5yMl/Sgf+ZwqdrKxlxBdX5DcTSmwTB1zJSw
        wnAnGymVh+k2HmwSH/J2HtnLaAqzpvYitYrUlhrC7Q==
X-Google-Smtp-Source: ABdhPJxSDFz9qtx2zDzz0V4rwDXS3Bqf+8r+uF6knARBRLYg2CSyYUclaw5Kvp2mKllpYfrz4WigvFxj3FEwByAFghE=
X-Received: by 2002:a6b:e704:: with SMTP id b4mr14476477ioh.114.1609183554526;
 Mon, 28 Dec 2020 11:25:54 -0800 (PST)
MIME-Version: 1.0
References: <20201223182026.GA9935@ircssh-2.c.rugged-nimbus-611.internal>
 <20201223185044.GQ874@casper.infradead.org> <20201223192940.GA11012@ircssh-2.c.rugged-nimbus-611.internal>
 <20201223200746.GR874@casper.infradead.org> <20201223202140.GB11012@ircssh-2.c.rugged-nimbus-611.internal>
 <20201223204428.GS874@casper.infradead.org> <CAOQ4uxjAeGv8x2hBBzHz5PjSDq0Q+RN-ikgqEvAA+XE_U-U5Nw@mail.gmail.com>
 <20201224121352.GT874@casper.infradead.org> <CAOQ4uxj5YS9LSPoBZ3uakb6NeBG7g-Zeu+8Vt57tizEH6xu0cw@mail.gmail.com>
 <1334bba9cefa81f80005f8416680afb29044379c.camel@kernel.org>
 <20201228155618.GA6211@casper.infradead.org> <5bc11eb2e02893e7976f89a888221c902c11a2b4.camel@kernel.org>
In-Reply-To: <5bc11eb2e02893e7976f89a888221c902c11a2b4.camel@kernel.org>
From:   Sargun Dhillon <sargun@sargun.me>
Date:   Mon, 28 Dec 2020 11:25:18 -0800
Message-ID: <CAMp4zn92-WLFkDPVCUX=e+oyHb--7thDDwFEqyvBTGm64biyDw@mail.gmail.com>
Subject: Re: [PATCH 3/3] overlayfs: Report writeback errors on upper
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Matthew Wilcox <willy@infradead.org>,
        Amir Goldstein <amir73il@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>, Jan Kara <jack@suse.cz>,
        NeilBrown <neilb@suse.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@lst.de>,
        Chengguang Xu <cgxu519@mykernel.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Dec 28, 2020 at 9:26 AM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Mon, 2020-12-28 at 15:56 +0000, Matthew Wilcox wrote:
> > On Mon, Dec 28, 2020 at 08:25:50AM -0500, Jeff Layton wrote:
> > > To be clear, the main thing you'll lose with the method above is the
> > > ability to see an unseen error on a newly opened fd, if there was an
> > > overlayfs mount using the same upper sb before your open occurred.
> > >
> > > IOW, consider two overlayfs mounts using the same upper layer sb:
> > >
> > > ovlfs1                              ovlfs2
> > > ----------------------------------------------------------------------
> > > mount
> > > open fd1
> > > write to fd1
> > > <writeback fails>
> > >                             mount (upper errseq_t SEEN flag marked)
> > > open fd2
> > > syncfs(fd2)
> > > syncfs(fd1)
> > >
> > >
> > > On a "normal" (non-overlay) fs, you'd get an error back on both syncfs
> > > calls. The first one has a sample from before the error occurred, and
> > > the second one has a sample of 0, due to the fact that the error was
> > > unseen at open time.
> > >
> > > On overlayfs, with the intervening mount of ovlfs2, syncfs(fd1) will
> > > return an error and syncfs(fd2) will not. If we split the SEEN flag into
> > > two, then we can ensure that they both still get an error in this
> > > situation.
> >
> > But do we need to?  If the inode has been evicted we also lose the errno.
> > The guarantee we provide is that a fd that was open before the error
> > occurred will see the error.  An fd that's opened after the error occurred
> > may or may not see the error.
> >
>
> In principle, you can lose errors this way (which was the justification
> for making errseq_sample return 0 when there are unseen errors). E.g.,
> if you close fd1 instead of doing a syncfs on it, that error will be
> lost forever.
>
> As to whether that's OK, it's hard to say. It is a deviation from how
> this works in a non-containerized situation, and I'd argue that it's
> less than ideal. You may or may not see the error on fd2, but it's
> dependent on events that take place outside the container and that
> aren't observable from within it. That effectively makes the results
> non-deterministic, which is usually a bad thing in computing...
>
> --
> Jeff Layton <jlayton@kernel.org>
>

I agree that predictable behaviour outweighs any benefit of complexity
cutting we might do here.

Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20746C7EE23
	for <linux-unionfs@archiver.kernel.org>; Tue, 30 May 2023 16:19:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbjE3QT0 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 30 May 2023 12:19:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230234AbjE3QTY (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 30 May 2023 12:19:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52A45102
        for <linux-unionfs@vger.kernel.org>; Tue, 30 May 2023 09:19:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E28F8611DC
        for <linux-unionfs@vger.kernel.org>; Tue, 30 May 2023 16:19:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8713CC433EF;
        Tue, 30 May 2023 16:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685463558;
        bh=ds7pi7wEsz5YoX1D7hn5LB8yLIGcR9eTtKstAoKXQbA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BFU2u0GC9XC9kfdA0kiYGp3aajovjHl/0i8xilfAv5oGILWXRd3oUmCnWUzyYTrDI
         ERMxWhLkHxT9ee40W/Hn7ngQpqYSsUytcb+05SsDtdjuecOnkYnLTIV7vORPH2o632
         4dyFkG7GJ30FzNLya9trCkXPJnY0xVflFc9M1iZSPub1T90Moalj4DBq3MkMuScvrR
         CyDM8Qthq+cX+Ne0I+ZeyTQ1AjjzUirppoifT2i0ezs+nLeMmTraKz2Jv++nF3fJB/
         Z5ZEGmvddULl1kn0hVxzmo57GrArh+rt+f347qDOwLE+4p49Gu38mtYioqweZVA/tW
         7eVmUrfcjSC6A==
Date:   Tue, 30 May 2023 18:19:13 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Miklos Szeredi <miklos@szeredi.hu>,
        Amir Goldstein <amir73il@gmail.com>
Cc:     Gao Xiang <hsiangkao@linux.alibaba.com>,
        Alexander Larsson <alexl@redhat.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        linux-unionfs@vger.kernel.org,
        Lennart Poettering <lennart@poettering.net>
Subject: Re: [PATCH v2 00/13] Overlayfs lazy lookup of lowerdata
Message-ID: <20230530-klagen-zudem-32c0908c2108@brauner>
References: <20230427130539.2798797-1-amir73il@gmail.com>
 <CAL7ro1G7DQS_aAC4+9-ppdQz_7vjoXdBLohZ6bKo6S75NQUDPA@mail.gmail.com>
 <CAOQ4uxhN1dPBkhAu3Zag8=RKCbzMQghuXnyp+uur83dRW8tz6Q@mail.gmail.com>
 <87h6s0z6rf.fsf@redhat.com>
 <CAOQ4uxhkCgU2=F2oAJn34Jor2_Hr56fLsa8cAAz936G05d-+ZQ@mail.gmail.com>
 <CAL7ro1EoNDMxU2d9WYrb772VFWWMDWV=KVvrZDnK=5byemmo8Q@mail.gmail.com>
 <fb711bb4-3f25-ccee-0d21-2cb6deea75ec@linux.alibaba.com>
 <CAOQ4uxiCzTbr4OXhxv=RbNbKn+kaBva-Wkz4AGW8OJUwL3GfLQ@mail.gmail.com>
 <CAJfpegvsEuSNepb_9MNEkEFsW7R60DDk57x3oivA6wx9y8StRA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAJfpegvsEuSNepb_9MNEkEFsW7R60DDk57x3oivA6wx9y8StRA@mail.gmail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, May 30, 2023 at 04:08:38PM +0200, Miklos Szeredi wrote:
> On Sat, 27 May 2023 at 16:04, Amir Goldstein <amir73il@gmail.com> wrote:
> 
> > If we would want to support data-only layers in the middle on the
> > stack, which would this syntax make sense?
> > lowerdir=lower1::data1:lower2::data2
> >
> > If this syntax makes sense to everyone, then we can change the syntax
> > of data-only in the tail from lower1::data1:data2 to lower1::data1::data2
> > and enforce that after the first ::, only :: are allowed.
> >
> > Miklos, any thoughts?
> > I have a feeling that this was your natural interpretation when you first
> > saw the :: syntax.
> 
> Yes, I think it's more natural to have a prefix for each data-only
> layer.  And this is also good for extensibility, as discussed.

Sorry, just a quick braindump vaguely related to this new mount syntax.

A while ago util-linux reported issues with overlayfs when mounted
through the new mount api (cf. [1]) and I completely forgot to mention
this to you during LSFMM. So say you do:

        fs_fd = fsopen("overlay", FSOPEN_CLOEXEC);

        fsconfig(fs_fd, FSCONFIG_SET_STRING, "upperdir", "/home/asavah/kross/tmp/asusb450eg/upper", 0);

        fsconfig(fs_fd, FSCONFIG_SET_STRING, "workdir", "/tmp/work", 0);

        fsconfig(fs_fd, FSCONFIG_SET_STRING, "lowerdir", "0:1:2:3:4:5:6:7:8:9:a:b:c:d:e:f:10:11:12:13:14:15:16:17:18:19:1a:1b:1c:1d:1e:1f:20:21:22:23:24:25:26:27:28:29:2a:2b:2c:2d:2e:2f:

This will fail because FSCONFIG_SET_STRING is limited to 256 bytes.
That's a reasonable limit and I don't think we need to extend this to
PATH_MAX.

Instead, my reaction had been that lowerdir should be specifiable
multiple times through fsconfig() and overlayfs should probably append
lower layers via:

        ret = fsconfig(fs_fd, FSCONFIG_SET_STRING, "lowerdir", "/home/username/project/data1", 0);
        // append 
        ret = fsconfig(fs_fd, FSCONFIG_SET_STRING, "lowerdir", ":/home/username/project/data2", 0);
        // append
        ret = fsconfig(fs_fd, FSCONFIG_SET_STRING, "lowerdir", ":/home/username/project/data3", 0);

        // replace everything specified until now
        ret = fsconfig(fs_fd, FSCONFIG_SET_STRING, "lowerdir", "/home/username/project/data4", 0);

        // reset everything
        ret = fsconfig(fs_fd, FSCONFIG_SET_STRING, "lowerdir", "", 0);

so with the new syntax this would probably be:

        ret = fsconfig(fs_fd, FSCONFIG_SET_STRING, "lowerdir", "/home/username/project/data1", 0);
        // append data only layer
        ret = fsconfig(fs_fd, FSCONFIG_SET_STRING, "lowerdir", "::/home/username/project/data2", 0);
        // append data only layer
        ret = fsconfig(fs_fd, FSCONFIG_SET_STRING, "lowerdir", "::/home/username/project/data3", 0);

[1]: https://github.com/util-linux/util-linux/issues/1992

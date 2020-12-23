Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 764D2C433E6
	for <linux-unionfs@archiver.kernel.org>; Wed, 23 Dec 2020 19:30:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4CC31224B0
	for <linux-unionfs@archiver.kernel.org>; Wed, 23 Dec 2020 19:30:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728176AbgLWTa3 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 23 Dec 2020 14:30:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727794AbgLWTa2 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 23 Dec 2020 14:30:28 -0500
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A172EC06179C
        for <linux-unionfs@vger.kernel.org>; Wed, 23 Dec 2020 11:29:43 -0800 (PST)
Received: by mail-il1-x12e.google.com with SMTP id 75so81235ilv.13
        for <linux-unionfs@vger.kernel.org>; Wed, 23 Dec 2020 11:29:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sargun.me; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=GO51UVUTNvBhCJQD69obTiRmEahl2WX/DtgMyfCh1aI=;
        b=umJvLbgabVKE8NNhribeB3Mj6CL5aAY9F2WgopT7biHDRcoOldyYTms3ycziT26qQg
         P/kXz1hRLNT/c/2MSX9QidYbgghCvG1gzH9BMOUcaNgrU+AUO2svFTveIGmWm/KhLYeG
         s7Y0jLEyONdRTDgzkLpKdIWWRoJOBg1zkOagU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=GO51UVUTNvBhCJQD69obTiRmEahl2WX/DtgMyfCh1aI=;
        b=hEj5qUGXEiU+2EFKDKaDKmfFHth1AR8pPP9fTcHB7K092tPyJf37lfjfRWM1/gM3Vo
         gBo6n0tfzcMCoN7i3jTejWEe+o5HTEtVpu2IKyRDqTpVReKMlIqjBOUMhaG/qn8JBE3H
         0hsqadq67Lc/l1M9nfMzO+og0O06v1QGxTecGzBplI8je3/jOKLZyj9pT5w5TNTH9iRS
         Zx4h5h9GZMAEbJpUp9g5hMmnQMF4ESpWJE7/CSZszVG/9PSEwJ5jUEYVc/FeiCP+oQIp
         aVBSKdaatLaCKt6wUaYESmHJfk+v01BAVCRvAHE5Q7XYVgWGccyLhaXiSq/jb+z+iuPm
         vqXg==
X-Gm-Message-State: AOAM532oYYoxSpUfgRH0YDt20C1+6klA8fLaD1HX3UuQRTgwKhFjhfy/
        06wBdqrpllqB1s1Q7nUpZ74tZg==
X-Google-Smtp-Source: ABdhPJxgVI0N51a4lmloOWZTPdlTyDr3h7eUWimFnjN0UoZ0lBJsf8GBs9hacFiqk8YOuJmal1g4eA==
X-Received: by 2002:a92:bd04:: with SMTP id c4mr27471004ile.158.1608751782751;
        Wed, 23 Dec 2020 11:29:42 -0800 (PST)
Received: from ircssh-2.c.rugged-nimbus-611.internal (80.60.198.104.bc.googleusercontent.com. [104.198.60.80])
        by smtp.gmail.com with ESMTPSA id n77sm26473525iod.48.2020.12.23.11.29.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 23 Dec 2020 11:29:42 -0800 (PST)
Date:   Wed, 23 Dec 2020 19:29:41 +0000
From:   Sargun Dhillon <sargun@sargun.me>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Vivek Goyal <vgoyal@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        jlayton@kernel.org, amir73il@gmail.com, miklos@szeredi.hu,
        jack@suse.cz, neilb@suse.com, viro@zeniv.linux.org.uk, hch@lst.de
Subject: Re: [PATCH 3/3] overlayfs: Report writeback errors on upper
Message-ID: <20201223192940.GA11012@ircssh-2.c.rugged-nimbus-611.internal>
References: <20201221195055.35295-1-vgoyal@redhat.com>
 <20201221195055.35295-4-vgoyal@redhat.com>
 <20201223182026.GA9935@ircssh-2.c.rugged-nimbus-611.internal>
 <20201223185044.GQ874@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201223185044.GQ874@casper.infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Dec 23, 2020 at 06:50:44PM +0000, Matthew Wilcox wrote:
> On Wed, Dec 23, 2020 at 06:20:27PM +0000, Sargun Dhillon wrote:
> > I fail to see why this is neccessary if you incorporate error reporting into the 
> > sync_fs callback. Why is this separate from that callback? If you pickup Jeff's
> > patch that adds the 2nd flag to errseq for "observed", you should be able to
> > stash the first errseq seen in the ovl_fs struct, and do the check-and-return
> > in there instead instead of adding this new infrastructure.
> 
> You still haven't explained why you want to add the "observed" flag.


In the overlayfs model, many users may be using the same filesystem (super block)
for their upperdir. Let's say you have something like this:

/workdir [Mounted FS]
/workdir/upperdir1 [overlayfs upperdir]
/workdir/upperdir2 [overlayfs upperdir]
/workdir/userscratchspace

The user needs to be able to do something like:
sync -f ${overlayfs1}/file

which in turn will call sync on the the underlying filesystem (the one mounted 
on /workdir), and can check if the errseq has changed since the overlayfs was
mounted, and use that to return an error to the user.

If we do not advance the errseq on the upperdir to "mark it as seen", that means 
future errors will not be reported if the user calls sync -f ${overlayfs1}/file,
because errseq will not increment the value if the seen bit is unset.

On the other hand, if we mark it as seen, then if the user calls sync on 
/workdir/userscratchspace/file, they wont see the error since we just set the 
SEEN flag.

You need a new flag (observed) to differentiate between "Seen and reported to 
user" versus "seen by a second-order system, so should now increment".

One alternative is to always increment the errseq error counter, but I've
gotta imagine there's a reason that wasn't done in the first place.

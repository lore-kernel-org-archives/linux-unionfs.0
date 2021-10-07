Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00A89C433F5
	for <linux-unionfs@archiver.kernel.org>; Thu,  7 Oct 2021 12:27:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9E7161038
	for <linux-unionfs@archiver.kernel.org>; Thu,  7 Oct 2021 12:27:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241342AbhJGM32 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 7 Oct 2021 08:29:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233135AbhJGM32 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 7 Oct 2021 08:29:28 -0400
Received: from mail-vs1-xe32.google.com (mail-vs1-xe32.google.com [IPv6:2607:f8b0:4864:20::e32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91A4AC061746
        for <linux-unionfs@vger.kernel.org>; Thu,  7 Oct 2021 05:27:34 -0700 (PDT)
Received: by mail-vs1-xe32.google.com with SMTP id g10so6554513vsb.8
        for <linux-unionfs@vger.kernel.org>; Thu, 07 Oct 2021 05:27:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=JlKsfdmgfXs09taACmDyRZJY8EiHSnNfp8iCZ5IXTlY=;
        b=Pq29b+ECnINLhLjebcICFPMl5kZefTp91ONzUQAF3MiFKcnUY/fr26wFSGnUQLNPtw
         krwpnbduhJfqVIxHXtSreaczjcWiqGEkqBbnV1X8j3IlqHRu4TYSHvWaMnsHzFfS7B/y
         B//L+TWkij04JKEW5cQ3aktGXvFOebgmq9wTQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JlKsfdmgfXs09taACmDyRZJY8EiHSnNfp8iCZ5IXTlY=;
        b=v9VvIzcSjuMcsjualhpOf6qmiiYa7rkcm2AUu+T66TCpNGZV2ubqNNC1nQK9z2ZBC/
         CVXns6cR+NbIfU1hwjN4EPAsQ/0/xnxtQa1mNPngwdurV+LnTr6ZAaBLwBCjwyFCAiAG
         iSyYXtS1GDlKiYrmKFTVPz11e8P/7cS8TgVktGkLThWtEyBlaXLBvrP8r9J2Rlg7NfwQ
         /FvwsanFy0eZ10M1dYMvVkXiDxKtxWY4J0cgGwlAHwlmM49d57vPt6mxocYmCa/7omIa
         j+vbsWcjPklNxr9XQxj+kE7EtQMs6+fpMguSqGdgrtcNVhyuS4IqoXCsfjNrE/qM+ooZ
         GHJg==
X-Gm-Message-State: AOAM531FLpRIztKmux9y40eEn29vDgwqWFlZc+91niMnFX+M4dpXR9kD
        gT2sODBlJrlXbmh5WB3X0Bzjz3wrbbSALt9DknW7Ag==
X-Google-Smtp-Source: ABdhPJxSHUY84YfC3qTrGfqvnuokf7y4lKDUThEZMrITfoSSdEa2Y1i9F2ps9WjZfFtDnx0KREJl8X7VoIrtlGi7hU8=
X-Received: by 2002:a05:6102:3c3:: with SMTP id n3mr3706923vsq.19.1633609653793;
 Thu, 07 Oct 2021 05:27:33 -0700 (PDT)
MIME-Version: 1.0
References: <20210923130814.140814-1-cgxu519@mykernel.net> <20210923130814.140814-8-cgxu519@mykernel.net>
 <CAJfpegtLi1PsfpkohJ-8kTHVazf7cZiX96OSBMn7Q39PY_PXaw@mail.gmail.com> <3b660f79-9f60-5acd-0b9a-47f9e3e6a04b@139.com>
In-Reply-To: <3b660f79-9f60-5acd-0b9a-47f9e3e6a04b@139.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Thu, 7 Oct 2021 14:27:23 +0200
Message-ID: <CAJfpegujsoyXEQR4CBH3koZdpe+qUVj3R6Okt+3k9AbvUPohJQ@mail.gmail.com>
Subject: Re: [RFC PATCH v5 07/10] ovl: cache dirty overlayfs' inode
To:     Chengguang Xu <cgxu519@139.com>
Cc:     Chengguang Xu <cgxu519@mykernel.net>, Jan Kara <jack@suse.cz>,
        Amir Goldstein <amir73il@gmail.com>,
        linux-fsdevel@vger.kernel.org,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, 7 Oct 2021 at 14:04, Chengguang Xu <cgxu519@139.com> wrote:
>
> =E5=9C=A8 2021/10/7 19:09, Miklos Szeredi =E5=86=99=E9=81=93:
> > On Thu, 23 Sept 2021 at 15:08, Chengguang Xu <cgxu519@mykernel.net> wro=
te:
> >> Now drop overlayfs' inode will sync dirty data,
> >> so we change to only drop clean inode.
> >>
> >> The purpose of doing this is to keep compatible
> >> behavior with before because without this change
> >> dropping overlayfs inode will not trigger syncing
> >> of underlying dirty inode.
> >>
> >> Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
> >> ---
> >>   fs/overlayfs/super.c | 16 +++++++++++++++-
> >>   1 file changed, 15 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> >> index cddae3ca2fa5..bf4000eb9be8 100644
> >> --- a/fs/overlayfs/super.c
> >> +++ b/fs/overlayfs/super.c
> >> @@ -441,11 +441,25 @@ static int ovl_write_inode(struct inode *inode,
> >>          return ret;
> >>   }
> >>
> >> +/*
> >> + * In iput_final(), clean inode will drop directly and dirty inode wi=
ll
> >> + * keep in the cache until write back to sync dirty data then add to =
lru
> >> + * list to wait reclaim.
> >> + */
> >> +static int ovl_drop_inode(struct inode *inode)
> >> +{
> >> +       struct inode *upper =3D ovl_inode_upper(inode);
> >> +
> >> +       if (!upper || !(inode->i_state & I_DIRTY_ALL))
> > Could we check upper dirtyness here? That would give a more precise res=
ult.
>
> We keep tracking mmapped-file(shared mode) by explicitely marking
> overlay inode dirty,
>
> so if we drop overlay inode by checking upper dirtyness, we may lose
> control on those mmapped upper inodes.

That's fine, since there are no more mmaps at this point.

> >
> > Alternatively don't set .drop_inode (i.e. use generic_drop_inode())
> > and set I_DONTCACHE on overlay inodes.  That would cause the upper
> > inode to be always written back before eviction.
> >
> > The latter would result in simpler logic, and I think performance-wise
> > it wouldn't matter.  But I may be missing something.
>
> I think we may seperate mmapped-file(shared) inode and other inode by
>
> clear/set I_DONTCACHE flag on overlay inode if you prefer this approach.

Same reasoning here: after upper inode is written out, the dirtyness
in the overlay inode doesn't matter since there cannot be any active
mmaps.

Thanks,
Miklos

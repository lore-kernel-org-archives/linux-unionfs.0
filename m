Return-Path: <SRS0=Lx5L=AZ=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DA25C433E1
	for <linux-unionfs@archiver.kernel.org>; Tue, 14 Jul 2020 09:29:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DD762075F
	for <linux-unionfs@archiver.kernel.org>; Tue, 14 Jul 2020 09:29:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jYmzpFpt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725955AbgGNJ30 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 14 Jul 2020 05:29:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbgGNJ3Z (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 14 Jul 2020 05:29:25 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98E05C061755
        for <linux-unionfs@vger.kernel.org>; Tue, 14 Jul 2020 02:29:25 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id a11so13679665ilk.0
        for <linux-unionfs@vger.kernel.org>; Tue, 14 Jul 2020 02:29:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DW8NiYJcVY4TQdqX4nHKPQdni0zusROFDH3+qs0zum0=;
        b=jYmzpFptypYn9PxS6WV6EFpZZgME20P1ivsZoM6BXewcWpfdj0GehFo9jJWFUV/ext
         j1fb7Spl3JAC3vdNempvtIC+WV+OW2oFZ153H1zp/xsDF+xLiN6dUj8Tns3khO/I0IJT
         YJGBVuRb+R9T946/clOsMh27tDAsE/efPfDfOQJ+HLlS3u1TEFhoMdnRLZcOOcqCjTAD
         DLbUQEd/W2/9+maH/RSQRqH7WuBZylm7lIO6S3tEaK42aQPFftFnYUjk5cSBt4GpY9tb
         BDXeQeLEcV6iQIK1xbz2kcQR3ClrSGeZur/ZvtLOhSCRtRiGLoBP40cLy0GHCaMngCYJ
         iRrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DW8NiYJcVY4TQdqX4nHKPQdni0zusROFDH3+qs0zum0=;
        b=nVzvFjOK/oVUoEV3k2sAGXjFgRBqU/oA9ODGqWwLLJqKhOMEvajSQWec7x2AsG/FtG
         +lOpFFxHr0h2Yd20gCgQtepg3me/v6lY+BI2q7nDlaTsrE3hHCdRqvU7Mlo63504VAmm
         nzVarAuMOmHOP6RccwY7ViYoQxl0/z2w3ZS0ydWPvoWUol8kndcUTKKx8sxYJaNY2nFp
         eYP+diVb9JoOfrlDYM/2ngQv4e6vkL7RIbP7Uajzj/j3YnXiHKnxMRT8lRFkZE40YCXZ
         Hu1NsIQcU7DIBubH9gzxEbX4CbQ4nVTdYhr3DTaTQaBQzL+fpg1+ZXjaF21TsIKGvFEd
         FaPA==
X-Gm-Message-State: AOAM530lCHEunQYbWo8kGi+tGy8fHpC5EjgjuQ+uEKz4wDfPwrC+4SSo
        0ii2ZXCJa0jUNr3YfVlxqSIcYx00FxmX58tyc4I=
X-Google-Smtp-Source: ABdhPJxoBQ2H0EsV0jeDQQZT9zQBnIJ5+XLgxU4sb1hxDZrwkvTNAFuhwYkYqzrLcBfOxkAYowi/p5Klan88ubnLbcY=
X-Received: by 2002:a05:6e02:13e2:: with SMTP id w2mr4023345ilj.9.1594718959948;
 Tue, 14 Jul 2020 02:29:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200713105732.2886-1-amir73il@gmail.com>
In-Reply-To: <20200713105732.2886-1-amir73il@gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 14 Jul 2020 12:29:08 +0300
Message-ID: <CAOQ4uxg9PWi+645+zeH77FKQwi+RJ6bFugqG8Zv6qpPPJuTPnQ@mail.gmail.com>
Subject: Re: [PATCH RFC 0/2] Invalidate overlayfs dentries on underlying changes
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Vivek Goyal <vgoyal@redhat.com>, Josh England <jjengla@gmail.com>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Jul 13, 2020 at 1:57 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> Miklos,Vivek,
>
> These patches are part of the new overlay "fsnotify snapshot" series
> I have been working on.
>
> Conterary to the trend to disallow underlying offline changes with more
> configurations, I have seen that some people do want to be able to make
> some "careful" underlying online changes and survive [1].
>
> In the following patches, I argue for improving the robustness of
> overlayfs in the face of online underlying changes, but I have not
> really proved my claims, so feel free to challenge them.
>

This wasn't actually working unless underlying fs was remote, because
overlayfs clears the DCACHE_OP_REVALIDATE flags in that case.

I added this hunk for revalidate of local lower fs with nfs_export=on:

@@ -111,6 +111,10 @@ void ovl_dentry_update_reval(struct dentry
*dentry, struct dentry *upperdentry,
        for (i = 0; i < oe->numlower; i++)
                flags |= oe->lowerstack[i].dentry->d_flags;

+       /* Revalidate on local fs lower changes */
+       if (oe->numlower && ovl_verify_lower(dentry->d_sb))
+               flags |= mask;
+


> I also remember we discussed several times about the conversion of
> zero return value to -ESTALE, including in the linked thread.
> I did not change this behavior, but I left a boolean 'strict', which
> controls this behavior. I am using this boolean to relax strict behavior
> for snapshot mount later in my snapshot series. Relaxing the strict
> behavior for other use cases can be considered if someone comes up with
> a valid use case.
>

After giving this some more though, I came to a conclusion that it is actually
wrong to convert 0 to error because 0 could mean cache timeout expiry
or other things that do not imply anyone has made underlying changes.
I see that fuse_dentry_revalidate() handles timeout expiry internally and
other network filesystems may also do that, but there is nothing in the
"contract" about not returning 0 if entry MAY be valid.
Am I wrong?

I can even think of a network filesystem that marks its own dentry for lazy
revalidate after some local changes, so this behavior is even more dodgy
when dealing with remote upper fs.

So I added another patch to remove the conversion 0 => -ESTALE.

Pushed these patches to
https://github.com/amir73il/linux/commits/ovl-revalidate:
 ovl: invalidate dentry if lower was renamed
 ovl: invalidate dentry with deleted real dir
 ovl: do not return error on remote dentry cache expiry

Will wait for Miklos' feedback before posting.

Thanks,
Amir.

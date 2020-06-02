Return-Path: <SRS0=S/H/=7P=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52B50C433DF
	for <linux-unionfs@archiver.kernel.org>; Tue,  2 Jun 2020 16:49:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2713920738
	for <linux-unionfs@archiver.kernel.org>; Tue,  2 Jun 2020 16:49:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H5ohNTa6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726000AbgFBQtO (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 2 Jun 2020 12:49:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725940AbgFBQtO (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 2 Jun 2020 12:49:14 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFFA7C05BD1E
        for <linux-unionfs@vger.kernel.org>; Tue,  2 Jun 2020 09:49:13 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id d7so11575015ioq.5
        for <linux-unionfs@vger.kernel.org>; Tue, 02 Jun 2020 09:49:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C2oLk0QBJ4rd2sZwzFUr9co16a0U33hHW7pdV9hkDlo=;
        b=H5ohNTa6q1fBeYnlY/g5MPG5iM9pT1jCibhxBkyXQVAe099UO013gLn1brELOWLD8n
         PviGncN/ajJn4denYIekhJErqXfByKBqQ42618Yr8sNSQ5/5l5rGjR+OGPXYGEU6YvJi
         cPErgW6xq/g0r3Wq+7AHjr/84EG+kgSHGEWg8FdE26rJ0JUAyIwpvX2dJfMMmDzRL2rp
         K86IYvJmSsTzplGw9dJXtdFX3pSsKGKAjwzND/EFhd6fWw+51gQRNYJ6qv+Lk23u4cu0
         gAiZIGWcZWLhxlBdldvnoPDnRaJk0x/EPYfrUgjWL+9gYkLct36FGd8BvnJwpueR8RPk
         WmDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C2oLk0QBJ4rd2sZwzFUr9co16a0U33hHW7pdV9hkDlo=;
        b=LefXuJ+WTXpipf9xX7EdpkQ9Ujo8ndd9GSrWbQv8RP6l2l4d+n0jg0cObiS+gdra/f
         a+F7tFHeE4Ks51fKNyWhoiYYL5ELq6tkhcNY7kmthtfx/SAdsECMk+aHIfx4DFjSSJ/N
         7CKk8SUoYjVvfiFbNInwSXo5/hea0u+yKSw6KYkUCoWqn9I+RQIq9Nl2qK7TCoPiNeHV
         jKyhnwn8j4DxC27D4uhh+C8rc+ekNP2hSbXBpH7cgjUDvLnSQ7/4Q2rDE7ix4aRohkRv
         Zve1KijpXOd+hzjUF5LtrRaVkP3NzguLlMKlpI7IWPo+8y6SNzcmrawE+D+3A/LQsmv8
         jhow==
X-Gm-Message-State: AOAM5329+nFHe7y+z9KER5klayEseJ+TtozRVuY1UlcmWEbdLPSvfe3s
        Q1dAz2ZIYlW6bHVi2xsYscj2jVyESikjj0wT9tb7a2gt
X-Google-Smtp-Source: ABdhPJwV07/tP0gB7P8lxAJvZpQbr92PgiEUuyVzNJxg0IW8P17BW0JL91vK4dASrW1qnxAU6jIT8wW9tMxYp5JkJG8=
X-Received: by 2002:a05:6638:d96:: with SMTP id l22mr18703035jaj.120.1591116553213;
 Tue, 02 Jun 2020 09:49:13 -0700 (PDT)
MIME-Version: 1.0
References: <20200602152338.GA3311@redhat.com>
In-Reply-To: <20200602152338.GA3311@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 2 Jun 2020 19:49:01 +0300
Message-ID: <CAOQ4uxih30anwtcJpSinTScEZkPzZcDXT3ew-sqkzRc2Jg0vWA@mail.gmail.com>
Subject: Re: [PATCH] overlayfs: Fix redirect traversal on metacopy dentries
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Jun 2, 2020 at 6:23 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> Amir pointed me to metacopy test cases in unionmount-testsuite and
> I decided to run "./run --ov=10 --meta" and it failed while running
> test "rename-mass-5.py".
>
> Problem is w.r.t absolute redirect traversal on intermediate metacopy
> dentry. We do not store intermediate metacopy dentries and also skip
> current loop/layer and move onto lookup in next layer. But at the end
> of loop, we have logic to reset "poe" and layer index if currnently
> looked up dentry has absolute redirect. We skip all that and that
> means lookup in next layer will fail.
>
> Following is simple test case to reproduce this.
>
> - mkdir -p lower upper work merged lower/a lower/b
> - touch lower/a/foo.txt
> - mount -t overlay -o lowerdir=lower,upperdir=upper,workdir=work,metacopy=on none merged
>
> # Following will create absolute redirect "/a/foo.txt" on upper/b/bar.txt.
> - mv merged/a/foo.txt merged/b/bar.txt
>
> # unmount overlay and use upper as lower layer (lower2) for next mount.
> - umount merged
> - mv upper lower2
> - rm -rf work; mkdir -p upper work
> - mount -t overlay -o lowerdir=lower2:lower,upperdir=upper,workdir=work,metacopy=on none merged
>
> # Force a metacopy copy-up
> - chown bin:bin merged/b/bar.txt
>
> # unmount overlay and use upper as lower layer (lower3) for next mount.
> - umount merged
> - mv upper lower3
> - rm -rf work; mkdir -p upper work
> - mount -t overlay -o lowerdir=lower3:lower2:lower,upperdir=upper,workdir=work,metacopy=on none merged
>
> # ls merged/b/bar.txt
> ls: cannot access 'bar.txt': Input/output error
>
> Intermediate lower layer (lower2) has metacopy dentry b/bar.txt with absolute
> redirect "/a/foo.txt". We skipped redirect processing at the end of loop
> which sets poe to roe and sets the appropriate next lower layer index. And
> that means lookup failed in next layer.
>
> Fix this by continuing the loop for any intermediate dentries. We still do not
> save these at lower stack. With this fix applied unionmount-testsuite,
> "./run --ov-10 --meta" now passes.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

I though I ran this test - I guess not...

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  fs/overlayfs/namei.c | 26 ++++++++++++++------------
>  1 file changed, 14 insertions(+), 12 deletions(-)
>
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index da05e33db9ce..df81ec0e179f 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -913,15 +913,6 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>                         goto out_put;
>                 }
>
> -               /*
> -                * Do not store intermediate metacopy dentries in chain,
> -                * except top most lower metacopy dentry
> -                */
> -               if (d.metacopy && ctr) {
> -                       dput(this);
> -                       continue;
> -               }
> -
>                 /*
>                  * If no origin fh is stored in upper of a merge dir, store fh
>                  * of lower dir and set upper parent "impure".
> @@ -956,9 +947,20 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>                         origin = this;
>                 }
>
> -               stack[ctr].dentry = this;
> -               stack[ctr].layer = lower.layer;
> -               ctr++;
> +               if (d.metacopy && ctr) {
> +                       /*
> +                        * Do not store intermediate metacopy dentries in
> +                        * lower chain, except top most lower metacopy dentry.
> +                        * Continue the loop so that if there is an absolute
> +                        * redirect on this dentry, poe can be reset to roe.
> +                        */
> +                       dput(this);
> +                       this = NULL;
> +               } else {
> +                       stack[ctr].dentry = this;
> +                       stack[ctr].layer = lower.layer;
> +                       ctr++;
> +               }
>
>                 /*
>                  * Following redirects can have security consequences: it's like
> --
> 2.25.4
>

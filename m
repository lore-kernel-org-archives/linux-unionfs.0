From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v7 04/14] ovl: Provide a mount option metacopy=on/off for
 metadata copyup
Date: Fri, 17 Nov 2017 18:32:52 +0200
Message-ID: <CAOQ4uxgAPU99AzaYHV=ispJKgH=WdAdVP7YKW=o0CU=SJnUCKA@mail.gmail.com>
References: <20171116220335.13448-1-vgoyal@redhat.com> <20171116220335.13448-5-vgoyal@redhat.com>
 <CAOQ4uxj2UCtUhNF30DTHg=8u675-us0PiRvxcZ7DEoC+=DE-3w@mail.gmail.com> <20171117161836.GC15566@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f196.google.com ([209.85.213.196]:44564 "EHLO
        mail-yb0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751116AbdKQQcx (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 17 Nov 2017 11:32:53 -0500
Received: by mail-yb0-f196.google.com with SMTP id x72so947493ybg.11
        for <linux-unionfs@vger.kernel.org>; Fri, 17 Nov 2017 08:32:53 -0800 (PST)
In-Reply-To: <20171117161836.GC15566@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Fri, Nov 17, 2017 at 6:18 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Fri, Nov 17, 2017 at 01:23:58PM +0200, Amir Goldstein wrote:
>
> [..]
>> > @@ -1164,6 +1187,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
>> >
>> >         ofs->config.redirect_dir = ovl_redirect_dir_def;
>> >         ofs->config.index = ovl_index_def;
>> > +       ofs->config.metacopy = ovl_metacopy_def;
>> >         err = ovl_parse_opt((char *) data, &ofs->config);
>> >         if (err)
>> >                 goto out_err;
>> > @@ -1209,6 +1233,16 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
>> >         else if (ofs->upper_mnt->mnt_sb != ofs->same_sb)
>> >                 ofs->same_sb = NULL;
>> >
>> > +       if (!(ovl_force_readonly(ofs)) && ofs->config.metacopy) {
>> > +               /* Verify lower root is upper root origin */
>> > +               err = ovl_verify_origin(upperpath.dentry,
>> > +                                       oe->lowerstack[0].dentry, false, true);
>> > +               if (err) {
>> > +                       pr_err("overlayfs: failed to verify upper root origin\n");
>> > +                        goto out_free_oe;
>> > +               }
>> > +       }
>> > +
>> >
>>
>> Fs can have upper but no workdir and you still need to verify lower
>> If metacopy is enabled
>
> Hmm..., trying to understand this. This probably is more involved.
>
> So first use case is that if metacopy is being enabled, verify lower
> root is upper root origin. (Even if it is read-only fs).
>
> if (ofs->upper_mnt && ofs->config.metacopy)
>         ovl_verify_origin().

Yes, this is needed in case workdir/work dir creation fails and fs is mounted
read-only. You should not allow it with metacopy on unverified lower.

>
> But this does not cover the case of same fs being remounted with
> metacopy=off. In that case we will not do metacopy only copy ups but
> existing metacopy inodes will still require that lower does not change.
>
> Will it make sense to set OVL_METACOPY xattr on upper when metacopy=on
> is done first time on mount. And later in subsequent mounts, if METACOPY
> is set on upper, make sure to verify origin and make sure lower supports
> file handles etc.
>

This is an related to what we discussed at length on the ovl-features
patches.

Yes, we SHOULD mark that the metacopy feature was enabled, at least
on first meta_copy_up().

No, we should not do that by marking root upper with metacopy xattr.
this would be very confusing and inconsistent.
We can either set trusted.overlay.features on upper root as Miklos suggested
or incompat_feature/ directory as I suggested, but we need to decide on
a consistent scheme we can use for other features as well.

I guess metacopy must have this infrastructure in place, because as you
correctly noted, we should not mount an overlay with metacopied inodes
without verifying lower and file handle support.

Amir.

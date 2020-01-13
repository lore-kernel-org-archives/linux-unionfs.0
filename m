From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 2/5] ovl: simplify ovl_same_sb() helper
Date: Mon, 13 Jan 2020 16:31:42 +0200
Message-ID: <CAOQ4uxj8yewBzot0_Hu2OwNWMH=M_yGf_wtsCJn9UkwJARs0SA@mail.gmail.com>
References: <20191222080759.32035-1-amir73il@gmail.com> <20191222080759.32035-3-amir73il@gmail.com>
 <CAJfpeguNywFLtpETg1oVpLnjkMP=DPZU3Fjvvb9aumRvTXBwtw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-il1-f193.google.com ([209.85.166.193]:40522 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726505AbgAMObx (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 13 Jan 2020 09:31:53 -0500
Received: by mail-il1-f193.google.com with SMTP id c4so8317530ilo.7
        for <linux-unionfs@vger.kernel.org>; Mon, 13 Jan 2020 06:31:53 -0800 (PST)
In-Reply-To: <CAJfpeguNywFLtpETg1oVpLnjkMP=DPZU3Fjvvb9aumRvTXBwtw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: overlayfs <linux-unionfs@vger.kernel.org>

On Mon, Jan 13, 2020 at 1:37 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Sun, Dec 22, 2019 at 9:08 AM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > No code uses the sb returned from this helper, so make it retrun
> > a boolean and rename it to ovl_same_fs().
> >
> > The xino mode is irrelevant when all layers are on same fs, so
> > instead of describing samefs with mode OVL_XINO_OFF, use a new mode
> > OVL_XINO_SAME_FS, which is different than the case of non-samefs
> > with xino=off.
> >
> > Create a new helper ovl_same_dev(), to use instead of the common check
> > for (ovl_same_fs() || xinobits).
>
> What about OVL_XINO_AUTO: in this case xinobits would be zero but
> ovl_same_dev() would return true, no?
>

Yes, I missed it.

> More comments inline.
>
> > @@ -358,7 +352,8 @@ static int ovl_show_options(struct seq_file *m, struct dentry *dentry)
> >         if (ofs->config.nfs_export != ovl_nfs_export_def)
> >                 seq_printf(m, ",nfs_export=%s", ofs->config.nfs_export ?
> >                                                 "on" : "off");
> > -       if (ofs->config.xino != ovl_xino_def())
> > +       if (ofs->config.xino != ovl_xino_def() &&
> > +           ofs->config.xino != OVL_XINO_SAME_FS)
>
> I'm not sure I like this, although it doesn't contradict the policy of
> repeatability of mounts.   Could we instead have a separate
> ofs->xino_state, that defaults to config.xino but can take the value
> of OVL_XINO_SAME_FS?
>

OK, I understand why you don't like it and I think is makes sense to
have an xino_state.
However, xino_state and xino_bits are quite redundant.

If we change:
unsigned int xino_bits;
to:
int xino_mode;

It can take the values:
-1 /* not same dev */
0 /* same fs */
1..32 /* xino_bits */

And:

static inline unsigned int ovl_xino_bits(struct super_block *sb)
{
        return OVL_FS(sb)->xino_mode > 0 : OVL_FS(sb)->xino_mode : 0;
}

Thanks,
Amir.

From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v2 2/5] ovl: simplify ovl_same_sb() helper
Date: Mon, 13 Jan 2020 12:37:44 +0100
Message-ID: <CAJfpeguNywFLtpETg1oVpLnjkMP=DPZU3Fjvvb9aumRvTXBwtw@mail.gmail.com>
References: <20191222080759.32035-1-amir73il@gmail.com> <20191222080759.32035-3-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-io1-f65.google.com ([209.85.166.65]:41564 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725992AbgAMLhz (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 13 Jan 2020 06:37:55 -0500
Received: by mail-io1-f65.google.com with SMTP id c16so9416894ioo.8
        for <linux-unionfs@vger.kernel.org>; Mon, 13 Jan 2020 03:37:55 -0800 (PST)
In-Reply-To: <20191222080759.32035-3-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>

On Sun, Dec 22, 2019 at 9:08 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> No code uses the sb returned from this helper, so make it retrun
> a boolean and rename it to ovl_same_fs().
>
> The xino mode is irrelevant when all layers are on same fs, so
> instead of describing samefs with mode OVL_XINO_OFF, use a new mode
> OVL_XINO_SAME_FS, which is different than the case of non-samefs
> with xino=off.
>
> Create a new helper ovl_same_dev(), to use instead of the common check
> for (ovl_same_fs() || xinobits).

What about OVL_XINO_AUTO: in this case xinobits would be zero but
ovl_same_dev() would return true, no?

More comments inline.

> @@ -358,7 +352,8 @@ static int ovl_show_options(struct seq_file *m, struct dentry *dentry)
>         if (ofs->config.nfs_export != ovl_nfs_export_def)
>                 seq_printf(m, ",nfs_export=%s", ofs->config.nfs_export ?
>                                                 "on" : "off");
> -       if (ofs->config.xino != ovl_xino_def())
> +       if (ofs->config.xino != ovl_xino_def() &&
> +           ofs->config.xino != OVL_XINO_SAME_FS)

I'm not sure I like this, although it doesn't contradict the policy of
repeatability of mounts.   Could we instead have a separate
ofs->xino_state, that defaults to config.xino but can take the value
of OVL_XINO_SAME_FS?

Thanks,
Miklos

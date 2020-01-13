From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v2 2/5] ovl: simplify ovl_same_sb() helper
Date: Mon, 13 Jan 2020 15:38:32 +0100
Message-ID: <CAJfpegvpQXzEpZUrrNLMt=2Bs_ykx9RoV+hXfKF_33ybo4-HPg@mail.gmail.com>
References: <20191222080759.32035-1-amir73il@gmail.com> <20191222080759.32035-3-amir73il@gmail.com>
 <CAJfpeguNywFLtpETg1oVpLnjkMP=DPZU3Fjvvb9aumRvTXBwtw@mail.gmail.com> <CAOQ4uxj8yewBzot0_Hu2OwNWMH=M_yGf_wtsCJn9UkwJARs0SA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-il1-f196.google.com ([209.85.166.196]:42928 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726074AbgAMOio (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 13 Jan 2020 09:38:44 -0500
Received: by mail-il1-f196.google.com with SMTP id t2so8321431ilq.9
        for <linux-unionfs@vger.kernel.org>; Mon, 13 Jan 2020 06:38:43 -0800 (PST)
In-Reply-To: <CAOQ4uxj8yewBzot0_Hu2OwNWMH=M_yGf_wtsCJn9UkwJARs0SA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>

On Mon, Jan 13, 2020 at 3:31 PM Amir Goldstein <amir73il@gmail.com> wrote:

> OK, I understand why you don't like it and I think is makes sense to
> have an xino_state.
> However, xino_state and xino_bits are quite redundant.
>
> If we change:
> unsigned int xino_bits;
> to:
> int xino_mode;
>
> It can take the values:
> -1 /* not same dev */
> 0 /* same fs */
> 1..32 /* xino_bits */
>
> And:
>
> static inline unsigned int ovl_xino_bits(struct super_block *sb)
> {
>         return OVL_FS(sb)->xino_mode > 0 : OVL_FS(sb)->xino_mode : 0;
> }

Okay.

Thanks,
Miklos

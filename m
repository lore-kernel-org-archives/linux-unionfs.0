From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v5 1/4] ovl: move include of ovl_entry.h into overlayfs.h
Date: Tue, 31 Oct 2017 15:22:45 +0200
Message-ID: <CAOQ4uxg3H0WgQMMkDNYKMq=kwJVBVCb01h+GEwPKdo3Jyeaw0g@mail.gmail.com>
References: <1509395247-15180-1-git-send-email-amir73il@gmail.com>
 <1509395247-15180-2-git-send-email-amir73il@gmail.com> <CAJfpegupc9mb8AWYocnn-RB6zaemfSpCSHb+H4NDUxD=RtX-XA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:48145 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752589AbdJaNWq (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 31 Oct 2017 09:22:46 -0400
Received: by mail-yw0-f193.google.com with SMTP id q1so14698891ywh.5
        for <linux-unionfs@vger.kernel.org>; Tue, 31 Oct 2017 06:22:46 -0700 (PDT)
In-Reply-To: <CAJfpegupc9mb8AWYocnn-RB6zaemfSpCSHb+H4NDUxD=RtX-XA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, zhangyi <yi.zhang@huawei.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Tue, Oct 31, 2017 at 3:14 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> Is this really necessary?
>
> "ovl_entry.h" is supposed to be more of a low level thing, and I'm not
> sure having that proliferate to all parts of the code is a good idea.
>
> At least some justification would be good here.

The "problem" is that include "ovl_entry.h" is already included by 5/8
overlayfs c files and by the end of the NFS export series its 7/9 and
there are exported functions in overlayfs.h whose signature include
pointers to structs defined in ovl_entry.h, so I started forward declaring those
structs in overlayfs.h.

After you look at the next patch "anonymous devs for lowerdirs"
let me know if you prefer a different distribution between the 2 include
files, or a 3rd include file.

Thanks,
Amir.

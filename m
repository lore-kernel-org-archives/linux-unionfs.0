From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 15/23] ovl: index directories on copy up with 'verify=on'
Date: Tue, 9 Jan 2018 18:31:39 +0200
Message-ID: <CAOQ4uxiO+pdPo7AWD+zY57Hp+KfQw0rmwpYgp1fgR1q0WWYJGQ@mail.gmail.com>
References: <1515084018-25134-1-git-send-email-amir73il@gmail.com>
 <1515084018-25134-16-git-send-email-amir73il@gmail.com> <CAJfpegsXCm-EG=Odpy0sBiK-htJEH4nRqSNn0Qd0o0YtQ=gBZg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f170.google.com ([209.85.161.170]:35862 "EHLO
        mail-yw0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753483AbeAIQbl (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 9 Jan 2018 11:31:41 -0500
Received: by mail-yw0-f170.google.com with SMTP id r205so5869250ywb.3
        for <linux-unionfs@vger.kernel.org>; Tue, 09 Jan 2018 08:31:40 -0800 (PST)
In-Reply-To: <CAJfpegsXCm-EG=Odpy0sBiK-htJEH4nRqSNn0Qd0o0YtQ=gBZg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: zhangyi <yi.zhang@huawei.com>, overlayfs <linux-unionfs@vger.kernel.org>

On Tue, Jan 9, 2018 at 6:08 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Thu, Jan 4, 2018 at 5:40 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> With the 'verify' feature enabled, all dirs are indexed on copy up.
>> Non-dir files are copied up directly to indexdir and then hardlinked
>> to upper dir.
>>
>> Directories are copied up to indexdir, then an index entry is created
>
> Makes me wonder:  do we need a workdir at all?  Temp files are already
> differentiated by leading "#", so that takes care of cleanup.
> Advantage: one less directory to worry about in implementation.
>

One advantage of keeping legacy work dir is that existence of index dir
is the one and only "feature bit" in overlayfs on-disk format and I wouldn't
like that bit to get lost. We can also look for non # entries in index as
indication to past index=on mount, but a simple exists indication is nicer.

I guess we could always use indexdir for copy up with index=on,
but I don't know that is going to simplify code, given that this (dir index)
patch didn't even need to change struct ovl_copy_up_ctx.

Thanks,
Amir.

From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 09/23] ovl: lookup index for directories
Date: Tue, 9 Jan 2018 18:07:30 +0200
Message-ID: <CAOQ4uxjAq4y_x3C8NoMW0FhZgpS=RrKYMVvsi4wQWK_-o5Yv=w@mail.gmail.com>
References: <1515084018-25134-1-git-send-email-amir73il@gmail.com>
 <1515084018-25134-10-git-send-email-amir73il@gmail.com> <CAJfpegshDhTByqBWY1-CAs6pO1mi7RWZDoEJMUacxzwD25_rGA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f174.google.com ([209.85.213.174]:33587 "EHLO
        mail-yb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933760AbeAIQHb (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 9 Jan 2018 11:07:31 -0500
Received: by mail-yb0-f174.google.com with SMTP id f16so6167573ybn.0
        for <linux-unionfs@vger.kernel.org>; Tue, 09 Jan 2018 08:07:31 -0800 (PST)
In-Reply-To: <CAJfpegshDhTByqBWY1-CAs6pO1mi7RWZDoEJMUacxzwD25_rGA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: zhangyi <yi.zhang@huawei.com>, overlayfs <linux-unionfs@vger.kernel.org>

On Tue, Jan 9, 2018 at 4:49 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Thu, Jan 4, 2018 at 5:40 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> A directory index is a directory type entry in index dir with a
>> "trusted.overlay.origin" xattr containing an encoded ovl_fh of the merge
>> directory upper dir inode.
>
> While it's convenient to call this ".origin", it's not really that,
> since now we are pointing to the latest incarnation of the file, which
> is the opposite of origin.
>
> Could we call it something more appropriate?
>

I can't come up with anything more creative than ".upper"...
I guess I can try to rename ovl_{check|verify}_origin_*
helpers to a more common name or and have
ovl_{check|verify}_{origin|upper}_* wrappers.

Thanks,
Amir.
